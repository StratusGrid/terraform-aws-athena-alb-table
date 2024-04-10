<!-- BEGIN_TF_DOCS -->
<p align="center">                                                                                                                                            
                                                                                
  <img src="https://github.com/StratusGrid/terraform-readme-template/blob/main/header/stratusgrid-logo-smaller.jpg?raw=true" />
  <p align="center">                                                           
    <a href="https://stratusgrid.com/book-a-consultation">Contact Us</a> |                  
    <a href="https://stratusgrid.com/cloud-cost-optimization-dashboard">Stratusphere FinOps</a> |
    <a href="https://stratusgrid.com">StratusGrid Home</a> |
    <a href="https://stratusgrid.com/blog">Blog</a>
  </p>                    
</p>

 # terraform-aws-athena-alb-table

 GitHub: [StratusGrid/terraform-aws-athena-alb-table](https://github.com/StratusGrid/terraform-aws-athena-alb-table)

 Provide an application load balancer name, workgroup name, and database name, and the module will create an Athena table to query the logs. Requires that access logs are enabled on the ALB.
 - [Creating Tables For ALB Logs](https://docs.aws.amazon.com/athena/latest/ug/application-load-balancer-logs.html#create-alb-table)

 ## Example

 ```hcl
 module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  acl    = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

resource "aws_athena_workgroup" "workgroup" {
  name  = "my-athena-workgroup"

  configuration {
    publish_cloudwatch_metrics_enabled = false

    result_configuration {
      output_location = "s3://${module.s3_bucket.s3_bucket_id}/athena/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}

resource "aws_athena_database" "database" {
  name   = "my_athena_database"
  bucket = module.s3_bucket.s3_bucket_id
  force_destroy = true
}

module "aws_athena_alb_logs" {
  source  = "StratusGrid/terraform-aws-athena-alb-table/aws"
  # source   = "github.com/StratusGrid/terraform-aws-terraform-aws-athena-alb-table"
  alb_name   = "test-lb-matt-barlow"
  workgroup_name = aws_athena_workgroup.workgroup.name
  database_name = aws_athena_database.database.name
}
 ```

 ## StratusGrid Standards we assume

 - All resource names shall use `_` and not `-`s
 - The old naming standard for common files such as inputs, outputs, providers, etc was to prefix them with a `-`, this is no longer true as it's not POSIX compliant. Our pre-commit hooks will fail with this old standard.
 - StratusGrid generally follows the TerraForm standards outlined [here](https://www.terraform-best-practices.com/naming)

 ## Repo Knowledge

 This repo has several base requirements
 - This repo is based upon the AWS `~> 4.9.0` provider
 - The following packages are installed via brew: `tflint`, `terrascan`, `terraform-docs`, `gitleaks`, `tfsec`, `pre-commit`, `go`
 - Install `bash` through Brew for Bash 5.0, otherwise it will fail with the error that looks like `declare: -g: invalid option`
 - If you need more tflint plugins, please edit the `.tflint.hcl` file with the instructions from [here](https://github.com/terraform-linters/tflint)
 - It's highly recommend that you follow the Git Pre-Commit Instructions below, these will run in GitHub though they should be ran locally to reduce issues
 - By default Terraform docs will always run so our auto generated docs are always up to date
 - This repo has been tested with [awsume](https://stratusgrid.atlassian.net/wiki/spaces/TK/pages/1564966913/Awsume)
 - The Terraform module standard is to place everything in the `main.tf` file, and this works well for small modules. Though StratusGrid suggests breaking it out into multiple files if the module is larger or touches many resources such as data blocks.
 - StratusGrid requires the tag logic be used and every resource within the module be tagged with `local.tags`

 ### TFSec

 See the pre-commit tfsec documentation [here](https://github.com/antonbabenko/pre-commit-terraform#terraform_tfsec), this includes on how to bypass warnings

 ## Apply this template via Terraform

 ### Before this is applied, you need to configure the git hook on your local machine
 ```bash
 #Verify you have bash5
 brew install bash

 # Test your pre-commit hooks - This will force them to run on all files
 pre-commit run --all-files

 # Add your pre-commit hooks forever
 pre-commit install
 ```

 ### Template Documentation

 A sample template Git Repo with how we should setup client infrastructure, in this case it's shared infrastructure.
 More details are available [here](https://stratusgrid.atlassian.net/wiki/spaces/MS/pages/2065694728/MSP+Client+Setup+-+Procedure) in confluence.

 ## Documentation

 This repo is self documenting via Terraform Docs, please see the note at the bottom.

 ### `LICENSE`
 This is the standard Apache 2.0 License as defined [here](https://stratusgrid.atlassian.net/wiki/spaces/TK/pages/2121728017/StratusGrid+Terraform+Module+Requirements).

 ### `outputs.tf`
 The StratusGrid standard for Terraform Outputs.

 ### `README.md`
 It's this file! I'm always updated via TF Docs!

 ### `tags.tf`
 The StratusGrid standard for provider/module level tagging. This file contains logic to always merge the repo URL.

 ### `variables.tf`
 All variables related to this repo for all facets.
 One day this should be broken up into each file, maybe maybe not.

 ### `versions.tf`
 This file contains the required providers and their versions. Providers need to be specified otherwise provider overrides can not be done.

 ## Documentation of Misc Config Files

 This section is supposed to outline what the misc configuration files do and what is there purpose

 ### `.config/.terraform-docs.yml`
 This file auto generates your `README.md` file.

 ### `.config/terrascan.yaml`
 This file has all of the configuration options required for Terrascan, this is where you would skip rules to.

 ### `.github/sync-repo-settings.yaml`
 This file is our standard for how GitHub branch protection rules should be setup.

 ### `.github/workflows/pre-commit.yml`
 This file contains the instructions for Github workflows, in specific this file run pre-commit and will allow the PR to pass or fail. This is a safety check and extras for if pre-commit isn't run locally.

 ### `.vscode/settings.json`
 This file is a vscode workspace settings file.

 ### `examples/*`
 The files in here are used by `.config/terraform-docs.yml` for generating the `README.md`. All files must end in `.tfnot` so Terraform validate doesn't trip on them since they're purely example files.

 ### `.gitignore`
 This is your gitignore, and contains a slew of default standards.

 ### `.pre-commit-config.yaml`
 This file is the GIT pre-commit file and contains all of it's configuration options

 ### `.prettierignore`
 This file is the ignore file for the prettier pre-commit actions. Specific files like our auto generated README have to be ignored.

 ### `.python-version`
 Specifies the Python version that the `actions/setup-python` in GitHub Actions should use.

 ### `.tflint.hcl`
 This file contains the plugin data for TFLint to run.

 ---

 ## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |

 ## Resources

| Name | Type |
|------|------|
| [aws_athena_named_query.alb_access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |

 ## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Name of the Application Load Balancer | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the database to use for the table creation | `string` | n/a | yes |
| <a name="input_partition_table"></a> [partition\_table](#input\_partition\_table) | Whether or not to create table partitioning. Recommended for large ALB sets | `bool` | `true` | no |
| <a name="input_query_name"></a> [query\_name](#input\_query\_name) | Optionally provide a name for the saved query that creates the table | `string` | `""` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Optionally provide a name for the table | `string` | `""` | no |
| <a name="input_workgroup_name"></a> [workgroup\_name](#input\_workgroup\_name) | Name of the workgroup to use for the query and query results | `string` | n/a | yes |

 ## Outputs

No outputs.

 ---

 Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->