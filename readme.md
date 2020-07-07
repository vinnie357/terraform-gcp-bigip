# GCP BIG-IP Terraform Module
modeled from https://github.com/f5devcentral/terraform-aws-bigip
thanks to [codygreen](https://github.com/codygreen),[mjmenger](https://github.com/mjmenger)

## example
```hcl
module bigip {
  source = "github.com/vinnie357/terraform-gcp-bigip?ref=master"
  #====================#
  # BIG-IP settings    #
  #====================#
  gceSshPubKey = var.gceSshPubKey
  projectPrefix = var.projectPrefix
  buildSuffix = "-${random_pet.buildSuffix.id}"
  adminSrcAddr = var.adminSrcAddr
  adminPass = random_password.password.result
  adminAccountName = var.adminAccountName
  mgmtVpc = google_compute_network.vpc_network_mgmt
  intVpc = google_compute_network.vpc_network_int
  extVpc = google_compute_network.vpc_network_ext
  mgmtSubnet = google_compute_subnetwork.vpc_network_mgmt_sub
  intSubnet = google_compute_subnetwork.vpc_network_int_sub
  extSubnet = google_compute_subnetwork.vpc_network_ext_sub
  serviceAccounts = var.serviceAccounts
  instanceCount = 1
  customImage = ""
  customUserData = ""
  bigipMachineType = "n1-standard-8"
}
```