require 'ostruct'
$config = OpenStruct.new(
    :image_dir => 'i',
    :image_max => 5*2**20,
    :storage_limit => 50*2**20
)
