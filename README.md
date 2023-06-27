Terraform Custom Provider for Alibaba Cloud
===========================================

This Terraform custom provider is designed for own use case scenario.

Supported Versions
------------------

| Terraform version | minimum provider version |maxmimum provider version
| ---- | ---- | ----|
| >= 1.3.x	| 0.1.1	| latest |

Requirements
------------

-	[Terraform](https://www.terraform.io/downloads.html) 1.3.x
-	[Go](https://golang.org/doc/install) 1.19 (to build the provider plugin)

Local Installation
------------------

1. Run make file `make install-local-custom-provider` to install the provider under ~/.terraform.d/plugins.

2. The provider source should be change to the path that configured in the *Makefile*:

    ```
    terraform {
      required_providers {
        st-alicloud = {
          source = "example.local/myklst/st-alicloud"
        }
      }
    }

    provider "st-alicloud" {
      region = "cn-hongkong"
    }
    ```

Why Custom Provider
-------------------

This custom provider exists due to some of the resources and data sources in the
official AliCloud Terraform provider may not fulfill the requirements of some
scenario. The reason behind every resources and data sources are stated as below:

### Resources

- **st-alicloud_alidns_gtm_instance**

  The original reason to write this resource is official AliCloud Terraform
  provider does not support creating GTM (Global Traffic Manager) instance on
  AliCloud international account using Terraform. As we developing on the
  resource, we added few more features which are useful in our use case, which
  includes:

    - setting the renewal status to *NotRenewal* when destroying the resource.

    - allowing changing of renewal period and status without recreating the GTM instsance.

- **st-alicloud_alidns_record_weight**

  Official AliCloud Terraform provider does not have the resource to modify DNS
  records weight.

- **st-alicloud_ram_user_group_attachment**

  The official AliCloud Terraform provider's resource
  [*alicloud_ram_group_membership*](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_group_membership)
  will remove all other attached users for the target group, which may cause a
  problem where Terraform may delete those users attached outside from Terraform.

- **st-alicloud_cms_alarm_rule**

  The official AliCloud Terraform provider's resource
  [*alicloud_cms_alarm*](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cms_alarm)
  does not support adding alarm rules based on expression-based creation.

### Data Sources

- **st-alicloud_ddoscoo_domain_resources**

  Official AliCloud Terraform provider does not support querying the CNAME of
  AntiDDoS domain resources through
  [*alicloud_ddoscoo_domain_resources*](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/ddoscoo_domain_resources).

- **st-alicloud_ddoscoo_instances**

  Official AliCloud Terraform provider does not support querying the EIP of
  AntiDDoS instance resources through
  [*alicloud_ddoscoo_instances*](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/ddoscoo_instances).

- **st-alicloud_cdn_domain**

  Official AliCloud Terraform provider does not have the data source to query
  the CNAME of CDN domain.

- **st-alicloud_slb_load_balancers**

  The tags parameter of AliCloud API
  [*DescribeLoadBalancers*](https://www.alibabacloud.com/help/en/server-load-balancer/latest/describeloadbalancers)
  will return all load balancers when any one of the tags are matched. This may
  be a problem when the user wants to match exactly all given tags, therefore
  this data source will filter once more after listing the load balancers
  from AliCloud API to match all the given tags.

  The example bahaviors of AliCloud API *DescribeLoadBalancers*:

  | Load Balancer   | Tags                                            | Given tags: { "location": "office" "env": "test" }          |
  |-----------------|-------------------------------------------------|-------------------------------------------------------------|
  | load-balancer-A | { "location": "office" "env" : "test" }         | Matched (work as expected)                                  |
  | load-balancer-B | { "location": "office" "env" : "prod" }         | Matched (should not be matched as the `env` is prod)          |

References
----------

- Website: https://www.terraform.io
- Terraform Plugin Framework: https://developer.hashicorp.com/terraform/tutorials/providers-plugin-framework
- AliCloud official Terraform provider: https://github.com/aliyun/terraform-provider-alicloud
