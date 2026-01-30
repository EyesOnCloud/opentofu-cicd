# ServiceAccount in the 'apps' namespace
resource "kubernetes_service_account" "ci" {
  metadata {
    name      = "github-ci"
    namespace = kubernetes_namespace.apps.metadata[0].name
  }

  # Ensure namespace exists before creating the ServiceAccount
  depends_on = [
    kubernetes_namespace.apps
  ]
}

# ClusterRoleBinding giving cluster-admin to the ServiceAccount
resource "kubernetes_cluster_role_binding" "ci_admin" {
  metadata {
    name = "github-ci-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.ci.metadata[0].name
    namespace = kubernetes_service_account.ci.metadata[0].namespace
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  # Ensure ServiceAccount exists before creating the binding
  depends_on = [
    kubernetes_service_account.ci
  ]
}
