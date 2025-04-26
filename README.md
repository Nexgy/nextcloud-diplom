README.md
## Installation Secrets

### 1. Creation Secrets
Generate initial secrets for PostgreSQL and Nextcloud:

# For PostgreSQL
kubectl create secret shared postgres-creds \
--namespace nextcloud \
--dry-run=client \
--from-literal=db=nextclouddb \
--from-literal=user=nextclouduser \
--from-literal=password=YOUR_POSTGRES_PASSWORD \
-o yaml > postgres-secret.yaml

# For Nextcloud admin
kubectl create secret shared nextcloud-admin \
--namespace nextcloud \
--dry-run=client \
--from-literal=user=YOUR_ADMIN_LOGIN \
--from-literal=password=YOUR_ADMIN_PASSWORD \
-o yaml > nextcloud-secret.yaml
2. Encrypt Secrets
Encrypt Secrets with kubeseal:

kubeseal --format yaml < postgres-secret.yaml > sealed-postgres.yaml
kubeseal --format yaml < nextcloud-secret.yaml > sealed-nextcloud.yaml
3. Delete Original Secrets
Do not commit unencrypted files to Git! Make sure they are added to .gitignore:

echo "*-secret.yaml" >> .gitignore
rm postgres-secret.yaml nextcloud-secret.yaml
4. Installing Helm Chart
When installing, use encrypted values:

helm install nextcloud . \

  --namespace nextcloud \
  --set nextcloud.trustedDomain=your-domain.com \
  --set postgres.image.tag=16 \
  --set postgres.storageSize=10Gi \
  --set postgres.timezone=Asia/Yekaterinburg \
  --set redis.image.tag=7.0 \
  --set redis.env.TZ=Asia/Yekaterinburg \
  --set-file secrets.postgres.db=sealed-postgres-db.yaml \
  --set-file secrets.postgres.password=sealed-postgres-password.yaml \
  --set secrets.nextcloud.adminUser="$(yq eval '.spec.encryptedData.user' sealed-nextcloud.yaml)" \
  --set secrets.nextcloud.adminPassword="$(yq eval '.spec.encryptedData.password' sealed-nextcloud.yaml)"
