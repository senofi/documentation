Managing MongoDB
================

.. include:: icons.rst

The below are the steps to perform to manage MongoDB instance.


1. Setup AWS CLI and set AWS_PROFILE to the relevant IAM credentials that has access to EKS application cluster

2. Set the context to application cluster
    Example: aws eks update-kubeconfig --region <region> --name <app-cluster-name>

3. Set port forward using below command

    #kubectl port-forward -n database svc/${ORG-NAME}-mongodb-headless 27017:27017

|NOTE| org-name refers to organisation name set during node preparation (AWS resources/blockchain)

|NOTE| If you are running mongodb locally, you should use another port like 28017:27017 in port-forward command

4. Connect to MongoDB using Compass client with following URL

# mongodb://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@localhost:27017 /openidl-offchain-db?authSource=openidl-offchain-db

|NOTE| The mongodb_username and mongodb_password are put into the aws secrets manager at

<org_name>-<env>-mongodb-user for the username and
<org_name>-<env>-mongodb-user-token for the password

|NOTE| use "tf_automation" role to access the tokens as they have rights to read the credentials.

5. Command to retrieve secrets

    #aws secretsmanager get-secret-value --region <region> --secret-id <orgname>-<env>-mongodb-user
    #aws secretsmanager get-secret-value --region <region> --secret-id <orgname>-<env>-mongodb-user-token


