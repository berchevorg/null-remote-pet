data "terraform_remote_state" "pet" {
  backend = "atlas"
  config {
    name = "berchevorg/random_pet"
  }
}


resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "echo Hello ${data.terraform_remote_state.pet.out}"
  }
}

