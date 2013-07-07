class ChargesController < ApplicationController
  before_filter :authorize, :sanitize_params

  def create

    begin
        customer = Stripe::Customer.create(
          :email => current_user.contact.email,
          :card  => params[:stripeToken],
          :plan  => params[:plan]
        )
        current_user.stripe_ud = customer.id
        render :json => customer, :status => :ok
    rescue => error
        render :json => ["Could not process payment", error.message], :status => :unprocessable_entity
    end

  end

end
