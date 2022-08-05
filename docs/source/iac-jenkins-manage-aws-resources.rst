Managing AWS resources
======================

.. include:: icons.rst

This section describes the details on how to manage AWS resources provisioned. All the resources provisioned
in AWS by terraform automation has access only to the IAM role used to provision resources.

Hence to manage the resources the IAM role needs to be assumed.

1. Just to recollect during the initial preparation phase an IAM user called "terraform" and IAM role called
"tf_automation" with necessary permissions was configured

2. Further this IAM user assumed IAM role to provision AWS resources through CI-CD pipeline

3. By default all the resources are accessible by the IAM role "tf_automation. Hence assuming this role helps to gain access to these resources

4. However only for the IAM role "terraform" is allowed to assume this "tf_automation". Hence login as terraform user
and assume this IAM role to manage it.

5. Since this terraform user is configured only with programmatic access, it is required to use AWS CLI to manage resources

Using AWS CLI and assuming role
-------------------------------

1. Install AWS CLI (refer to AWS documentation to install AWS CLI)

2. Go to the user profile directory under "./aws" directory

3. Edit the file called "credentials" located under user profile directory "./aws/"

4. Update terraform user access/secret keys and assume role profile configuration as below

+---------------------------------------------------+
|[openidl-terraform-user]                           |
|aws_access_key_id = <accesskey>                    |
|aws_secret_access_key = <secretkey>                |
|                                                   |
|[openidl-terraform-role]                           |
|role_arn = <IAM-ROLE-ARN>                          |
|source_profile = openidl-terraform-user            |
|external_id = terraform                            |
|region = <aws-region>                              |
+---------------------------------------------------+

5. Once this profile is updated in the "credentials" file save and close

6. Go to command line interface and set the AWS_PROFILE=openidl-terraform-role

    Linux: export AWS_PROFILE=openidl-terraform-role
    Windows: set AWS_PROFILE=openidl-terraform-role

7. Validate the profile is configured well and IAM user is able to assume the role by running this command.

    #aws sts get-caller-identity

+----------------------------------------------------------------------------------+
|{                                                                                 |
| "UserId": "AROAYM7S43VMIRGVMSVN6:botocore-session-1629220738",                   |
| "Account": "577645632856",                                                       |
| "Arn": "arn:aws:sts::577645632856:assumed-role/terraform_automation/terraform"   |
|}                                                                                 |
+----------------------------------------------------------------------------------+

8. Now it is all set to manage AWS resources through CLI

