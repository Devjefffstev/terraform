check "warning_for_using_legacy_access_policies" {
  assert {
    error_message = "Using legacy access policies is not recommended. Consider using RBAC for better security and management."
    condition     = var.legacy_access_policies != null || length(var.legacy_access_policies) > 0 || var.legacy_access_policies != {}
  }

}