 image = MiniMagick::Image.open("atn.png")
 image_optim = ImageOptim.new(config_paths: "#{Rails.root}/config/image_optim.yml")
 image_type = image.type.downcase
 image_optim.optimize_image! image.path
 image.write("out.#{image_type}")
