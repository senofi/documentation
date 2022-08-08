Prepare Jenkins
===============

.. include:: icons.rst

It is assumed that Jenkins exist in the environment, if not refer to jenkins documentation to setup an instance in the network.

When the jenkins instance is up and running below are the configuration required to complete.

1. Plugins

2. Node labels

3. Global tools configuration

4. Configure System – Ansible Tower/AWX

5. Credentials

Plugins required
----------------

..

|checkbox| **Enable required jenkins plugin**

   The following are the additional plugins required to enable other
   than standard plugins which are installed during initial Jenkins’s
   setup.

1. HTTP Request Plugin

2. Source Code Plugin (Git Plugin)

3. Ansible Tower Plugin

5. AnsiColor

..

   .. image:: images3/image16.png

Node labels
-----------

|checkbox| **Label jenkins node**

The Jenkins pipeline job uses a node label "openidl". Do either of the one to setup a node with relevant label.

Option 1: Setup "openidl" as node lable to existing node

Option 2: Setup a new node and label it as "openidl"

Option 3: Identify existing nodes in the environment and identify the label set. Then update the Jenkins pipeline code with
that label to align code with the environment.

**The steps to labeling a node is skipped as it can be handled by Jenkins’s administrator.**

In case chosen to update the pipeline code with relevant node label.
Refer to the pipeline code to the following section and replace
“openidl” with custom label.

Go to the repository **openidl-aais-gitops** and to the folder Jenkins-jobs/. For each
job code, update as required.

+-----------------------------+----------------------------------------+
| node {                      | node(‘openidl’)                        |
|                             |                                        |
| label “openidl”             |                                        |
|                             |                                        |
| }                           |                                        |
+=============================+========================================+
+-----------------------------+----------------------------------------+

Global tools configuration
--------------------------

|checkbox| **setup global tools configuration**

1. Go to Jenkins => Mange Jenkins => Global Tool Configuration

2. Ensure Git and Terraform are configured according to your environment

3. Note the command shown here works for Ubuntu node and for Linux it
   will be different. Hence configure Git according to your nodes
   operating system.

.. image:: images3/image19.png

tool home should be ‘/usr/bin/git’

Configure System (AWX/Ansible Tower)
------------------------------------

|checkbox| **configure Ansible Tower plugin in Jenkins for integration between them**

1. Go to Jenkins => Manage Jenkins => Configure System

2. Go to Ansible Tower

3. Click on Add, Give a name to the instance “AWX”. Please note “AWX”
   instance name is used in Jenkins’s pipeline code. In case a different
   name is used, the pipeline code needs to be updated.

4. Update the actual URL of Ansible Tower/AWX instance to make API calls

5. Include the username/password to authenticate Jenkins in AWX/Tower.
   Hence get the user first created in AWX/Tower and get that credential
   added in Jenkins as username/password credential type before setting
   this up. Refer to the AWX preparation section on how to setup user account.

6. During development instance SSL is not used, however in production
   environment SSL should be enabled which is not documented here, refer
   to relevant Jenkins’s documentation on enabling SSL.

7. Test the connection between Jenkins and Ansible is successful to
   proceed further.

.. image:: images3/image21.png

Credentials
-----------

|checkbox| **Finally create credentials and enter the secrets used in the pipelines/integrations**

The following are the listed credentials are required to create in Jenkins. Refer to example of
username and password kind and secret text type to provision the three credentials in Jenkins.

+----+------------+-----------------+---------------------------------+
| No | Purpose    | **Cred Type**   | **Description**                 |
+====+============+=================+=================================+
| 1  | Jenkins    | Username and    | An AWX user account having      |
|    | access to  | Password        | permissions to run jobs, access |
|    | AWX        |                 | required credentials, project,  |
|    |            |                 | and resources. A username and   |
|    |            |                 | password are used. Setup an acc |
|    |            |                 | in Ansible Tower and key in.    |
|    |            |                 | Refer to Ansible Tower section. |
+----+------------+-----------------+---------------------------------+
| 2  | Jenkins    | Username and    | GitHub username and Personal    |
|    | access to  | Password (PAT)  | Access Token. This is used by   |
|    | GitHub     |                 | Jenkins to work with source     |
|    | (source    |                 | control. Refer to tokens created|
|    | control)   |                 | previously.                     |
+----+------------+-----------------+---------------------------------+
| 3  | Jenkins    | Secret Text     | A User/team token created in    |
|    | access to  |                 | Terraform Cloud/Enterprise. Get |
|    | Terraform  |                 | that added as secret text in    |
|    | Cloud/     |                 | Jenkins. Refer to token created |
|    | Enterprise |                 | previously.                     |
+----+------------+-----------------+---------------------------------+

Username and Password Type
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Login to Jenkins go to Manage Jenkins => Manage Credentials => Stores
   scoped to Jenkins (Jenkins) => Global Credentials (unrestricted) =>
   Add credentials

2. Then choose Kind as “Username Password” and key in username,
   Password, Description and a unique ID which would be referred in the
   pipeline code. (An example below)

.. image:: images3/image22.png

Secret Text Type
~~~~~~~~~~~~~~~~

