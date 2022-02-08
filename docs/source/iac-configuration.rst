Configuring the IaC
===================

There are many places where configuration values must be provided to the IaC.
There is one central place where all these configurations originate.
This is the openidl-config directory in the gitops repository.

Use the openidl-config directory in the gitops repository.
Create a configuration file from the template.
There is a schema that provides validation and information for the config file.
If you use Visual Studio Code, there will be type ahead and hover help available.

Then as you need configuration items like secrets, variables or full files, just run the appropriate make target and get the results from the config directory.
Use this |checklist| :download:`worksheet <./IaC-Jenkins-Worksheet.xlsx>` to keep track of your progress through the process.

