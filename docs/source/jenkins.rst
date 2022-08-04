Overview
--------

This document describes the process of setting up an openIDL node using Infrastructure as Code.  The process varies based on the set of technologies utilized.  There are two paths to choose from: GitHub Actions or Jenkins.
The GitHub Actions path uses GitHub actions as the core execution technology of terraform and ansible.
The Jenkins path uses Jenkins to coordinate Terraform Enterprise (Terraform Cloud is the free / low-cost alternative) and Ansible Tower (AWX is the open source alternative).

NOTE: When setting up nodes, all nodes must use the same environment.  It is not possible to connect with different environments.  For example, a test carrier node cannot connect to a dev aais and analytics network.

Throughout this document you will find sections, sub sections, paragraphs or steps that apply to one or the other path.  This will be designated with a if statement or a flag in the right part of the page.

The overall infrastructure as code to deploy the required nodes (AAIS node | analytics node | carrier node) involves the following.

#. GitHub
#. Jenkins
#. Terraform
#. AWS Cloud
#. Ansible/Ansible Tower

.. include:: iac-configuration.rst

Instructions
------------

If you see a |checkbox| then you will find a step in the iac-workbook.
