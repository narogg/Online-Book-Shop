class StoreController < ApplicationController
  def index
    #@products = Product.all
	@products = Product.paginate(:page=>params[:page], :order=>'created_at desc' ,:per_page => 4)
	@cart = current_cart
  end
end
