.. _Manage the Network:

Managing the Network
====================

Environment Secrets for git actions (Not applicable for Jenkins)
----------------------------------------------------------------

The pipeline requires the below defined environment secrets setup.
Environment name follows the standard name format as
<org_name>_<env_type>. Example for aais development environment it will
be aais_dev.

.. csv-table:: Secrets
    :file: table7.csv
    :header-rows: 1

Create network configuration files
----------------------------------

As a pre-requisite, prepare the organization configuration files using
the templates under
openidl-aais-gitops/ansible-automation/config-examples directory based
on the node type (aais, analytics and carrier) for github actions based pipelines.

Create <org name>-config-<env>.yml under
openidl-aais-gitops/ansible-automation/ directory for each of the nodes.
For example, if organization belongs to aais node, use the template
openidl-aais-gitops/ansible-automation/config-examples/aais-config-dev-template.yml
to create openidl-aais-gitops/ansible-automation/aais-config-dev.yml and
push it to aais openidl-aais-gitops repository.

Note: Make sure to at least have a defaultchannel listed under channels
in organization configuration file. New channel information must be
added when required to the configuration file and maintained in the
repository.

Organization configuration file should be present at the above-mentioned
location in the repository branch before triggering any of the github
action pipelines to deploy vault, mongodb and hyperledger fabric
network.

Following tables detail the values to be replaced for creating these
configuration files.

.. csv-table:: aais Configuration
    :file: table8.csv
    :header-rows: 2

.. csv-table:: analytics Configuration
    :file: table9.csv
    :header-rows: 2

.. csv-table:: carrier Configuration
    :file: table10.csv
    :header-rows: 2

For Jenkins based pipelines,
the templates are located under awx-automation/config-references/templates
the example configs are located under awx-automation/config-references/examples

Using the reference and examples which helps to prepare the actual config files and placed them under
awx-automation/config/

The name of the files suppose to be orgname-config-env.yml. Note that the orgname suppose to be either
aais|anal|first 4 chars of a carrier org name used while setting up. Example trv|cnd|hig1 etc.,
dev|test|prod for environment.


Setup AAIS
----------
The below are the steps required to complete using relevant jenkins jobs to setup base AAIS (multi tenant node).
In case a carrier/analytics node is prepared this section is not applicable. It is only applicable for
AAIS(multi tenant node) only.

.. csv-table:: AAIS NODE
    :file: table-aais-network.csv
    :header-rows: 2

Setup Analytics node(AAIS – Analytics Workflow)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: images2/image13.png
   :width: 6.45417in
   :height: 4.91944in

Analytics-AAIS network setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The below steps applicable when deploying analytics node in the network. This includes working with both
analytics node as well as aais node for appropriate network setup between them.

    1. Get Orderer TLS cert from aais vault and convert to base64 encoded string.  Refer to Connecting to Vault Cluster

    2. Share the TLS Cert with analytics							

    3. analytics uploads the TLS Cert to its AWS Secret Manager. Refer to Connecting to AWS Secret Manager

1.	Node=analytics, action=new_org, org=analytics, env=<env>, channel=defaultchannel

    1. Get Org MSP from analytics vault. Refer to section 5.12 Connecting to Vault Cluster in Managing the network

    2. Share the Org MSP with aais							

    3. aais uploads the analytics Org MSP to its AWS Secret Manager. Refer section 5.13 to Connecting to AWS Secret Manager in Managing the network

    4. Make sure the aais-config-<env>.yml in the aais-<env> branch has the analytics org and domain							

2.	Node=aais, action=add_new_org, org=aais, env=<env>, channel=defaultchannel, other org=analytics

