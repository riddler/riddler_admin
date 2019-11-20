require "aws-sdk-sqs"

Aws.config.update \
  region: 'us-west-2',
  credentials: Aws::Credentials.new("x","x"),
  endpoint: "http://127.0.0.1:9324"

SQS = Aws::SQS::Client.new

SEND_QUEUE = SQS.create_queue queue_name: "riddler-guides"
INBOX_QUEUE = SQS.create_queue queue_name: "riddler-inbox"
