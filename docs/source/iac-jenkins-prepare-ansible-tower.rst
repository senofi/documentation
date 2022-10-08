Prepare Ansible Tower/AWX
=========================

.. include:: icons.rst

The following configuration items are required to setup in Ansible for the pipelines to work.

1. An User Account

2. Credential Types

3. Inventory, Group and Host

4. Credentials

5. Projects

6. Templates

User Account
------------

|checkbox| **An user account for jenkins to make API calls to Ansible**

A user account to allow Jenkins to successfully work with Ansible
Tower/AWX API. The user should have necessary permissions to run jobs
and its relevant objects. In development used system administrator type,
however in production use role-based access control using teams/roles.

.. image:: images3/image28.png

|Note| **Note down the username and password created**

Credential Types
----------------

|checkbox| **Custom credential types for openidl project specific in ansible**

For the OpenIDL deployment there are infrastructure and application
related pipelines. They require specific credentials and additional
variables. Hence custom credential types are used to simply the setup.
The following are the credential types and steps to configure them.

1. OpenIDL-IAC => Used in infrastructure provisioning jobs

2. OpenIDL-APP => Used in application deployment jobs

3. OpenIDL-IAC-AWSUser-BAF => AWS IAM user credentials used with
   Blockchain automation jobs

OpenIDL-IAC
~~~~~~~~~~~

1. Login into Ansible Tower/AWX instance, Go to Administration

2. Go to Credential Types

3. Click on Add

4. Name it as OpenIDL-IAC and paste the below configuration in each
relevant section.

**Input Configuration**

::

  fields:
  - id: aws_access_key
    type: string
    label: AWS access key
    secret: true
    help_text: AWS IAM user access key
  - id: aws_secret_key
    type: string
    label: AWS secret key
    secret: true
    help_text: AWS IAM user secret key
  - id: aws_iam_role
    type: string
    label: AWS IAM role
    help_text: AWS IAM role to be assumed
  - id: aws_external_id
    type: string
    label: AWS external id
    help_text: Externl ID set during IAM user/role configuration
  - id: aws_region
    type: string
    label: AWS region
    help_text: AWS Region
  - id: aws_account_number
    type: string
    label: AWS account number
    secret: true
    help_text: AWS account number
  - id: baf_image_repo
    type: string
    label: BAF image repository
    help_text: Blockchain automation framework Docker image repository
  - id: blk_cluster_name
    type: string
    label: Blockchain cluster name
    help_text: Blockchain EKS cluster name
  - id: app_cluster_name
    type: string
    label: Application cluster name
    help_text: OpenIDL Application EKS cluster name
  - id: gitops_repo_url
    type: string
    label: 'Gitops repository URL (without https://)'
    help_text: Github repository URL
  - id: gitops_repo_branch
    type: string
    label: Gitops repository branch
    help_text: Branch name in Github repository
  - id: gitops_repo_user
    type: string
    label: Gitops repository user
    help_text: GITHUB repository user
  - id: gitops_repo_user_token
    type: string
    label: Gitops repository user PAT
    secret: true
    help_text: GITHUB repository user token
  - id: gitops_repo_user_email
    type: string
    label: Gitops repository user email
    help_text: GITHUB repository user email id
  required:
  - aws_access_key
  - aws_secret_key
  - aws_iam_role
  - aws_external_id
  - aws_region
  - aws_account_number
  - blk_cluster_name
  - baf_image_repo
  - app_cluster_name
  - gitops_repo_user
  - gitops_repo_user_email
  - gitops_repo_user_token

**Injector Configuration**

::

  extra_vars:
    aws_region: '{{ aws_region }}'
    aws_iam_role: '{{ aws_iam_role }}'
    aws_access_key: '{{ aws_access_key }}'
    aws_secret_key: '{{ aws_secret_key }}'
    baf_image_repo: '{{ baf_image_repo }}'
    aws_external_id: '{{ aws_external_id }}'
    gitops_repo_url: '{{ gitops_repo_url }}'
    app_cluster_name: '{{ app_cluster_name }}'
    blk_cluster_name: '{{ blk_cluster_name }}'
    gitops_repo_user: '{{ gitops_repo_user }}'
    aws_account_number: '{{ aws_account_number }}'
    gitops_repo_branch: '{{ gitops_repo_branch }}'
    gitops_repo_user_email: '{{ gitops_repo_user_email }}'
    gitops_repo_user_token: '{{ gitops_repo_user_token }}'

