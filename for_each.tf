##### Example 1: Using for_each with set of strings 
##### Create 2 VPC 
variable "vpc" {
    type = set(string)
    default = [ "vpc-a", "vpc-b" ]
}
resource "google_compute_network" "vpc" {
    for_each = var.vpc
    name = each.value
    auto_create_subnetworks = false
    mtu                     = 1460
}

##### VPC use for example 2,3,4,5
resource "google_compute_network" "default" {
  name = "vpc-default"
  auto_create_subnetworks = false
  mtu                     = 1460
}

##### Example 2: Using for_each with map
variable "subnet_map" {
  type = map(string)
  default = {
    "subnet1" = "10.0.1.0/24", 
    "subnet2" = "10.0.2.0/24" 
    }
}
resource "google_compute_subnetwork" "subnet_map" {
  for_each = var.subnet_map
  name                     = each.key
  ip_cidr_range            = each.value
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = false
}

##### Example 3: Using for_each with modules
variable "subnet_map_object" {
  type = map(object({
    name = string,
    cidr = string
  })
  )
  default = {
    "subnet3" = {
        name = "subnet3"
        cidr = "10.0.3.0/24"
    },
    "subnet4" = {
        name = "subnet4"
        cidr = "10.0.4.0/24"
    },
  }
}
resource "google_compute_subnetwork" "subnet_map_object" {
  for_each = var.subnet_map_object
  name = each.value.name
  ip_cidr_range = each.value.cidr
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = false
}

##### Example 4: Using for_each with list of objects
variable "subnet_list_object" {
  type = list(object({
    name = string
    ip_cidr_range = string
    enable = bool
  })
  )
    # enabled – a boolean value that decides whether to provision the instance or not. 
  
  default = [ 
  {
    name = "subnet5"
    ip_cidr_range = "10.0.5.0/24"
    enable = true
  },
  {
    name = "subnet6"
    ip_cidr_range = "10.0.6.0/24"
    enable = false
  }, 
  ]
}
resource "google_compute_subnetwork" "subnet_list_object" {
  for_each = {for i in var.subnet_list_object : i.name => i }
  # Conditional creation with for_each
  # for_each = { for i in var.subnet_list_object : i.name => i if i.enable }
  
  name = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  network = google_compute_network.default.self_link
  region = var.region
  private_ip_google_access = false
}



##### EXAM CREATE VM FROM SUBNET
# resource "google_compute_instance" "vm_map_object" {
#   for_each = google_compute_subnetwork.subnet_map_object
#   project = var.project_id
#   name = "instance-map-object-${each.value.id}"
#   machine_type = "f1-micro"
#   zone         = var.zone
#   tags = [ "${each.value.id} instance" ]
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }
#   network_interface {
#     subnetwork = each.value.id
#   }
# }

# resource "google_compute_instance" "vm_list_object" {
#   for_each = google_compute_subnetwork.subnet_list_object
#   name = "instance-${each.value.name}"
#   project = var.project_id
#   machine_type = "f1-micro"
#   zone         = var.zone
#   tags = [ "${each.value.name}-instance" ]
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }
#   network_interface {
#     subnetwork = each.value.name
#   }
# }