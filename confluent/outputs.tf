output "api_key" {
  value = confluent_api_key.api_key.id
}

output "api_secret" {
  value = confluent_api_key.api_key.secret
}