4. Save and close, screenshot below.

..

   .. image:: images3/image29.png

OpenIDL-IAC-AWSUser-BAF
~~~~~~~~~~~~~~~~~~~~~~~

Similarly repeat the above steps to setup this credential type as well.

**Input Configuration**

::

  fields:
  - id: baf_user_access_key
    type: string
    label: baf_user_access_key
    help_text: AWS IAM user access key for baf
  - id: baf_user_secret_key
    type: string
    label: baf_user_secret_key
    secret: true
    help_text: AWS IAM user secret key for baf
  - id: baf_user_external_id
    type: string
    label: baf_user_external_id
  - id: baf_user_assume_role_arn
    type: string
    label: baf_user_assume_role_arn
  required:
  - baf_user_access_key
  - baf_user_secret_key
  - baf_user_external_id
  - baf_user_assume_role_arn

**Injector Configuration**

::

  extra_vars:
    baf_user_access_key: '{{ baf_user_access_key }}'
    baf_user_secret_key: '{{ baf_user_secret_key }}'
    baf_user_external_id: '{{ baf_user_external_id }}'
    baf_user_assume_role_arn: '{{ baf_user_assume_role_arn }}'

.. image:: images3/image30.png

OpenIDL-APP
~~~~~~~~~~~

Similarly repeat the above steps to setup this credential type as well.

**Input Configuration**

::

  fields:
  - id: aws_access_key
    type: string
    label: AWS access key
    secret: true
    help_text: AWS IAM user access key
  - id: aws_secret_key
    type: string
    label: AWS secret key
    secret: true
    help_text: AWS IAM user secret key
  - id: aws_iam_role
    type: string
    label: AWS IAM role
    help_text: AWS IAM role to be assumed
  - id: aws_external_id
    type: string
    label: AWS external id
    help_text: Externl ID set during IAM user/role configuration
  - id: aws_region
    type: string
    label: AWS region
    help_text: AWS Region
  - id: gitrepo_name
    type: string
    label: 'Git Repository (without https://)'
    help_text: Git repository URL
  - id: gitrepo_branch
    type: string
    label: Git branch name
    help_text: Git repository branch name
  - id: gitrepo_username
    type: string
    label: Gitrepo username
    help_text: Git repository login username
  - id: gitrepo_pat
    type: string
    label: Gitrepo PAT
    secret: true
    help_text: Git repository personl access token
  - id: app_cluster_name
    type: string
    label: Application cluster name
    help_text: OpenIDL Application EKS cluster name
  - id: vault_secret_name
    type: string
    label: vault secret name
    help_text: Vault secret name provisioned in AWS secrets manager
  required:
  - aws_access_key
  - aws_secret_key
  - aws_iam_role
  - aws_external_id
  - aws_region
  - gitrepo_username
  - gitrepo_password
  - gitrepo_name
  - gitrepo_branch
  - app_cluster_name
  - vault_secret_name

**Injector Configuration**

::

  extra_vars:
    aws_region: '{{ aws_region }}'
    aws_iam_role: '{{ aws_iam_role }}'
    gitrepo_name: '{{ gitrepo_name }}'
    aws_access_key: '{{ aws_access_key }}'
    aws_secret_key: '{{ aws_secret_key }}'
    gitrepo_branch: '{{ gitrepo_branch }}'
    aws_external_id: '{{ aws_external_id }}'
    app_cluster_name: '{{ app_cluster_name }}'
    gitrepo_password: '{{ gitrepo_pat }}'
    gitrepo_username: '{{ gitrepo_username }}'
    vault_secret_name: '{{ vault_secret_name }}'

..

   .. image:: images3/image31.png

|Note| **Note down the credential types created**

Inventory, Group and Host
-------------------------

