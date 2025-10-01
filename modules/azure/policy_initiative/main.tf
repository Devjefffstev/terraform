data "azurerm_subscription" "current" {
}

# Get Azure Policy Set Definitions data
data "azurerm_policy_set_definition" "builtin_initiative" {
  count                 = var.create_set_definition == false ? 1 : 0
  display_name          = var.initiative_name
  management_group_name = var.initiatives_store
}

# Get Azure Management Group data
data "azurerm_management_group" "mg" {
  count        = var.scope == "management_group" ? 1 : 0
  display_name = var.management_group_name
}

# Get Azure Management Group to store Policy Set
data "azurerm_management_group" "mg_store" {
  count        = var.initiatives_store != null ? 1 : 0
  display_name = var.initiatives_store
}

# Get Azure Policy Definitions data
data "azurerm_policy_definition" "policy_definitions" {
  count        = length(var.policy_definition_list)
  display_name = var.policy_definition_list[count.index].policy_name
}

locals {
  parameter_values = var.assignment_parameters != null ? {
    for key, value in var.assignment_parameters :
    key => merge({ value = value })
  } : null
  parameters = jsonencode(local.parameter_values)
}

# Create Subscription Policy Assignment
resource "azurerm_subscription_policy_assignment" "policy_assignment" {
  count                = var.scope == "subscription" && var.assignment_name != null ? 1 : 0
  name                 = replace(var.assignment_name, "/[%&?\\/<>:]/", "")
  display_name         = replace(var.assignment_name, "/[%&?\\/<>:]/", "")
  subscription_id      = data.azurerm_subscription.current.id
  description          = var.assignment_description
  enforce              = var.enforce
  policy_definition_id = try(data.azurerm_policy_set_definition.builtin_initiative[0].id, azurerm_policy_set_definition.policy_set[0].id)
  location             = var.assignment_location
  parameters           = local.parameters
  not_scopes           = var.assignment_exclusions

  identity {
    type         = var.identity.type
    identity_ids = var.identity.type == "UserAssigned" ? var.identity.identity_ids : null
  }

  dynamic "non_compliance_message" {
    for_each = var.non_compliance_message
    content {
      content                        = non_compliance_message.value.content
      policy_definition_reference_id = non_compliance_message.value.policy_definition_reference_id
    }
  }

  dynamic "overrides" {
    for_each = var.assignment_overrides != null ? var.assignment_overrides : []
    content {
      value = overrides.value.value

      dynamic "selectors" {
        for_each = overrides.value.selector
        content {
          in     = selectors.value.in
          not_in = selectors.value.not_in
        }
      }
    }
  }

  dynamic "resource_selectors" {
    for_each = var.assignment_resource_selectors != null ? var.assignment_resource_selectors : []
    content {
      name = resource_selectors.value.name

      dynamic "selectors" {
        for_each = resource_selectors.value.selectors
        content {
          kind   = selectors.value.kind
          in     = selectors.value.in
          not_in = selectors.value.not_in
        }
      }
    }
  }
}

# Create Azure Policy Initiative/Set and adding policies to it
resource "azurerm_policy_set_definition" "policy_set" {
  count               = var.create_set_definition == true ? 1 : 0
  name                = var.initiative_name
  policy_type         = var.policy_type
  display_name        = var.display_name
  description         = var.description
  management_group_id = var.initiatives_store != null ? data.azurerm_management_group.mg_store[0].id : data.azurerm_management_group.mg[0].id

  dynamic "policy_definition_reference" {
    for_each = var.policy_definition_list
    content {
      policy_definition_id = data.azurerm_policy_definition.policy_definitions[index(var.policy_definition_list, policy_definition_reference.value)].id
      parameter_values     = policy_definition_reference.value.parameter_values
    }
  }
}

