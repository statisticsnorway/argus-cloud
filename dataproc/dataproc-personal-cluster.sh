# Login if necessary
#gcloud auth login

# Project settings
PROJECT=team-brunost
REGION=europe-north1
ZONE=europe-north1-a 
BUCKET_NAME=brunost-team-notebooks
NETWORK=brunost-team-vpc
EMAIL=$(gcloud auth list --filter=status=ACTIVE --format="value(account)")
USERNAME=$(echo ${EMAIL} | cut -d @ -f 1)
CLUSTER_NAME=dataproc-personal-cluster-${USERNAME}

#For output formatting
COL='\033[0;32m'
NC='\033[0m' # No Color

if
  gcloud dataproc clusters list --region=${REGION} | grep -Fq ${CLUSTER_NAME}
then
  echo "Cluster ${COL}${CLUSTER_NAME}${NC} already created. Starting cluster if necessary..."
  if
    gcloud dataproc clusters list --region=${REGION} --filter=status.state=STOPPED --format="value(NAME)" | grep -Fq ${CLUSTER_NAME}
  then
    gcloud dataproc clusters start ${CLUSTER_NAME} --project=${PROJECT} --region=${REGION}
  fi
else
  # Create personal cluster
  gcloud dataproc clusters create ${CLUSTER_NAME} \
  --image-version=2.0-debian10 \
  --properties=dataproc:dataproc.personal-auth.user=${EMAIL} \
  --region=${REGION} \
  --zone=${ZONE} \
  --project=${PROJECT} \
  --master-machine-type=n1-standard-4 \
  --worker-machine-type=n1-standard-4 \
  --bucket=${BUCKET_NAME} \
  --optional-components=JUPYTER \
  --enable-component-gateway \
  --metadata 'PIP_PACKAGES=google-cloud-bigquery google-cloud-storage jupyterlab-system-monitor' \
  --metadata GCS_CONNECTOR_VERSION=2.2.2 \
  --metadata bigquery-connector-version=1.2.0 \
  --metadata spark-bigquery-connector-version=0.21.0 \
  --subnet=${NETWORK} \
  --initialization-actions gs://goog-dataproc-initialization-actions-${REGION}/python/pip-install.sh,gs://goog-dataproc-initialization-actions-${REGION}/connectors/connectors.sh
fi

JLAB_URL=$(gcloud dataproc clusters describe ${CLUSTER_NAME} \
  --region=${REGION} --project=${PROJECT} | grep JupyterLab | cut -d : -f 2- | xargs)

echo "Opening URL: ${COL}${JLAB_URL}${NC}"
open ${JLAB_URL}

echo 'Open a terminal window in Jupyterlab and type: \n
   kinit -kt /etc/security/keytab/dataproc.service.keytab dataproc/$(hostname -f) \n'

echo "Also, run the following gcloud command from within the gcloud console: \n
  gcloud dataproc clusters enable-personal-auth-session --project=${PROJECT} --region=${REGION} ${CLUSTER_NAME}"
