

DNS zones
==========

The IaC uses three DNS zones, two private and one public.
The private zones are created in AWS Route 53 and are only available within the VPC in which they were created.
The public zone can either be created within Route 53 or the information needed to produce appropriate DNS records.

Name Construction
-----------------

There are several variable that control how the DNS names are constructed.

aws_env: dev, test, or prod
domain_name
sub_domain_name
The FQDN for the service SERVICE would be SERVICE[.aws_env].sub_domain_name.domain_name
If aws_env is prod the the .aws_env component is omitted.
For example:
service: data-call-app-service
aws_env: dev
sub_domain_name: openidl
domain_name: mycompany.com
The resultant FQDN would be data-call-app-service.dev.openidl.mycompany.com

Public Zone Location
--------------------

r53_public_hosted_zone_required: yes or no

Public Zone Not in Route53
~~~~~~~~~~~~~~~~~~~~~~~~~~

The constructed DNS names and the load balancer DNS name are listed in the output file.  (The example is from github_actions, but the same information is in the terraform output)
.. image:: DNSoutput.png
This information can be used to construct DNS CNAME or ALIAS records in the target DNS service.

Public Zone in Route 53 and served from VPC
-------------------------------------------

The DNS records, including an SOA record and an NS record, are in Route 53 in the AWS account where the IaC was run. 
The SOA and NS record must be ported to whatever domain registration service is used for the provided domain.

Public Zone in Route 53 and Records Published in Another Route 53 Server
-------------------------------------------------------------------------
These records can be pulled from the public zone created in the VPC and ported to the authoritative Route 53 location for the domain.
 There is short perl script, r53-conv.pl, which will pull the records from the account where they were created and transform them into a format suitable for import into the authoritative zone via an AWS CLI route53 command.

Perl Script to Copy
===================

Use this :download:`Script <./code/r53-conv.pl>` to copy dns to the main route 53.

.. code-block:: perl

    .. include:: ./code/r53-conv.pl
