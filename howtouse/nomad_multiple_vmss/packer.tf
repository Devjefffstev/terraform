resource "terraform_data" "packer_image" {
  provisioner "local-exec" {
    command = "${path.module}/packer/run_packer.sh"
  }
  triggers_replace = {
    always_run = var.create_packer_image
  }
}
