# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

// Use either RoleBinding or ClusterRoleBinding RBAC depending on watch namespace
resource "kubernetes_role_binding" "operator_terraform_sync_workspace" {
  count = var.k8_watch_namespace == "null" || var.k8_watch_namespace == var.operator_namespace ? 1 : 0

  metadata {
    name      = "operator-terraform-sync-workspace"
    namespace = var.operator_namespace
    labels = {
      app     = "terraform"
      release = "operator"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "operator-terraform-sync-workspace"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "operator-terraform-sync-workspace"
    namespace = var.operator_namespace
  }
}

resource "kubernetes_cluster_role_binding" "operator_terraform_sync_workspace" {
  count = var.k8_watch_namespace == "null" || var.k8_watch_namespace == var.operator_namespace ? 0 : 1

  metadata {
    name = "operator-terraform-sync-workspace"
    labels = {
      app     = "terraform"
      release = "operator"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "operator-terraform-sync-workspace"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "operator-terraform-sync-workspace"
    namespace = var.operator_namespace
  }
}
