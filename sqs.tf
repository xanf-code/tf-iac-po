resource "aws_sqs_queue" "po_sqs_queue" {
  name                      = "${var.all_vars_prefix}-ip-sqs-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 10
}