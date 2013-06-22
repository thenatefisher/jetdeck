class AirframeMessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def sendgrid
  
  	logger = Rails.logger
	logger.info params.inspect
	render :nothing => true

  end

end
