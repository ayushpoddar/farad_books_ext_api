class S3Upload

  # Upload any file
  # Need to pass the file
  # Optional arguments: bucket_name, filename, prefix
  # Returns JSON
  def self.upload(file, options = {})
    default_bucket_name = Rails.env.production? ? "farad-compressed" : "farad-compressed-dev"
    defaults = {bucket_name: default_bucket_name, filename: "#{SecureRandom.uuid}.#{file.type.downcase}", prefix: ""}
    options = defaults.merge options
    creds = Aws::Credentials.new(ENV['S3_ACCESS_KEY'], ENV['S3_SECRET_KEY'])
    s3 = Aws::S3::Resource.new(region: 'ap-south-1', credentials: creds)
    upload_key = Pathname.new(options[:prefix]).join(options[:filename]).to_s
    obj = s3.bucket(options[:bucket_name]).object(upload_key)
    if obj.upload_file(file.path, acl: "public-read", content_type: file.mime_type, cache_control: "max-age=#{6.months.to_i}")
      {
        status: "success",
        public_url: obj.public_url,
        original_file_size: options[:original_file_size],
        new_file_size: file.size,
        compression_ratio: ((1 - (file.size/options[:original_file_size].to_f))*100).round(2)
      }
    else
      {
        status: "failure",
        message: "Failed to upload to s3",
        retry: true
      }
    end
  end

end
