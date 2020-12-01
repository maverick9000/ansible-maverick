# encoding: utf-8
# Backup v5.x Configuration

Storage::S3.defaults do |s3|
  s3.access_key_id     = "{{s3.key}}"
  s3.secret_access_key = "{{s3.secret}}"
  s3.region             = "{{s3.region}}"
  s3.bucket             = "{{s3.bucket}}"
  s3.keep               = 5
end

Compressor::Gzip.defaults do |compression|
  compression.level = 1
end

Notifier::Mail.defaults do |mail|
  mail.from = "{{s3.mail_from}}"
  mail.to = "{{sysadmin_email}}"
  mail.address = "{{s3.mail_address}}"
  mail.port = "{{s3.mail_port}}"
  mail.authentication = "{{s3.mail_authentication}}"
  mail.domain = "{{s3.mail_domain}}"
  mail.on_success = true
  mail.on_failure = true
end
