tenant_name  = "f5-emea-ent"
namespace    = "j-agboola"
volterra_url = "https://f5-emea-ent.console.ves.volterra.io/api"
# Optional: Virtual Site Configuration
create_f5xc_vsite_resources = true
f5xc_vsite_key              = "jeremieon-key"
f5xc_vsite_key_label        = "azure-aws"
create_f5xc_virtual_site    = true
f5xc_virtual_site_name      = "jeremieon-v-sites"
f5xc-ce-site-name           = "jeremieon-aws-site"
f5xc_default_sw_version     = true
node_count                  = 1
f5xc_sms_description        = "F5XC SMSv2 AWS site created with Terraform"
