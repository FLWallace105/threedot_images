require 'active_support/core_ext'
require 'sinatra/activerecord'
require 'down'
require 'fileutils'

require_relative 'models/model'


Dotenv.load

module ResqueHelper

    def download_images(params)
        puts params.inspect

        my_product_images = ProductImageFile.where("is_downloaded = ?", false)
        my_product_images.each do |myprod|
            puts myprod.inspect

            if !myprod.base_image.nil?
                matchdata = myprod.base_image.match(/\/...\//)
                response = FileUtils.mkdir_p("./#{matchdata}")
                tempfile = Down.download("https://www.threedots.com/media/catalog/product/#{myprod.base_image}")
                FileUtils.mv(tempfile.path, "./#{matchdata}#{tempfile.original_filename}")
            end
            if !myprod.small_image.nil?
                matchdata = myprod.small_image.match(/\/...\//)
                response = FileUtils.mkdir_p("./#{matchdata}")
                tempfile = Down.download("https://www.threedots.com/media/catalog/product/#{myprod.small_image}")
                FileUtils.mv(tempfile.path, "./#{matchdata}#{tempfile.original_filename}")
            end
            if !myprod.thumbnail_image.nil?
                matchdata = myprod.thumbnail_image.match(/\/...\//)
                response = FileUtils.mkdir_p("./#{matchdata}")
                tempfile = Down.download("https://www.threedots.com/media/catalog/product/#{myprod.thumbnail_image}")
                FileUtils.mv(tempfile.path, "./#{matchdata}#{tempfile.original_filename}")
            end
            if !myprod.swatch_image.nil?
                matchdata = myprod.swatch_image.match(/\/...\//)
                response = FileUtils.mkdir_p("./#{matchdata}")
                tempfile = Down.download("https://www.threedots.com/media/catalog/product/#{myprod.swatch_image}")
                FileUtils.mv(tempfile.path, "./#{matchdata}#{tempfile.original_filename}")
            end
            myprod.is_downloaded = true
            time_updated = DateTime.now
            time_updated_str = time_updated.strftime("%Y-%m-%d %H:%M:%S")
            myprod.downloaded_at = time_updated_str
            myprod.save




        end
        puts "All done with downloading images from Threedots!"
    end



end