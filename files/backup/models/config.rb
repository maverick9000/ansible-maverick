Model.new("{{dir_name}}_backup".to_sym, "{{dir_name}} directory backup") do
	split_into_chunks_of 5000000
	compress_with Gzip
	store_with S3
	archive :etc do |archive|
		archive.add "{{dir_location}}"
	end
end
