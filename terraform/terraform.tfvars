compartment_display_name="vbs-tf-compartment"
vcn_cidr_block = "10.1.0.0/16"
vcn_display_name = "vbs-tf-vcn"
igw_display_name = "vbs-tf-igw"
default_route_table_name = "defaultRouteTable"
default_security_list_name = "defaultSecurityList"
public_subnet_cidr = "10.1.20.0/24"
public_subnet_display_name = "public-subnet"
compute_instance_display_name = "vbs-tf-compute-instance"
# Use any eligible shape based on service limits
compute_instance_shape = "VM.Standard.E3.Flex"
ssh_public_key_path = "~/.ssh/id_rsa.pub"
ssh_private_key_path = "~/.ssh/id_rsa"
# The following is the image OCID for Oracle-Linux-7.9-2021.08.27-0 in the region eu-frankfurt-1
# If you want to use a different image, get the image OCID based on the OS version from https://docs.oracle.com/en-us/iaas/images/
compute_shape_image_ocid = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaacwqra6qcg5iil3pwqdmtorw37prkvxaw4xql6fxt6gx4lp2diyoa"



