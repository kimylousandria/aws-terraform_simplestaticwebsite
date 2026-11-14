#!/usr/bin/env bash
# Deploy otomatis: terraform apply (infra + upload file) lalu invalidasi cache CloudFront.
# Pemakaian: ./scripts/deploy.sh
set -euo pipefail

cd "$(dirname "$0")/.."

command -v terraform >/dev/null || { echo "terraform belum terpasang"; exit 1; }
command -v aws >/dev/null || { echo "aws cli belum terpasang"; exit 1; }

terraform init -input=false
terraform apply -auto-approve -input=false

DIST_ID="$(terraform output -raw distribution_id)"
echo "Membersihkan cache CloudFront ($DIST_ID)..."
aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths '/*' >/dev/null

echo
echo "Selesai. Website: $(terraform output -raw website_url)"
