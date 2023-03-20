provider "st-alicloud" {
  alias  = "antiddos-instance"
  region = "ap-southeast-1"
}

data "st-alicloud_antiddos_coo_instances_detail" "ins" {
  provider     = st-alicloud.antiddos-instance
  ids          = ["id1", "id2"]
  remark_regex = "^example-remark"
}

output "alicloud_antiddos_coo_instances_detail" {
  value = data.st-alicloud_antiddos_coo_instances_detail.ins
}
