variable gceSshPubKey {
  description = "GCP GCE Key name for SSH access"
  type        = string
}

variable projectPrefix {
  description = "Prefix for resources created by this module"
  type        = string
  default     = "terraform-gcp-bigip-"
}

variable serviceAccounts {
  type = map
  default = {
    storage = "default-compute@developer.gserviceaccount.com"
    compute = "default-compute@developer.gserviceaccount.com"
  }
}
variable adminSourceAddress {
  description = "admin source range in CIDR"

}
variable adminAccountName {
  description = "big-ip admin account name"
}
variable gcpProjectId {
  description = "project ID"
}

variable gcpRegion {
  description = "region"
  default     = "us-east1"
}
variable gcpZone {
  description = "zone"
  default     = "us-east1-b"
}