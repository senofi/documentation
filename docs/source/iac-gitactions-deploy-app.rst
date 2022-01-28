Deploying Application (UI and Services)
=======================================

Following are steps to deploy Application and UI Services

-  Create MongoDB on Application Cluster

-  Create Application Configuration Files from Templates

-  Add Application Configuration Files to Vault on the Blockchain
   Cluster

-  Run the github actions pipeline to deploy secrets and application
   helm charts

-  Create Admin User in Cognito

-  Create Application User using Utilities Service

Deploy MongoDB (GitHub Actions)
-------------------------------

**NOTE**: In case during mongoDB deployment if it fails due to issues
before rerunning again after resolving issues, please run clean-up job
first to remove all the leftovers.

**ACTION NAME:** mongodb_cleanup – It is used to cleanup the leftovers
by action mongodb

1. Login into the “\ **openidl-aais-gitops**\ ” repository and navigate
   to the Action Tab in GitHub account (reference to screenshot below)

    .. image:: images/image51.png

2. Click on the “Deploy Mongo DB” workflow under the “Workflow” section
(reference to screenshot below)

    .. image:: images/image52.png

3. Click on “\ **Run workflow**\ ” with following fields

+------------------+---------------------------------------------------+
| Use workflow     | Branch to run the pipeline against for deploying  |
| from             | the Blockchain network                            |
+==================+===================================================+
| ORGANIZATION     | Organization name to use for deploying the Mongo  |
| NAME             | DB                                                |
+------------------+---------------------------------------------------+
| ENVIRONMENT      | Environment name to use for deploying the Mongo   |
|                  | DB ex: dev, stage, or prod                        |
+------------------+---------------------------------------------------+

5. Once the required arguments are updated in the dialog box, click on
the button “Run workflow” which will start the workflow.

Port Forwarding to Mongo DB
~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Setup AWS CLI and log-in using aws_access_key_id and
   aws_secret_access_key

2. Set the context for application cluster

Example: >aws eks update-kubeconfig –region <region> --name
<app-cluster>

3. Setup port forward using below command

# kubectl port-forward --namespace database
svc/${ORG_NAME}-mongodb-headless 27017:27017

NOTE: if you are running mongo locally, you should use another port like
28017:27017

4. Connect to Mongo DB using Compass with following URL

# mongodb://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@localhost:27017
/openidl-offchain-db?authSource=openidl-offchain-db

NOTE: the mongodb_username and mongodb_password are put into the aws
secrets manager at <org_name>-<env>-mongodb-user for the username and
<org_name>-<env>-mongodb-user-token for the password

Creating Application Configuration files
----------------------------------------

Use the application configuration templates to replace the following
files for each individual organization. These files are found in the
openidl-config directory in the openidl-main repository. Copy the
template config file to create a usable config file with all the correct
values. Then run #make copy_config_files to generate correct config
files in the config directory.

There are targets available for specific like #make copy_carrier_secrets

AAIS Variables
~~~~~~~~~~~~~~