# Assign Azure Policy Initiative/Set to Management Group
resource "azurerm_management_group_policy_assignment" "policy_assignment" {
  count                = var.scope == "management_group" && var.assignment_name != null ? 1 : 0
  name                 = replace(var.assignment_name, "/[%&?\\/<>:]/", "")
  display_name         = replace(var.initiative_name, "/[%&?\\/<>:]/", "")
  description          = var.description
  policy_definition_id = try(data.azurerm_policy_set_definition.builtin_initiative[0].id, azurerm_policy_set_definition.policy_set[0].id)
  management_group_id  = data.azurerm_management_group.mg[0].id
  parameters           = local.parameters
  enforce              = var.enforce
  location             = var.assignment_location
  not_scopes           = var.assignment_exclusions

  identity {
    type         = var.identity.type
    identity_ids = var.identity.type == "UserAssigned" ? var.identity.identity_ids : null
  }

  dynamic "non_compliance_message" {
    for_each = var.non_compliance_message
    content {
      content                        = non_compliance_message.value.content
      policy_definition_reference_id = non_compliance_message.value.policy_definition_reference_id
    }
  }

  dynamic "overrides" {
    for_each = var.assignment_overrides
    content {
      value = overrides.value.value
      dynamic "selectors" {
        for_each = overrides.value.selectors
        content {
          in     = selectors.value.in
          not_in = selectors.value.not_in
          kind   = selectors.value.kind
        }
      }
    }
  }

  dynamic "resource_selectors" {
    for_each = var.assignment_resource_selectors
    content {
      name = resource_selectors.value.name
      dynamic "selectors" {
        for_each = resource_selectors.value.selectors
        content {
          kind   = selectors.value.kind
          in     = selectors.value.in
          not_in = selectors.value.not_in
        }
      }
    }
  }
}

resource "azurerm_management_group_policy_exemption" "mg_exemptions" {
  for_each            = var.assignment_exemptions != null ? { for k, v in var.assignment_exemptions : k => v if v.scope == "management_group" } : {}
  name                = each.value.name
  display_name        = each.value.display_name
  exemption_category  = each.value.exemption_category
  description         = each.value.description
  management_group_id = each.value.scope_id
  policy_assignment_id = var.scope == "management_group" ? (
    azurerm_management_group_policy_assignment.policy_assignment[0].id) : (
    azurerm_subscription_policy_assignment.policy_assignment[0].id
  )

  expires_on                      = each.value.expires_on
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  metadata                        = each.value.metadata
}

resource "azurerm_subscription_policy_exemption" "subscription_exemptions" {
  for_each           = var.assignment_exemptions != null ? { for k, v in var.assignment_exemptions : k => v if v.scope == "subscription" } : {}
  name               = each.value.name
  display_name       = each.value.display_name
  exemption_category = each.value.exemption_category
  description        = each.value.description
  subscription_id    = each.value.scope_id
  policy_assignment_id = var.scope == "management_group" ? (
    azurerm_management_group_policy_assignment.policy_assignment[0].id) : (
    azurerm_subscription_policy_assignment.policy_assignment[0].id
  )

  expires_on                      = each.value.expires_on
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  metadata                        = each.value.metadata
}

resource "azurerm_resource_group_policy_exemption" "rg_exemptions" {
  for_each           = var.assignment_exemptions != null ? { for k, v in var.assignment_exemptions : k => v if v.scope == "resource_group" } : {}
  name               = each.value.name
  display_name       = each.value.display_name
  exemption_category = each.value.exemption_category
  description        = each.value.description
  resource_group_id  = each.value.scope_id
  policy_assignment_id = var.scope == "management_group" ? (
    azurerm_management_group_policy_assignment.policy_assignment[0].id) : (
    azurerm_subscription_policy_assignment.policy_assignment[0].id
  )
  expires_on                      = each.value.expires_on
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  metadata                        = each.value.metadata
}

resource "azurerm_resource_policy_exemption" "resource_exemptions" {
  for_each           = var.assignment_exemptions != null ? { for k, v in var.assignment_exemptions : k => v if v.scope == "resource" } : {}
  name               = each.value.name
  display_name       = each.value.display_name
  exemption_category = each.value.exemption_category
  description        = each.value.description
  resource_id        = each.value.scope_id
  policy_assignment_id = var.scope == "management_group" ? (
    azurerm_management_group_policy_assignment.policy_assignment[0].id) : (
    azurerm_subscription_policy_assignment.policy_assignment[0].id
  )
  expires_on                      = each.value.expires_on
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  metadata                        = each.value.metadata
}
