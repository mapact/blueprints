# SAMPLE FILE FOR TRANQUILITY BLUEPRINT
# Check documentation and design decisions on Wiki: https://dev.azure.com/azure-terraform/Blueprints/_wiki/ 

# Azure Subscription activity logs retention period
azure_activity_logs_retention = 365

# Azure diagnostics logs retention period
azure_diagnostics_logs_retention = 60

# Set of resource groupds to land the blueprint
resource_groups_hub = {
    HUB-CORE-NET    = "-hub-core-net"
    HUB-CORE-SEC    = "-hub-core-sec"
    HUB-EDGE-NET    = "-hub-egress-net"
    HUB-INGRESS-NET = "-hub-ingress-net"
    HUB-TRANSIT-NET = "-hub-transit-net"
    HUB-OPERATIONS  = "-hub-operations"
}

#Primary location picked is region1, region2 is picked as backup whenever applicable
location_map = {
    region1   = "southeastasia"
    region2   = "eastasia"
}

#Set of tags for core operations: includes core resources for hub
tags_hub = {
    environment     = "DEV"
    owner           = "Arnaud"
    deploymentType  = "Terraform"
    costCenter      = "1664"
    BusinessUnit    = "SHARED"
    DR              = "NON-DR-ENABLED"
  }

#Logging and monitoring 
analytics_workspace_name = "lalogs"

#Azure Security Center Configuration 
security_center = {
    contact_email   = "email@email.com" 
    contact_phone   = "9293829328"
}

##Log analytics solutions to be deployed 
solution_plan_map = {
    NetworkMonitoring = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/NetworkMonitoring"
    },
    ADAssessment = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ADAssessment"
    },
    ADReplication = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ADReplication"
    },
    AgentHealthAssessment = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/AgentHealthAssessment"
    },
    DnsAnalytics = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/DnsAnalytics"
    },
    KeyVaultAnalytics = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/KeyVaultAnalytics"
    }
}
