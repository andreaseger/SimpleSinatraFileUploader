require 'env'
class Upload
  attr_accessor :org_filename

  def makeFilename
    if self.class.exists? org_filename
      m=org_filename.match /(.*)\.(.*)/
      "#{m[1]}_#{Time.now.to_i}.#{m[2]}"
    else
      org_filename
    end
  end

  def self.exists?(file)
    File.exists? "./public/#{$env.image_dir}/#{file}"
  end
end
