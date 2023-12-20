# Upgrading from 2.X.Y to 3.0.0

Upgrading to `3.0.0` from `2.X.Y` will destroy and recreate the ingress nginx controller resource since now we're using the external module hosted on [GitHub](https://github.com/sparkfabrik/terraform-helm-ingress-nginx/).

To avoid that you will need to use the `moved` resource:

```hcl
moved {
  from = module.MODULE_NAME.helm_release.ingress_nginx_release
  to   = module.MODULE_NAME.helm_release.this
}
```

Upgrading to `3.0.0` from `2.X.Y` will also destroy and recreate the namespace, which is caused by the change of the `kubernetes_namespace` to `kubernetes_namespace_v1` resource.

You will need to import the new resource with the name of the current namespace.

It can be done using the `import` resource to import the new resource using the id of the old one:

```hcl
import {
  to = module.MODULE_NAME.kubernetes_namespace_v1.this[0]
  id = NS_NAME
}
```

Or manually using the terraform cli:

```bash
terraform import module.MODULE_NAME.kubernetes_namespace_v1.this[0] NS_NAME
```

And then you have to remove manually the old one from the state:

```bash
terraform state rm module.MODULE_NAME.kubernetes_namespace.ingress_nginx
```
