class Potepan::ProductsController < ApplicationController
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
  end

end
