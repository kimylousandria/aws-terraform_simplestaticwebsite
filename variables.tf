variable "aws_region" {
  description = "Region AWS untuk bucket S3 (CloudFront bersifat global)."
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Nama proyek, dipakai sebagai prefix nama resource dan tag."
  type        = string
  default     = "static-website"
}

variable "environment" {
  description = "Nama environment (dev/staging/prod)."
  type        = string
  default     = "dev"
}

variable "website_dir" {
  description = "Folder lokal berisi file website yang di-upload ke S3."
  type        = string
  default     = "website"
}

variable "price_class" {
  description = "Price class CloudFront. PriceClass_100 = edge location paling murah (NA & Eropa)."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "price_class harus PriceClass_100, PriceClass_200, atau PriceClass_All."
  }
}
