resource "helm_release" "sonarqube" {
  name             = "sonarqube"
  repository       = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart            = "sonarqube"
  namespace        = "sonarqube"
  create_namespace = true
  timeout          = 600

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.externalPort"
    value = "9000"
  }

  set {
    name  = "postgresql.enabled"
    value = "true"
  }

  set {
    name  = "postgresql.postgresqlPassword"
    value = "sonar"
  }

  set {
    name  = "postgresql.postgresqlDatabase"
    value = "sonar"
  }

  set {
    name  = "monitoringPasscode"
    value = "sonar"
  }

  set {
    name  = "community.enabled"
    value = "true"
  }
}
