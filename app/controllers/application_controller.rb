class ApplicationController < ActionController::Base
  before_filter :authorize
  
  
  protect_from_forgery

	private

	def current_cart
		Cart.find(session[:cart_id])
	rescue
		cart = Cart.create
		session[:cart_id] = cart.id
		cart
	end	
	
	protected
	
	def authorize
		if request.format == Mime::HTML
			unless User.find_by_id(session[:user_id])
				redirect_to login_url, :notice => "Please log in"
			end
		else
			authenticate_or_request_with_http_basic do |username, password|
				user = User.authenticate(username, password)
		end
	end
end
