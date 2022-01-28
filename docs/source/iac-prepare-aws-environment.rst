Prepare AWS environment
=======================

Setup IAM Role
--------------

1.	Login to AWS console using either a root account or IAM user with administrative rights
2.	Go to IAM and go to roles under access management and click on create role
3.	Select type of trusted entity as “Another AWS account”
4.	Under specify accounts that can use this role set the Account ID to AWS account number (same AWS account number that you are logged in) and select Option Require external ID

    .. image:: images/iac_aws_setup_1.png

5. Set a value to External ID and note down this as it would be used in terraform configuration and click next

    .. image:: images/iac_aws_setup_2.png

6. Then click on create policy, select json and update the policy content with below policy to limit only necessary permissions for the IAM role to be used by terraform to manage AWS resources. 

    .. code-block:: JSON

        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "AllowServices",
                    "Effect": "Allow",
                    "Action": [
                        "iam:*",
                        "ec2:*",
                        "s3:*",
                        "cloudtrail:*",
                        "cloudwatch:*",
                        "logs:*",
                        "ses:*",
                        "cognito-idp:*",
                        "eks:*",
                        "kms:*",
                        "dynamodb:*",
                        "acm:*",
                        "autoscaling:*",
                        "elasticloadbalancing:*",
                        "ebs:*",
                        "route53:*",
                        "route53domains:*",
                        "sts:*",
                        "secretsmanager:*",
                        "cloudformation:ListStacks"

                    ],
                    "Resource": "*"
                }
            ]
        }

7. Add necessary meaningful tags which are arbitrary for the policy

   **Example:**

    Owner = “”

    Used_by = “terraform”

    Application = “openidl”

8. Enter a name for the IAM policy, ex: tf_admin_policy and click on create policy to finish

    .. image:: images/iac_aws_setup_3.png

9. Once the policy is created, go back to roles screen, and create the role again click refresh and select the named policy created in previous step and hit the refresh button.

    .. image:: images/iac_aws_setup_4.png

10. Add the necessary arbitrary tags to the IAM role this time and click Review

11. Enter role name, a description and ensure the policy is assigned as per below screen shot and click on create role to finish setting up IAM role with necessary policy required to manage AWS

12. Note down the ARN of the IAM role created as it is required for next steps as well as in terraform configuration.

    .. image:: images/iac_aws_setup_5.png


