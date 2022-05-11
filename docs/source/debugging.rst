Debugging
=========

Connecting to Vault UI
----------------------

Set the context for blockchain cluster

Port forward for the vault ui

Get the unseal_key from secrets manager

Setup port forwarding

kubectl port-forward –namespace vault svc/vault 8200:8200

open the ui at localhost:8200/ui/vault/

use the unseal key as the token to login

Checking the logs of the different components
---------------------------------------------

The logs for the different pods can be accessed through kubectl.

Setup aws and configure your eks command to point to the specific
cluster:

something like:

aws *eks* update-kubeconfig --region us-east-1 --name
aais-dev-blk-cluster

Then you can use the usual kubectl commands to get the pods:

kubectl get ns

Then you can get the pods in a namespace

*kubectl* -n aais-net get po

Then you can get the logs for one of the pods and follow it too.

kubectl -n aais-net logs peer0-0 -c peer0

Exec or run in shell on a pod
-----------------------------

Change context to the cluster

Get the namespace

Get the pod name

kubectl -n openidl exec --stdin --tty <pod name> -- /bin/bash

Data Call Likes Not Appearing
-----------------------------

Check the Logs of the mood listener on the analytics node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Change the kubectl context to the analytics node app cluster

Get the pod from the openidl namespace

Look at the logs

Check the Logs of the data call app on the carrier / aais node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Change the kubectl context to the carrier/aais node app cluster

Get the pod from the openidl namespace

Look at the logs

Mood Listener
-------------

Likes and unlikes not working for a node.

Restart the aais and analytics node to make sure they have the

configuration correctly pointing to the new carrier node.

you can also just restart the mood listener pod on the analytics node.

Chaincode Troubleshooting
-------------------------

How to Tell the Version of the Chaincode Running on a channel for 8a node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The chaincode running in a channel must have the same version for all
nodes in that channel.

You can see the version of the chaincode for a channel by looking at the
docker containers in the dind pod on the blk node.

1. Change kubectl context to the node’s blk cluster

2. exec into the **dind** pod

..

   kubectl -n <org name>-net exec -it peer0-0 -c dind sh

3. see the docker containers running

..

   docker ps

4. you will see the image information which includes the name of the
   version for the channel

5. also, you can list the pods for the cluster and see that the approve
   xxx pod has completed

..

   kubectl -n <org name>-net get po

6. you will see a list of the pods, look for the most recent “approve”
   with the carriers or default and the version

Fixing the issue with expired github user token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the user token expires for github.

Create a new token.

Update the secrets in github environments with the new token.

Fix the secret in the blk-cluster.

\``\`

echo "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" \| base64

\``\`

put that into the secret object.

\``\`

kubectl -n flux-dev edit secret git-auth-dev (example)

\``\`

Fix the flux deployment

- fix the flux

\``\`

kubectl -n flux-dev get deployments

kubectl -n flux-dev edit deployment flux-dev

Look for the deployment specification for "Args: --git-url" and update the github token in the "git-url".

\``\`
