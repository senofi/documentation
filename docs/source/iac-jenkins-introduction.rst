Overview
========

This document describes the process of setting up an openIDL node using Infrastructure as a Code. This document details the process
that involves automation pipelines prepared using Jenkins and its dependant platform. The following are the technology tools required.

#. GitHub
#. Jenkins
#. Terraform Cloud/Terraform Enterprise
#. AWS Cloud
#. Ansible Tower/AWX (Opensource)

NOTE: When setting up nodes, all nodes must use the same environment.  It is not possible to connect with different environments.  For example, a test carrier node cannot connect to a dev aais and analytics network.

Throughout this document you will find sections, sub sections, paragraphs or steps that apply to one or the other path.  This will be designated with a if statement or a flag in the right part of the page.

Instructions
------------

If you see a |checkbox| then you will find a step in the iac-workbook.

Architecture
------------

.. image:: images/iac_architecture.png

High Level Workflow
-------------------

The below are the stages required to complete to get the node up and running.

#. Prepare Amazon Web Services account
#. Prepare GitHub Repository
#. Prepare Terraform Cloud/Enterprise
#. Prepare Jenkins
#. Prepare Ansible Tower/AWX (open source version)
#. Deploy Base Infrastructure (AWS cloud)
#. Deploy Blockchain Network (New network/join existing network)
#. Deploy OpenIDL application

Configuration Worksheet
-----------------------

This section is pending...



