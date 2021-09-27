# Automate OCI Resource Provisioning with Visual Builder Studio and Terraform

Oracle Visual Builder Studio (VB Studio) is a robust application development platform that helps your team effectively plan and manage your work throughout all stages of the app dev lifecycle: design, build, test, and deploy. By integrating the terraform scripts in the VB Studio, we can automate the OCI resource provisioning. 

In the current usecase, we will explore how we can use Oracle VB Studio and terraform scripts to achieve the following.
1) Provision the VB Studio and acquire the access
2) Setup a VBS Project
3) Setup a GIT repository qith required terraform files in the VBS project
4) Define a build job to run the terraform script files from GIT repo to provision the OCI resources

## VB Studio Access
* Ensure that you have [access to VB Studio instance](https://docs.oracle.com/en/cloud/paas/visual-builder/visualbuilder-manage-development-process/basics.html#GUID-F907935C-DE58-41CE-AF3B-5F2DE654AE12)
* Login to the VB Studio to [access the home page](https://docs.oracle.com/en/cloud/paas/visual-builder/visualbuilder-manage-development-process/basics.html#GUID-93A3E6D1-FED5-4AE0-8AF6-7B27E72556E8)

## Setup VB Studio project
* From the Organization tab in the home page, click on Create
* 
