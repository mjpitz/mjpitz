find out/${1}/grafana_dashboard_*.json 2>/dev/null | xargs -I{} bash -c 'cp {} ../infra/helm/kube-prometheus-stack/dashboards/$(basename {} .json | cut -c19-).json'
