Update IAM Role with Trust Policy
---------------------------------

|checkbox| **Update role trust policy**

1. Finally, time to update the trust policy for the IAM role created in the
   previous step. So, within AWS console under IAM go to roles in access
   management, select the role created in previous step.

2. Go to trust relationships and click on Edit trust relationship

3. Now update the policy document using the below template with update
   on IAM user ARN and finish update trust policy

    .. code-block:: JSON

        {
            "Version": "2012-10-17",
            "Statement": [
                {
                "Effect": "Allow",
                "Principal": {
                    "AWS": "<IAM_USER_ARN>"
                },
                "Action": [
                    "sts:AssumeRole",
                    "sts:TagSession"
                ],
                "Condition": {
                    "StringEquals": {
                    "sts:ExternalId": "<AWS_EXTERNAL_ID>"
                    }
                }
                }
            ]
        }

External ID is from the first step of IAM. “terraform”

Now we have completed the following steps

1. Created IAM role (ARN to be noted)
2. Assigned permission policy to manage AWS resources
3. Created IAM user that issues access key and secret key as well (ARN, access key and secret key to be noted)
4. Created and assigned IAM assume policy to IAM user to assume the IAM role
5. Updated trust policy in IAM role to allow IAM user to assume the role

This IAM user credentials and IAM role will be used in managing AWS resources via Terraform IaC.

