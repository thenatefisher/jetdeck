class BookmarkletController < ApplicationController

	skip_before_filter :authorize

	def index
		@user = User.find_by_bookmarklet_token(params[:token])
		render :layout => "bookmarklet", :chunked => true, :content_type => 'application/javascript' if @user
	end

end