+------------------------+---------------------------------------------+
| **JSON File Name**     | **Values to be Replaced**                   |
+========================+=============================================+
| channel-config.json    | AAIS_ORGNAME: aais                          |
|                        |                                             |
|                        | CARRIER_ORGNAME: trv                        |
|                        |                                             |
|                        | Add cross channel query params for all      |
|                        | carriers                                    |
+------------------------+---------------------------------------------+
| c                      | Refer to 11.2.4 Creating Connection Profile |
| onnection-profile.json |                                             |
|                        | AAIS_ORGNAME: aais                          |
|                        |                                             |
|                        | ENV: DEV                                    |
|                        |                                             |
|                        | DOMAIN: techiething                         |
|                        |                                             |
|                        | TLS_CERT: CA TLS Certificate                |
+------------------------+---------------------------------------------+
| insurance-data-manag   | AAIS_ORGNAME: aais                          |
| er-channel-config.json |                                             |
+------------------------+---------------------------------------------+
| listen                 | AAIS_ORGNAME: aais                          |
| er-channel-config.json |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
+------------------------+---------------------------------------------+
| local-cog              | AWS Credentials                             |
| nito-admin-config.json |                                             |
|                        | AWS_ACCESS_KEY_ID                           |
|                        |                                             |
|                        | AWS_SECRET_ACCESS_KEY                       |
|                        |                                             |
|                        | AWS_REGION                                  |
|                        |                                             |
|                        | Refer to IAM user provisioned for           |
|                        | application.                                |
|                        | <orgname>-<envtype>-openidl-apps-user. Use  |
|                        | this user credentials.                      |
+------------------------+---------------------------------------------+
| loc                    | Cognito Config                              |
| al-cognito-config.json |                                             |
|                        | COGNITO_USERPOOLID                          |
|                        |                                             |
|                        | COGNITO_CLIENTID                            |
|                        |                                             |
|                        | COGNITO_REGION                              |
+------------------------+---------------------------------------------+
| local-db-config.json   | Mongo DB URL with credentials               |
|                        |                                             |
|                        | MONGO_DB_USERNAME                           |
|                        |                                             |
|                        | MONGO_DB_PASSWORD                           |
|                        |                                             |
|                        | AAIS_ORGNAME: aais                          |
+------------------------+---------------------------------------------+
| l                      | AWS Credentials and AWS Secret Name for     |
| ocal-vault-config.json | Vault                                       |
|                        |                                             |
|                        | AWS_ACCESS_KEY_ID                           |
|                        |                                             |
|                        | AWS_SECRET_ACCESS_KEY                       |
|                        |                                             |
|                        | AWS_REGION                                  |
|                        |                                             |
|                        | VAULT_SECRET_NAME: Look for this in AWS     |
|                        | Secret Manager.                             |
|                        |                                             |
|                        | Format <AAIS_ORGNAME>-<ENV>-kvs-vault       |
|                        |                                             |
|                        | Ex: aais-dev-kvs-vault                      |
|                        |                                             |
|                        | Refer to IAM user provisioned for           |
|                        | application.                                |
|                        | <orgname>-<envtype>-openidl-apps-user. Use  |
|                        | this user credentials.                      |
+------------------------+---------------------------------------------+
| targ                   | AAIS_ORGNAME: aais                          |
| et-channel-config.json |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
+------------------------+---------------------------------------------+
| u                      | AAIS_ORGNAME: aais                          |
| i-mappings-config.json |                                             |
|                        | ENV: DEV                                    |
|                        |                                             |
|                        | DOMAIN: techiething                         |
+------------------------+---------------------------------------------+
| util                   | Fabric CA Admin Credentials                 |
| ties-admin-config.json |                                             |
|                        | AAIS_ORGNAME: aais                          |
+------------------------+---------------------------------------------+

Analytics Variables
~~~~~~~~~~~~~~~~~~~

