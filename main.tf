terraform {
  required_providers {
    checkpoint = {
      source = "CheckPointSW/checkpoint"
    }
  }
}

/*
# Smart1 Cloud
provider "checkpoint" {
  server = "${var.portal}"
  api_key = "${var.api_key}"
  cloud_mgmt_id = "${var.cloud_mgmt_id}"
#  auto_publish_batch_size = 1
}
*/

# Smart1
provider "checkpoint" {
  server = "${var.server}"
  username = "${var.user}"
  password = "${var.password}"
  auto_publish_batch_size = 1
}

# Create network object
resource "checkpoint_management_network" "net1" {
  name = "Network1"
  subnet4 = "192.0.1.0"
  mask_length4 = "24"   
}

# Create network object
resource "checkpoint_management_network" "net2" {
  name = "Network2"
  subnet4 = "192.0.2.0"
  mask_length4 = "24"   
}

resource "checkpoint_management_access_layer" "inline" {
  name = "Inline"
  add_default_rule = false
}


resource "checkpoint_management_access_rule" "inline-rule" {
  name = "Inline"
  layer = "Network"
  position = {bottom = "bottom"}
  source = [
    checkpoint_management_network.net1.name,
    checkpoint_management_network.net2.name
  ]
  destination = ["Any"]
  service = ["Any"]
  content = ["Any"]
  time = ["Any"]
  action = "Apply Layer"
  inline_layer = checkpoint_management_access_layer.inline.id
  install_on = ["Policy Targets"]
  track = {
    type = "None"
    accounting = false
    alert = "none"
    enable_firewall_session = false
    per_connection = true
    per_session = false
  }
  action_settings = {}
  custom_fields = {}
  vpn = "Any"
}





resource "checkpoint_management_publish" "example" {
  run_publish_on_destroy = true
}