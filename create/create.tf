
locals {
  inline-policy = jsondecode(file("${path.module}/inline-policy.json"))
}

# Setup server_setup scripts
data "template_file" "rules" {
  count = length(local.inline-policy.rules)
  template = file("${path.module}/rules.tftpl")

  vars = {
    name = local.inline-policy.rules[count.index].name
    name_ = replace(local.inline-policy.rules[count.index].name, "/[^a-zA-Z0-9]/", "_")
    pre   = count.index == 0 ? "" : replace(local.inline-policy.rules[count.index - 1].name, "/[^a-zA-Z0-9]/", "_")
    source = tostring(local.inline-policy.rules[count.index].source)
    destination = tostring(local.inline-policy.rules[count.index].destination)
    service = tostring(local.inline-policy.rules[count.index].service)
    vpn = tostring(local.inline-policy.rules[count.index].vpn)
    action = tostring(local.inline-policy.rules[count.index].action)
    track = tostring(local.inline-policy.rules[count.index].track)
    layer = "checkpoint_management_access_layer.inline"
  }
}

locals {
  rendered = [for a in data.template_file.rules : a.rendered ]
  remove_list = [for a in data.template_file.rules : "checkpoint_management_access_rule.rule_${a.vars.name_}" ]
}

resource "local_file" "rules_file" {
  content  = join("\n", local.rendered)
  filename = "${path.module}/../inline-rules.tf"
}

resource "local_file" "destroy_file" {
  content  = "terraform state rm checkpoint_management_access_layer.inline ${join(" ", local.remove_list)}\nterraform destroy"
  filename = "${path.module}/../destroy.bat"
}

