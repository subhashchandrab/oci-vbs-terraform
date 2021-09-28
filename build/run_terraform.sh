echo $(pwd)
# Update the environment variables
source terraform/env_vars

#Copy the public and private key files to terraform directory
cp oci_api_key_private.pem ~/.terraform.d/
cp oci_api_key_pub.pem ~/.terraform.d/


#Generate the public/private key pair on the current VM which can be used to connect to the compute instance provisioned using terraform
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y

terraform --version
cd terraform 
terraform init 
terraform plan 
terraform destroy -auto-approve
terraform apply -auto-approve 