|checkbox| **Setting up hosts/groups in ansible inventory**

   The OpenIDL ansible playbooks use the inventory group
   “ansible_provisioners” and a localhost. Hence setup the relevant
   inventory, its group and host details in Ansible Tower/AWX.

1. Login to the instance, go to Resources => Inventories => Add

2. Name it as “ansible_provisioners and save.

..

   .. image:: images3/image32.png

3. Now open the created inventory and go to Groups and click on Add

..

   .. image:: images3/image33.png

4. Name the group as “ansible_provisioners”.

..

   .. image:: images3/image34.png

5. Now go to inventory ansible_provisioners and then go to Hosts and
   click on Add to include localhost part of the group.

..

   .. image:: images3/image35.png

6. Note localhost is by default added to the inventory file part of
   playbook configuration in the repository. In case chosen to use
   alternate node then ensure that the relevant node is added to the
   ansible_provisioners group/inventory and further the same host
   information is added to the inventory file located in the path
   “awx-automation/inventory/ansible_provisioners” file in the github
   repositories as well. For example, below.

7. This entry should be added to both the repositories. (app and infra).

..

   .. image:: images3/image36.png

.. _credentials-1:

Credentials
-----------

|checkbox| **Setup credentials that will be used for authentication in jobs**

The following are the credentials to be configured in Ansible Tower/AWX.

1. Machine credential

2. Source Control credential

3. OpenIDL-IAC

4. OpenIDL-APP

5. OpenIDL-IAC-AWSUser-BAF

Machine Credential
~~~~~~~~~~~~~~~~~~

This credential is used by the playbook to authenticate a host to run
the playbooks. It may be either a localhost or remote node. This is a
system SSH credential configured to allow Ansible instance to access a
host to run the playbook.

First ensure the host (localhost/remotehost) is configured such access
and further the credential is added here.

1. Go to Ansible instance => Resource => Credentials and add.

2. Ensure the credential type chosen is Machine

3. Enter a name, Input username of the account and add private key of
   the SSH key pair which is configured in the system and also enable
   privilege escalation method as sudo.

4. Note that in development an account “ansible” is used with sudo
   permissions. The account can be adjusted with permissions carefully
   reviewing the playbook actions and relevant permissions only to allow
   sudo commands.

.. image:: images3/image37.png

|Note| **Note down the credential**

Source Control Credential
~~~~~~~~~~~~~~~~~~~~~~~~~

Similarly create a credential of type source control to enter GitHub
user credential (username and PAT) to allow Ansible to successfully work
with repositories. The screenshot for reference.

1. Name the credential

2. Select Type as Source Control

3. Enter the GitHub username and Personal Access Token (alternate is to
   use SSH method)

.. image:: images3/image38.png

|Note| **Note down the credential**

.. _openidl-iac-1:

OpenIDL-IAC
~~~~~~~~~~~

The next step is to use credential of type OpenIDL-IAC. This will be
used by infrastructure jobs. A reference screenshot and significance of
each field is detailed in below table.

|NOTE| However the values for all the fields would not be readily available as the
AWS infrastructure is not provisioned yet. Hence fill up dummy values which are unknown
at the moment and later it can be populated before executing the relevant pipeline jobs.

.. image:: images3/image39.png

