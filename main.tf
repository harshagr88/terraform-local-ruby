provider "kubernetes" {
  host = "https://kubernetes.docker.internal:6443"
  config_context_cluster   = "docker-desktop"
  config_path = "~/.kube/config"
  insecure = true
}
resource "kubernetes_deployment" "app" {
  metadata {
    name = "http-ruby-app"
    labels = {
      app = "http-ruby-app"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "http-ruby-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "http-ruby-app"
        }
      }

      spec {
        security_context {
          run_as_non_root = true
          run_as_user = 1000
        }
        container {
          image = "localhost:5000/http_server:latest"
          name  = "http-ruby-app"
          port {
            name           = "port-80"
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          readiness_probe {
            exec {
              command = ["/bin/sh", "-c", "curl http://localhost/healthcheck"]
            }
            failure_threshold = 2
            success_threshold = 2
            period_seconds = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = "http-ruby-app"
  }
  spec {
    selector = {
      app = kubernetes_deployment.app.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}