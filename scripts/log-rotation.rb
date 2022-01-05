require 'aws-sdk-core'
require 'aws-sdk-s3'

def log_rotation
  aws_client = Aws::S3::Client.new(region: 'us-gov-west-1')
  File.open('/home/nginx/app/log/production.log', 'rb') do |file|

    response = aws_client.put_object(body: file, bucket: ENV["DM_LOG_ROTATION_BUCKET"], key: "#{DateTime.now.strftime('%Y-%m-%d')}-production.log")
    puts response
    `> /home/nginx/app/log/production.log`
  rescue StandardError => e
    puts response
    puts "There was an error. #{e.message}"
  end
end

log_rotation