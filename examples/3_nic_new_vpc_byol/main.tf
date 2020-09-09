# provider
provider google {
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone

}

# project
resource random_pet buildSuffix {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    #ami_id = "${var.ami_id}"
    prefix = var.projectPrefix
  }
  #length = ""
  #prefix = "${var.projectPrefix}"
  separator = "-"
}
# password
resource random_password password {
  length           = 16
  special          = true
  override_special = " #%*+,-./:=?@[]^_~"
}
# networks
# vpc
resource google_compute_network vpc_network_mgmt {
  name                    = "${var.projectPrefix}terraform-network-mgmt-${random_pet.buildSuffix.id}"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource google_compute_subnetwork vpc_network_mgmt_sub {
  name          = "${var.projectPrefix}mgmt-sub-${random_pet.buildSuffix.id}"
  ip_cidr_range = "10.0.10.0/24"
  region        = var.gcpRegion
  network       = google_compute_network.vpc_network_mgmt.self_link

}
resource google_compute_network vpc_network_int {
  name                    = "${var.projectPrefix}terraform-network-int-${random_pet.buildSuffix.id}"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource google_compute_subnetwork vpc_network_int_sub {
  name          = "${var.projectPrefix}int-sub-${random_pet.buildSuffix.id}"
  ip_cidr_range = "10.0.20.0/24"
  region        = var.gcpRegion
  network       = google_compute_network.vpc_network_int.self_link

}
resource google_compute_network vpc_network_ext {
  name                    = "${var.projectPrefix}terraform-network-ext-${random_pet.buildSuffix.id}"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource google_compute_subnetwork vpc_network_ext_sub {
  name          = "${var.projectPrefix}ext-sub-${random_pet.buildSuffix.id}"
  ip_cidr_range = "10.0.30.0/24"
  region        = var.gcpRegion
  network       = google_compute_network.vpc_network_ext.self_link

}
# firewall
resource google_compute_firewall default-allow-internal-mgmt {
  name    = "${var.projectPrefix}default-allow-internal-mgmt-${random_pet.buildSuffix.id}"
  network = google_compute_network.vpc_network_mgmt.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = ["10.0.10.0/24"]
}

resource google_compute_firewall default-allow-internal-ext {
  name    = "${var.projectPrefix}default-allow-internal-ext-${random_pet.buildSuffix.id}"
  network = google_compute_network.vpc_network_ext.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = ["10.0.30.0/24"]
}

resource google_compute_firewall default-allow-internal-int {
  name    = "${var.projectPrefix}default-allow-internal-int-${random_pet.buildSuffix.id}"
  network = google_compute_network.vpc_network_int.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = ["10.0.20.0/24"]
}
resource google_compute_firewall mgmt {
  name    = "${var.projectPrefix}mgmt-${random_pet.buildSuffix.id}"
  network = google_compute_network.vpc_network_mgmt.name
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }

  source_ranges = var.adminSourceAddress
}
resource google_compute_firewall app {
  name    = "${var.projectPrefix}app-${random_pet.buildSuffix.id}"
  network = google_compute_network.vpc_network_ext.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = var.adminSourceAddress
}
module bigip {
  source = "github.com/vinnie357/terraform-gcp-bigip?ref=master"
  #====================#
  # BIG-IP settings    #
  #====================#
  gceSshPubKey     = var.gceSshPubKey
  projectPrefix    = var.projectPrefix
  buildSuffix      = "-${random_pet.buildSuffix.id}"
  adminSrcAddr     = var.adminSourceAddress
  adminPass        = random_password.password.result
  adminAccountName = var.adminAccountName
  mgmtVpc          = google_compute_network.vpc_network_mgmt
  intVpc           = google_compute_network.vpc_network_int
  extVpc           = google_compute_network.vpc_network_ext
  mgmtSubnet       = google_compute_subnetwork.vpc_network_mgmt_sub
  intSubnet        = google_compute_subnetwork.vpc_network_int_sub
  extSubnet        = google_compute_subnetwork.vpc_network_ext_sub
  serviceAccounts  = var.serviceAccounts
  instanceCount    = 1
  customImage      = "projects/f5-7626-networks-public/global/images/f5-bigip-15-1-0-4-0-0-6-byol-all-modules-2boot-loc-00618231635"
  customUserData   = ""
  bigipMachineType = "n1-standard-8"
}