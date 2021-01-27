# Running Terraform in VS Code

[Terraform](https://www.terraform.io/) is an open-source tool that provides the ability to build, change, and version infrastructure as code using declarative configuration files with HashiCorp Configuration Language (HCL). This recipe shows how to successfully run Terraform with minimal setup with VS Code.

## Getting Started

- [Visual Studio Code](https://code.visualstudio.com/download): Install the latest version of Visual Studio Code that is appropriate for your environment.

- [Terraform](https://www.terraform.io/downloads.html): Download the latest version of Terraform that is appropriate for your environment.

- [Terraform Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform): The HashiCorp Terraform VS Code extension adds syntax highlighting and other editing features for Terraform files using the Terraform Language Server.

## Configuring the Terraform Tasks

The tasks below are based on Microsoft Azure as the cloud provider but other cloud provides such as AWS and Google Cloud are also supported with Terraform.

Add the following `shell` task to your tasks.json file:

```json
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    // ensures that windows machines execute tasks on cmd even if git bash or wsl bash is set as default shell
    "windows": {
        "options": {
            "shell": {
                "executable": "cmd.exe",
                "args": ["/d", "/c"],
            },
        }
    },
    "tasks": [
        {
            "label": "login",
            "type": "shell",
            "linux": {
                "command": "az login && az account set -s $ARM_SUBSCRIPTION_ID"
            },
            "problemMatcher": []
        },
        {
            "label": "terraform create backend",
            "type": "shell",
            "linux": {
                "command": "${workspaceFolder}/create-backend.sh"
            },
            "problemMatcher": []
        },
        {
            "label": "terraform init",
            "type": "shell",
            "command": "terraform",
            "problemMatcher": [],
            "args": [
                "init",
                "-backend-config=\"storage_account_name=${env:TF_BACKEND_STORAGE_ACCOUNT}\"",
                "-backend-config=\"container_name=${env:TF_BACKEND_CONTAINER}\"",
                "-backend-config=\"key=${env:TF_BACKEND_KEY}\"",
                "-backend-config=\"resource_group_name=${env:TF_BACKEND_RESOURCE_GROUP}\"",                              
                "-backend-config=\"subscription_id=${env:ARM_SUBSCRIPTION_ID}\"",
                "-backend-config=\"tenant_id=${env:ARM_TENANT_ID}\"",
            ],
            "options": {
                "cwd": "${workspaceFolder}/templates"
            }
        },
        {
            "label": "terraform validate",
            "type": "shell",
            "options": {
                "cwd": "${workspaceFolder}/templates"
            },
            "command": "terraform",
            "problemMatcher": [],
            "args": [
                "validate"
            ]
        },
        {
            "label": "terraform format",
            "type": "shell",
            "options": {
                "cwd": "${workspaceFolder}/templates"
            },
            "command": "terraform",
            "problemMatcher": [],
            "args": [
                "fmt",
                "--recursive"
            ]   
        },
        {
            "label": "terraform lint",
            "type": "shell",
            "options": {
                "cwd": "${workspaceFolder}/templates"
            },
            "command": "tflint --module",
            "problemMatcher": []
        },
        {
            "label": "terraform plan",
            "type": "shell",
            "options": {
                "cwd": "${workspaceFolder}/templates"
            },
            "command": "terraform",
            "problemMatcher": [],
            "args": [
                "plan"
            ]
        },
        {
            "label": "terraform apply",
            "type": "shell",
            "options": {
                "cwd": "${workspaceFolder}/templates"
            },
            "command": "terraform",
            "problemMatcher": [],
            "args": [
                "apply"
            ]
        },
        {
            "label": "terraform destroy",
            "type": "shell",
            "options": {
                "cwd": "${workspaceFolder}/templates"
            },
            "command": "terraform",
            "problemMatcher": [],
            "args": [
                "destroy"
            ]
        },
    ]
}

```

## Running the Terraform Commands

## Sample Project

In this short [sample](), we create and execute the basic Terraform configuration that will provision a new Azure Resource Group.

## Additional References

- [Terraform Overview](https://www.terraform.io/intro/index.html)
- [Terraform Tutorials](https://learn.hashicorp.com/terraform?utm_source=terraform_io)
