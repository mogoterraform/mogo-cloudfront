variable "bucket_name" {
  type = string
}
variable "domain_alias" {
  type = string
  default = "cfstg.moka.ai"
}
variable "origins" {
  type = list(string)
  default = ["staging.moka.ai","moka-web.dev.mogo.dev"]
}
variable "origin_ids" {
  type = list(string)
  default = ["staging","mokaweb"]
}
