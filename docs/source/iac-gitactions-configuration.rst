Basic configuration required for GitHub repository
--------------------------------------------------

#. The appropriate number of branches and its naming are vital for the overall GitHub actions pipeline. Hence setup the repository with the following branches and its names according to required nodes to setup.  Only those branches you will use are needed.  So, if you are setting up a carrier node, only use those branches.

.. list-table:: Branches
    :header-rows: 1

    * - Node Type
      - Environment
      - Branch Name
    * - AAIS node
      - Dev
      - aais_dev
    * - AAIS node
      - Test
      - aais_test
    * - AAIS node
      - Prod
      - aais_prod
    * - Carrier node
      - Dev
      - carrier_dev
    * - Carrier node
      - Test
      - carrier_test
    * - Carrier node
      - Prod
      - carrier_prod
    * - Analytics node
      - Dev
      - analytics_dev
    * - Analytics node
      - Test
      - analytics_test
    * - Analytics node
      - Prod
      - analytics_prod

