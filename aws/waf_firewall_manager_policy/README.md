    module "waf_firewall_manager_policy" {
      source       = "./modules/security/waf_firewall_manager_policy"
      team         = var.team
      company_name = var.company
      include_map  = var.include_map
    
      providers = {
        aws = aws.management
      }
    }