+-----+--------------+-------------------------------------------------+
| **S | **Key**      | **Description**                                 |
| N   |              |                                                 |
| o** |              |                                                 |
+=====+==============+=================================================+
| 1   | Credential   | Select type OpenIDL-IAC                         |
|     | Type         |                                                 |
+-----+--------------+-------------------------------------------------+
| 2   | AWS access   | AWS access key of GitHub actions IAM user       |
|     | key          | provisioned                                     |
+-----+--------------+-------------------------------------------------+
| 3   | AWS secret   | AWS secret key of GitHub actions IAM user       |
|     | key          | provisioned                                     |
+-----+--------------+-------------------------------------------------+
| 4   | AWS IAM role | AWS IAM role provisioned to be assumed by       |
|     |              | GitHub actions IAM user                         |
+-----+--------------+-------------------------------------------------+
| 5   | AWS external | “git-actions” by default                        |
|     | id           |                                                 |
+-----+--------------+-------------------------------------------------+
| 6   | AWS region   | AWS region in which resources are provisioned   |
+-----+--------------+-------------------------------------------------+
| 7   | AWS account  | AWS account number                              |
|     | number       |                                                 |
+-----+--------------+-------------------------------------------------+
| 8   | BAF image    | The repository in which Docker image for        |
|     | repository   | Blockchain Automation Framework is located.     |
|     |              | Presently this is public repository.            |
+-----+--------------+-------------------------------------------------+
| 9   | Blockchain   | Name of the cluster provisioned for blockchain  |
|     | cluster name | resources                                       |
+-----+--------------+-------------------------------------------------+
| 10  | Application  | Name of the cluster provisioned for application |
|     | cluster name | resources                                       |
+-----+--------------+-------------------------------------------------+
| 11  | Gitops       | GitHub repository URL in which infrastructure   |
|     | repository   | code is located                                 |
|     | URL          |                                                 |
+-----+--------------+-------------------------------------------------+
| 12  | Gitops       | GitHub repository branch to be used             |
|     | repository   |                                                 |
|     | branch       |                                                 |
+-----+--------------+-------------------------------------------------+
| 13  | GitOps       | Username has access to the repository           |
|     | repository   |                                                 |
|     | user         |                                                 |
+-----+--------------+-------------------------------------------------+
| 14  | Gitops       | Personal access token of the user to            |
|     | repository   | authenticate with GitHub to use with ansible    |
|     | user PAT     | playbooks                                       |
+-----+--------------+-------------------------------------------------+
| 15  | Gitops       | User email ID of the GitHub repository user     |
|     | repository   | used                                            |
|     | user email   |                                                 |
+-----+--------------+-------------------------------------------------+

|Note| **Note down the credential**

.. _openidl-app-1:

OpenIDL-APP
~~~~~~~~~~~

Create the credential of type OpenIDL-APP as described below which will
be used by jobs related to OpenIDL application.

|NOTE| However the values for all the fields would not be readily available as the
AWS infrastructure is not provisioned yet. Hence fill up dummy values which are unknown
at the moment and later it can be populated before executing the relevant pipeline jobs.

.. image:: images3/image40.png

+-----+---------------------+-----------------------------------------+
| **S | **Key**             | **Description**                         |
| N   |                     |                                         |
| o** |                     |                                         |
+=====+=====================+=========================================+
| 1   | Credential Type     | OpenIDL-APP                             |
+-----+---------------------+-----------------------------------------+
| 2   | AWS access key      | AWS access key of GitHub actions IAM    |
|     |                     | user provisioned                        |
+-----+---------------------+-----------------------------------------+
| 3   | AWS secret key      | AWS secret key of GitHub actions IAM    |
|     |                     | user provisioned                        |
+-----+---------------------+-----------------------------------------+
| 4   | AWS IAM role        | AWS IAM role provisioned to be assumed  |
|     |                     | by GitHub actions IAM user              |
+-----+---------------------+-----------------------------------------+
| 5   | AWS external id     | “git-actions” by default                |
+-----+---------------------+-----------------------------------------+
| 6   | AWS region          | AWS region in which resources are       |
|     |                     | provisioned                             |
+-----+---------------------+-----------------------------------------+
| 7   | Git Repository      | GitHub repository related to            |
|     |                     | applications                            |
+-----+---------------------+-----------------------------------------+
| 8   | Git branch name     | Name of the GitHub branch               |
+-----+---------------------+-----------------------------------------+
| 9   | Gitrepo username    | Email id of the GitHub user used        |
+-----+---------------------+-----------------------------------------+
| 10  | Gitrepo PAT         | Personal access token created           |
|     |                     | previously to use with ansible          |
|     |                     | playbooks                               |
+-----+---------------------+-----------------------------------------+
| 11  | Application cluster | Application cluster name                |
|     | name                |                                         |
+-----+---------------------+-----------------------------------------+
| 12  | Vault Secret name   | Secret created in AWS secret manage     |
|     |                     | which holds credentials of vault. The   |
|     |                     | standard format is                      |
|     |                     | <orgname>-<env>-config-vault            |
+-----+---------------------+-----------------------------------------+

|Note| **Note down the credential**

