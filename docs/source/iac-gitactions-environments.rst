How to setup GitHub Environments
--------------------------------

This is a mandatory step to perform for the pipeline to function. The pipeline uses Environments in GitHub to function using specific branches and its related secrets configured under the GitHub Environment. Hence, to setup the GitHub environment follow the below steps. 

#. Login to GitHub and get into necessary GitHub repository
#. Go to settings and click on Environments
#. For each node type and its relevant environment (dev | test | prod) setup the GitHub environments
#. Click on New environment
#. Enter the environment name, prefer name of the branch it will be mapped to. 

    .. image:: images/iac_github_permissions.png

#. Setup necessary environment protection rules like Required reviewers, wait timer.

    .. image:: images/iac_github_permission_2.png

#. Setup the branch pattern to which this environment will be applied to. Example to setup the environment for aais_dev and its relevant feature branch set the selected deployment branch pattern as aais_dev*. This enables pull | push request to trigger GitHub actions pipeline against this specific environment. 

    .. image:: images/iac_github_permission_3.png

NOTE:  
	Later in this document, we will set up sensitive data.  The secrets relevant and specific to this environment will be added under environment secrets. Hence environment secrets can be skipped at this moment. 
