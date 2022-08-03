References – Inputs
===================

Input Template
--------------

| #The following inputs should be via git secrets as they contain
  sensitive data. refer to README.md
| ##################start of sensitive data that goes to git
  secrets###################
| aws_account_number = "" #mandatory
| aws_access_key = "" #mandatory
| aws_secret_key = "" #mandatory
| aws_user_arn = "" #mandatory
| aws_role_arn = "" #mandatory
| aws_region = "" #mandatory
| aws_external_id = "" #mandatory
| bastion_ssh_key = "" #mandatory
| app_eks_worker_nodes_ssh_key = "" #mandatory
| blk_eks_worker_nodes_ssh_key = "" #mandatory
| #Cognito specifications
| #When email_sending_account = "COGNITO_DEFAULT", set the below to
  empty in git secrets
| #When email_sending_account = "DEVELOPER", setup verified email
  address in AWS SES on cognito supported region and update the below in
  git secrets
| ses_email_identity = "" #email address verified in AWS SES
| userpool_email_source_arn ="" #arn of the email address configured in
  aws SES service
| #List of iam users and their relevant groups mapping in EKS for its
  access
| #When no additional IAM users are required to enable EKS access, set
  the below as empty in git secrets
| app_cluster_map_users = ["<userarn>","<userarn>"] #Optional, if not
  required set to empty in git secrets
| app_cluster_map_roles = ["<rolearn>","<rolearn>"] #Optional, if not
  required set to emtpy in git secrets
| #List of iam roles and their relevant group mapping in EKS for its
  access
| #When no additional IAM roles are required to enable EKS access, set
  the below as empty in git secrets
| blk_cluster_map_users = ["<userarn>","<userarn>"] #Optional, if not
  required set to empty in git secrets
| blk_cluster_map_roles = ["<rolearn>","<rolearn>"] #Optional, if not
  required set to empty in git secrets
| #Name of S3 bucket to hold terraform input file
| aws_input_bucket = ""
| ################end of sensitive data that goes to git
  secrets#####################
| #set org name as below
| #when nodetype is aais set org_name="aais"
| #when nodetype is analytics set org_name="analytics"
| #when nodetype is aais's dummy carrier set org_name="carrier" and for
  other carriers refer to next line.
| #when nodetype is other carrier set org_name="<carrier_org_name>" ,
  example: org_name = "travelers" etc.,
| org_name = "aais"
| aws_env = "<env>" #set to dev|test|prod

| #--------------------------------------------------------------------------------------------------------------------
| #Cluster VPC specifications
| create_vpc = "true" # set to true to create VPC, false when existing VPC is planned to use
| vpc_id = "" # when create_vpc is set to false, key in valid VPC Id
| vpc_cidr = "<vpc_cidr>" # applicable when create_vpc is true
| availability_zones = ["", "", ""] # applicable when create_vpc is true
| public_subnets = ["", "", ""] # applicable when create_vpc is true
| private_subnets = ["", "", ""] # applicable when create_vpc is true
| #--------------------------------------------------------------------------------------------------------------------
| #Bastion host specifications
| #Bastion hosts are placed in autoscaling group with EIP.
| create_bastion_host = "true" # Choose whether bastion host required or not.
| bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "<IP/CIDR>"}] #applicable when bastion host is opted.
| bastion_sg_egress =   [{rule="ssh-tcp", cidr_blocks = "<IP/CIDR>"}] #applicable when bastion host is opted.
| #--------------------------------------------------------------------------------------------------------------------
| #Route53 (PUBLIC) DNS domain related specifications
| domain_info = {
| r53_public_hosted_zone_required = "<yes>", #Options: yes \| no. Setting this to "yes" will provision public hosted zone in Route53
| domain_name = "<domain_name>", #primary domain registered
| sub_domain_name = "<sub_domain_name>", #sub domain name is optional. If not used keep it empty quotes
| comments = "<comments>"
| }
| #--------------------------------------------------------------------------------------------------------------------
| #Cognito specifications
| create_cognito_userpool = "true" | Choose whether cognito user pool is required.
| userpool_name = "<cognito_pool_name>" #unique user_pool name when chosen
| # COGNITO_DEFAULT - Uses cognito default. When set to cognito default
  SES related inputs ses_email_identity and userpool_email_source_arn goes empty in git secrets
