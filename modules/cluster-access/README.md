# Cluster access

## Roles description

This module creates `Role` and `RoleBinding` in the specified namespace with two access levels:

1. `developer-access` is a simple reader of the specified namespaces and it can only get the current deployed resources, read pod logs and exec commands inside the pods
2. `admin-access` is the admin of the specified namespace and it can do anything on the current deployed resources

## IAM Access

These `Roles` are binded to two `Groups` in the cluster. The mapping between `Groups` and `Users` is managed from the `aws-auth` configmap which is created by the `eks module` (`cluster_definition`) and it maps the AWS IAM `arn` with the corresponding `Group` (so to the corresponding `Role`). To access to the cluster you can create an `env` file with the AWS credentials, based on the following template:

```env
AWS_ACCESS_KEY_ID=<developer or admin ACCESS KEY>
AWS_SECRET_ACCESS_KEY=<developer or admin SECRET ACCESS KEY>
AWS_DEFAULT_REGION=<cluster region>
```

Launch the `aws cli` container as follow:

```bash
$ docker run --rm -it --env-file=<the env file with AWS credentials> ghcr.io/sparkfabrik/aws-tools:latest
```

If all the infromations are correct, and you have only one cluster, the `docker-entrypoint` should automatically configure your `Kubeconfig` in order to access to the EKS cluster.
