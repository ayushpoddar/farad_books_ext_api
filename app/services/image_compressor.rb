class ImageCompressor

  def self.compress_from_url(url, options = {})
    return { status: "failure", message: "Invalid URL" } unless GenericMethods.valid_url?(url)
    content_type = GenericMethods.get_size_and_content_type_of_url_file(url)[:content_type]
    return { status: "failure", message: "This URL does not contain an image. Please choose another file." } unless content_type.starts_with?("image")
    image = nil
    begin
      image = MiniMagick::Image.open(url)
    rescue => e
      return { status: "failure", message: "This URL does not contain an image. Please choose another file." }
    end
    original_file_size = image.size
    resize_to_limit image, options
    image_optim = ImageOptim.new(config_paths: "#{Rails.root}/config/image_optim.yml")
    image_optim.optimize_image! image.path
    S3Upload.upload image, options.merge({original_file_size: original_file_size})
  end

  # Resize image to limit
  # Pass image as argument
  # Pass max_width and max_height as optional arguments.
  # Defaults: max_width: 600, max_height: 600
  def self.resize_to_limit(image, options = {})
    defaults = {max_width: 600, max_height: 600}
    options = defaults.merge options
    puts options
    max_width = options[:max_width].to_i
    max_height = options[:max_height].to_i
    width = image.width.to_i
    height = image.height.to_i
    if width > max_width
      height *= (max_width / width.to_f)
      width = max_width
    end
    if height > max_height
      width *= (max_height / height.to_f)
      height = max_height
    end
    image.resize "#{width}x#{height}"
  end

end
