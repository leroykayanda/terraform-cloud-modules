output "sqs_url" {
  value = aws_sqs_queue.main_sqs.url
}

output "queue_id" {
  value = aws_sqs_queue.main_sqs.id
}

output "queue_arn" {
  value = aws_sqs_queue.main_sqs.arn
}

output "queue_name" {
  value = "${var.env}-${var.microservice_name}"
}
