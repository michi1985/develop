module ApplicationHelper
  include Spree::BaseHelper

  def show_variant_price(variant)
    format_with_comma(variant&.prices&.last&.amount&.to_i)
  end

  def format_with_comma(num) # 3桁ごとにカンマを入れて文字列を返す
    if num
      num.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
    else
      nil
    end
  end  
end
