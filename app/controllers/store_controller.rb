class StoreController < ApplicationController
  allow_unauthenticated_access

  def index
    @products = Product.order(:title)
  end
end