+------------------------+---------------------------------------------+
| **JSON File Name**     | **Values to be Replaced**                   |
+========================+=============================================+
| channel-config.json    | AAIS_ORGNAME: aais                          |
|                        |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
+------------------------+---------------------------------------------+
| c                      | Refer to 11.2.4 Creating Connection Profile |
| onnection-profile.json |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
|                        |                                             |
|                        | ENV: DEV                                    |
|                        |                                             |
|                        | DOMAIN: techiething                         |
|                        |                                             |
|                        | TLS_CERT: CA TLS Certificate                |
+------------------------+---------------------------------------------+
| data-call-mood-listen  | AAIS_ORGNAME: aais                          |
| er-channel-config.json |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
|                        |                                             |
|                        | CARRIER_ORGNAME: trv                        |
|                        |                                             |
|                        | Add listener channels for all carriers      |
|                        |                                             |
|                        | Ex: analytics-trv                           |
+------------------------+---------------------------------------------+
| data-c                 | ANALYTICS_ORGNAME: analytics                |
| all-mood-listener-targ |                                             |
| et-channel-config.json |                                             |
+------------------------+---------------------------------------------+
| local-cog              | AWS Credentials                             |
| nito-admin-config.json |                                             |
|                        | AWS_ACCESS_KEY_ID                           |
|                        |                                             |
|                        | AWS_SECRET_ACCESS_KEY                       |
|                        |                                             |
|                        | AWS_REGION                                  |
|                        |                                             |
|                        | Refer to IAM user provisioned for           |
|                        | application.                                |
|                        | <orgname>-<envtype>-openidl-apps-user. Use  |
|                        | this user credentials.                      |
+------------------------+---------------------------------------------+
| loc                    | Cognito Config                              |
| al-cognito-config.json |                                             |
|                        | COGNITO_USERPOOLID                          |
|                        |                                             |
|                        | COGNITO_CLIENTID                            |
|                        |                                             |
|                        | COGNITO_REGION                              |
+------------------------+---------------------------------------------+
| [STRIKEOUT             | [STRIKEOUT:Mongo DB URL with credentials]   |
| :local-db-config.json] |                                             |
|                        | [STRIKEOUT:MONGO_DB_USERNAME]               |
| [STRIKEOUT:NOT NEEDED  |                                             |
| ON analytics node]     | [STRIKEOUT:MONGO_DB_PASSWORD]               |
|                        |                                             |
|                        | [STRIKEOUT:ANALYTICS_ORGNAME: analytics]    |
+------------------------+---------------------------------------------+
| l                      | AWS Credentials and AWS Secret Name for     |
| ocal-vault-config.json | Vault                                       |
|                        |                                             |
|                        | AWS_ACCESS_KEY_ID                           |
|                        |                                             |
|                        | AWS_SECRET_ACCESS_KEY                       |
|                        |                                             |
|                        | AWS_REGION                                  |
|                        |                                             |
|                        | VAULT_SECRET_NAME: Look for this in AWS     |
|                        | Secret Manager.                             |
|                        |                                             |
|                        | Format <ANALYTICS_ORGNAME>-<ENV>-kvs-vault  |
|                        |                                             |
|                        | Ex: analytics-dev-kvs-vault                 |
|                        |                                             |
|                        | Refer to IAM user provisioned for           |
|                        | application.                                |
|                        | <orgname>-<envtype>-openidl-apps-user. Use  |
|                        | this user credentials.                      |
+------------------------+---------------------------------------------+
| local-cog              | AWS Credentials                             |
| nito-admin-config.json |                                             |
|                        | AWS_ACCESS_KEY_ID                           |
|                        |                                             |
|                        | AWS_SECRET_ACCESS_KEY                       |
|                        |                                             |
|                        | AWS_REGION                                  |
|                        |                                             |
|                        | Refer to IAM user provisioned for           |
|                        | application.                                |
|                        | <orgname>-<envtype>-openidl-apps-user. Use  |
|                        | this user credentials.                      |
+------------------------+---------------------------------------------+
| transacti              | AAIS_ORGNAME: aais                          |
| onal-data-event-listen |                                             |
| er-channel-config.json | ANALYTICS_ORGNAME: analytics                |
|                        |                                             |
|                        | CARRIER_ORGNAME: trv                        |
|                        |                                             |
|                        | Add listener channels for all carriers      |
|                        |                                             |
|                        | Ex: analytics-trv                           |
+------------------------+---------------------------------------------+
| transactional-da       | ANALYTICS_ORGNAME: analytics                |
| ta-event-listener-targ |                                             |
| et-channel-config.json |                                             |
+------------------------+---------------------------------------------+
| u                      | ANALYTICS_ORGNAME: analytics                |
| i-mappings-config.json |                                             |
|                        | ENV: DEV                                    |
|                        |                                             |
|                        | DOMAIN: techiething                         |
+------------------------+---------------------------------------------+
| util                   | Fabric CA Admin Credentials                 |
| ties-admin-config.json |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
+------------------------+---------------------------------------------+

Carrier Variables
~~~~~~~~~~~~~~~~~

