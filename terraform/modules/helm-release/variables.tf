variable "release_name" {
  description = "Name of the Helm release"
  type        = string
}

variable "chart_path" {
  description = "Path to the Helm chart"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "values_file" {
  description = "Path to the values.yaml file"
  type        = string
}

variable "extra_values" {
  description = "Extra values to pass to the Helm chart"
  type        = string
  default     = ""
}
