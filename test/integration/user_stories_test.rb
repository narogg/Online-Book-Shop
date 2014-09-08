require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  
  # Agile Development with Rails, p. 207
  
  # User story is:
  # A user goes to the store index page. They select a product, adding it to their
  # cart. They then check out, filling in their details on the checkout form. When they
  # submit, an order is created in the database containing their information, along
  # with a single line item corresponding to the product they added to their cart.
  # Once the order has been received, an e-mail is sent confirming their purchase.
  
  fixtures :products
    
  # By the end of the test, we know we’ll want to have added an order to the orders
  # table and a line item to the line_items table, so let’s empty them out before we
  # start. And, because we’ll be using the Ruby book fixture data a lot, let’s load it
  # into a local variable:
  LineItem.delete_all
  Order.delete_all
  ruby_book = products(:ruby)
  
  # Let’s attack the first sentence in the user story: A user goes to the store index
  # page.
  get "/"
  assert_response :success
  assert_template "index"
  
  
  # The next sentence in the story goes They select a product, adding it to their cart.
  # We know that our application uses an Ajax request to add things to the cart,
  # so we’ll use the xml_http_request method to invoke the action. When it returns,
  # we’ll check that the cart now contains the requested product:
  xml_http_request :post, '/line_items' , :product_id => ruby_book.id
  assert_response :success
  cart = Cart.find(session[:cart_id])
  assert_equal 1, cart.line_items.size
  assert_equal ruby_book, cart.line_items[0].product
  
  
  # In a thrilling plot twist, the user story continues, They then check out.... That’s
  # easy in our test:
  get "/orders/new"
  assert_response :success
  assert_template "new"
  
  
  # At this point, the user has to fill in their details on the checkout form. Once
  # they do and they post the data, our application creates the order and redirects
  # to the index page. Let’s start with the HTTP side of the world by posting
  # the form data to the save_order action and verifying we’ve been redirected
  # to the index. We’ll also check that the cart is now empty. The test helper
  # method post_via_redirect generates the post request and then follows any redirects
  # returned until a nonredirect response is returned.
  post_via_redirect "/orders" ,
  :order => { :name => "Dave Thomas" ,
  :address => "123 The Street" ,
  :email => "dave@example.com" ,
  :pay_type => "Check" }
  assert_response :success
  assert_template "index"
  cart = Cart.find(session[:cart_id])
  assert_equal 0, cart.line_items.size
  
  
  # Finally, we’ll wander into the database and make sure we’ve created an order
  # and corresponding line item and that the details they contain are correct.
  # Because we cleared out the orders table at the start of the test, we’ll simply
  # verify that it now contains just our new order:  
  orders = Order.find(:all)
  assert_equal 1, orders.size
  order = orders[0]
  assert_equal "Dave Thomas" , order.name
  assert_equal "123 The Street" , order.address
  assert_equal "dave@example.com" , order.email
  assert_equal "Check" , order.pay_type
  assert_equal 1, order.line_items.size
  line_item = order.line_items[0]
  assert_equal ruby_book, line_item.product
  
  
end