| # DEVELOPER - Ensure inputs ses_email_identity and userpool_email_source_arn are setup in git secrets
| email_sending_account = "COGNITO_DEFAULT" # Options: COGNITO_DEFAULT \| DEVELOPER
| #--------------------------------------------------------------------------------------------------------------------
| # application cluster EKS specifications
| app_cluster_name = "<app_cluster_name>"
| app_cluster_version = "<version>"
| app_worker_nodes_ami_id = "AMI-ID"
| #--------------------------------------------------------------------------------------------------------------------
| # blockchain cluster EKS specifications
| blk_cluster_name = "<blk_cluster_name>"
| blk_cluster_version = "<version>"
| blk_worker_nodes_ami_id = "<AMI-ID>"
| #--------------------------------------------------------------------------------------------------------------------
| #cloudtrail related
| create_cloudtrail = "true" # Choose whether cloudtrail is required to enable.
| s3_bucket_name_cloudtrail = <s3_bucket_name> #s3 bucket name to manage cloudtrail logs
| #--------------------------------------------------------------------------------------------------------------------
#Terraform backend specification
| terraform_state_s3_bucket_name = "" # when s3 is used for TF state backend
| tf_org_name = "" # organization name in Terraform Cloud/Enterprise when TFC/TFE is used for backend
| tf_workspace_name_aws_resources = "" # Terraform workspace chosen for AWS resources when TFC/TFE is used
| #--------------------------------------------------------------------------------------------------------------------
#Applicable only to analytics and carrier node. For AAIS node set this to empty
| s3_bucket_name_hds_analytics = "" #S3 bucket name to manage HDS analytics data when node is analytics/carrier
| #--------------------------------------------------------------------------------------------------------------------
#Name of Public S3 bucket used to manage logos which is optional.
| create_s3_bucket_public = "true" | Helps to choose decide in provisioning public s3 bucket
| s3_bucket_name_logos = "" # public s3 bucket name
| #--------------------------------------------------------------------------------------------------------------------
#Name of S3 bucket to store access logs of S3 bucket and its objects
| s3_bucket_name_access_logs = "" # bucket name to store s3 access logs
| #--------------------------------------------------------------------------------------------------------------------
#KMS keys to be either created or used existing Keys
| create_kms_keys = "true" # Set to true to create keys and false to use existing keys
| s3_kms_key_arn = "" #KMS key ARN that will be used to encrypt S3
| eks_kms_key_arn = "" #KMS key ARN that will be used to encrypt EKS secrets
| cloudtrail_cw_logs_kms_key_arn = "" #KMS key ARN that will be used to encrypt cloutrail cloudwatch logs
| vpc_flow_logs_kms_key_arn = "" #KMS key ARN that will be used to encrypt VPC flow logs
| secrets_manager_kms_key_arn = "" #KMS key ARN that will be used to encrypt secrets
| #--------------------------------------------------------------------------------------------------------------------
#Cloudwatch logs retention period (VPC flow logs, EKS logs and cloutrail logs)
| cw_logs_retention_period = "<days>" #example 90 days
| #--------------------------------------------------------------------------------------------------------------------
| custom_tags = { <tag1> = "<value1>", <tag2> = "<value2>" } # custom tags to include

Sample input file used for aais_node setup
------------------------------------------

org_name = "aais"
aws_env = "dev"

#--------------------------------------------------------------------------------------------------------------------
#Choose whether to create VPC or use existing VPC
create_vpc = "true"

#Key in VPC ID when create_vpc is set to false
vpc_id = ""

#Key in for the below when create_vpc is set to true
# 3 Availability Zones required
vpc_cidr = "172.18.0.0/16"
availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
public_subnets = ["172.18.1.0/24", "172.18.2.0/24", "172.18.5.0/24"]
private_subnets = ["172.18.3.0/24", "172.18.4.0/24", "172.18.6.0/24"]
#--------------------------------------------------------------------------------------------------------------------
#Bastion host specs. It is provisioned in autoscaling group and gets an Elastic IP assigned
#Choose whether to provision bastion host
create_bastion_host = "true"

