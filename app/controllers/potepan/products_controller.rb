class Potepan::ProductsController < ApplicationController
    def index
        @products = Spree::Product.all
    end
    def show
        @single_product = Spree::Product.find(params[:id])
    end
end
