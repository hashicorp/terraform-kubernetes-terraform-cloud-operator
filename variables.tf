variable "operator_namespace" {
  type        = string
  description = "The namespace in which to install the operator and monitor for Workspaces."
}

variable "terraform_credentials_path" {
  type        = string
  description = "Specify the relative path to the file that contains your Terraform Cloud Team API token."
  default     = "credentials"
}

variable "workspace_secrets" {
  type        = map(string)
  description = "Add sensitive variables, such as your cloud provider credentials, to the workspace."
  default     = {}
}

variable "create_namespace" {
  type        = bool
  description = "By default, the module will create a namespace in which to install the operator."
  default     = true
}

variable "create_secrets" {
  type        = bool
  description = "By default, the module will create two secrets named terraformrc and workspacesecrets."
  default     = true
}

variable "k8_watch_namespace" {
  type        = string
  description = "The Kubernetes namespace to watch for workspace changes and sync to Terraform Cloud. If this is not set then it will default to the release namespace."
  default     = "null"
}

variable "terraform_version" {
  type        = string
  description = "Describes the version of Terraform to use for each workspace. If this is not set then it will default to the latest version of Terraform compiled with the operator."
  default     = "latest"
}

variable "insecure" {
  type        = bool
  description = "If true it disables certificate validation for all outbound HTTPS connection the operator has to do. It can be used when connecting to TFE instances with self-signed certificates."
  default     = false
}

variable "tfe_address" {
  type        = string
  description = "Denotes the address in the form of https://tfe.local for a Terraform Enterprise instance. If this is not set then it will default to Terraform Cloud (https://app.terraform.io)."
  default     = "https://app.terraform.io"
}

variable "image_k8s" {
  type        = string
  description = "The name (and tag) of the terraform-k8s Docker image that is used for functionality such as workspace sync. This can be overridden per component."
  default     = "hashicorp/terraform-k8s:1.0.0"
}

variable "log_level" {
  type        = string
  description = "WARNING: use only on terraform-k8s versions > 1.0.0. Configure optional flag to adjust log level verbosity. Can be one of 'debug', 'info', 'error'. Defaults to 'debug'."
  default     = "null"
}
