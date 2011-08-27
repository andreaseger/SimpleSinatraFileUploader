class Upload
  attr_accessor :org_filename

  def params=(p)
    self.org_filename = p[:filename]
  end
  def filename
    @filename ||= makeFilename
  end
  def link
    @link ||= "#{$config.image_dir}/#{filename}"
  end

  def makeFilename
    if self.class.exists? org_filename
      m=org_filename.match /(.*)\.(.*)/
      "#{m[1]}_#{Time.now.to_i}.#{m[2]}"
    else
      org_filename
    end
  end

  def self.exists?(file)
    File.exists? "./public/#{$config.image_dir}/#{file}"
  end
  def self.filelist
    Dir.glob("public/#{$config.image_dir}/*.*").map{|f| f.split('/').last}
  end
end
