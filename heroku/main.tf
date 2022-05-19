terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
    herokux = {
      source  = "davidji99/herokux"
      version = "0.33.2"
    }
  }
}


variable "app_name" {
  description = "Name of the Heroku app provisioned as an example"
}

resource "heroku_app" "example" {
  name   = var.app_name
  region = "us"
}

data "herokux_registry_image" "foobar" {
  app_id = heroku_app.example.uuid
  process_type = "web"
  docker_tag = "latest"
}

resource "herokux_app_container_release" "foobar" {
  app_id = heroku_app.example.uuid
  image_id = data.herokux_registry_image.foobar.digest
  process_type = "web"
}

# Launch the app's web process by scaling-up
resource "heroku_formation" "example" {
  app_id     = heroku_app.example.id
  type       = "web"
  quantity   = 1
  size       = "free"
  depends_on = [herokux_app_container_release.foobar]
}

output "example_app_url" {
  value = "https://${heroku_app.example.name}.herokuapp.com"
}
