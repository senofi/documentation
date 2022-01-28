Setup IAM User with inline policy
---------------------------------

1. Within IAM in AWS console go to users in access management and click
   on Add users

2. Enter a username and select AWS access type as “Programmatic access”
   and click next

..

   .. image:: images/image14.png
      :width: 5.62083in
      :height: 1.66667in

3. Add user to specific group if applicable, otherwise key in tags and
   finish creating user

    **Note**: Do not attach any IAM policy at this moment.

4. Then get back to users and open the created user, go to permissions
   and click on Add inline policy, click on json

    .. image:: images/image15.png
       :width: 5.76667in
       :height: 1.49444in

5. Modify the below policy template by adding ARN of the IAM role
   created in previous step and the external id value set in previous
   step and click review policy “terraform” is the external id

    .. code-block:: JSON

        {                                                                     
            "Version": "2012-10-17",                                              
            "Statement": [                                                        
                {                                                                     
                    "Action": [                                                           
                            "sts:AssumeRole",                                                     
                            "sts:TagSession"                                                      
                    ],                                                                    
                    "Resource": "**<AWS_IAM_ROLE_ARN>**",                                 
                    "Effect": "Allow",                                                    
                    "Condition": {                                                        
                    "StringEquals": {                                                     
                            "sts:ExternalId": "**<AWS_EXTERNAL_ID>**"                             
                        }                                                                     
                    }                                                                     
                }                                                                     
            ]                                                                     
        }                                                                     

6. Finally name the inline policy and finish creating it.

7. Note down the IAM user access key and secret key

    .. image:: images/image16.png
       :width: 6.49931in
       :height: 2.80208in

8. Note down the ARN of the IAM user created as it is required for
further steps and terraform configuration.

