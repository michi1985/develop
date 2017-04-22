class Potepan::ProductsController < ApplicationController

    include Spree::Core::ControllerHelpers::Order
    include Spree::Core::ControllerHelpers::Auth
    include Spree::Core::ControllerHelpers::Store

  def index
     if params[:category]
      @products = Spree::Product.with_taxons_name( params[:category] ).includes(:prices)
     else
       @products = Spree::Product.all
     end
       @product_images = @products.map{ |p| p.display_image.attachment(:large)}
       @product_categories = Spree::Taxon.categories_with_products.pluck(:name).map(&:upcase)
  end

  def show
      @single_product = Spree::Product.find(params[:id])
binding.pry
      @variants = @single_product
                  .variants_including_master
                  .display_includes
                  .with_prices(current_pricing_options)
                  .includes([:option_values, :images])
  end

  def cart

  end

end
