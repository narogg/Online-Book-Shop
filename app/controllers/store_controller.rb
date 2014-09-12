class StoreController < ApplicationController
  #def index
  #  #@products = Product.all
  #  @products = Product.paginate(:page=>params[:page], :order=>'created_at desc' ,:per_page => 4)
  #	 @cart = current_cart
  #end
  
  
  #def search
  #  q = params[:title]
  #  @products = Product.find(:all, :conditions => ["title LIKE %?%",q])
  #end
  
  # Index method with a search function 
  def index
  @cart = current_cart
  flash[:notice] = nil
  flash[:alert]  = nil
	
	# check if this is search and if search string is not empty
    if !params[:search].blank?
	@productSearched = Product.search(params[:search]).paginate(:page=>params[:page], :order=>'created_at desc' ,:per_page => 4)
	  
	  if (@productSearched.present?)  then      
	    @products = @productSearched
		flash[:notice] = "Your search results are below"		
      else
	    @products = Product.paginate(:page=>params[:page], :order=>'created_at desc' ,:per_page => 4)
		flash[:alert] = "No results for your search"		
	  end
	
	# if it's not search get all products
	else
	  @products = Product.paginate(:page=>params[:page], :order=>'created_at desc' ,:per_page => 4)
    end
  end
  
  
end
