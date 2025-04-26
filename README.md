README.md
Создайте секреты (согласно README.md):

bash
# PostgreSQL
kubectl create secret generic postgres-creds \
  --namespace nextcloud \
  --dry-run=client \
  --from-literal=db=nextclouddb \
  --from-literal=user=nextclouduser \
  --from-literal=password=YOUR_POSTGRES_PASSWORD \
  -o yaml > postgres-secret.yaml

# Nextcloud Admin
kubectl create secret generic nextcloud-admin \
  --namespace nextcloud \
  --dry-run=client \
  --from-literal=user=YOUR_ADMIN_LOGIN \
  --from-literal=password=YOUR_ADMIN_PASSWORD \
  -o yaml > nextcloud-secret.yaml
Запечатайте секреты:

bash
kubeseal --format yaml < postgres-secret.yaml > sealed-postgres.yaml
kubeseal --format yaml < nextcloud-secret.yaml > sealed-nextcloud.yaml
Установите Helm-чарт:

bash
helm install nextcloud . \
  --namespace nextcloud \
  --create-namespace \
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
