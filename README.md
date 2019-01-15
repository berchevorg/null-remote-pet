# null-remote-pet
This repository is example of how you can use **remote state**.
We are going to use additional github repo:
- [random_pet](https://github.com/berchevorg/random_pet) This repo contain only random pet code, which is going to be our workspace in TFE. Once connected to TFE, we are going to execute the code and we will use the created state in order to be consumed by the current one.
  

## Requirements
- Terraform installed. If you do not have Terraform installed on your computer, install it from [here](https://learn.hashicorp.com/terraform/getting-started/install.html)
- Registration to [TFE](https://app.terraform.io) (recomended is to use user, the same as github)
- Generate [token](https://www.terraform.io/docs/enterprise/users-teams-organizations/users.html#api-tokens)

## Tasks to do after registration to TFE
- You need to crete [organization](https://www.terraform.io/docs/enterprise/getting-started/access.html#creating-an-organization)
- Generate [token](https://www.terraform.io/docs/enterprise/users-teams-organizations/users.html#api-tokens)

## Instructions
- Create **random_pet** repo in github the same as mine! (at least use the same **main.tf** code)
```
resource "random_pet" "name" {
  length    = "4"
  separator = "-"
}

output "out" {
  value = "${random_pet.name.id}"
}
```
- Log in to your TFE account and connect **random_pet** repo to it as a workspace
- Navigate to **random_pet** workspace
- Choose **Queue Plan**, provide **name** and click on **Queue Plan**
- This is going to crete 4 random words separated by hyphen. (in my case: `equally-presently-engaging-monster`)
- Now create repository in github with the same repository as mine.
- Fill the **main.tf** in this way:
```
data "terraform_remote_state" "name_of_the_resource" {
  backend = "atlas"
  config {
    name = "your_organization/your_random_pet_repo_name"
  }
}


resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "echo Hello ${data.terraform_remote_state.pet.out}"
  }
}

```
- Create file which name to end on **.env** (The name does not really matters) with following content:
```
export ATLAS_TOKEN=xxxxxxxx.atlasv1.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
- Type: **source your_file.env**, in order to export your token as environment variable
- Type: **terraform init**
- Type: **terraform plan**
- Type: **terraform apply**
- expected result will be:
```
null_resource.hello: Creating...
null_resource.hello: Provisioning with 'local-exec'...
null_resource.hello (local-exec): Executing: ["/bin/sh" "-c" "echo Hello equally-presently-engaging-monster"]
null_resource.hello (local-exec): Hello equally-presently-engaging-monster
null_resource.hello: Creation complete after 0s (ID: 7387797754892142072)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