+------------------------+---------------------------------------------+
| **JSON File Name**     | **Values to be Replaced**                   |
+========================+=============================================+
| channel-config.json    | CARRIER_ORGNAME: trv                        |
|                        |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
|                        |                                             |
|                        | Add cross channel query params for all      |
|                        | carriers                                    |
+------------------------+---------------------------------------------+
| c                      | Refer to 11.2.4 Creating Connection Profile |
| onnection-profile.json |                                             |
|                        | CARRIER_ORGNAME: trv                        |
|                        |                                             |
|                        | ENV: DEV                                    |
|                        |                                             |
|                        | DOMAIN: techiething                         |
|                        |                                             |
|                        | TLS_CERT: CA TLS Certificate                |
+------------------------+---------------------------------------------+
| insurance-data-manag   | CARRIER_ORGNAME: trv                        |
| er-channel-config.json |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
+------------------------+---------------------------------------------+
| listen                 | CARRIER_ORGNAME: trv                        |
| er-channel-config.json |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
+------------------------+---------------------------------------------+
| local-cog              | AWS Credentials                             |
| nito-admin-config.json |                                             |
|                        | AWS_ACCESS_KEY_ID                           |
|                        |                                             |
|                        | AWS_SECRET_ACCESS_KEY                       |
|                        |                                             |
|                        | AWS_REGION                                  |
|                        |                                             |
|                        | Refer to IAM user provisioned for           |
|                        | application.                                |
|                        | <orgname>-<envtype>-openidl-apps-user. Use  |
|                        | this user credentials.                      |
+------------------------+---------------------------------------------+
| loc                    | Cognito Config                              |
| al-cognito-config.json |                                             |
|                        | COGNITO_USERPOOLID                          |
|                        |                                             |
|                        | COGNITO_CLIENTID                            |
|                        |                                             |
|                        | COGNITO_REGION                              |
+------------------------+---------------------------------------------+
| local-db-config.json   | Mongo DB URL with credentials               |
|                        |                                             |
|                        | MONGO_DB_USERNAME                           |
|                        |                                             |
|                        | MONGO_DB_PASSWORD                           |
|                        |                                             |
|                        | AAIS_ORGNAME: aais                          |
+------------------------+---------------------------------------------+
| l                      | AWS Credentials and AWS Secret Name for     |
| ocal-vault-config.json | Vault                                       |
|                        |                                             |
|                        | AWS_ACCESS_KEY_ID                           |
|                        |                                             |
|                        | AWS_SECRET_ACCESS_KEY                       |
|                        |                                             |
|                        | AWS_REGION                                  |
|                        |                                             |
|                        | VAULT_SECRET_NAME: Look for this in AWS     |
|                        | Secret Manager.                             |
|                        |                                             |
|                        | Format <AAIS_ORGNAME>-<ENV>-kvs-vault       |
|                        |                                             |
|                        | Ex: aais-dev-kvs-vault                      |
|                        |                                             |
|                        | Refer to IAM user provisioned for           |
|                        | application.                                |
|                        | <orgname>-<envtype>-openidl-apps-user. Use  |
|                        | this user credentials.                      |
+------------------------+---------------------------------------------+
| targ                   | CARRIER_ORGNAME: trv                        |
| et-channel-config.json |                                             |
|                        | ANALYTICS_ORGNAME: analytics                |
+------------------------+---------------------------------------------+
| u                      | CARRIER_ORGNAME: trv                        |
| i-mappings-config.json |                                             |
|                        | ENV: DEV                                    |
|                        |                                             |
|                        | DOMAIN: techiething                         |
+------------------------+---------------------------------------------+
| util                   | Fabric CA Admin Credentials                 |
| ties-admin-config.json |                                             |
|                        | CARRIER_ORGNAME: trv                        |
+------------------------+---------------------------------------------+

Creating CA TLS CERT for connection profile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Connect to vault using port-forwarding and AWS secret manager for
secrets (refer 11.2.5 Connecting to vault)

2. CA TLS certificate is available at below path

http://localhost:8200/ui/vault/secrets/aais/show/crypto/peerOrganizations/aais-net/ca

(Replace aais with correct organization name when applicable)

Get the .pem secret contents.

3. Copy TLS certificate into VS Code

3.1 Use replace all values

3.2 Select use regular expression (little ‘.*’ icon on search)

3.3 Replace “\n” with `\\\n <file:///\\n>`__

