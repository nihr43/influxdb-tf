variable "context" {}
variable "ip" {}
variable "image" {}
variable "storage" {}
variable "storage_class" {}

variable "port" {
  default = 8086
}

variable "stack" {
  default = "influxdb"
}

resource "kubernetes_service" "main" {
  metadata {
    name = "${var.stack}-${var.context}"
  }
  spec {
    selector = {
      app = "${var.stack}-${var.context}"
    }
    port {
      port        = var.port
      target_port = var.port
    }
    type = "LoadBalancer"
    load_balancer_ip = ["${var.ip}"]
  }
}

resource "kubernetes_deployment" "main" {
  metadata {
    name = "${var.stack}-${var.context}"
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "${var.stack}-${var.context}"
      }
    }
    template {
      metadata {
        labels = {
          app = "${var.stack}-${var.context}"
        }
      }
      spec {
        container {
          image = var.image
          name  = "${var.stack}-${var.context}"
          volume_mount {
            name       = "${var.stack}-${var.context}"
            mount_path = "/var/lib/influxdb2"
          }
        }
        volume {
          name = "${var.stack}-${var.context}"
          persistent_volume_claim {
            claim_name = "${var.stack}-${var.context}"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "main" {
  metadata {
    name = "${var.stack}-${var.context}"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage
      }
    }
    storage_class_name = var.storage_class
  }
}
