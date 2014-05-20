class ImageUploader < CarrierWave::Uploader::Base

	include Cloudinary::CarrierWave

	process :convert => 'png'
	process :tags => ['post_image']
	process :resize_to_limit => [500, nil]

	version :standard do
		process :resize_to_fill => [100, 150, :north]
	end

	version :square do
		process :resize_to_fill => [400, 400]
	end

	version :thumbnail do
		resize_to_fill(200,200)
	end

	def extension_white_list
    %w(jpg png pdf)
  end

end