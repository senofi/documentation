Setup sensitive data as secrets in GitHub (GitHub Actions only)
===============================================================

All the sensitive data are required to be configured as secrets in
GitHub. There are multiple ways to configure secrets

1. Environment secrets

2. Repository secrets

3. Organization secrets.

We would be configuring all the sensitive data as environment secrets
which will allow GitHub actions to use them in the pipeline. Follow the
below steps.

1. Login to GitHub and select the relevant repository

2. Go to settings and click on Environment

3. Now select the environment referring to the table to which secrets
are to be entered. Note that all these environments mentioned in below
table are setup part of preparing GitHub repository in the previous
section.

.. csv-table:: Environments
    :file: table-gitactions-environments.csv
    :header-rows: 1

Add the following sensitive data as environment secrets. Ensure that the secrets are added according to the node_type, environment_type and branch.
---------------------------------------------------------------------------------------------------------------------------------------------------

For the SSH keys, create one key atleast and use the same for all SSH keys (used for bastion and EKS worker nodes).
------------------------------------------------------------------------------------------------------------------

Use ssh-keygen command to prepare required SSH keys and use the public key in the environment secret for SSH key variable.

.. csv-table:: Environment Secrets
    :file: table-gitactions-secrets.csv
    :header-rows: 1

