
# device
variable "projectPrefix" {
  description = "prefix for resources"
  default = "terraform-gcp-bigip-"
}
variable "buildSuffix" {
  description = "resource suffix"
}
variable "name" {
  description = "device name"
  default = "bigip"
}
variable "instanceCount" {
    description = "number of devices"
    default = 1
}
variable "bigipMachineType" {
    description = "bigip gce machine type/size"
    default = "n1-standard-8"
}
variable "bigipImage" {
 description = " bigip gce image name"
 default = "projects/f5-7626-networks-public/global/images/f5-bigip-15-0-1-1-0-0-3-payg-best-1gbps-191118"
}

# bigip stuff
variable adminAccountName { 
    description = "big-ip admin account name"
    default = "admin" 
}
variable adminPass { 
    description = "big-ip admin password"
    default = ""
 }
variable host1Name { default = "f5vm01" }
variable host2Name { default = "f5vm02" }
variable dnsServer { default = "8.8.8.8" }
variable ntpServer { default = "0.us.pool.ntp.org" }
variable timezone { default = "UTC" }
variable libsDir { default = "/config/cloud/gcp/node_modules" }
variable onboardLog { default = "/var/log/startup-script.log" }
# Custom image
variable "customImage" {
  description = "custom build image name"
  default = ""
}
variable "customUserData" {
  description = "custom startup script data"
  default = ""
}
# IAM
variable "gcpServiceAccounts" {
  type = "map"
  default = {
      storage = "default-compute@developer.gserviceaccount.com"
      compute = "default-compute@developer.gserviceaccount.com"
    }
}
variable "adminSrcAddr" {
  description = "admin source range in CIDR"

}
variable "gceSshPubKey" {
    description = "public key for ssh access"
    default = ""
}
# networks
# vpcs
variable "extVpc" {
  description = "name of external vpc"
}
variable "mgmtVpc" {
  description = "name of mgmt vpc"
}
variable "intVpc" {
  description = "name of internal vpc"
}
# subnets
variable "extSubnet" {
  description = "name of external subnet"
}
variable "mgmtSubnet" {
  description = "name of management subnet"
}
variable "intSubnet" {
  description = "name of internal subnet"
}