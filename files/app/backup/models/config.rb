Model.new("{{app.name}}_{{app.environment}}_psql_backup", "{{app.name}} {{app.environment}} PostgreSQL backup") do
  split_into_chunks_of 5000000
  compress_with Gzip
  store_with S3
	db_name = "{{app.name}}_{{app.environment}}"
	database PostgreSQL, db_name.to_s do |db|
		db.name = db_name.to_s
		db.username           = "{{app.name}}_{{app.environment}}"
		db.password           = "{{database_password}}"
		db.socket             = "/var/run/postgresql"
	end
end

Model.new("{{app.name}}_{{app.environment}}_directory_backup".to_sym, "{{app.name}} {{app.environment}} project configuration directory backup") do
	split_into_chunks_of 5000000
	compress_with Gzip
	store_with S3
	archive :www do |archive|
		archive.add "/var/www/{{app.environment}}/{{app.name}}/shared/config"
	end
end
