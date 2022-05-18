provider "google" {
}

locals {
  instance_name = "test-module"
}

module "gce-container" {
  source         = "terraform-google-modules/container-vm/google"
  cos_image_name = "cos-stable-77-12371-89-0"
  container = {
    image = "gcr.io/bentoml-316710/test-google-cloud-run/test-google-cloud-run:fzxokwu6d2mreulw"
    env = [
      {
        name  = "BENTOML_PORT"
        value = "3000"
      },
    ]
  }

  restart_policy = "Always"
}

resource "google_compute_instance" "vm" {
  project      = "bentoml-316710"
  name         = local.instance_name
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["container-vm-example"]

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  service_account {
    email = "558210432501-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "google_compute_firewall" "default" {
 name    = "web-firewall"
 network = "default"
  project      = "bentoml-316710"

 allow {
   protocol = "tcp"
   ports    = ["3000"]
 }

 source_ranges = ["0.0.0.0/0"]
}
