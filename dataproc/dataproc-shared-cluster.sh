gcloud config set project team-brunost

gcloud services enable dataproc.googleapis.com \
  compute.googleapis.com \
  storage-component.googleapis.com \
  bigquery.googleapis.com \
  bigquerystorage.googleapis.com
  
REGION=europe-north1
BUCKET_NAME=brunost-team-notebooks
gsutil mb -c standard -l ${REGION} gs://${BUCKET_NAME}

REGION=europe-north1
ZONE=europe-north1-a 
CLUSTER_NAME=spark-jupyter-brunost-cluster 
BUCKET_NAME=brunost-team-notebooks
NETWORK=brunost-team-vpc

gcloud dataproc clusters create ${CLUSTER_NAME} \
  --region=${REGION} \
  --zone=${ZONE} \
  --image-version=2.0 \
  --master-machine-type=n1-standard-4 \
  --worker-machine-type=n1-standard-4 \
  --bucket=${BUCKET_NAME} \
  --optional-components=JUPYTER \
  --enable-component-gateway \
  --network=${NETWORK} \
  --metadata 'PIP_PACKAGES=google-cloud-bigquery google-cloud-storage' \
  --metadata GCS_CONNECTOR_VERSION=2.2.2 \
  --metadata bigquery-connector-version=1.2.0 \
  --metadata spark-bigquery-connector-version=0.21.0 \
  --initialization-actions gs://goog-dataproc-initialization-actions-${REGION}/python/pip-install.sh,gs://goog-dataproc-initialization-actions-${REGION}/connectors/connectors.sh
