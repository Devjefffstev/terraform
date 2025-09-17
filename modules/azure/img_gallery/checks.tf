check "amount_of_galleries" {
  assert {
    condition     = length((module.compute_gallery)) >= 1
    error_message = "Please be sure to define at least one Shared Image Gallery in the variable image_galleries"
  }

}