3.	Node=analytics, action=join_peer, org=analytics, env=<env>, channel=defaultchannel

    Chaincode version should be same as the one used on aais for defaultchannel. (See step #3)							

4.	Node=analytics, action=chaincode, org=analytics, env=<env>, channel=defaultchannel	extra args=-e add_new_org=true, version=Format: d (one digit)

    Update organization configuration file with new channel analytics-aais and chaincode information (channels section). Push the config file to repository in the aais-<env> branch							

5.	Node=aais, action=add_new_channel, org=aais, env=<env>, channel=analytics-aais

    aais node should be able to pull the analytics MSP from AWS secret manager which was added as part of add_new_org action on defaultchannel (See step #6)							

6.	Node=aais, action=add_new_org, org=aais, env=<env>, channel=analytics-aais, other org=analytics

7.	Node=aais, action=chaincode, org=aais, env=<env>, channel=analytics-aais, version=Format: d (one digit)

    Update analytics organization configuration file with new channel analytics-aais and chaincode information (channels section). Push the config file to repository							

8.	Node=analytics, action=join_peer, org=analytics, env=<env>, channel=analytics-aais

    Chaincode version should be same as the one used on aais for analytics-aais channel (See step #11)							

9.	Node=analytics, action=chaincode, org=analytics, env=<env>, channel=analytics-aais, extra args=-e add_new_org=true

10.	Node=analytics, action=register_users, org=analytics, env=<env>, channel=defaultchannel


Set up a Carrier Node
---------------------

Carrier Workflow
~~~~~~~~~~~~~~~~

.. image:: images2/image14.png
   :width: 6.54028in
   :height: 6.09792in

Carrier Steps
~~~~~~~~~~~~~

The below steps applicable when deploying a carrier node in the network. This includes working with aais,
analytics nodes as well as with the carrier node to join the network. Follow the below steps against
all these nodes to complete the setup.

    * AAIS must share the certificate with the carrier.  AAIS will follow these directions:
    
    * Get Orderer TLS cert from AAIS vault and convert to base64 encoded string.  Refer to section 5.12 Connecting to Vault Cluster (Org MSP and Orderer TLS Certificate) in Managing the network
    
    * Share the TLS Cert with Carrier								
    
    * Carrier now puts the cert from aais into the aws secrets manager								
    
    * Carrier uploads the TLS Cert to its AWS Secret Manager . Refer to section 5.13 Create Secret using AWS Secret Manager in Managing the network

1.	Node=carrier, action=new_org, org=<org_name>, env=<env>, channel=defaultchannel

    * Get Org MSP from Carrier vault. Refer to Connecting to Vault Cluster (Org MSP and Orderer TLS Certificate)								
    
    * Share the Org MSP with AAIS								

    * AAIS uploads the Carrier Org MSP to its AWS Secret Manager. Refer to Create Secret using AWS Secret Manager								

    * refer to Creating CA TLS CERT for connection profile								
    
    * in the deployment guide								

    * Update the config file for aais to include this new carrier org								

    * get 4 or less name of node								
    
    * setup org in aais-config-<env>.yml to add organization								

2.	Node=aais, action=add_new_org, org=aais, env=<env>, channel=defaultchannel, other org=<org_name of carrier>

3.	Node=carrier, action=join_peer, org=<org_name>, env=<env>, channel=defaultchannel

    Chaincode version should be same as the one used on AAIS for defaultchannel								

4.	Node=carrier, action=chaincode, org=<org_name>, env=<env>, channel=defaultchannel, extra args=-e add_new_org=true, version=Format: d (one digit)	Don’t include the quotes

    for aais - Update organization configuration file with new channel analytics-carrier and chaincode information (channels section). Push the config file to repository								

5.	Node=aais, action=add_new_channel, org=aais, env=<env>, channel=anal-<org_name first 4>, extra args=--skip-tags=join,anchorpeer

    AAIS node should be able to pull the analytics msp from aws secret manager which was added as part of add_new_org action on defaultchannel								

6.	Node=aais, action=add_new_org, org=aais, env=<env>, channel=anal-<org_name first 4>, other org=analytics

    AAIS node should be able to pull the carrier msp from aws secret manager which was added as part of add_new_org action on defaultchannel (See step #2)								

7.	Node=aais, action=add_new_org, org=aais, env=<env>, channel=anal-<org_name first 4>, other org=<org_name>

    on the analytics node - Update organization configuration file with new channel analytics-carrier and chaincode information (channels section). Push the config file to repository								

8.	Node=analytics, action=join_peer, org=analytics, env=<env>, channel=anal-<org_name first 4>

    On the carrier node - Update organization configuration file with new channel anal-<org_name first 4> and chaincode information (channels section). Push the config file to repository								

9.	Node=carrier, action=join_peer, org=<org_name>, env=<env>, channel=anal-<org_name first 4>

10.	Node=analytics, action=chaincode, org=analytics, env=<env>, channel=anal-<org_name first 4>, version=FORMAT: d (one digit)

    Chaincode version should be same as the one used on Analytics for anal-<org_name first 4> channel								

11.	Node=carrier, action=chaincode, org=<org_name>, env=<env>, channel=anal-<org_name first 4>, extra args=-e add_new_org=true, version=FORMAT: d (one digit)

    (anal channel prob better to use 1 character version)	

12.	Node=carrier, action=register_users, org=<org_name>, env=<env>, channel=defaultchannel

    Update the configuration files for the analytics node to include the new channel anal-<org_name first 4>.  This will be these files:								

    -        channel-config.json								
    
    -        data-call-mood-listener-channel-config.json								
    
    -        transactional-data-event-listener-channel-config.json								
    
    -        transactional-data-event-listener-target-channel-config.json								
    
    Update the channel config on the aais node, rerun the secrets and app jobs								

    Restart the Analytics and AAIS nodes that participate with this carrier.  This allows the pods to be refreshed and pickup any changes necessary to see the new carrier node.								


Details of GitHub Actions List related to Deploy Blockchain Network (Not applicable for Jenkins)
------------------------------------------------------------------------------------------------

Action: baf_image
~~~~~~~~~~~~~~~~~

This action will build a BAF docker image and push it to the ghcr.io
registry. To get this action executed key in the following information
in the manual pipeline trigger.

+----------------------------+--------------------+--------------------+
| Use workflow from branch   | develop            | Refer to pipelines |
|                            |                    | in develop branch  |
+============================+====================+====================+
| ORGANIZATION NAME          | aais               | Org name will be   |
|                            |                    | aais \| analytics  |
|                            |                    | \| any carrier     |
+----------------------------+--------------------+--------------------+
| ENVIRONMENT                | dev                | Dev \| test \|     |
|                            |                    | prod               |
+----------------------------+--------------------+--------------------+
| ACTION                     | baf_image          | This is the action |
|                            |                    | name to run        |
+----------------------------+--------------------+--------------------+

This option will trigger the
“ansible-automation/roles/baf/tasks/main.yaml” (ansible role) to build
the baf image.

Action: vault 
~~~~~~~~~~~~~

This action deploys the vault cluster in EKS blockchain cluster and
unseals vault using AWS secret manager credentials. The arguments to
pass while triggering this in the GitHub pipeline are below.

+----------------------------+--------------------+--------------------+
| Use workflow from branch   | develop            | Refer to pipelines |
|                            |                    | in develop branch  |
+============================+====================+====================+
| ORGANIZATION NAME          | aais               | Org name will be   |
|                            |                    | aais \| analytics  |
|                            |                    | \| any carrier     |
+----------------------------+--------------------+--------------------+
| ENVIRONMENT                | dev                | Dev \| test \|     |
|                            |                    | prod               |
+----------------------------+--------------------+--------------------+
| ACTION                     | vault              | This is the action |
|                            |                    | name to run        |
+----------------------------+--------------------+--------------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1.  Generate the template from the vault templates directory to
    “vault-values.yaml”

2.  Create a namespace “vault” on blockchain cluster

3.  Add helm vault repo

4.  Install vault helm chart

5.  Wait for the 60 seconds till vault cluster gets deployed

6.  Initialize and unseal the vault cluster

7.  Get the unseal keys

8.  Upload the unseal keys to AWS secret manager

9.  Delete unseal key files from local

10. Create secret path for Org in vault

11. Create secret path for Orderer org

12. Join the vault-1 to vault cluster

13. Generate the vault add user script from vault templates directory

14. Create configmap for network configuration file

15. Create a secret for credentials

16. Launch pod for vault user

    a. Create vault user for storing application config files

    b. Create vault user for storing kvs credentials

17. Generate user credentials for config user

18. Upload config user credentials to secrets manager

19. Delete the config user credentials generated in local

20. Generate user credentials for kvs user

21. Upload kvs user credentials to secrets manager

22. Delete the kvs user credentials generated in local

23. Delete used script pod

24. Delete script configmap

25. Delete user credentials secret

26. Delete vault add user script

27. Delete vault values file generated

This GitHub action choice actually runs ansible role
“ansible-automation/roles/vault/tasks/main.yaml”.

Action: deploy_network
~~~~~~~~~~~~~~~~~~~~~~

This action deploys the blockchain network. The inputs to pass to the
pipeline are below.

+-------------------------+---------------+----------------------------+
| Use workflow from       | develop       | Refer to pipelines in      |
| branch                  |               | develop branch             |
+=========================+===============+============================+
| ORGANIZATION NAME       | aais          | Org name will be aais \|   |
|                         |               | analytics \| any carrier   |
+-------------------------+---------------+----------------------------+
| ENVIRONMENT             | dev           | Dev \| test \| prod        |
+-------------------------+---------------+----------------------------+
| ACTION                  | d             | This is the action name to |
|                         | eploy_network | run                        |
+-------------------------+---------------+----------------------------+
| CHANNEL NAME            | d             | Name of the channel        |
|                         | efaultchannel |                            |
| (By default, the        |               |                            |
| argument will be        |               |                            |
| “defaultchannel”)       |               |                            |
+-------------------------+---------------+----------------------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1. Delete “openidl-baf” namespace if exists already

2. Generate the “network-setup” file from the template to deploy the
   blockchain network

3. Create “openidl-baf” namespace

4. Create a secret with network details

5. Create a secret with AWS credentials

Variables used:

i.  ACCESS_ID

ii. ACCESS_KEY

6.  Mount the network configuration file which was generated from the
    above steps

7.  Launch the BAF container. Once the BAF container is created rest of
    the blockchain network steps will be performed in the BAF pod

8.  Flux will be configured in Kubernetes

9.  Environment setup playbook will run and setup the required
    configurations inside the baf pod.

10. As the action is selected as **“deploy_network”**, ansible will use
    the network-setup.yaml file generated above to start the deployment
    of Blockchain Network

11. Pull the “openidl-aais-gitops” repo

12. Deployment of blockchain will be performed and following nodes will
    be created

    a. CA

    b. Peer

    c. Orderer

13. A new channel will be created

This GitHub action choice runs ansible role
“blockchain-automation-framework/platforms/hyperledger-fabric/configuration/join-peer-add-org.yaml”.

Action: chaincode
~~~~~~~~~~~~~~~~~

This action deploys the install/approve/commit chaincode. The inputs to
pass to the pipeline are below.

+------------------+---------------------+----------------------------+
| Use workflow     | develop             | Refer to pipelines in      |
| from branch      |                     | develop branch             |
+==================+=====================+============================+
| ORGANIZATION     | aais                | Org name will be aais \|   |
| NAME             |                     | analytics \| any carrier   |
+------------------+---------------------+----------------------------+
| ENVIRONMENT      | dev                 | Dev \| test \| prod        |
+------------------+---------------------+----------------------------+
| ACTION           | chaincode           | This is the action name to |
|                  |                     | run                        |
+------------------+---------------------+----------------------------+
| CHANNEL NAME     | defaultchannel      | Name of the channel        |
|                  |                     |                            |
| (By default, the |                     |                            |
| argument will be |                     |                            |
| “                |                     |                            |
| defaultchannel”) |                     |                            |
+------------------+---------------------+----------------------------+
| EXTRA ARGUMENTS  | Empty or '-e        | Extra arguments if         |
|                  | add_new_org=true'   | applicable to pass         |
|                  |                     |                            |
|                  |                     | Empty in order to install, |
|                  |                     | approve, commit, invoke by |
|                  |                     | creator organization on    |
|                  |                     | channel or '-e             |
|                  |                     | add_new_org=true' to       |
|                  |                     | install and approve for    |
|                  |                     | joiner organizations on    |
|                  |                     | channel                    |
+------------------+---------------------+----------------------------+
| CHAINCODE        | MMDDTTTT            | Chaincode version in the   |
| VERSION          |                     | format MMDDTTTT should be  |
|                  |                     | passed by creator          |
|                  |                     | organization to deploy the |
|                  |                     | chaincode. Same version    |
|                  |                     | should be used by other    |
|                  |                     | organizations to deploy    |
|                  |                     | chaincode on their         |
|                  |                     | organizations to have the  |
|                  |                     | chaincode running at same  |
|                  |                     | version.                   |
+------------------+---------------------+----------------------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1.  Delete “openidl-baf” namespace if exists

2.  Create “openidl-baf” namespace

3.  Launch the baf container. Once the baf container is created rest of
    the steps will be performed in the baf pod

4.  Flux will be configured in Kubernetes

5.  Environment setup playbook will run and setup the required
    configurations inside the baf pod

6.  Install the chaincode

7.  Instantiate the chaincode

8.  Approve the chaincode

9.  Commit the chaincode

10. Invoke the chaincode

This GitHub action choice runs ansible role
“blockchain-automation-framework/platforms/hyperledger-fabric/configuration/chaincode-ops.yaml”.

Action: join_peer
~~~~~~~~~~~~~~~~~

This action will join the peer to the channel. join_peer should be only
performed after

-  new_org action by analytics or carrier node

-  add_new_org action by aais to join analytics/carrier org to the
   channel

..

   Anchor peer update will not be executed in this action. It will be
   done as part of adding organization to channel in add_new_org action.

   The below are the arguments required to pass while trigger this
   action.

+--------------------------------+------------------+------------------+
| Use workflow from branch       | develop          | Refer to         |
|                                |                  | pipelines in     |
|                                |                  | develop branch   |
+================================+==================+==================+
| ORGANIZATION NAME              | aais             | Org name will be |
|                                |                  | aais \|          |
|                                |                  | analytics \| any |
|                                |                  | carrier          |
+--------------------------------+------------------+------------------+
| ENVIRONMENT                    | dev              | Dev \| test \|   |
|                                |                  | prod             |
+--------------------------------+------------------+------------------+
| ACTION                         | join_peer        | This is the      |
|                                |                  | action name to   |
|                                |                  | run              |
+--------------------------------+------------------+------------------+
| CHANNEL NAME                   | defaultchannel   | Name of the      |
|                                |                  | channel          |
| (By default, the argument will |                  |                  |
| be “defaultchannel”)           |                  |                  |
+--------------------------------+------------------+------------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1. Delete “openidl-baf” namespace if exists

2. Create “openidl-baf” namespace

3. Launch the baf container. Once the baf container is created rest of
   the steps will be performed in the baf pod

4. Flux will be configured in Kubernetes

5. Environment setup playbook will run and setup the required
   configurations inside the baf pod

6. Fetch Block ‘0’ to join peers to the channel

7. Create a CLI pod for each peer with CLI option enabled

8. Inside the peer CLI pod of each peer, “peer channel join” command
   will execute

This GitHub action choice runs ansible role “blockchain-automation
framework/platforms/hyperledger-fabric/configuration/join-peer-add-org.yaml”.

Action: register_users
~~~~~~~~~~~~~~~~~~~~~~

This action will preregister the users in CA, arguments to pass while
trigger the action

+--------------------------+--------------+---------------------------+
| Use workflow from branch | develop      | Refer to pipelines in     |
|                          |              | develop branch            |
+==========================+==============+===========================+
| ORGANIZATION NAME        | aais         | Org name will be aais \|  |
|                          |              | analytics \| any carrier  |
+--------------------------+--------------+---------------------------+
| ENVIRONMENT              | dev          | Dev \| test \| prod       |
+--------------------------+--------------+---------------------------+
| ACTION                   | re           | This is the action name   |
|                          | gister_users | to run                    |
+--------------------------+--------------+---------------------------+
| CHANNEL NAME             | de           | Name of the channel       |
|                          | faultchannel |                           |
| (By default, the         |              |                           |
| argument will be         |              |                           |
| “defaultchannel”)        |              |                           |
+--------------------------+--------------+---------------------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1.  Get the vault root token from AWS secrets manager

2.  Get the kvs user credentials (user and password) from secrets
    manager

3.  Generate the pre-register-user script from BAF pre-register-user
    template directory

4.  Delete any script config map related to pre-register-user

5.  Create a configmap for network connection profile

6.  Create secret for credentials

7.  Launch a pod for pre-register-users

8.  Upload CA user token to AWS secrets manager

9.  Delete the pre-register-users pod created earlier

10. Delete the configmap script

This GitHub action choice runs ansible role
“ansible-automation/roles/pre-register-users/tasks/main.yaml”

Action: add_new_channel
~~~~~~~~~~~~~~~~~~~~~~~

This action will create new channel. Below are arguments we provide to
run this pipeline

+-------------------+----------------------+---------------------------+
| Use workflow from | develop              | Refer to pipelines in     |
| branch            |                      | develop branch            |
+===================+======================+===========================+
| ORGANIZATION NAME | aais                 | Org name will be aais \|  |
|                   |                      | analytics \| any carrier  |
+-------------------+----------------------+---------------------------+
| ENVIRONMENT       | dev                  | Dev \| test \| prod       |
+-------------------+----------------------+---------------------------+
| ACTION            | add_new_channel      | This is the action name   |
|                   |                      | to run                    |
+-------------------+----------------------+---------------------------+
| CHANNEL NAME      | defaultchannel       | Name of the channel       |
|                   |                      |                           |
| (By default, the  |                      |                           |
| argument will be  |                      |                           |
| “defaultchannel”) |                      |                           |
+-------------------+----------------------+---------------------------+
| EXTRA ARGUMENTS   | Empty or             | Extra arguments if        |
|                   | '--skip-t            | applicable                |
|                   | ags=join,anchorpeer' |                           |
|                   |                      | When aais is part of the  |
|                   |                      | channel pass empty which  |
|                   |                      | will join aais peer to    |
|                   |                      | the channel. When AAIS    |
|                   |                      | organization is not part  |
|                   |                      | of the channel, pass      |
|                   |                      | '--s                      |
|                   |                      | kip-tags=join,anchorpeer' |
|                   |                      | to not join aais peer in  |
|                   |                      | the new channel. This is  |
|                   |                      | used when AAIS is         |
|                   |                      | creating new channel      |
|                   |                      | between analytics and     |
|                   |                      | carrier                   |
+-------------------+----------------------+---------------------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1. Get the vault root token from AWS secrets manager

2. Create configtx.yaml file

3. Add init patch to configtx.yaml

4. Add organization patch to configtx.yaml

5. Add orderer patch to configtx.yaml

6. Add profile patch to the configtx.yaml

7. Execute Create channel script

8. Execute Channel join script

9. Execute anchor peer script

This GitHub action choice runs ansible role “blockchain-automation
framework/platforms/hyperledger-fabric/configuration/add-new-channel.yaml”

Action: add_new_org
~~~~~~~~~~~~~~~~~~~

This action will add new org. Below are arguments we provide to run this
pipeline

+---------------------------+--------------+---------------------------+
| Use workflow from branch  | develop      | Refer to pipelines in     |
|                           |              | develop branch            |
+===========================+==============+===========================+
| ORGANIZATION NAME         | aais         | Org name will be aais \|  |
|                           |              | analytics \| any carrier  |
+---------------------------+--------------+---------------------------+
| ENVIRONMENT               | dev          | dev \| test \| prod       |
+---------------------------+--------------+---------------------------+
| ACTION                    | add_new_prg  | This is the action name   |
|                           |              | to run                    |
+---------------------------+--------------+---------------------------+
| CHANNEL NAME              | de           | Name of the channel       |
|                           | faultchannel |                           |
| (By default, the argument |              |                           |
| will be “defaultchannel”) |              |                           |
+---------------------------+--------------+---------------------------+
| ORGANIZATION NAME TO BE   | analytics    | New organization name to  |
| ADDED TO THE CHANNEL      |              | be added to the channel   |
+---------------------------+--------------+---------------------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1.  Get the vault root token from AWS secrets manager

2.  Generate the channelconfig.json

3.  Run system channel ansible playbook

4.  Create new organization using systemchannel script

5.  Create new anchor file

6.  Add new org peers and anchor peer information

7.  Launch CLI for new org peers

8.  Fetch the configuration block from orderer

9.  Sign the config block

10. Delete the peer CLI pod

Action: new_org
~~~~~~~~~~~~~~~

   This action will setup a new organization with CA and Peers on the
   network. Below are arguments we provide to run this pipeline

+----------------------------+--------------------+--------------------+
| Use workflow from branch   | develop            | Refer to pipelines |
|                            |                    | in develop branch  |
+============================+====================+====================+
| ORGANIZATION NAME          | aais               | Org name will be   |
|                            |                    | aais \| analytics  |
|                            |                    | \| any carrier     |
+----------------------------+--------------------+--------------------+
| ENVIRONMENT                | dev                | dev \| test \|     |
|                            |                    | prod               |
+----------------------------+--------------------+--------------------+
| ACTION                     | new_org            | This is the action |
|                            |                    | name to run        |
+----------------------------+--------------------+--------------------+
| CHANNEL NAME               | defaultchannel     | Name of the        |
|                            |                    | channel            |
| (By default, the argument  |                    |                    |
| will be “defaultchannel”)  |                    |                    |
+----------------------------+--------------------+--------------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1.  Prepare the Kubernetes environment

2.  Create pod with new org name

3.  Generate the channel artifacts, crypto config for new_org

4.  Deploy the CA and Peer nodes

5.  Upload the Organization MSP definition to vault

6.  Launch the baf container. Once the baf container is created rest of
    the blockchain network steps will be performed in the baf pod

7.  Flux will be configured in the Kubernetes

8.  Environment setup playbook will play and setup the required
    configurations inside the baf pod

9.  As the action is selected as **“new_org”**, ansible will use the
    network-setup.yaml

10. Deployment of blockchain will be performed and below are the nodes
    will be created

    -  CA

    -  Peer

This GitHub action choice runs ansible using
“blockchain-automation-framework/platforms/hyperledger-fabric/configuration/launch-new-organization.yaml”

Action: reset
~~~~~~~~~~~~~

This action will reset the blockchain network on the node. Below are
arguments we provide to run this pipeline

+----------------------------------+-----------------+-----------------+
| Use workflow from branch         | develop         | Refer to        |
|                                  |                 | pipelines in    |
|                                  |                 | develop branch  |
+==================================+=================+=================+
| ORGANIZATION NAME                | aais            | Org name will   |
|                                  |                 | be aais \|      |
|                                  |                 | analytics \|    |
|                                  |                 | any carrier     |
+----------------------------------+-----------------+-----------------+
| ENVIRONMENT                      | dev             | Dev \| test \|  |
|                                  |                 | prod            |
+----------------------------------+-----------------+-----------------+
| ACTION                           | reset           | This is the     |
|                                  |                 | action name to  |
|                                  |                 | run             |
+----------------------------------+-----------------+-----------------+
| CHANNEL NAME                     | defaultchannel  | Name of the     |
|                                  |                 | channel         |
| (By default, the argument will   |                 |                 |
| be “defaultchannel”)             |                 |                 |
+----------------------------------+-----------------+-----------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1. Delete “openidl-baf” namespace if exists

2. Create “openidl-baf” namespace

3. Launch the baf container. Once the baf container is created rest of
   the steps will be performed in the baf pod

4. Environment setup playbook will run and setup the required
   configurations inside the baf pod

5. Delete Vault and Kubernetes Secrets

6. Uninstall Flux

7. Delete Helm Releases

8. Remove build directory

Action: health_check
~~~~~~~~~~~~~~~~~~~~

This action will perform a health check. Below are arguments we provide
to run this pipeline

+----------------------------------+-----------------+-----------------+
| Use workflow from branch         | develop         | Refer to        |
|                                  |                 | pipelines in    |
|                                  |                 | develop branch  |
+==================================+=================+=================+
| ORGANIZATION NAME                | aais            | Org name will   |
|                                  |                 | be aais \|      |
|                                  |                 | analytics \|    |
|                                  |                 | any carrier     |
+----------------------------------+-----------------+-----------------+
| ENVIRONMENT                      | dev             | Dev \| test \|  |
|                                  |                 | prod            |
+----------------------------------+-----------------+-----------------+
| ACTION                           | health_check    | This is the     |
|                                  |                 | action name to  |
|                                  |                 | run             |
+----------------------------------+-----------------+-----------------+
| CHANNEL NAME                     | defaultchannel  | Name of the     |
|                                  |                 | channel         |
| (By default, the argument will   |                 |                 |
| be “defaultchannel”)             |                 |                 |
+----------------------------------+-----------------+-----------------+

The below are the actual steps performed by this action in the pipeline
after triggering it.

1. Delete “openidl-baf” namespace if exists

2. Create “openidl-baf” namespace

3. Launch the baf container. Once the baf container is created rest of
   the steps will be performed in the baf pod

4. Environment setup playbook will run and setup the required
   configurations inside the baf pod

5. Get the list of existing namespaces

Action: vault_cleanup
~~~~~~~~~~~~~~~~~~~~~

This action is used to clean up leftovers of deployment action “vault”
in case it fails during the deployment.

+------------------------------+--------------+-----------------------+
| Workflow file:               | Example:     | The branch where the  |
|                              | aais_dev     | workflow file and its |
| Branch:                      |              | dependent files are   |
|                              | Workflow:    | existed to be used.   |
|                              | Deploy       |                       |
|                              | blockchain   | Example: aais_dev     |
|                              | network and  |                       |
|                              | vault        |                       |
|                              | cluster on   |                       |
|                              | blockchain   |                       |
|                              | cluster      |                       |
+==============================+==============+=======================+
| ORGANIZATION NAME            | aais         | Org name will be aais |
|                              |              | \| analytics \| any   |
|                              |              | carrier               |
+------------------------------+--------------+-----------------------+
| ENVIRONMENT                  | dev          | Dev \| test \| prod   |
+------------------------------+--------------+-----------------------+
| ACTION                       | V            | This is the action    |
|                              | ault_cleanup | name to run           |
+------------------------------+--------------+-----------------------+
