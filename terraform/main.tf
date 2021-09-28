# Initialize the local values to be used in the script
locals {
  all_ip_cidr_wildcard = "0.0.0.0/0" // CIDR block to wildcard all ip addresses
  tcp_protocol = "6" // Numeric code for TCP protocol
  icmp_protocol = "1"
}
 
# Create the compartment under the root  
resource "oci_identity_compartment" "vbs_tf_compartment" {
    compartment_id = var.tenancy_ocid
    description = "Compartment provisioned by terraform"
    name = var.compartment_display_name
}  

# Initialize the availability domain to be used
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

# Create the VCN
resource "oci_core_vcn" "vbs_tf_vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name
}

# Create Internet Gateway
resource "oci_core_internet_gateway" "vbs_tf_igw" {
  compartment_id = var.compartment_ocid
  display_name   = var.igw_display_name
  vcn_id         = oci_core_vcn.vbs_tf_vcn.id
}

# Create default route table  for the VCN  with a routing rule to use internet gateway
resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vbs_tf_vcn.default_route_table_id
  display_name               = var.default_route_table_name

  route_rules {
    destination       = local.all_ip_cidr_wildcard
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.vbs_tf_igw.id
  }
}


# Create default security list for the VCN with required ingress and egress rules
resource "oci_core_default_security_list" "default_security_list" {
  manage_default_resource_id = oci_core_vcn.vbs_tf_vcn.default_security_list_id
  display_name               = var.default_security_list_name

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = local.all_ip_cidr_wildcard
    protocol    = local.tcp_protocol
  }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = local.tcp_protocol
    source    = local.all_ip_cidr_wildcard
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
 // allow http ingress traffic
  ingress_security_rules {
    protocol  = local.tcp_protocol
    source    = local.all_ip_cidr_wildcard
    stateless = false

    tcp_options {
      min = 80
      max = 80
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = local.all_ip_cidr_wildcard
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }
}

# Create the public subnet under the VCN
resource "oci_core_subnet" "vbs_tf_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = var.public_subnet_cidr
  display_name        = var.public_subnet_display_name
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.vbs_tf_vcn.id
  security_list_ids   = [oci_core_vcn.vbs_tf_vcn.default_security_list_id]  
  route_table_id      = oci_core_vcn.vbs_tf_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.vbs_tf_vcn.default_dhcp_options_id
}

# Create the compute instance using the provided shape and images
module "vbs_tf_compute_instance" {
  source = "oracle-terraform-modules/compute-instance/oci"
  
  # general oci parameters
  compartment_ocid = var.compartment_ocid
  instance_display_name = var.compute_instance_display_name
  subnet_ocids = [oci_core_subnet.vbs_tf_subnet.id]
  ssh_authorized_keys = var.ssh_public_key_path
  shape = var.compute_instance_shape
  assign_public_ip = true
  source_ocid=var.compute_shape_image_ocid
}

output "instance_public_ip" {
  value       = module.vbs_tf_compute_instance.public_ip[0]
}

# Install httpd(Apache web server) on the provisioned instance using the remote-exec
resource "null_resource" "remote-exec" {

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = module.vbs_tf_compute_instance.public_ip[0]
      user        = "opc"
      private_key = "${file(var.ssh_private_key_path)}"
    }

    inline = [
        "echo 'This instance was provisioned by Terraform.' | sudo tee /etc/motd",
        "sudo yum -y update",
        "sudo yum -y install httpd",
        "sudo firewall-cmd --permanent --add-service=http",
        "sudo firewall-cmd --reload",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd"
    ]
  }
}

output "httpd_url" {
  value = "http://${module.vbs_tf_compute_instance.public_ip[0]}/"
}

