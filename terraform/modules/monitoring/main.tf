# Prometheus + Grafana (kube-prometheus-stack)
resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = true
  timeout          = 600   # 10 minutes - reduced since we're not waiting
  wait             = false # Don't wait for pods to be ready - let them deploy in background
  atomic           = false # Don't rollback on failure, allow manual troubleshooting
  version          = "55.5.0"

  values = [
    yamlencode({
      prometheus = {
        service = {
          type = "ClusterIP"
        }
        prometheusSpec = {
          retention                                = var.prometheus_retention
          serviceMonitorSelectorNilUsesHelmValues = false
          podMonitorSelectorNilUsesHelmValues     = false
          # Allow Prometheus to discover ServiceMonitors in all namespaces
          serviceMonitorNamespaceSelector = {}
          podMonitorNamespaceSelector     = {}
          # Reduce resource requests for faster scheduling
          resources = {
            requests = {
              cpu    = "200m"
              memory = "1Gi"
            }
            limits = {
              cpu    = "2000m"
              memory = "4Gi"
            }
          }
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                accessModes = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = var.prometheus_storage_size
                  }
                }
              }
            }
          }
        }
      }
      grafana = {
        service = {
          type = "ClusterIP"
        }
        adminPassword = var.grafana_admin_password
        # Reduce resource requests for faster scheduling - minimal resources to fit in single node
        resources = {
          requests = {
            cpu    = "50m"   # Reduced from 100m
            memory = "64Mi"  # Reduced from 128Mi
          }
          limits = {
            cpu    = "500m"  # Reduced from 1000m
            memory = "256Mi" # Reduced from 512Mi
          }
        }
        # Use the chart's built-in Prometheus datasource (it's enabled by default)
        # and only add Elasticsearch as an additional datasource
        datasources = {
          "datasources.yaml" = {
            apiVersion = 1
            datasources = [
              {
                name     = "Elasticsearch"
                type     = "elasticsearch"
                url      = "http://elasticsearch-master:9200"
                database = "[microservices-logs-]*"
                jsonData = {
                  timeField = "@timestamp"
                }
              }
            ]
          }
        }
        dashboardProviders = {
          "dashboardproviders.yaml" = {
            apiVersion = 1
            providers = [
              {
                name            = "default"
                orgId           = 1
                folder          = ""
                type            = "file"
                disableDeletion = false
                editable        = true
                options = {
                  path = "/var/lib/grafana/dashboards/default"
                }
              }
            ]
          }
        }
        dashboardsConfigMaps = {
          default = "grafana-dashboards"
        }
      }
      alertmanager = {
        service = {
          type = "ClusterIP"
        }
        # Reduce resource requests for faster scheduling
        alertmanagerSpec = {
          resources = {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
      # Disable some optional components to speed up deployment
      kubeStateMetrics = {
        enabled = true
        resources = {
          requests = {
            cpu    = "50m"
            memory = "64Mi"
          }
        }
      }
      nodeExporter = {
        enabled = true
        resources = {
          requests = {
            cpu    = "50m"
            memory = "64Mi"
          }
        }
      }
      prometheusOperator = {
        resources = {
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
        # Reduce admission webhook timeout to speed up deployment
        admissionWebhooks = {
          failurePolicy = "Ignore"  # Don't block on webhook failures
          timeoutSeconds = 5
        }
      }
    })
  ]
}

# Elasticsearch
resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  namespace        = var.namespace
  create_namespace = true
  timeout          = 300
  wait             = false  # Don't wait for pods to be ready
  version          = "7.17.3"

  values = [
    yamlencode({
      replicas            = var.elasticsearch_replicas
      minimumMasterNodes  = 1
      clusterHealthCheckParams = "wait_for_status=yellow&timeout=1s"
      service = {
        type = "ClusterIP"
      }
      volumeClaimTemplate = {
        accessModes = ["ReadWriteOnce"]
        resources = {
          requests = {
            storage = var.elasticsearch_storage_size
          }
        }
      }
      esJavaOpts = "-Xmx512m -Xms512m"
      resources = {
        requests = {
          cpu    = "100m"
          memory = "1Gi"
        }
        limits = {
          cpu    = "1000m"
          memory = "2Gi"
        }
      }
    })
  ]

  depends_on = [helm_release.kube_prometheus_stack]
}

# Logstash
resource "helm_release" "logstash" {
  name             = "logstash"
  repository       = "https://helm.elastic.co"
  chart            = "logstash"
  namespace        = var.namespace
  create_namespace = true
  timeout          = 300
  wait             = false  # Don't wait for pods to be ready
  version          = "7.17.3"

  values = [
    yamlencode({
      service = {
        type = "ClusterIP"
        ports = [
          {
            name       = "tcp"
            port       = 5000
            protocol   = "TCP"
            targetPort = 5000
          }
        ]
      }
      logstashConfig = {
        "logstash.yml" = <<-EOT
          http.host: 0.0.0.0
          xpack.monitoring.enabled: false
        EOT
      }
      logstashPipeline = {
        "logstash.conf" = <<-EOT
          input {
            tcp {
              port => 5000
              codec => json_lines
            }
          }
          filter {
            if [service] {
              mutate {
                add_field => { "[@metadata][index]" => "microservices-logs-%%{+YYYY.MM.dd}" }
              }
            }
          }
          output {
            elasticsearch {
              hosts => ["http://elasticsearch-master:9200"]
              index => "%%{[@metadata][index]}"
            }
          }
        EOT
      }
      resources = {
        requests = {
          cpu    = "100m"
          memory = "512Mi"
        }
        limits = {
          cpu    = "500m"
          memory = "1Gi"
        }
      }
    })
  ]

  depends_on = [helm_release.elasticsearch]
}

# Kibana
resource "helm_release" "kibana" {
  name             = "kibana"
  repository       = "https://helm.elastic.co"
  chart            = "kibana"
  namespace        = var.namespace
  create_namespace = true
  timeout          = 300
  wait             = false  # Don't wait for pods to be ready
  version          = "7.17.3"

  values = [
    yamlencode({
      service = {
        type = "ClusterIP"
      }
      elasticsearchHosts = "http://elasticsearch-master:9200"
      resources = {
        requests = {
          cpu    = "100m"
          memory = "512Mi"
        }
        limits = {
          cpu    = "500m"
          memory = "1Gi"
        }
      }
    })
  ]

  depends_on = [helm_release.elasticsearch]
}

# ConfigMap for Grafana Dashboards
resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name      = "grafana-dashboards"
    namespace = var.namespace
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "overview-dashboard.json"  = file("${path.module}/dashboards/overview-dashboard.json")
    "service-dashboard.json"   = file("${path.module}/dashboards/service-dashboard.json")
  }

  depends_on = [helm_release.kube_prometheus_stack]
}
