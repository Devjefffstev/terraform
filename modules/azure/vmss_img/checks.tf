check "vmss_img" {
      
  assert {
    condition = regex(local.source_image_id, "/providers/Microsoft.Compute/galleries/.+/images/.+/versions/.+")
    error_message = "source_image_id must be a valid Shared Image Version ID when source_image_id is provided."
  }
  
}