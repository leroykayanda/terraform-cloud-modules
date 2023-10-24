output "private_endpoints" {
  value = aws_msk_cluster.msk_cluster.bootstrap_brokers_sasl_scram
}

output "public_endpoints" {
  value = aws_msk_cluster.msk_cluster.bootstrap_brokers_public_sasl_scram
}
