class Potepan::OrdersController < ApplicationController

  include Spree::Core::ControllerHelpers::Pricing
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::StrongParameters

  def show
    @order = current_order(create_order_if_necessary: true)  # 未オーダー時に呼ばれた場合の挙動を検討: オプションtrueでよいか?
    items = @order.line_items

    @total_price = items.pluck(:price, :quantity).map{|a,b| (a || 0).to_i * (b || 0).to_i }.inject(&:+)
    @total_tax = @total_price && (@total_price * 0.08).to_i   # [todo] 税金はSolidusの機能を使って汎用化･国際化する
    @grand_total_price = @total_price && (@total_price + @total_tax)
  end

  def update
    @order = current_order(create_order_if_necessary: false)  # 未オーダー時に呼ばれた場合の挙動を検討: オプションtrueでよいか?

    if @order.contents.update_cart(order_params)
      if params.key?(:checkout)
        @order.next if @order.cart?
        redirect_to checkout_state_path(@order.checkout_steps.first)
      else
        redirect_to action: :show
      end
    else
      redirect_to action: :show   # カートのupdateに失敗した場合はリロードとする
    end
  end

  def edit
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
      redirect_to potepan_cart_path
    end
  end

  def remove_item
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = order.line_items.find_by(variant_id: variant).quantity

    begin
      order.contents.remove(variant, quantity)
    rescue ActiveRecord::RecordInvalid => e
      error = e.record.errors.full_messages.join(", ")
    end

    if error
      flash[:error] = error
      redirect_back_or_default(potepan_index_path)
    else
      redirect_to potepan_order_path(order.id)
    end
  end

  private

  def order_params
    if params[:order]
      params[:order].permit(*permitted_order_attributes)
    else
      {}
    end
  end

end