.. image:: images/image53.png
   :width: 6.16667in
   :height: 2.91389in

5. After replacing all, final output would look like below.

.. image:: images/image54.png
   :width: 6.50556in
   :height: 1.41944in

6. Replace the following values in connection-profile template

+----------------+-----------------+-----------------------------------+
| **Variable**   | **Description** | **Example Value**                 |
+================+=================+===================================+
| AAIS_ORGNANE   | Organization    | aais                              |
|                | Name            |                                   |
+----------------+-----------------+-----------------------------------+
| ENV.           | Environment     | dev                               |
|                | Name            |                                   |
+----------------+-----------------+-----------------------------------+
| DOMAIN         | Domain Name     | aais.techiething                  |
+----------------+-----------------+-----------------------------------+
| TLS_CERT       | CA TLS          | Formatted CA Certificate from     |
|                | Certificate     | Vault.                            |
|                |                 |                                   |
|                |                 | If using the copy_secrets         |
|                |                 | routine, you will need to copy    |
|                |                 | this value into the result file   |
|                |                 | since the `\\\n <file://n>`__ is  |
|                |                 | reinstated as part of the copy.   |
+----------------+-----------------+-----------------------------------+

Connecting to Vault Cluster (CA TLS Certificate)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Setup AWS CLI and log-in using aws_access_key_id and
   aws_secret_access_key

2. Set the context for blockchain cluster

Example: >aws eks update-kubeconfig –region <region> --name
<blockchain-cluster>

3. Get the vault root token from AWS Secret Manager

4. Vault root token will be available at <org>-<env>-vault-unseal-key.
   Ex: aais-dev-vault-unseal-key

..

   .. image:: images/image55.png
      :width: 5.51736in
      :height: 2.19514in

5. Click on retrieve secret value to get the vault root token

..

   .. image:: images/image56.png
      :width: 5.41944in
      :height: 2.90208in

6. Setup port forward using below command

#kubectl port-forward –namespace vault svc/vault 8200:8200

7. Vault should be available at http://localhost:8200/

8. Login to vault using root token retrieved from AWS secret manager

..

   .. image:: images/image57.png
      :width: 5.32153in
      :height: 2.78194in

9.  The certificates can be checked further like below

10. CA Certificate is available at the below path. Replace <orgname>
    with organization name

..

   `http://localhost:8200/ui/vault/secrets/<orgname>/show/crypto/peerOrganizations/<orgname>-net/ca <http://localhost:8200/ui/vault/secrets/%3corgname%3e/show/crypto/peerOrganizations/%3corgname%3e-net/ca>`__

   **ca.aais-net-cert.pem**

   .. image:: images/image58.png
      :width: 5.09792in
      :height: 2.62639in

Adding config files to Vault
----------------------------

1. Setup AWS CLI and login using AWS access key and secret key

2. Set the cluster context to blockchain cluster

#aws eks update-kubeconfig –region <region> --name <blockchain-cluster>

3. Create a file ubuntu.yml and paste the following content in the file
   (this file is available in the openidl-config directory)

+-----------------------------------------------------------------------+
| apiVersion: v1                                                        |
|                                                                       |
| kind: Pod                                                             |
|                                                                       |
| metadata:                                                             |
|                                                                       |
| name: ubuntu                                                          |
|                                                                       |
| spec:                                                                 |
|                                                                       |
| containers:                                                           |
|                                                                       |
| - name: ubuntu                                                        |
|                                                                       |
| image: ubuntu:latest                                                  |
|                                                                       |
| # Just spin & wait forever                                            |
|                                                                       |
| command: ['/bin/bash', '-c', '--']                                    |
|                                                                       |
| args: ['while true; do sleep 30; done;']                              |
+=======================================================================+
+-----------------------------------------------------------------------+

4. Create a new pod in the default namespace #kubectl apply -f
   ./ubuntu.yml

5. Copy the config files and pull-vault-config script (from
   openidl-config directory)

# kubectl cp config/config-dev-<node_type>/ default/ubuntu:config

# kubectl cp ../openidl-test-network/vault/add-vault-config.sh
default/ubuntu:add-vault-config.sh

