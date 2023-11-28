class Product < ApplicationRecord
    has_many_attached :images
    validates :name, presence:true, uniqueness:true
    validates :description,presence:true
    validates :price,presence:true

    validate :image_type, if: :images_attached?

    def image_urls
     images.map {|image| Rails.application.routes.url_helpers.url_for(image)}
    end

    def images_attached?
        images.attached?
    end

    def image_type
        #check image for creating types = png/jpeg/.jpg
        #add error messages
        images.each do |image|
            if !image.content_type.in?(["image/png","image/jpeg","image/gif"])
                errors.add(:images,'must be a JPEG or PNG or GIF' )
            end
        end
    end

end