1. Login to Jenkins go to Manage Jenkins => Manage Credentials => Stores
   scoped to Jenkins (Jenkins) => Global Credentials (unrestricted) =>
   Add credentials

2. Choose Kind as secret text, enter secret text like Token in “secret”
   field and name the secret ID as unique since it will be used in
   pipeline code. (An example below)

.. image:: images3/image23.png

Jenkins Jobs Configuration
=========================

Credentials
-----------

1. Before configuring Jenkins’s job ensure that the required credentials
   relevant to the jobs are already configured in Jenkins.

..

   Terraform credentials

   AWX (Ansible Tower/AWX User credentials)

   GitHub User credentials

+----+------------+------------+----------+-------------+-------------+
| No | Cred Type  | **ID**     | Username | Password    | Descr       |
+====+============+============+==========+=============+=============+
| 1  | Username   | openidl-a  | GitHub   | Personal    | GitHub      |
|    | with       | ais-gitops | account  | access      | credentials |
|    | password   |            | username | token       |             |
|    |            |            |          | created     |             |
+----+------------+------------+----------+-------------+-------------+
| 2  | Username   | AWX        | Ansible  | Ansible     | Ansible     |
|    | with       |            | tower    | tower user  | Tower/AWX   |
|    | password   |            | username | password    | credentials |
+----+------------+------------+----------+-------------+-------------+
| 3  | Secret     | TF_BE      | NA       | Terraform   | Terraform   |
|    | text       | ARER_TOKEN |          | user/team   | Cloud       |
|    |            |            |          | API token   | /Enterprise |
|    |            |            |          |             | access      |
|    |            |            |          |             | token       |
+----+------------+------------+----------+-------------+-------------+

**References: GitHub credential**

.. image:: images3/image56.png

**References: AWX credential**

.. image:: images3/image57.png

**References: Terraform credential**

.. image:: images3/image58.png

Job Configurations
------------------

|checkbox| **Configure Jenkins pipeline jobs**

The list of jobs to be configured are

1. Job to provision AWS resources and K8s resources using Terraform
   Cloud/Enterprise

2. Job to provision Vault using Ansible Tower/AWX

3. Job to provision Blockchain Network using Ansible Tower/AWX

4. Job to provision MongoDB using Ansible Tower/AWX

5. Job to provision OpenIDL application secrets and application using
   Ansible Tower/AWX

Terraform Job
~~~~~~~~~~~~~

1. Go to Jenkins => New Item => Give a meaningful name

2. Select Job type as PIPELINE and proceed next

3. Give a description to the job and move to pipeline section

4. Select Definition as Pipeline Script from SCM

5. Select SCM as Git

6. Key in the Infrastructure code repository (openidl-aais-gitops) url.

7. Select the GitHub credentials

8. Specify the relevant branch “refs/heads/<branch-name>”.

9. Set script path to “Jenkins-jobs/jenkinsfile-tf”.

..

   .. image:: images3/image59.png

Vault Job
~~~~~~~~~

1. Go to Jenkins => New Item => Give a meaningful name

2. Select Job type as PIPELINE and proceed next

3. Give a description to the job and move to pipeline section

4. Select Definition as Pipeline Script from SCM

5. Select SCM as Git

6. Key in the Infrastructure code repository (openidl-aais-gitops) url.

7. Select the GitHub credentials

8. Specify the relevant branch “refs/heads/<branch-name>”.

9. Set script path to “Jenkins-jobs/jenkinsfile-vault”.

.. image:: images3/image60.png

Blockchain Network Job
~~~~~~~~~~~~~~~~~~~~~~

1. Go to Jenkins => New Item => Give a meaningful name

2. Select Job type as PIPELINE and proceed next

3. Give a description to the job and move to pipeline section

4. Select Definition as Pipeline Script from SCM

5. Select SCM as Git

6. Key in the Infrastructure code repository (openidl-aais-gitops) url.

7. Select the GitHub credentials

8. Specify the relevant branch “refs/heads/<branch-name>”.

9. Set script path to “Jenkins-jobs/jenkinsfile-baf”.

.. image:: images3/image61.png

MongoDB Job
~~~~~~~~~~~

1. Go to Jenkins => New Item => Give a meaningful name

2. Select Job type as PIPELINE and proceed next

3. Give a description to the job and move to pipeline section

4. Select Definition as Pipeline Script from SCM

5. Select SCM as Git

6. Key in the Infrastructure code repository (openidl-aais-gitops) url.

7. Select the GitHub credentials

8. Specify the relevant branch “refs/heads/<branch-name>”.

9. Set script path to “Jenkins-jobs/jenkinsfile-mongodb”.

..

   .. image:: images3/image62.png

OpenIDL Application Job
~~~~~~~~~~~~~~~~~~~~~~~

1. Go to Jenkins => New Item => Give a meaningful name

2. Select Job type as PIPELINE and proceed next

3. Give a description to the job and move to pipeline section

4. Select Definition as Pipeline Script from SCM

5. Select SCM as Git

6. Key in the Infrastructure code repository (openidl-main) url.

7. Select the GitHub credentials

8. Specify the relevant branch “refs/heads/<branch-name>”.

9. Set script path to “Jenkins-jobs/jenkinsfile-apps-secrets”.

.. image:: images3/image63.png

