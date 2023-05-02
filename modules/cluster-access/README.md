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
$ docker run --rm -it --env-file=<the env file with AWS credentials> --entrypoint bash amazon/aws-cli:latest
```

Launch the following commands inside the shell of the container:

```bash
curl -o /usr/local/bin/kubectl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -o /usr/local/bin/jq -LO "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
chmod +x /usr/local/bin/{kubectl,jq}
alias k=kubectl
export CLUSTER_NAME="$(aws eks list-clusters | jq --raw-output '.clusters[0]')"
export KUBECONFIG="/aws/${CLUSTER_NAME}_kubeconfig"
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --kubeconfig "${KUBECONFIG}"
```

Now you have the access to all the application namespaces with your configured role.
