class PotepanController < ApplicationController
    include Spree::Core::ControllerHelpers::Pricing
    include Spree::Core::ControllerHelpers::Order
    include Spree::Core::ControllerHelpers::Auth
    include Spree::Core::ControllerHelpers::Store
    include Spree::Core::ControllerHelpers::StrongParameters
    include Spree::TaxonsHelper          # オススメ商品抽出用メソッドのため

    def index
      @new_arrivals = Spree::Product.order('id DESC').limit(5)
      @new_arrival_variants = @new_arrivals.map{|prd| prd.variants.first}        # とりあえず最初のバリアントのみ
      @new_arrival_images = @new_arrivals.map{ |prd| prd.display_image.attachment(:large) }
    end

end
