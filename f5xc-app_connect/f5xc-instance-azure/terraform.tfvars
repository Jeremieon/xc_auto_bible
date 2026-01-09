# Azure Infrastructure Settings
resource_group_name = "jerry-rg"
location            = "West US 2"
public_subnet_cidr  = "172.16.1.0/24"
outside_subnet_cidr = "172.16.2.0/24"
inside_subnet_cidr  = "172.16.3.0/24"
name_prefix         = "jeremy-az"

# F5XC CE Configuration
f5xc-ce-site-name       = "jerry-azr-site"
owner                   = "jeremy"
ssh_username            = "cloud-user"
f5xc_default_sw_version = true

# VM Settings
f5xc_sms_instance_type        = "Standard_D8_v4"
f5xc_sms_storage_account_type = "Standard_LRS"
node_count                    = 1

# F5XC API Configuration
f5xc_api_url      = "https://f5-emea-ent.console.ves.volterra.io/api"
f5xc_api_p12_file = "./api-creds.p12"