.. _openidl-iac-awsuser-baf-1:

OpenIDL-IAC-AWSUser-BAF
~~~~~~~~~~~~~~~~~~~~~~~

Finally, provision credential of type OpenIDL-IAC-AWSUser-BAF. Choose
the relevant credential type, key in AWS access key, secret key, external_id and baf user assume role arn of
AWS IAM user provisioned related to BAF.

|NOTE| However the values for all the fields would not be readily available as the
AWS infrastructure is not provisioned yet. Hence fill up dummy values which are unknown
at the moment and later it can be populated before executing the relevant pipeline jobs.

.. image:: images3/image41.png

|Note| **Note down the credential**

Projects
--------

|checkbox| **Setup projects**

The next step is to configure projects which is used to pull the ansible
playbook contents from GitHub to ansible tower/AWX.

1. openidl-aais-gitops

openidl-aais-gitops
~~~~~~~~~~~~~~~~~~~

Repeat the same above steps to configure project for infrastructure
code.

.. image:: images3/image43.png

|Note| **Note down the project name"

Templates
---------

|checkbox| **Setup ansible job templates**

It is time to configure ansible job templates in Ansible Tower/AWX. The
following are the list of job templates required to configure.

1. Vault install

2. MongoDB install

3. Blockchain install

4. Register Users (BAF preregister users)

5. OpenIDL application secrets install

6. OpenIDL application install

Vault Install
~~~~~~~~~~~~~

1. Login to Ansible Tower/AWX, Go to Resources => Templates => Add

2. Key in Job name. The format is <org_name>-<env>-openidl-vault.

..

   **Org_name:** First 4 characters of org_name. Note Jenkins pipeline
   code refers to the job template name and hence it is vital.

   **Env:** dev \| test \| prod

3.  Select Job type as Run and check on Prompt on Launch

4.  Choose inventory as ansible_provisioners which was configured in
    previous step.

5.  Choose the project that holds the IaC code. (openidl-aais-gitops)
    configured in previous step

6.  Choose the relevant execution environment

7.  Choose the playbook “awx-automation/vault.yml”.

8.  Choose the following credentials.

    a. Machine credential configured in previous step

    b. OpenIDL-IAC credential configured in previous step

9.  Choose prompt on Launch for variables (mandatory)

10. Set relevant verbosity level, Timeout at minimum 1800 seconds.

11. Set the Option “Privilege Escalation”.

..

   |image6|\ |image7|

MongoDB Install
~~~~~~~~~~~~~~~

1. Login to Ansible Tower/AWX, Go to Resources => Templates => Add

2. Key in Job name. The format is <org_name>-<env>-openidl-mongodb.

..

   **Org_name:** First 4 characters of org_name. Note Jenkins pipeline
   code refers to the job template name and hence it is vital.

   **Env:** dev \| test \| prod

3.  Select Job type as Run and check on Prompt on Launch

4.  Choose inventory as ansible_provisioners which was configured in
    previous step.

5.  Choose the project that holds the IaC code. (openidl-aais-gitops)
    configured in previous step

6.  Choose the relevant execution environment

7.  Choose the playbook “awx-automation/mongodb.yml”.

8.  Choose the following credentials.

    a. Machine credential configured in previous step

    b. OpenIDL-IAC credential configured in previous step

9.  Choose prompt on Launch for variables (mandatory)

10. Set relevant verbosity level, Timeout at minimum 1800 seconds.

11. Set the Option “Privilege Escalation”.

.. image:: images3/image46.png

.. image:: images3/image47.png

Blockchain install
~~~~~~~~~~~~~~~~~~

1. Login to Ansible Tower/AWX, Go to Resources => Templates => Add

2. Key in Job name. The format is <org_name>-<env>-openidl-baf.

..

   **Org_name:** First 4 characters of org_name. Note Jenkins pipeline
   code refers to the job template name and hence it is vital.

   **Env:** dev \| test \| prod

3.  Select Job type as Run and check on Prompt on Launch

4.  Choose inventory as ansible_provisioners which was configured in
    previous step.

5.  Choose the project that holds the IaC code. (openidl-aais-gitops)
    configured in previous step

