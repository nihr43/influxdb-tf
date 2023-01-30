# influxdb-tf

Terraform module for influxdb in kubernetes on a rook storageclass.
This likey isn't a direct copy-paste for you because of kubernetes implementation nuances from cluster to cluster, but core concepts can be transferred.

## usage

External modules can be brought into your project using `git submodule`:

```
cd some-config-repo/modules/
git submodule add git@github.com:nihr43/influxdb-tf.git
```

Then, this module can be used in a DRY manner for multiple environments:

```
module "influxdb-prod" {
  source = "./modules/influxdb-tf"
  context = "prod"
  ip = "10.0.100.101"
  image = "influxdb:2.4"
  storage = "256Gi"
}

module "influxdb-staging" {
  source = "./modules/influxdb-tf"
  context = "staging"
  ip = "10.0.100.100"
  image = "influxdb:2.5"
  storage = "4Gi"
}
```
