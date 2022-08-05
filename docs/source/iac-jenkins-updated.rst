===============================================
Infrastructure as Code using Jenkins - UPDATED
===============================================

.. include:: icons.rst

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

.. include:: iac-jenkins-introduction.rst

.. include:: iac-jenkins-prepare-aws.rst

.. include:: iac-jenkins-prepare-github.rst

.. include:: iac-jenkins-prepare-terraform.rst

.. include:: iac-jenkins-prepare-jenkins.rst

.. include:: iac-jenkins-prepare-ansible-tower.rst

.. include:: iac-jenkins-deploy-base-infra.rst

.. include:: iac-jenkins-deploy-blockchain.rst

.. include:: iac-jenkins-manage-resources.rst

.. include:: iac-jenkins-deploy-application.rst



