require 'active_record'
#require 'sinatra'
require 'sinatra/activerecord/rake'
require 'resque/tasks'

require_relative 'threedots_images'

namespace :three_dots do
    desc 'read catalog'
    task :read_catalog do |t|
        ThreeDots::ImageGetter.new.read_product_catalog
    end
    
    desc 'import catalog'
    task :import_catalog do |t|
        ThreeDots::ImageGetter.new.load_product_catalog
    end

    desc 'background download images'
    task  :background_download do |t|
        ThreeDots::ImageGetter.new.background_download_images
    end


end