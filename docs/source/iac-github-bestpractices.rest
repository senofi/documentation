Best practices to consider in setting up GitHub repository
----------------------------------------------------------

|checkbox| **Follow best practices in github**

The below are best practices recommended in setting up a GitHub repository and for more details refer to GitHub documentation. However, these are only optional for enabling the pipeline.

#. Enable appropriate branch protection rules to manage who can push/pull to a branch 
#. Enable required status checks, either strict or loose to have controlled updates to the branch 
#. Configure how to merge based on requirements (Option A: Allow merge commits, Option B: Allow squash merging, Option C: Allow rebase merging)  
#. Disable auto merge 
#. Disable auto delete of head branch 
#. Enable who can have access to repository 
#. Enable branch protection by setting up

	#. require pull requests review before merging, 
	#. require conversion resolution before merging 

#. Protect who can push to branch directly 
#. Setup notifications related to branch updates/changes 
#. Setup artifact and log retention as per needs 
#. Configure necessary secrets according to requirements at Organization, Environment or Repository level. 
#. Setup Runner configuration - Allow select actions especially those created by GitHub and verified marketplace actions as below. (GitHub Actions only)

.. image:: images/iac_github_permissions.png