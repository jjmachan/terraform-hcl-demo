provider "google" {
  project = "bentoml-316710"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_firewall" "http-traffic" {
  name          = "allow-http"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-traffic"]
}

resource "google_compute_firewall" "http-ssh" {
  name          = "allow-ssh"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-traffic"]
}

data "template_file" "cloud-init" {
  template = file("./start-script.sh")
}

resource "google_compute_instance" "cos-instnace" {
  name         = "test"
  machine_type = "n1-standard-1"

  tags = ["http-traffic", "ssh-traffic"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-73-11647-217-0"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // this empty block creates a public IP address
    }
  }

  metadata_startup_script = file("./start-script.sh")
}

output "address" {
  value = google_compute_instance.cos-instnace.network_interface.0.access_config.0.nat_ip
}
