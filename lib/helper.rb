module Sinatra
  module MyHelper
    include Rack::Utils
    alias_method :h, :escape_html

    def section(key, *args, &block)
      @sections ||= Hash.new{ |k,v| k[v] = [] }
      if block_given?
        @sections[key] << block
      else
        @sections[key].inject(''){ |content, block| content << block.call(*args) } if @sections.keys.include?(key)
      end
    end

    def title(page_title, show_title = true)
      section(:title) { page_title.to_s }
      @show_title = show_title
    end

    def javascript(file)
      section(:js) { haml "%script{:src=>'#{file}'}" }
    end

    def show_title?
      @show_title
    end

    def cache_page(seconds=5*60)
      response['Cache-Control'] = "public, max-age=#{seconds}" unless Sinatra::Base.development?
    end
  end
end
