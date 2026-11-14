# Static Website Hosting on AWS (S3 + CloudFront) with Terraform

Website statis yang di-hosting pada bucket S3 **privat** dan disajikan global melalui **Amazon CloudFront** dengan HTTPS. Seluruh infrastruktur dan proses upload konten didefinisikan secara deklaratif dengan Terraform, tanpa klik manual di AWS Console.

## Arsitektur

```
Pengguna --HTTPS--> CloudFront (edge cache + security headers)
                         |  SigV4 (Origin Access Control)
                         v
                  S3 Bucket (privat, terenkripsi, versioning)
```

## Mengapa arsitektur ini?

| Keputusan | Alasan |
|---|---|
| Bucket S3 privat + OAC | Objek hanya bisa dibaca oleh distribution CloudFront ini (dibatasi `AWS:SourceArn`). Tidak ada akses publik langsung ke bucket, berbeda dengan S3 website endpoint yang harus dibuka ke publik. |
| CloudFront di depan S3 | Latensi rendah lewat edge cache, HTTPS bawaan, kompresi gzip/brotli, HTTP/2 dan HTTP/3. |
| Response headers policy | HSTS, X-Content-Type-Options, X-Frame-Options, dan Referrer-Policy diterapkan di edge tanpa kode tambahan. |
| `aws_s3_object` + `for_each` | Konten ikut ter-deploy oleh `terraform apply` (tanpa langkah manual) dan hanya file yang berubah (hash MD5) yang di-upload ulang. |
| Versioning + lifecycle 30 hari | Dapat rollback konten, sementara biaya penyimpanan tetap minim. |
| `PriceClass_100` | Edge location termurah; cukup untuk portofolio. |
| Random suffix pada nama bucket | Nama bucket S3 harus unik secara global. |

## Estimasi biaya

Masuk Free Tier: CloudFront 1 TB transfer dan 10 juta request per bulan (Always Free), S3 5 GB selama 12 bulan pertama. Untuk traffic portofolio, biaya mendekati $0.

## Cara menjalankan

Prasyarat: Terraform >= 1.5, AWS CLI yang sudah dikonfigurasi (`aws configure`).

```bash
./scripts/deploy.sh      # init + apply + invalidasi cache
terraform output website_url
```

Update konten: ubah file di `website/`, lalu jalankan `./scripts/deploy.sh` lagi.

## Membersihkan resource

```bash
./scripts/destroy.sh     # setara dengan: terraform destroy
```

## Struktur repositori

```
.
├── versions.tf   # versi Terraform & provider
├── variables.tf  # input variabel
├── main.tf       # S3, CloudFront, OAC, bucket policy
├── outputs.tf    # URL, distribution ID
├── website/      # konten statis
└── scripts/      # deploy.sh, destroy.sh
```
