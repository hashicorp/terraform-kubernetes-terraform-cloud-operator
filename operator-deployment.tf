# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "kubernetes_deployment" "operator_terraform_sync_workspace" {
  depends_on = [kubernetes_secret.terraformrc, kubernetes_secret.workspacesecrets]

  metadata {
    labels = {
      app     = "terraform"
      release = "operator"
    }
    name      = "operator-terraform-sync-workspace"
    namespace = var.operator_namespace
  }

  spec {
    progress_deadline_seconds = 600
    replicas                  = 1
    revision_history_limit    = 10
    selector {
      match_labels = {
        app       = "terraform"
        component = "sync-workspace"
        release   = "operator"
      }
    }
    strategy {
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
      type = "RollingUpdate"
    }
    template {
      metadata {
        labels = {
          app       = "terraform"
          component = "sync-workspace"
          release   = "operator"
        }
      }
      spec {
        container {
          args = [
            "--enable-leader-election",
            "--k8s-watch-namespace=${var.k8_watch_namespace == "null" ? var.operator_namespace : var.k8_watch_namespace}",
          "${var.log_level == "null" ? "" : "--zap-log-level=${var.log_level}"}"]
          command = ["/bin/terraform-k8s"]
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }
          env {
            name  = "OPERATOR_NAME"
            value = "terraform-k8s"
          }
          env {
            name  = "TF_VERSION"
            value = var.terraform_version
          }
          env {
            name  = "TF_INSECURE"
            value = var.insecure
          }
          env {
            name  = "TF_CLI_CONFIG_FILE"
            value = "/etc/terraform/.terraformrc"
          }
          env {
            name  = "TF_URL"
            value = var.tfe_address
          }
          image             = var.image_k8s
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            failure_threshold = 3
            http_get {
              path   = "/metrics"
              port   = 8383
              scheme = "HTTP"
            }
            initial_delay_seconds = 30
            period_seconds        = 5
            success_threshold     = 1
            timeout_seconds       = 5
          }
          name = "terraform-sync-workspace"
          readiness_probe {
            failure_threshold = 5
            http_get {
              path   = "/metrics"
              port   = 8383
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            success_threshold     = 1
            timeout_seconds       = 5
          }
          resources {}
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          volume_mount {
            mount_path = "/etc/terraform"
            name       = "terraformrc"
            read_only  = true
          }
          volume_mount {
            mount_path = "/tmp/secrets"
            name       = "sensitivevars"
            read_only  = true
          }
        }
        dns_policy                       = "ClusterFirst"
        restart_policy                   = "Always"
        service_account_name             = "operator-terraform-sync-workspace"
        termination_grace_period_seconds = 30
        volume {
          name = "terraformrc"
          secret {
            items {
              key  = "credentials"
              path = ".terraformrc"
            }
            secret_name = "terraformrc"
          }
        }
        volume {
          name = "sensitivevars"
          secret {
            secret_name = "workspacesecrets"
          }
        }
      }
    }
  }
}
