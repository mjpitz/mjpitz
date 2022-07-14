cat <<EOF > /opt/presto/etc/node.properties
node.environment=${PRESTO_NODE_ENVIRONMENT:-development}
node.id=${PRESTO_NODE_ID:-$HOSTNAME}
node.data-dir=${PRESTO_NODE_DATA_DIR:-/data}
EOF

/opt/presto/bin/launcher run $@
