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
  end

  def cart

  end

  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i

    # 2,147,483,647 is crazy. See issue https://github.com/spree/spree/issues/2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        order.contents.add(variant, quantity)
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(", ")
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.root_path)
    else
      respond_with(order) do |format|
        format.html { redirect_to cart_path }
    end
  end

end

end
