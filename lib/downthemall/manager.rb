require 'sequel'
require 'firefox'

module DownThemAll
  class Manager

    def initialize(options={})
      @download_path = options[:download_path] || File.expand_path('~/Downloads')
      @database_file = options[:database_file] || File.join(Firefox::Profile.path, "dta_queue.sqlite")
      @queue         = Sequel.sqlite(:database => @database_file)[:queue]
    end

    def queue(url, options={})
      options[:subpath]  ||= ''
      options[:filename] ||= File.basename(url)
      options[:referrer] ||= ''
      options[:position] ||= 0

      path_name = File.join(@download_path, options[:subpath])
      data =<<DATA
{"fileName":"#{ options[:filename] }","postData":null,"numIstance":13,"description":"","resumable":true,"mask":"*name*.*ext*","pathName":"#{ path_name }","compression":null,"maxChunks":4,"contentType":"","conflicts":0,"fromMetalink":false,"state":2,"referrer":"#{ options[:referrer] }","startDate":1278559024057,"urlManager":[{"url":"#{ url }","charset":"ISO-8859-1","preference":100}],"visitors":[],"totalSize":0,"chunks":[]}
DATA

      @queue << { :pos => options[:position], :item => data }
    end

  end
end

