class BookmarkletController < ApplicationController
  skip_before_filter :authorize

  # /b/:token
  def index
    @user = User.where(:bookmarklet_token => params[:token]).first
    render :layout => "bookmarklet", :chunked => true, :content_type => 'application/javascript' if @user
  end

end
