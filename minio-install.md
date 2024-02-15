# TAP + MinIO
### Publishing TAP Developer Portal Docs via MinIO


## Create new NS
`k create ns minio`

## Install MinIO Helm Chart
`helm install minio bitnami/minio`

## Get MinIO Username / Password
```bash
export ROOT_USER=$(kubectl get secret --namespace minio minio -o jsonpath="{.data.root-user}" | base64 -d)
export ROOT_PASSWORD=$(kubectl get secret --namespace minio minio -o jsonpath="{.data.root-password}" | base64 -d)
```
## MinIO Info

### Sample command to get info
```bash
kubectl run --namespace minio minio-client \
     --rm --tty -i --restart='Never' \
     --env MINIO_SERVER_ROOT_USER=$ROOT_USER \
     --env MINIO_SERVER_ROOT_PASSWORD=$ROOT_PASSWORD \
     --env MINIO_SERVER_HOST=minio \
     --image docker.io/bitnami/minio-client:2024.1.18-debian-11-r1 -- admin info minio
```
### Port fwd API port
`kubectl port-forward --namespace minio svc/minio 9000:9000`

### Set local MC alias
`mc alias set k8s-minio-dev http://127.0.0.1:9000 "$ROOT_USER" "$ROOT_PASSWORD"`

### Set region for minio
```bash
export REGION=us-east-1
mc admin config set k8s-minio-dev/ region name="$REGION"
```

### Create bucket
```bash
export BUCKET=customer-profile
mc mb k8s-minio-dev/"$BUCKET" --region "$REGION"
```
## Tech Docs

### Generate Tech docs
Run following command from root directory of your app. e.g. customer-profile director. Catalog folder exists at this level. 
`npx @techdocs/cli generate -v --source-dir ./catalog --output-dir ./site`

### Export the docs to MinIO bucket
Assuming apps are running in dev namespace.
```bash
export AWS_ACCESS_KEY_ID=$ROOT_USER
export AWS_SECRET_ACCESS_KEY=$ROOT_PASSWORD
export AWS_REGION=$REGION

npx @techdocs/cli publish --publisher-type awsS3 --storage-name "$BUCKET" \
  --awsEndpoint http://127.0.0.1:9000 --awsS3ForcePathStyle \
  --entity dev/Component/customer-profile \
  --directory ./site
```

## Update tap-values file.
Finally update tap-values file. You can genera new access keys using MinIO UI. Access MinIO UI by running portforward command on 9001 port.

```yaml
tap_gui:
  app_config:
    techdocs:
      builder: external
      publisher:
        awsS3:
          bucketName: customer-profile
          credentials:
            accessKeyId: XXX
            secretAccessKey: XXX
          endpoint: http://minio.minio.svc.cluster.local:9000
          region: us-east-1
          s3ForcePathStyle: true
        type: awsS3

```

Update catalog-info.yaml with following 
```yaml
metadata:
  annotations:
    backstage.io/techdocs-ref: dir:.
```