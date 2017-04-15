class Potepan::ProductsController < ApplicationController
    def index
        @products = Spree::Product.all
        @prototypes = Spree::Prototype.all
    end
    def show
        @single_product = Spree::Product.find(params[:id])
    end
end
