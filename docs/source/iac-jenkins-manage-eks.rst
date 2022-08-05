Managing EKS Kubernetes Cluster and resources
=============================================

.. include:: icons.rst

This section briefs the details about access to EKS kubernetes cluster and how to manage it.

Let us first understand how this access to EKS cluster is all set in AWS. Whenever a kubernetes cluster is created in AWS the
IAM user or IAM role assumed by the user gains access to EKS cluster by default. Other than this IAM user/role none of them
will have access to the cluster.

However in our project during AWS resource provisioning, there is an option to enter list of IAM users/IAM roles to provision
access to EKS cluster part of deployment and its configuration. In case if you have added some IAM user/IAM role they
would have gained access.

Finally the last option is that part of our project there is a default IAM role which is set to have access to the EKS cluster.
However to assume this IAM role manage EKS cluster, an IAM user must the added to the specific IAM group setup part of
resource provisioning. Once the user is added in the group then the user has permissions to assume this IAM role to manage
EKS cluster.

In summary who has access to EKS cluster

1. tf_automation role and it can be assumed by terraform user

2. List of IAM users/IAM roles allowed permissions to the EKS cluster part of AWS resource provisioning pipeline process

3. Letting list of IAM users by subscribing to IAM group specifically setup for this purpose and the user assumes the IAM role
allowed to assume by this group membership

In all of these cases setting up AWS CLI and configuring IAM role assumption in AWS profiles helps to gain access to EKS cluster.

In case how to setup AWS CLI profile, refer to section "Managing AWS resources"

Adding IAM user to IAM group for managing EKS
---------------------------------------------

1. Login to AWS and got IAM and under groups

2. Edit the group <orgname>-<env>-eks-admin. Example aais-dev-eks-admin

3. Add any IAM user expected to give permissions to EKS cluster

Now the user has permission to assume the IAM role named "<orgname>-<env>-eks-admin" to gain eks cluster access.

    Example IAM ROLE ARN: arn:aws:iam::<acc_number>:role/carr-dev-eks-admin

Managing EKS Kubernetes Cluster
-------------------------------

1. Setup AWS CLI (refer to AWS documentation)

2. Setup AWS Profile (refer to section managing aws resources)

3. set/export AWS_PROFILE

4. set cluster context to whichever cluster the user is going to manage

    #aws eks update-kubeconfig --region <region> --name <orgname>-<env>-<clustername>

    Example: aws eks update-kubeconfig --region us-east-2 --name aais-dev-blk-cluster



