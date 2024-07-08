variable "clickhouse_username" {
  type      = string
  sensitive = true
}

variable "clickhouse_password" {
  type      = string
  sensitive = true
}

variable "clickhouse_s3_access_key_id" {
  type      = string
  sensitive = true
}

variable "clickhouse_s3_secret_access_key" {
  type      = string
  sensitive = true
}

variable "grafana_gitea_client_id" {
  type      = string
  sensitive = true
}

variable "grafana_gitea_client_secret" {
  type      = string
  sensitive = true
}

locals {
  cognative_s3_xml = <<EOF
<clickhouse>
  <storage_configuration>
    <disks>
      <s3>
        <type>s3</type>
        <endpoint>https://nyc3.digitaloceanspaces.com/mya-clickhouse/clickhouse</endpoint>
        <access_key_id>${var.clickhouse_s3_access_key_id}</access_key_id>
        <secret_access_key>${var.clickhouse_s3_secret_access_key}</secret_access_key>
        <metadata_path>/var/lib/clickhouse/disks/s3/</metadata_path>
        <skip_access_check>true</skip_access_check>
        <send_metadata>true</send_metadata>
      </s3>
      <s3_cache>
        <type>cache</type>
        <disk>s3</disk>
        <path>/var/lib/clickhouse/disks/s3_cache/</path>
        <max_size>10Gi</max_size>
        <cache_on_write_operations>1</cache_on_write_operations>
      </s3_cache>
    </disks>
    <policies>
      <default>
        <volumes>
          <hot>
            <disk>default</disk>
          </hot>
          <cold>
            <disk>s3_cache</disk>
            <prefer_not_to_merge>false</prefer_not_to_merge>
            <perform_ttl_move_on_insert>false</perform_ttl_move_on_insert>
          </cold>
        </volumes>
        <move_factor>0.2</move_factor>
      </default>
    </policies>
  </storage_configuration>
</clickhouse>
EOF
}

data "external" "cognative" {
  program = ["./scripts/hash.sh", "./cognative"]
}

resource "helm_release" "cognative" {
  depends_on = [
    helm_release.cert_manager,
    helm_release.longhorn,
  ]

  chart     = "./cognative"
  namespace = "metrics"
  name      = "cognative"

  values = [
    file("./cognative/values.yaml"),
  ]

  set_sensitive {
    name  = "cognative.clickhouse.auth.username"
    value = var.clickhouse_username
  }

  set_sensitive {
    name  = "cognative.clickhouse.auth.password"
    value = var.clickhouse_password
  }

  set_sensitive {
    name  = "cognative.clickhouse.extra.config.s3\\.xml"
    value = local.cognative_s3_xml
  }

  set_sensitive {
    name  = "cognative.collector.config.exporters.clickhouse.username"
    value = var.clickhouse_username
  }

  set_sensitive {
    name  = "cognative.collector.config.exporters.clickhouse.password"
    value = var.clickhouse_password
  }

  set_sensitive {
    name  = "cognative.grafana.oauth.clientId"
    value = var.grafana_gitea_client_id
  }

  set_sensitive {
    name  = "cognative.grafana.oauth.clientSecret"
    value = var.grafana_gitea_client_secret
  }

  set_sensitive {
    name  = "cognative.grafana.datasources.clickhouse\\.yaml.datasources[0].jsonData.username"
    value = var.clickhouse_username
  }

  set_sensitive {
    name  = "cognative.grafana.datasources.clickhouse\\.yaml.datasources[0].secureJsonData.password"
    value = var.clickhouse_password
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
