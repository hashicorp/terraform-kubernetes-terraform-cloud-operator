# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.operator_namespace
  }
}
