    module "datadog_integration" {
      source      = "app.terraform.io/abc-Inc/modules/abc//aws/networking/datadog_integration"
      version     = "1.1.72"
      external_id = local.external_id
      env         = local.workspace
    
      providers = {
        datadog = datadog.dd
      }
    }
