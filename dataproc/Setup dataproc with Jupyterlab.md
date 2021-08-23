### Dataproc with Jupyterlab

This page describes two ways to create a Dataproc cluster with Jupyterlab

#### Shared dataproc cluster with Jupyterlab

This cluster can be accessed by any authenticated `team-brunost` member. The member must have the role `dataproc.editor` to be able to access Jupyterlab and run notebooks.

#### Personal dataproc cluster with Jupyterlab

When you create a Dataproc cluster, you can enable Dataproc Personal Cluster Authentication to allow interactive workloads on the cluster to securely run as your user identity. This means that interactions with other Google Cloud resources such as Cloud Storage will be authenticated as yourself instead of the cluster service account.