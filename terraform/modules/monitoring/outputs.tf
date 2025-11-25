output "prometheus_service_name" {
  description = "Prometheus service name"
  value       = "kube-prometheus-stack-prometheus"
}

output "grafana_service_name" {
  description = "Grafana service name"
  value       = "kube-prometheus-stack-grafana"
}

output "elasticsearch_service_name" {
  description = "Elasticsearch service name"
  value       = "elasticsearch-master"
}

output "logstash_service_name" {
  description = "Logstash service name"
  value       = "logstash-logstash"
}

output "kibana_service_name" {
  description = "Kibana service name"
  value       = "kibana-kibana"
}

output "namespace" {
  description = "Monitoring namespace"
  value       = var.namespace
}

output "port_forward_commands" {
  description = "Commands to access monitoring services"
  value = <<-EOT
    # Grafana
    kubectl port-forward -n ${var.namespace} svc/kube-prometheus-stack-grafana 3000:80
    
    # Prometheus
    kubectl port-forward -n ${var.namespace} svc/kube-prometheus-stack-prometheus 9090:9090
    
    # Kibana
    kubectl port-forward -n ${var.namespace} svc/kibana-kibana 5601:5601
    
    # Elasticsearch
    kubectl port-forward -n ${var.namespace} svc/elasticsearch-master 9200:9200
  EOT
}