6. Exec into the pod #kubectl exec --stdin --tty ubuntu -- /bin/bash

7. Update the pod and install vim/curl/jq

#apt-get update

#apt-get install vim jq curl

8. Check whether the files are copied correctly into the pod. You should
   see the file “add-vault-config.sh” in “/” folder

9. Get the vault credentials from AWS secret manager

Vault credentials will be available at <org>-<env>-config-vault.

Example: dev-aais-config-vault

.. image:: images/image59.png
   :width: 5.59792in
   :height: 3.32778in

10. Click on retrieve secret value to get the credentials

.. image:: images/image60.png
   :width: 6.05764in
   :height: 3.13819in

Retrieve secret value to get all the values you need.

11. Run the script add-vault-config to update the vault with all config
    files.

..

   # ./add-vault-config.sh -V <url> -U <username> -P <password> -a
   <vaultPath> -o <orgName from secret> -c ./config

Mapping of values for add-vault-config script to AWS Secrets

+----------------------+-----------------------------------------------+
| **Input Param**      | **Secret Key**                                |
+======================+===============================================+
| V                    | url                                           |
+----------------------+-----------------------------------------------+
| U                    | username                                      |
+----------------------+-----------------------------------------------+
| P                    | password                                      |
+----------------------+-----------------------------------------------+
| a                    | vaultPath                                     |
+----------------------+-----------------------------------------------+
| o                    | orgName                                       |
+----------------------+-----------------------------------------------+
| c                    | Config Path                                   |
+----------------------+-----------------------------------------------+

12. Finally delete the pod after some time just keep around to make sure
    all is ok.

..

   #kubectl delete pod ubuntu

GitHub Actions to Deploy Secrets and Application
------------------------------------------------

Pipeline to deploy secrets
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. csv-table:: Pipeline
    :file: table15.csv
    :header-rows: 1

1. Go to GitHub and Actions section, look for Deploy openIDL secrets and
trigger the pipeline with below inputs

i. org_name – Name of the organization. Example: aais \| analytics \|
trv etc

ii. env_type – Type of the environment. Example: dev \| test \| prod

2. Upon the pipeline is manually triggered it deploys the secrets for
   openIDL application.

Troubleshooting
^^^^^^^^^^^^^^^

If you see an error in the secret deployment or the app deployment.

-  If you see an error in the log that it can’t copy the secrets or an
   error of cannot iterate over null, then you are missing a rule in the
   policies for vault.

-  The pods don’t start because of errors in the config files

Go into vault on the blk cluster through the port-forward.

Go to the policies tab.

Open the config… policy.

If there is only, the first line, then copy it to make the second line
changing config/data to config/metadata and save.

.. image:: images/image61.png
   :width: 6.26458in
   :height: 2.2875in

Pipeline to deploy application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. csv-table:: Pipeline
    :file: table15.csv
    :header-rows: 1

The following steps are required to get this pipeline triggered.

1. Ensure the required environment secrets are configured

2. According to node type and environment, ensure that the relevant
pipeline file is available/updated. For dev it exists, however for test
and prod these pipeline files are yet to be created and updated
referring existing code.

3. Update the global-values-<env>-<node>.yml file and push the code to
relevant branch to trigger the pipeline which eventually deploy
application on the application cluster (AWS EKS cluster)

Verification and Troubleshooting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use one of the urls to access the utilities api. It should be part of
the output.

If it works, you are good to go onto the testing.

If you get default host 404, then you have a configuration error.

Check the ingresses in the Kubernetes app cluster to make sure they are
going to the correct urls.

Pipeline to build and push images to repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. csv-table:: Pipeline
    :file: table16.csv
    :header-rows: 1

Adding Application Users
------------------------

Create Admin User in Cognito
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Log into AWS Console and select the Cognito User Pool. Click on
   ‘Users and Groups’

.. image:: images/image62.png
   :width: 6.51181in
   :height: 2.94861in

2. Select ‘Create User’ and provide the required information. See
   screenshot below

.. image:: images/image63.png
   :width: 6.49444in
   :height: 4.85625in

