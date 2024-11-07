variable "bucket" {
  description = "The name of the S3 bucket"
  default     = "myportfoliobucket061124"
  type        = string
}

variable "object_ownership" {
  description = "The ownership of the objects in the S3 bucket"
  default     = "ObjectWriter"
  type        = string
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use"
  default     = "AES256"
  type        = string
}