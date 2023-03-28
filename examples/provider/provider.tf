terraform {
  required_providers {
    st-alicloud = {
      source = "ruokei/st-alicloud"
    }
  }
}

provider "st-alicloud" {
  region = "cn-hongkong"
}
