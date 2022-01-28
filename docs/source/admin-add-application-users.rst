Adding application users using Utilities Service
================================================

1. Launch the Utilities Service Swagger at http://utilities-service
   ${ENV}.${ORGNAME}.${DOMAIN}.com/api-docs

Ex: http://utilities-service.dev.analytics.techiething.com/api-docs

.. image:: images2/image27.png
   :width: 6.54583in
   :height: 3.17222in

2. Select ‘app-user-login’ and provide the cognito user admin
   credentials. Get the ‘userToken’ from response and ‘Authorize’ the
   user

3. Select ‘app-user-creation’ and provide the necessary information for
   creating the user. Following are the examples for creating users for
   different organizations

+-----------+----------------------------------------------------------+
| **Organ   | **Request Body**                                         |
| ization** |                                                          |
+===========+==========================================================+
| AAIS      | {                                                        |
|           |                                                          |
|           | "users": [                                               |
|           |                                                          |
|           | {                                                        |
|           |                                                          |
|           | "username": "liz@lazarus.com",                           |
|           |                                                          |
|           | "password": "<password>",                                |
|           |                                                          |
|           | "familyName": "liz",                                     |
|           |                                                          |
|           | "givenName": "blockchain",                               |
|           |                                                          |
|           | "email": "liz@lazarus.com",                              |
|           |                                                          |
|           | "attributes": {                                          |
|           |                                                          |
|           | "custom:stateName": "Colorado",                          |
|           |                                                          |
|           | "custom:stateCode": "05",                                |
|           |                                                          |
|           | "custom:role": "carrier",                                |
|           |                                                          |
|           | "custom:organizationId": "12345"                         |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | ]                                                        |
|           |                                                          |
|           | }                                                        |
+-----------+----------------------------------------------------------+
| Analytics | {                                                        |
|           |                                                          |
|           | "users": [                                               |
|           |                                                          |
|           | {                                                        |
|           |                                                          |
|           | "username": "test_user1@regulator.com",                  |
|           |                                                          |
|           | "password": "<password>",                                |
|           |                                                          |
|           | "familyName": "test",                                    |
|           |                                                          |
|           | "givenName": "user1",                                    |
|           |                                                          |
|           | "email": "test_user1@regulator.com",                     |
|           |                                                          |
|           | "attributes": {                                          |
|           |                                                          |
|           | "custom:stateName": "Colorado",                          |
|           |                                                          |
|           | "custom:stateCode": "05",                                |
|           |                                                          |
|           | "custom:role": "regulator",                              |
|           |                                                          |
|           | "custom:organizationId": "colorado doi"                  |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | ]                                                        |
|           |                                                          |
|           | }                                                        |
+-----------+----------------------------------------------------------+
| Carrier   | {                                                        |
|           |                                                          |
|           | "users": [                                               |
|           |                                                          |
|           | {                                                        |
|           |                                                          |
|           | "username": "david@AAISonline.com",                      |
|           |                                                          |
|           | "password": "<password>",                                |
|           |                                                          |
|           | "familyName": "david",                                   |
|           |                                                          |
|           | "givenName": "aais",                                     |
|           |                                                          |
|           | "email": "david@AAISonline.com",                         |
|           |                                                          |
|           | "attributes": {                                          |
|           |                                                          |
|           | "custom:stateName": "Colorado",                          |
|           |                                                          |
|           | "custom:stateCode": "05",                                |
|           |                                                          |
|           | "custom:role": "stat-agent",                             |
|           |                                                          |
|           | "custom:organizationId": "12345"                         |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | }                                                        |
|           |                                                          |
|           | ]                                                        |
|           |                                                          |
|           | }                                                        |
+-----------+----------------------------------------------------------+
