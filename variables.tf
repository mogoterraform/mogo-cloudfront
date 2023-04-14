variable "bucket_name" {
  type = string
}
variable "domain_alias" {
  type    = string
  default = "cfstg.moka.ai"
}
variable "origins" {
  type    = list(string)
  default = ["staging.moka.ai", "moka-web.dev.mogo.dev"]
}
variable "origin_ids" {
  type    = list(string)
  default = ["staging", "mokaweb"]
}

variable "patterns" {
  type = list(string)
}

variable "cert_arn" {
  type = string
}

variable "cachepol" {
  type = string
  default = "Managed-CachingDisabled"
}

variable "originpol" {
  type = string
  default = "Managed-AllViewer"
}
