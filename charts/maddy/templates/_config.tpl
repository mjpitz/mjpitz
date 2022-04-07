{{/*
Render the maddy configuration file
*/}}
{{- define "maddy.config" -}}
$(hostname) = {{ .Values.config.domains.mx }}
$(primary_domain) = {{ .Values.config.domains.primary }}
$(local_domains) = $(primary_domain)

{{- if and .Values.config.tls.certPath .Values.config.tls.keyPath }}
# ----------------------------------------------------------------------------
# TLS
# ----------------------------------------------------------------------------
tls file {{ .Values.config.tls.certPath }} {{ .Values.config.tls.keyPath }}
{{- end }}

# ----------------------------------------------------------------------------
# Local storage & authentication
#
# pass_table provides local hashed passwords storage for authentication of
# users. It can be configured to use any "table" module, in default
# configuration a table in SQLite DB is used.
# Table can be replaced to use e.g. a file for passwords. Or pass_table module
# can be replaced altogether to use some external source of credentials (e.g.
# PAM, /etc/shadow file).
#
# If table module supports it (sql_table does) - credentials can be managed
# using 'maddyctl creds' command.
# ----------------------------------------------------------------------------

auth.pass_table local_authdb {
    table sql_table {
    	{{- if .Values.persistence.enabled }}
        driver sqlite3
        dsn /data/credentials.db
        {{- else }}
        driver postgres
        dsn {{ .Values.config.database.dsn }}
        {{- end }}
        table_name passwords
    }
}

# ----------------------------------------------------------------------------
# imapsql module stores all indexes and metadata necessary for IMAP using a
# relational database. It is used by IMAP endpoint for mailbox access and
# also by SMTP & Submission endpoints for delivery of local messages.
#
# IMAP accounts, mailboxes and all message metadata can be inspected using
# imap-* subcommands of maddyctl utility.
# ----------------------------------------------------------------------------

storage.imapsql local_mailboxes {
	{{- if .Values.persistence.enabled }}
	driver sqlite3
	dsn /data/imapsql.db
	{{- else }}
	driver postgres
	dsn {{ .Values.config.database.dsn }}
	{{- end }}
}

# ----------------------------------------------------------------------------
# SMTP endpoints + message routing (1025 - SMTP)
# ----------------------------------------------------------------------------

hostname $(hostname)

table.chain local_rewrites {
    optional_step regexp "(.+)\+(.+)@(.+)" "$1@$3"
    optional_step static {
        entry postmaster postmaster@$(primary_domain)
    }
    optional_step file /etc/maddy/aliases
}

msgpipeline local_routing {
    # Insert handling for special-purpose local domains here.
    # e.g.
    # destination lists.example.org {
    #     deliver_to lmtp tcp://127.0.0.1:8024
    # }

    destination postmaster $(local_domains) {
        modify {
            replace_rcpt &local_rewrites
        }

        deliver_to &local_mailboxes
    }

    default_destination {
        reject 550 5.1.1 "User doesn't exist"
    }
}

smtp tcp://0.0.0.0:1025 {
    limits {
        # Up to 20 msgs/sec across max. 10 SMTP connections.
        all rate 20 1s
        all concurrency 10
    }

    dmarc yes
    check {
        require_mx_record
        dkim
        spf
    }

    source $(local_domains) {
        reject 501 5.1.8 "Use Submission for outgoing SMTP"
    }
    default_source {
        destination postmaster $(local_domains) {
            deliver_to &local_routing
        }
        default_destination {
            reject 550 5.1.1 "User doesn't exist"
        }
    }
}

# ----------------------------------------------------------------------------
# SMTP Submission endpoints (10465 - TLS, 10587 - Plaintext)
# ----------------------------------------------------------------------------

submission tls://0.0.0.0:10465 tcp://0.0.0.0:10587 {
    limits {
        # Up to 50 msgs/sec across any amount of SMTP connections.
        all rate 50 1s
    }

    auth &local_authdb

    source $(local_domains) {
        check {
            authorize_sender {
                prepare_email &local_rewrites
                user_to_email identity
            }
        }

        destination postmaster $(local_domains) {
            deliver_to &local_routing
        }
        default_destination {
            modify {
                dkim $(primary_domain) $(local_domains) default
            }
            deliver_to &remote_queue
        }
    }
    default_source {
        reject 501 5.1.8 "Non-local sender domain"
    }
}

target.remote outbound_delivery {
    limits {
        # Up to 20 msgs/sec across max. 10 SMTP connections
        # for each recipient domain.
        destination rate 20 1s
        destination concurrency 10
    }

    mx_auth {
        dane
        mtasts {
            cache fs
            fs_dir mtasts_cache/
        }
        local_policy {
            min_tls_level encrypted
            min_mx_level none
        }
    }
}

target.queue remote_queue {
    target &outbound_delivery

    autogenerated_msg_domain $(primary_domain)
    bounce {
        destination postmaster $(local_domains) {
            deliver_to &local_routing
        }
        default_destination {
            reject 550 5.0.0 "Refusing to send DSNs to non-local addresses"
        }
    }
}

# ----------------------------------------------------------------------------
# IMAP endpoints (10993 - TLS, 10143 - Plaintext)
# ----------------------------------------------------------------------------

imap tls://0.0.0.0:10993 tcp://0.0.0.0:10143 {
    auth &local_authdb
    storage &local_mailboxes
}

# ----------------------------------------------------------------------------
# Telemetry
# ----------------------------------------------------------------------------

openmetrics tcp://0.0.0.0:9749 { }

{{- end -}}

{{/*
Render the nginx configuration file
*/}}
{{- define "maddy.nginx" -}}
http {
    include mime.types;
    sendfile on;

    server {
        listen 8080;
        listen [::]:8080;

        resolver 127.0.0.11;
        autoindex off;

        server_name _;
        server_tokens off;

        root /usr/share/nginx/html;
        gzip_static on;
    }
}

events {}
{{- end -}}

{{/*
Render the well-known mta-sts configuration file
*/}}
{{- define "maddy.well-known.mta-sts" -}}
version: STSv1
mode: enforce
max_age: 604800
mx: {{ .Values.config.domains.mx }}
{{- end -}}
