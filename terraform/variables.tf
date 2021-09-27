# Defines the variable for the compartment OCID
variable "compartment_ocid" {

}

# Defines the variable for the tenancy OCID
variable "tenancy_ocid" {

}

variable "namespace" {

}

#Defines a variable for the CIDR block of VCN
variable "vcn_cidr_block" {

}

#Defines a variable for the VCN display name
variable "vcn_display_name" {
  default = "TestVCN"
}

#Defines a variable for the Internet Gateway display name
variable "igw_display_name" {
  default = "vbs_tf_igw"
}


#Defines a variable for the default route table name
variable "default_route_table_name" {
  default = "defaultRouteTable"
}

#Defines a variable for the default security list name
variable "default_security_list_name" {
  default = "defaultSecurityList"
}


#Defines a variable for the CIDR of public subnet
variable "public_subnet_cidr" {

}

#Defines a variable for the display name of public subnet
variable "public_subnet_display_name" {

}

#Defines a variable for the name of the compute instance
variable "compute_instance_display_name" {

}

#Defines a variable for the compute instance shape
variable "compute_instance_shape" {

}

#Defines a variable for the OCID of the compuate instance shape image
variable "compute_shape_image_ocid" {

}

#Defines a variable for the public key file path
variable "ssh_public_key_path" {

}

#Defines a variable for the private key file path
variable "ssh_private_key_path" {

}
