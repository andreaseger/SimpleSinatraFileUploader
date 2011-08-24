require 'ostruct'
$env = OpenStruct.new(
        :image_dir => 'i',                     # relative to public/
        :imageMaxSize => 5*2**20,                 # Byte
        :filenameHandling => :compareAndRename    # IN [:discard ,:overwrite, :rename, :compareAndRename]
        #:redis_config => { :host => 'localhost', :port => 6379, :password => '', :db => 3 }
)