6.  Choose the relevant execution environment

7.  Choose the playbook “awx-automation/fabric-network.yml”.

8.  Choose the following credentials.

    a. Machine credential configured in previous step

    b. OpenIDL-IAC credential configured in previous step

    c. OpenIDL-IAC-AWSUser-BAF configured in previous step

9.  Choose prompt on Launch for variables (mandatory)

10. Set relevant verbosity level, Timeout at minimum 0 seconds.

11. Set the Option “Privilege Escalation”.

.. image:: images3/image48.png

.. image:: images3/image49.png

Register Users
~~~~~~~~~~~~~~

1. Login to Ansible Tower/AWX, Go to Resources => Templates => Add

2. Key in Job name. The format is
   <org_name>-<env>-openidl-register-users

..

   **Org_name:** First 4 characters of org_name. Note Jenkins pipeline
   code refers to the job template name and hence it is vital.

   **Env:** dev \| test \| prod

3.  Select Job type as Run and check on Prompt on Launch

4.  Choose inventory as ansible_provisioners which was configured in
    previous step.

5.  Choose the project that holds the IaC code. (openidl-aais-gitops)
    configured in previous step

6.  Choose the relevant execution environment

7.  Choose the playbook “awx-automation/pre-register-users.yml”.

8.  Choose the following credentials.

    a. Machine credential configured in previous step

    b. OpenIDL-IAC credential configured in previous step

9.  Choose prompt on Launch for variables (mandatory)

10. Set relevant verbosity level, Timeout at minimum 900 seconds.

11. Set the Option “Privilege Escalation”.

.. image:: images3/image50.png

.. image:: images3/image51.png

OpenIDL Application Install
~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Login to Ansible Tower/AWX, Go to Resources => Templates => Add

2. Key in Job name. The format is <org_name>-<env>-openidl-apps

..

   **Org_name:** First 4 characters of org_name. Note Jenkins pipeline
   code refers to the job template name and hence it is vital.

   **Env:** dev \| test \| prod

3.  Select Job type as Run and check on Prompt on Launch

4.  Choose inventory as ansible_provisioners which was configured in
    previous step.

5.  Choose the project that holds the application code. (openidl-main)
    configured in previous step

6.  Choose the relevant execution environment

7.  Choose the playbook “awx-automation/deploy-openidl-apps.yaml”.

8.  Choose the following credentials.

    a. Machine credential configured in previous step

    b. OpenIDL-APP credential configured in previous step

9.  Choose prompt on Launch for variables (mandatory)

10. Set relevant verbosity level, Timeout at minimum 900 seconds.

11. Set the Option “Privilege Escalation”.

.. image:: images3/image52.png

.. image:: images3/image53.png

OpenIDL Application Secrets Install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Login to Ansible Tower/AWX, Go to Resources => Templates => Add

2. Key in Job name. The format is <org_name>-<env>-openidl-secrets

..

   **Org_name:** First 4 characters of org_name. Note Jenkins pipeline
   code refers to the job template name and hence it is vital.

   **Env:** dev \| test \| prod

3.  Select Job type as Run and check on Prompt on Launch

4.  Choose inventory as ansible_provisioners which was configured in
    previous step.

5.  Choose the project that holds the application code. (openidl-main)
    configured in previous step

6.  Choose the relevant execution environment

7.  Choose the playbook “awx-automation/deploy-openidl-secrets.yaml”.

8.  Choose the following credentials.

    a. Machine credential configured in previous step

    b. OpenIDL-APP credential configured in previous step

9.  Choose prompt on Launch for variables (mandatory)

10. Set relevant verbosity level, Timeout at minimum 900 seconds.

11. Set the Option “Privilege Escalation”.

.. image:: images3/image54.png

.. image:: images3/image55.png

Summary
--------

At this stage the preparation phase is completed in getting the below technology tools and environment readiness.

|checkbox| Sourcecode repositories

|checkbox| AWS account

|checkbox| Terraform Cloud/Enterprise

|checkbox| Jenkins

|checkbox| Ansible Tower/AWX

The next stage is the deployment phase in preparing base infrastructure, setting up blockchain network and deploying
openidl application.
