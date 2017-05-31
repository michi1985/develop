class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :get_items_in_cart, if: :request_cart_info?

  private

    def get_items_in_cart
      order = current_order(create_order_if_necessary: false)  # 未オーダー時に呼ばれた場合の挙動を検討: オプションtrueでよいか?

      if order.present?
        @in_cart_items = order.line_items
        @in_cart_total_price = @in_cart_items.pluck(:price, :quantity).map{|a,b| (a || 0).to_i * (b || 0).to_i }.inject(&:+)
        @in_cart_item_images = @in_cart_items.map{ |item| item.product.display_image.attachment(:small) }
      end
    end

    def request_cart_info?
      /^\/potepan/ =~ request.path_info
    end
end
