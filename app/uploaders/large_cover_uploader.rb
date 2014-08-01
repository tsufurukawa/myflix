class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Minimagick to process uploaded image
  process :resize_to_fill => [665, 375]

  # default directory where uploaded files are stored (not for production / staging)
  def store_dir
    Rails.env.test? ? "uploads/test" : "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # white-list of allowed extensions
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # fallback url in case no image has been uploaded
  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end
end
