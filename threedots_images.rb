#file threedots_images.rb
require 'dotenv'
Dotenv.load
require 'down'
require 'csv'
require 'fileutils'
require 'resque'
require 'sinatra'
require 'active_record'
require "sinatra/activerecord"
require_relative 'models/model'
require_relative 'background_helper'

module ThreeDots
    class ImageGetter
      def initialize
        Dotenv.load

      end

      def load_product_catalog
        ProductImageFile.delete_all
        # Now reset index
        ActiveRecord::Base.connection.reset_pk_sequence!('product_image_files')

        CSV.foreach('catalog_product_20190524_184017.csv', :encoding => 'ISO-8859-1', :headers => true) do |row|
            base_image = nil
            small_image = nil
            thumbnail_image = nil
            swatch_image = nil
            if row['base_image'] != 'no_selection' && row['base_image'] != nil && row['base_image'] != " "
                base_image = row['base_image']
            end
            if row['small_image'] != 'no_selection' && row['small_image'] != nil && row['small_image'] != " "
                small_image = row['small_image']
            end
            if row['thumbnail_image'] != 'no_selection' && row['thumbnail_image'] != nil  && row['thumbnail_image'] != " "
                thumbnail_image = row['thumbnail_image']
            end
            if row['swatch_image'] != 'no_selection' && row['swatch_image'] != nil  && row['swatch_image'] != " "
                swatch_image = row['swatch_image']
            end
            puts "#{row['sku']}, #{row['name']}"
            ProductImageFile.create(sku: row['sku'], name: row['name'], base_image: base_image, small_image: small_image, thumbnail_image: thumbnail_image, swatch_image: swatch_image)

        end
        puts "All done importing product catalog images"

      end

      def background_download_images
        params = { "action" => "download_images" }
        Resque.enqueue(DownloadImages, params)
  
      end

      class DownloadImages
        extend ResqueHelper
        @queue = "download_images"
        def self.perform(params)
          download_images(params)
        end
  
      end



      def read_product_catalog
        CSV.foreach('catalog_product_20190524_184017.csv', :encoding => 'ISO-8859-1', :headers => true) do |row|
            #base_image
            if row['base_image'] != 'no_selection' && row['base_image'] != nil && row['base_image'] != "nil" && row['base_image'] != " "
            puts row['base_image']
            myfile_name = row['base_image']
            matchdata = myfile_name.match(/\/...\//)
            response = FileUtils.mkdir_p("./#{matchdata}")
            puts response.inspect

            tempfile = Down.download("https://www.threedots.com/media/catalog/product/#{row['base_image']}")
            FileUtils.mv(tempfile.path, "./#{matchdata}#{tempfile.original_filename}")
            #puts row['small_image']
            #puts row['thumbnail_image']
            #puts row['swatch_image']
            end
            #small_image
            if row['small_image'] != 'no_selection' && row['small_image'] != nil && row['small_image'] != "nil" && row['small_image'] != " "
                puts row['small_image']
                myfile_name = row['small_image']
                matchdata = myfile_name.match(/\/...\//)
                response = FileUtils.mkdir_p("./#{matchdata}")
                puts response.inspect
    
                tempfile = Down.download("https://www.threedots.com/media/catalog/product/#{row['small_image']}")
                FileUtils.mv(tempfile.path, "./#{matchdata}#{tempfile.original_filename}")
            end
            #thumbnail_image
            if row['thumbnail_image'] != 'no_selection' && row['thumbnail_image'] != nil && row['thumbnail_image'] != "nil" && row['thumbnail_image'] != " "
                puts row['thumbnail_image']
                myfile_name = row['thumbnail_image']
                matchdata = myfile_name.match(/\/...\//)
                response = FileUtils.mkdir_p("./#{matchdata}")
                puts response.inspect
    
                tempfile = Down.download("https://www.threedots.com/media/catalog/product/#{row['thumbnail_image']}")
                FileUtils.mv(tempfile.path, "./#{matchdata}#{tempfile.original_filename}")
            end
            #swatch_image
            if row['swatch_image'] != 'no_selection' && row['swatch_image'] != nil && row['thumbnail_image'] != "nil" && row['swatch_image'] != " "
                puts row['swatch_image']
                myfile_name = row['swatch_image']
                matchdata = myfile_name.match(/\/...\//)
                response = FileUtils.mkdir_p("./#{matchdata}")
                puts response.inspect
    
                tempfile = Down.download("https://www.threedots.com/media/catalog/product/#{row['swatch_image']}")
                FileUtils.mv(tempfile.path, "./#{matchdata}#{tempfile.original_filename}")
            end


        end

       puts "All done downloading images"

      end


    end
end


        