Prepare Terraform Cloud/Enterprise
==================================

.. include:: icons.rst

Terraform Cloud or Terraform Enterprise are assumed to be setup.  Please see your administrator for how to accomplish this.

The following are the configuration required to setup in Terraform cloud/enterprise instance.

1. User Token/Team Token

2. Workspaces

3. Variable Set

Terraform User/Team Token
-------------------------

|checkbox| **Setup terraform token (either user or team)**

A user token/team token is required to allow Jenkins to authenticate and
successfully communicate with Terraform. It depends on an organization
to choose between the type of token used according to their need.

TFC/TFE User Token
~~~~~~~~~~~~~~~~~~

A user API token has the same permission level as your user account. It is the only type of token which can be granted access to multiple organizations.

1. Login to Terraform Cloud/Enterprise go to User settings

2. Create an API token

|image1| |image2|

TFC/TFE Team Token
~~~~~~~~~~~~~~~~~~

A team is suppose to be created before creating a team token. Refer to terraform cloud/enterprise documentation on setting up a team.
Team API tokens are used by services, for example a CI/CD pipeline to perform plans and applies on a workspace. This is the preferred choice.

1. Login to Terraform Cloud/Enterprise, go to Organization settings

2. Go to Teams to setup up a new team and provision a team token or go
   to existing team and provision a team API token.

.. image:: images3/image4.png
   :width: 4.725in
   :height: 1.64167in

|Note| **Note down the token**

Workspaces
----------

|checkbox| **Setup terraform workspaces**

The terraform code to provision necessary Infrastructure resources for
OpenIDL node is provisioned into two independent sets. The first set is
used to provision AWS resources and the other one to provision K8s
resources. There is a dependency in provisioning K8s which are addressed
in the first set of code and before provisioning K8s.

For example, K8s resources like config-map, storage class and ha proxy
have dependencies with the EKS cluster which gets provisioned before these
resources. Hence two sets of code are managed which requires two
different terraform workspaces in the environment to manage and
configure. The details are below.

Workspace to manage K8S Resources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

|checkbox| **Create K8S Workspace**

1. A workspace to manage K8s resources is required. Create a new
   workspace and choose workflow as “API-Driven workflow” and give a
   meaningful name.  Like <org name>-k8s-workspace

2. Open the workspace go to settings => General and set the execution
   mode to Remote, Apply method as Manual and Terraform version above
   1.1.2

**Note**\ *: This workspace refers to the state file of AWS resources
workspace.*

.. image:: images3/image5.png
   :width: 4.41667in
   :height: 1.84167in

.. image:: images3/image6.png
   :width: 4.35833in
   :height: 1.9in

.. image:: images3/image7.png
   :width: 4.375in
   :height: 1.75in

.. image:: images3/image8.png
   :width: 4.3in
   :height: 1.04167in

|Note| **Note down the workspace name created to manage K8s resources**

Workspace to manage AWS Resources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

|checkbox| **Create AWS Workspace**

1. A workspace to manage AWS resources is required. Create a new
   workspace and choose workflow as “API-Driven workflow” and give a
   meaningful name. Like <org name>-aws-workspace

2. Open the workspace go to settings => General and set the execution
   mode to Remote, Apply method as Manual and Terraform version above
   1.1.2

3. And finally, *allow the state file of this workspace is accessible to
   the workspace used to manage K8s resources.*

**Note:**\ *This workspace shares its state file with K8s resources
workspace*

.. image:: images3/image9.png
   :width: 4.50833in
   :height: 1.76667in

.. image:: images3/image6.png
   :width: 4.175in
   :height: 1.625in

.. image:: images3/image10.png
   :width: 4.83333in
   :height: 2.18333in

|Note| **Note down the workspace name created to manage AWS resources**


Variable Set
------------

|checkbox| **Setup terraform variables set**

All the terraform variables and their values (including sensitive and
non-sensitive) are added in a variable set. The details of actual
variables and samples can be referred in the repository **openidl-aais-gitops** under directory
“aws/templates”.

All the variables in the templates are required to add in the variable
set. The detailed description of the variable’s significance is
documented the templates directory in the repository.

The variable set is preferred as it can be shared across workspaces
which is the typical use case in our solution. Configure variable set
and share them across the workspace’s setup in previous section.

**NOTE:** When you are entering variables, in case of complex data types
like maps, lists etc, follow HCL format and ensure the checkbox HCL is
checked. Please refer to the below link and section “variable values and
format”

https://www.terraform.io/cloud-docs/workspaces/variables/managing-variables

.. image:: images3/image11.png
   :width: 5.51667in
   :height: 1.95in

.. image:: images3/image12.png
    :width: 4.18333in
    :height: 2.04167in

Below is a list of variables, what they are for and some help with template values.

    .. csv-table:: Terraform Variables
        :file: table-terraform-variables.csv
        :header-rows: 1


Team Access
-----------

|checkbox| **Enable team access to the workspaces (applicable when teams and its token used)**

Finally in each workspace configured enable team access in case team
token is chosen as preferred method for API access.

.. image:: images3/image15.png
   :width: 5.00833in
   :height: 3.16667in


Terraform code changes to adapt to Terraform Cloud/Enterprise
-------------------------------------------------------------

|checkbox| **Update terraform code to support Terraform Cloud/Enterprise as backend**


Finally update the terraform code to support Terraform Cloud/Enterprise as backend for state management.
Ensure that the code is updated as below before using to provision resources in the pipeline.

1. Activate the right AWS provider configuration in the code for
   aws_resources code set. |image5|

2. Comment the terraform backend section of the code in both
   aws_resources and k8s_resources code set in the file main.tf. Below
   is an example.

..

   .. image:: images3/image25.png
      :width: 5.7in
      :height: 2.125in

3. Activate the AWS provider configuration as below for k8s_resources
   code set and for remaining providers like Kubernetes and helm
   requires no changes.

..

   .. image:: images3/image26.png
      :width: 3.60833in
      :height: 3.34167in

4. Finally update/activate the code relevant code snippet as below for
   data.tf in k8s_resources code set.

..

   .. image:: images3/image27.png
      :width: 3.275in
      :height: 4.075in

5. Finally ensure that the updated code is pushed to the repository.