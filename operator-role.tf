# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

// Use either Role or ClusterRole RBAC depending on watch namespace
resource "kubernetes_role" "operator_terraform_sync_workspace" {
  count = var.k8_watch_namespace == "null" || var.k8_watch_namespace == var.operator_namespace ? 1 : 0

  metadata {
    name      = "operator-terraform-sync-workspace"
    namespace = var.operator_namespace
    labels = {
      app     = "terraform"
      release = "operator"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "services/finalizers", "endpoints", "persistentvolumeclaims", "events", "configmaps", "secrets"]
    verbs      = ["*"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps/status"]
    verbs      = ["get", "update", "patch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "replicasets", "statefulsets"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["servicemonitors"]
    verbs      = ["get", "create"]
  }
  rule {
    api_groups     = ["apps"]
    resources      = ["deployments/finalizers"]
    resource_names = ["terraform-k8s"]
    verbs          = ["update"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["replicasets"]
    verbs      = ["get"]
  }
  rule {
    api_groups = ["app.terraform.io"]
    resources  = ["*", "workspaces"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "operator_terraform_sync_workspace" {
  count = var.k8_watch_namespace == "null" || var.k8_watch_namespace == var.operator_namespace ? 0 : 1

  metadata {
    name = "operator-terraform-sync-workspace"
    labels = {
      app     = "terraform"
      release = "operator"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "services/finalizers", "endpoints", "persistentvolumeclaims", "events", "configmaps", "secrets"]
    verbs      = ["*"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps/status"]
    verbs      = ["get", "update", "patch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "replicasets", "statefulsets"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["servicemonitors"]
    verbs      = ["get", "create"]
  }
  rule {
    api_groups     = ["apps"]
    resources      = ["deployments/finalizers"]
    resource_names = ["terraform-k8s"]
    verbs          = ["update"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["replicasets"]
    verbs      = ["get"]
  }
  rule {
    api_groups = ["app.terraform.io"]
    resources  = ["*", "workspaces"]
    verbs      = ["*"]
  }
}
