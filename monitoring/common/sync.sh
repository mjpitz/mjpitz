find out/${1}/grafana_dashboard_*.json 2>/dev/null | xargs -I{} bash -c 'cp {} ../infra/helm/cognative/dashboards/$(basename {} .json | cut -c19-).json'