The phone number must be in the form +11112223333

3. Once the user gets created, password will need to be changed. Go to
   ‘App Client Settings’ and ‘Launch Hosted UI’

.. image:: images/image64.tiff
   :width: 6.49444in
   :height: 2.90208in

4. Log-in using the credentials of the admin user which was just created

.. image:: images/image65.png
   :width: 6.50556in
   :height: 4.65486in

5. Change the password

.. image:: images/image65.png
   :width: 6.50556in
   :height: 4.65486in

Adding application users using Utilities Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Launch the Utilities Service Swagger at http://utilities-service
   ${ENV}.${ORGNAME}.${DOMAIN}.com/api-docs

Ex: http://utilities-service.dev.analytics.techiething.com/api-docs

.. image:: images/image66.png
   :width: 6.50556in
   :height: 3.2125in

2. Select ‘app-user-login’ and provide the cognito user admin
   credentials. Get the ‘userToken’ from response and ‘Authorize’ the
   user

3. Select ‘app-user-creation’ and provide the necessary information for
   creating the user. Following are the examples for creating users for
   different organizations

+-----------+----------------------------------------------------------+
| Organ     | Request Body                                             |
| ization   |                                                          |
+===========+==========================================================+
| AAIS      | {                                                        |
|           |                                                          |
|           | "users": [                                               |
|           |                                                          |
|           | {                                                        |
|           |                                                          |
|           | "username": "liz@lazarus.com",                           |
|           |                                                          |
|           | "password": "<password>",                                |
|           |                                                          |
|           | "familyName": "liz",                                     |
|           |                                                          |
|           | "givenName": "blockchain",                               |
|           |                                                          |
|           | "email": "liz@lazarus.com",                              |
|           |                                                          |
|           | "attributes": {                                          |
|           |                                                          |
|           | "custom:stateName": "Colorado",                          |
|           |                                                          |
|           | "custom:stateCode": "05",                                |
|           |                                                          |
|           | "custom:role": "stat-agent",                             |
|           |                                                          |
|           | "custom:organizationId": "12345"                         |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | ]                                                        |
|           |                                                          |
|           | }                                                        |
+-----------+----------------------------------------------------------+
| Analytics | {                                                        |
|           |                                                          |
|           | "users": [                                               |
|           |                                                          |
|           | {                                                        |
|           |                                                          |
|           | "username": "test_user1@regulator.com",                  |
|           |                                                          |
|           | "password": "<password>",                                |
|           |                                                          |
|           | "familyName": "test",                                    |
|           |                                                          |
|           | "givenName": "user1",                                    |
|           |                                                          |
|           | "email": "test_user1@regulator.com",                     |
|           |                                                          |
|           | "attributes": {                                          |
|           |                                                          |
|           | "custom:stateName": "Colorado",                          |
|           |                                                          |
|           | "custom:stateCode": "05",                                |
|           |                                                          |
|           | "custom:role": "regulator",                              |
|           |                                                          |
|           | "custom:organizationId": "colorado doi"                  |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | ]                                                        |
|           |                                                          |
|           | }                                                        |
+-----------+----------------------------------------------------------+
| Carrier   | {                                                        |
|           |                                                          |
|           | "users": [                                               |
|           |                                                          |
|           | {                                                        |
|           |                                                          |
|           | "username": "david@AAISonline.com",                      |
|           |                                                          |
|           | "password": "<password>",                                |
|           |                                                          |
|           | "familyName": "david",                                   |
|           |                                                          |
|           | "givenName": "aais",                                     |
|           |                                                          |
|           | "email": "david@AAISonline.com",                         |
|           |                                                          |
|           | "attributes": {                                          |
|           |                                                          |
|           | "custom:stateName": "Colorado",                          |
|           |                                                          |
|           | "custom:stateCode": "05",                                |
|           |                                                          |
|           | "custom:role": "carrier",                                |
|           |                                                          |
|           | "custom:organizationId": "12345"                         |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | ]                                                        |
|           |                                                          |
|           | }                                                        |
+-----------+----------------------------------------------------------+

