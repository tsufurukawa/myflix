CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Figaro.env.AWSAccessKeyID,
      :aws_secret_access_key  => Figaro.env.AWSSecretKey
    }
    config.fog_directory  = "Myflix/#{Rails.env}"
  else
    config.storage = :file # for development and test environments
    config.enable_processing = Rails.env.development? # no image processing in testing
  end
end