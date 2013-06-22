class AirframeMessagesController < ApplicationController

  def sendgrid
  
  	logger = Rails.logger
	logger.info params.inspect
	render :nothing => true

  end



end
