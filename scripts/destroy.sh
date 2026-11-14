#!/usr/bin/env bash
# Hapus seluruh resource agar tidak ada biaya tersisa.
set -euo pipefail

cd "$(dirname "$0")/.."
terraform destroy -auto-approve -input=false
echo "Semua resource telah dihapus."
