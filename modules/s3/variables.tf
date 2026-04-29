variable "bucket_name" {
  description = "Nombre del bucket S3 para el sitio web estático"
  type        = string
}

variable "index_file_path" {
  description = "Ruta del archivo index.html"
  type        = string
  default     = "index.html"
}

variable "index_file_key" {
  description = "Nombre del archivo index en S3"
  type        = string
  default     = "index.html"
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "project" {
  type = string
}