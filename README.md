# Automate OCI Resource Provisioning with Visual Builder Studio and Terraform

Oracle Visual Builder Studio (VB Studio) is a robust application development platform that helps your team effectively plan and manage your work throughout all stages of the app dev lifecycle: design, build, test, and deploy. By integrating the terraform scripts in the VB Studio, we can automate the OCI resource provisioning. 

In the current usecase, we will explore how we can use Oracle VB Studio and terraform scripts to achieve the following.
1) Provision the VB Studio and acquire the access
2) Setup a VBS Project
3) Setup a GIT repository with required terraform files in the VBS project
4) Define a build job to run the terraform script files from GIT repo to provision the OCI resources
5) Run the VBS build to verify the automated OCI resource provisioning

## VB Studio Access
* Ensure that you have [access to VB Studio instance](https://docs.oracle.com/en/cloud/paas/visual-builder/visualbuilder-manage-development-process/basics.html#GUID-F907935C-DE58-41CE-AF3B-5F2DE654AE12)
* Login to the VB Studio to [access the home page](https://docs.oracle.com/en/cloud/paas/visual-builder/visualbuilder-manage-development-process/basics.html#GUID-93A3E6D1-FED5-4AE0-8AF6-7B27E72556E8)

## Setup VB Studio project
* From the Organization tab in the home page, click on Create
* Enter the project name and description and click Next
![VBS-project-create](https://user-images.githubusercontent.com/22868753/135040681-45a177e8-8beb-41d1-aebf-b941e2a563e8.jpg)

* In the Template selection page, select **Initial Respository** and click Next
![vbs-project-template](https://user-images.githubusercontent.com/22868753/135034693-b2a6b80e-d169-471e-92a9-9a54ed68c047.jpg)

* Select **Import Existing repository** and enter the Importing repository URL as https://github.com/subhashchandrab/oci-vbs-terraform.git. Leave the other fields with default values and click Finish
![vbs-project-repo-details](https://user-images.githubusercontent.com/22868753/135035641-56b9169c-c08a-4030-8701-30671e6e6297.jpg)

* Wait for the project provisioning to be completed. Once done, you can see the project home page.


## Add API Key
* Login to OCI console and select **User Settings** option from the Profile menu.
![oci-console-user-settings](https://user-images.githubusercontent.com/22868753/135036751-6233cf1f-9fc3-48ac-a95c-e4cfd3ed435c.jpg)

* Navigate to API Keys and click on **Add API Key** button.
![oci-api-keys](https://user-images.githubusercontent.com/22868753/135037492-50dfca3b-35bc-4c74-bc20-ced27cc43e73.jpg)

* In the Add API Key dialog, keep the default option(Generate API Key Pair). Download both the private and public key files using the respective buttons available in the dialog. Now click on Add.
**Make sure that you download the public and private keys before clicking the Add button**
![oci-add-api-key](https://user-images.githubusercontent.com/22868753/135038223-45c50485-e641-4ba2-a478-7020a0a21dc1.jpg)

* Save the above private and public key in a location where you can refer them later when adding key files to GIT repository in the next section

* After the API Key is added, select **View Configuration File** option from the action menu of the created API key 
![api-key-view-config-file](https://user-images.githubusercontent.com/22868753/135100788-e9db76b8-dfa1-4ad7-a449-2904ab8347dd.jpg)

* Make a note of the entries user, fingerprint, tenancy and region. You need these values in the next section.
![api-key-config-file-preview](https://user-images.githubusercontent.com/22868753/135109313-07b3ea16-e744-419f-b7b3-ea23e937e0a8.jpg)

## Update the VBS Project GIT repository with OCI credentials
* Go to VBS project home page and navigate to GIT page
* Select the folder **oci-keys** and click on **+File** button. 
* Enter **oci_api_key_private.pem** in the file name field. Paste the content from the private key file downloaded in the previous section. Click on Commit. In the Commit dialog, click Commit again. The private key file oci_api_key_private.pem will be added to the GIT repository of the VBS project.
![add-keyfile-to-git](https://user-images.githubusercontent.com/22868753/135043160-65e40da6-022d-48c8-b712-544e372e629c.jpg)
* Perform the same step and create a new file **oci_api_key_pub.pem** under the directory **oci-keys** with the content of public key file downloaded in the previous section. 
* Navigate to **terraform** folder in the GIT repository and select **env_vars** file. Click on Edit File and update the values using the values copied in previous section and click on Commit
![vbs-update-env-vars](https://user-images.githubusercontent.com/22868753/135102108-be861a78-7577-45eb-8a01-c35cd05bb48d.jpg)


## Setup the Build job
* Go to VBS home and navigate to Organization page. Select **Build Executor Templates** and click on **Create Template**.
![build-vm-template](https://user-images.githubusercontent.com/22868753/135110376-bb315d94-2a2c-45bf-ad85-4499c0d2ec40.jpg)
* In the dialog for **New Build Executor Template**, enter the name as **Terraform Build** and any description. Select Platform as Oracle Linux 7 and click Create
* Select the created template **Terraform Build** and click on Configure Software. Search for terraform and select it so that it gets added to the selected software. Click Done.
![build-executor-config-software](https://user-images.githubusercontent.com/22868753/135111811-fd0c4b34-2454-4e09-960d-a3ae89a9c97e.jpg)
* Select the tab **VM Build Executors**. Click on **Create VM**. Select the previously selected Build Executor Template **Terraform Build**. Make sure the region selected is the same region where the VBS instance is running. Select one of the available shapes. Leave the VCN selection to default and click Add.
![add-vm-build-executor](https://user-images.githubusercontent.com/22868753/135113853-bd42ae3b-5df6-4fbf-9b8f-bad16b0919df.jpg)
* Select the created VM build executor **Terraform Build** and click on Start from the action menu and wait for the status to show as Ready
* Go to VBS Project Home and select **Builds**. Click on **Create Job**
* Enter the name and description and select the previously created template from the dropdown. Click on **Create**.
![create-build-job](https://user-images.githubusercontent.com/22868753/135112560-bbf7b72f-e1c7-4446-8c1c-d450da506cf9.jpg)
* Go to the job details page and click on **Configure**. 
* In the **Git** tab of Job Configuration page, click on **Add Git**. Select **vbs-terraform-integration.git** from the Repository dropdown.
* Go to **Steps** tab and click on **Add Step - > Common Build Tools -> Unix Shell**
* Copy the contents of /build/run_terraform.sh from VBS Git repository into the Unix Shell Script. Click on Save.
* From the Build Job Details page, click on **Build Now**. Wait for the build to be completed. In case of any errors, verify the steps in previous section to ensure that all the configurations related to OCI authentication are added properly.
* After the build is succesful, click on **View Build Log** from the Actions against the last build. Scroll to the end of the build to locate the public IP address of the compute instance created through terraform.  The log looks as shown below.
```
[2021-09-28 11:41:56] [0mhttpd_url = "http://130.61.131.111/"
[2021-09-28 11:41:56] instance_public_ip = "130.61.131.111"
[2021-09-28 11:41:56] END shell script execution
```
* Go to the browser and enter the URL http://compute_instance_public_ip(Public IP can be retrieved from the log). You should see Apache httpd server home page as the terraform script installs the httpd server on the compute instance.
* Also, you can go to the OCI console to verify the compartment, VCN, Internet Gateway, public subnet and compute instances created through terraform using VBS build job.

## Conclusion
We verified how we can add terraform scripts to provision the OCI resources can be added to the GIT repository of VBS projects to automate the OCI resource provisioning using the build jobs.



