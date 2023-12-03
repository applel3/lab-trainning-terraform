variable "path-file" {
  type = string
  default = "../cert/switcher@maximal-totem-402409.iam.gserviceaccount.com/maximal-totem-402409-b31ecdd967b4.json"
}

variable "project_id" {
  type = string
  default = "maximal-totem-402409"
}
variable "region" {
  type = string
  default = "asia-east1"
}
variable "zone" {
  type = string
  default = "asia-east1-c"
}

provider "google" {
  credentials = file("${var.path-file}")
  version = "< 5.0, >=3.83"
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
provider "google-beta" {
  credentials = file("${var.path-file}")
  version = "< 5.0, >= 3.45"
  project = var.project_id
  region  = var.region
  zone    = var.zone
}