#when chosen to create bastion host, set the required IP address or CIDR block that is allowed SSH access to bastion host
bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "3.237.88.84/32"}]
bastion_sg_egress =   [{rule="ssh-tcp", cidr_blocks = "3.237.88.84/32"}]
#--------------------------------------------------------------------------------------------------------------------
#Route53 (PUBLIC) DNS domain related specifications
domain_info = {
  r53_public_hosted_zone_required = "yes", #Options: yes | no - This allows to chose whether to setup public hosted zone in Route53
  domain_name = "aaisdirect.com", #Primary domain registered
  sub_domain_name = "", #Sub domain if applicable. Otherwise it can be empty quotes
  comments = "aais-dev node domain"
}
#--------------------------------------------------------------------------------------------------------------------
#Cognito specifications
#Chose whether to provision Cognito user pool
create_cognito_userpool = "true"

#When cognito is choosen to provision set the below
userpool_name                = "openidl" #unique user_pool name

# COGNITO_DEFAULT - Uses cognito default. When set to cognito default SES related inputs goes empty in git secrets
# DEVELOPER - Ensure inputs ses_email_identity and userpool_email_source_arn are setup in git secrets
email_sending_account        = "COGNITO_DEFAULT" # Options: COGNITO_DEFAULT | DEVELOPER
#--------------------------------------------------------------------------------------------------------------------
# application cluster EKS specifications
app_cluster_name              = "app-cluster"
app_cluster_version           = "1.20"
app_worker_nodes_ami_id       = "ami-09fd0b5dd68327412"
#--------------------------------------------------------------------------------------------------------------------
# blockchain cluster EKS specifications
blk_cluster_name = "blk-cluster"
blk_cluster_version = "1.20"
blk_worker_nodes_ami_id = "ami-09fd0b5dd68327412"
#--------------------------------------------------------------------------------------------------------------------
#cloudtrail related
#Choose whether to enable cloudtrail
create_cloudtrail = "true"

#S3 bucket name to manage cloudtrail logs
s3_bucket_name_cloudtrail = "openidl-cloudtrail"
#--------------------------------------------------------------------------------------------------------------------
#Terraform backend specification when S3 is used
terraform_state_s3_bucket_name = "openidl-tf-state"
#--------------------------------------------------------------------------------------------------------------------
#Terraform backend specifications when Terraform Enterprise/Cloud is used
#Name of the TFE/TFC organization
tfc_org_name = ""
#Name of the workspace that manages AWS resources
tfc_workspace_name_aws_resources = ""
#--------------------------------------------------------------------------------------------------------------------
#Applicable only to analytics and carrier nodes and not applicable to AAIS node. For AAIS it can be empty.
#Name of the S3 bucket used to store the data extracted from HDS for analytics

s3_bucket_name_hds_analytics = "openidl-hds"
#--------------------------------------------------------------------------------------------------------------------
#Name of the PUBLIC S3 bucket used to manage logos
#Optional: Choose whether s3 public bucket is required to provision
create_s3_bucket_public = "true"

s3_bucket_name_logos = "openidl-public-logos"
#--------------------------------------------------------------------------------------------------------------------
#Name of the S3 bucket to store S3 bucket and its object access logs
s3_bucket_name_access_logs = "openidl-access-logs"
#--------------------------------------------------------------------------------------------------------------------
#KMS Key arn to be used when create_kms_keys is set to false
create_kms_keys = "true"
s3_kms_key_arn = ""
eks_kms_key_arn = ""
cloudtrail_cw_logs_kms_key_arn = ""
vpc_flow_logs_kms_key_arn = ""
secrets_manager_kms_key_arn = ""

#--------------------------------------------------------------------------------------------------------------------
#Cloudwatch logs retention period (For VPC flow logs, EKS logs, Cloudtrail logs)
cw_logs_retention_period = "90" #example 90 days
#--------------------------------------------------------------------------------------------------------------------
#Custom tags to include

custom_tags = {
  department = "openidl"
  team = "demo-team"
}
