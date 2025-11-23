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
}

variable "values_file" {
  description = "Path to the values file"
  type        = string
}

variable "set_values" {
  description = "Map of values to set"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Timeout in seconds for the Helm release"
  type        = number
  default     = 300
}
