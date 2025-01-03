locals {
  separator = var.world == "none" ? "" : "-"
  world     = var.world == "none" ? "" : var.world
}
