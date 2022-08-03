Setup email identity and move SES out of sandbox
================================================

Cognito user pool allows users to self-sign in (self-register) using
their email id. Hence during user self-sign in process, Cognito sends
email to the user email address for verification.

These emails to users can be sent using Cognito default service or using
AWS SES service.

**Limitations:**

1. Cognito default allows only 50 emails per day only

Based on requirement, the option of either default email service
(COGNITO_DEFAULT) or SES service (DEVELOPER) shall be chosen

Option1: COGNITO_DEFAULT
------------------------

1. In case, Cognito default is preferred, there are no actions in adding
an email address and verifying it or moving SES service out of sandbox
for production used.

2. When Cognito default is chosen, set email_sending_account =
“COGNITO_DEFAULT” in input file (secrets).

3. Set the below inputs as empty in GitHub secrets as they are NA.
(These secrets must be set empty and cannot be ignored to set as empty,
otherwise GitHub actions pipeline will fail).

ses_email_identity = “”

userpool_email_source_arn = “”

Option2: AWS SES Service (DEVELOPER)
------------------------------------

1. Note that Cognito supports SES service only in the following region
though SES is available in most of the AWS regions. Hence for Cognito to
work along with SES choose either one of the regions to configure for
below steps.

**Cognito supported SES regions:**

1. us-west-1

2. us-west-2

3. us-east-1

2. In AWS console, choose one of the regions mentioned above, go to SES
service select email addresses

Login to AWS console, go to simple email service in one of the regions
and add the email address and click on verify a new email address

.. image:: images/image35.png
   :width: 6.49306in
   :height: 1.80764in

3. Enter an email address that would be used as an identity by Cognito
in sending emails to users during self-sign up.

.. image:: images/image36.png
   :width: 6.39306in
   :height: 1.975in

4. A verification email would be triggered to the email address that was
added. Please login to the email account and complete email id
verification.

5. |note| Then note down the ARN of the email address and the email address
itself that was verified in SES.

.. image:: images/image37.png
   :width: 5.95139in
   :height: 1.86458in

6. Further go to email addresses and click on the email id that is
added, then select Identity Policies and click on Create policy and
select Custom Policy.

.. image:: images/image38.png
   :width: 6.49653in
   :height: 2.66597in

7. Edit the below policy and replace account number and email-id with
the relevant values and add this policy statement to finish creating
identity policy. This allows Cognito to use SES service to trigger
emails upon user self-sign in to verify user identity.

+-----------------------------------------------------------------------+
| {                                                                     |
|                                                                       |
| "Version": "2008-10-17",                                              |
|                                                                       |
| "Statement": [                                                        |
|                                                                       |
| {                                                                     |
|                                                                       |
| "Sid": "stmnt1234567891234",                                          |
|                                                                       |
| "Effect": "Allow",                                                    |
|                                                                       |
| "Principal": {                                                        |
|                                                                       |
| "Service": "cognito-idp.amazonaws.com"                                |
|                                                                       |
| },                                                                    |
|                                                                       |
| "Action": [                                                           |
|                                                                       |
| "ses:SendEmail",                                                      |
|                                                                       |
| "ses:SendRawEmail"                                                    |
|                                                                       |
| ],                                                                    |
|                                                                       |
| "Resource":                                                           |
| "arn:aws:ses:us-east-1:<aws_account_number>:identity/<emailid>"       |
|                                                                       |
| }                                                                     |
|                                                                       |
| ]                                                                     |
|                                                                       |
| }                                                                     |
+-----------------------------------------------------------------------+

.. image:: images/image39.png
   :width: 6.49653in
   :height: 5.76111in

8. Finally follow the below link to move SES service out of sandbox for
production use.

https://docs.aws.amazon.com/ses/latest/DeveloperGuide/request-production-access.html