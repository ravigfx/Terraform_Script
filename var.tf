variable "subscription_id" {
    type = string
    default = "8d89b202-01a8-4471-b64e-0c8dea2928a0"
    description = "prod subscription"

}
variable "client_id" {
    type = string
    default = "4350bdd8-1866-4117-bed5-9aa2943890be"
    description = "prod client_id"

}
variable "client_secret" {
    type = string
    default = "RfP8Q~2d_U4A64hjW-jYEkhPH6ttwebl-UVlhcK9"
    description = "prod client_secret"

}
variable "tenant_id" {
    type = string
    default = "5a361c56-cc3e-40f9-92ef-ff13dd1fca8b"
    description = "prod tenant_id"


}
variable "vm_name_pfx" {
    type = string
    default = "dev-vm-"
    description = "vm name prefix"

}
variable "vm_count" {
    type = string
    default = "1"
    description = "vm count"

}