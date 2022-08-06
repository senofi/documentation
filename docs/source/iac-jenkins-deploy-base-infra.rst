Deploy Base Infrastructure in AWS Cloud
=======================================

Since the preparation phase is completed, the next phase is deployment in which getting the jenkins pipelines
executed to provision the following.

1. Base infrastructure deployment in AWS cloud (uses Terraform/Jenkins)
2. Vault deployment (uses Jenkins/Ansible)
3. Blockchain deployment (uses Jenkins/Ansible)
4. MongoDB deployment (uses Jenkins/Ansible)
5. OpenIDL application secrets deployment (uses Jenkins/Ansible)
6. OpenIDL application deployment (uses Jenkins/Ansible)

The following section describes how to prepare and execute each Jenkins job to provision on the node.
Let us first focus on deploying base infrastructure in AWS cloud.

|checkbox| **Base infrastructure preparation**

Executing Jenkins pipeline to provision AWS resources using Terraform Cloud
---------------------------------------------------------------------------

|checkbox| **Provision AWS resources using Jenkins/Terraform pipeline**

This is the job previously setup. It is used to provision AWS resources
and K8s resources. Before triggering the pipeline ensure that the following are already setup
as documentation in previous section.

1. Terraform Cloud/Enterprise (Workspaces, VariableSet, API Token)

2. Jenkins (Credentials, Job configuration)

3. Terraform code changes and pushed to repository

|NOTE| **First run after configuring the job is dummy run as the option
shows as “Build Now”. This will fail and will update your job with
relevant parameters required for the job to run. Further runs will show
an option Build with Parameters which will be right run.**

1. To trigger the job, go to Jenkins => relevant job (terraform) => Build with
   Parameters.

2. Enter the values to the inputs as listed below.

+-----------------+----------------------------------------------------+
| **Field**       | **Description**                                    |
+=================+====================================================+
| TF_ADDRESS      | Terraform Cloud/Enterprise endpoint                |
+-----------------+----------------------------------------------------+
| TF_ORG_NAME     | Organization name setup in Terraform               |
+-----------------+----------------------------------------------------+
| T               | Terraform workspace name setup specifically for    |
| F_AWS_WORKSPACE | AWS resources                                      |
+-----------------+----------------------------------------------------+
| T               | Terraform workspace name setup specifically for    |
| F_K8S_WORKSPACE | K8s resources                                      |
+-----------------+----------------------------------------------------+
| GITHUB_URL      | GitHub repository to check out the code            |
+-----------------+----------------------------------------------------+
| GITHUB_BRANCH   | GitHub branch specifically to check out the code   |
+-----------------+----------------------------------------------------+

3. The job runs terraform plan and asks manual confirmation before
   running terraform apply. This job will run first to provision AWS
   resources and further run for K8s resources. Hence twice it asks
   input to confirm before performing terraform apply.

.. image:: images3/image64.png

**NOTE:**

It is noticed that sometimes the request to upload configuration data
(git repository content) to Terraform fails with below HTTP error 422.
In case when you see the pipeline failed with this error, rerun the
pipeline which will help.

+----------------------+-----------------------+-----------------------+
| **Status**           | **Response**          | **Reason**            |
+======================+=======================+=======================+
| 422                  | JSON API error object | Malformed request.    |
+----------------------+-----------------------+-----------------------+


Once the AWS resources are provisioned successfully, carefully review the resources provisioned
and perform the below actions.

Disable access keys and setup new access keys
---------------------------------------------

|checkbox| **Disable existing keys, create new keys and note down credentials for next stage**

The terraform pipeline provisions three vital AWS IAM user resources. As
this is provisioned part of terraform these user access and secret keys
are in terraform state file.

The initial provisioned access keys and secret keys should not be used,
and it should be set as INACTIVE(Do not delete them). Further create new access keys and secret keys
for these users and use them.

NOTE: The name of the user has the first part truncated from the
org_name. That is “carrier” becomes “carr-dev-baf-automation” which
could cause a problem during testing if creating more than one carrier.

.. csv-table: IAM users
    :file: table5.csv
    :header-rows: 1

|Note| **Note down the access keys and secret keys of the IAM users. Also note down the IAM roles that these users will assume.
Refer to inline policy of the users to identify the same if required**

Remove security rule created by Kubernetes NGINX proxy deployment
-----------------------------------------------------------------

|checkbox| **Remove mentioned security group rules**

Once AWS resources are provisioned. The following security rules from
the security groups are required to remove as they are deployed by
default by Ingress Controller deployment in Kubernetes cluster.

Refer to the following security groups to identify the rule and remove
it.

.. csv-table: Security Groups
    :file: table6.csv
    :header-rows: 1

1. Go to EC2/VPC services section in the AWS console

2. Go to Security Group section

3. Look for the security group as mentioned in the above table

.. image:: images/image42.png
   :width: 6.50556in
   :height: 2.65486in

3. Open the security group and look for the rule related to ICMP set
   with source 0.0.0.0/0 and remove it. The below screenshot is a
   reference. Please remove only this rule only.

..

   .. image:: images/image43.png
      :width: 6.5in
      :height: 1.11528in

4. Remove this rule from both (two) security groups as mentioned the
   table above.

Confirm email id subscription confirmation
------------------------------------------

1. During the resource provisioning list of email ids included for SNS notification subscription

2. The infra provisioning would have subscribed these list of email ids to the SNS topics

3. The subscription process involves SES emailing subscription confirm/verify emails to individual email Ids

4. Each email account owners required to verify them before SNS could start sending notifications

Review and collect AWS resources details required:
--------------------------------------------------

|checkbox| **Collect AWS resource information based on the infra provisioned as it is required in next pipeline jobs**

1. account number it not noted previously
2. aws region
3. application EKS cluster name
4. blockchain EKS cluster name
5. vault secret name (refer to secret manager)
6. <orgname>-<env>-gitactions-admin credentials
7. <orgname>-<env>-openidl-apps-user credentials
8. <orgname>-<env>-baf-user  credentials
9. <orgname>-<env>-baf-automation role ARN which will be assumed by *-baf-user
10. <orgname>-<env>-gitactions-admin role ARN which will be assumed by *-gitactions-admin user
11.<orgname>-<env>-openidl-apps role ARN which will be assumed by *-openidl-apps-user
12. cognito pool id
13. cognito app client id
14. s3 buckets created for HDS and IDM-ETL functions

**In case anything missed to list here, while setting up the environment let us identify and include.**





