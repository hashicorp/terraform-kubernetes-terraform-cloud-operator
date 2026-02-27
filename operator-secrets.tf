# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "kubernetes_secret" "terraformrc" {
  count = var.create_secrets ? 1 : 0

  metadata {
    name      = "terraformrc"
    namespace = var.operator_namespace
  }

  data = {
    "credentials" = file("${path.cwd}/${var.terraform_credentials_path}")
  }

}

resource "kubernetes_secret" "workspacesecrets" {
  count = var.create_secrets ? 1 : 0

  metadata {
    name      = "workspacesecrets"
    namespace = var.operator_namespace
  }

  data = var.workspace_secrets

}
