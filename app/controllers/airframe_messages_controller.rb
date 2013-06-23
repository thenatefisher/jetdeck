class AirframeMessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def sendgrid
  
  	logger = Rails.logger
	logger.warn "From Sendgrid: #{params.inspect}"
	render :status => 200, :text => "test"

  end

end
