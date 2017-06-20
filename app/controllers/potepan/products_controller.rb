class Potepan::ProductsController < ApplicationController

  include Spree::Core::ControllerHelpers::Pricing
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::StrongParameters
  include Spree::TaxonsHelper          # オススメ商品抽出用メソッドのため

  def index
      @products = if params[:category]
                      Spree::Product.with_taxons_name( params[:category] ).includes(:prices)
                   else
                      Spree::Product.all
                   end
      @product_images = @products.map{ |p| p.display_image.attachment(:large)}
      @product_categories = Spree::Taxon.categories_with_products.pluck(:name).map(&:upcase)
  end

  def show
      @single_product = Spree::Product.find(params[:id])
      @variants = @single_product
                  .variants_including_master
                  .display_includes
                  .with_prices(current_pricing_options)
                  .includes([:option_values, :images])
      @product_image = @product.display_image.attachment(:large)

      if related_group.present?
        all_recommended_products =  related_group.map{|t| taxon_preview(t,2).to_a }.flatten.uniq
        @recommended_products =  all_recommended_products - [@product]   # taxonに関連したプロダクトを拾ってオススメとする(自分自身を除く)

        @recommended_product_variants = @recommended_products.map{|prd| prd.variants.first }         # とりあえず最初のバリアントのみ
        @recommended_product_images = @recommended_products.map{|prd| prd.display_image.attachment(:large)}
      else

        @recommended_products =  @recommended_product_variants = nil
        @recommended_product_images = nil
    end
  end

end
