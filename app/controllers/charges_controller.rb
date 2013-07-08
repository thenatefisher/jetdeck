class ChargesController < ApplicationController
  before_filter :authorize, :sanitize_params

  def create

    if params[:plan].present?
      begin
          customer_stripe = current_user.stripe rescue nil
          if customer_stripe.blank?
            customer = Stripe::Customer.create(
              :email => current_user.contact.email,
              :card  => params[:stripeToken],
              :plan  => params[:plan]
            )
            current_user.stripe_id = customer.id
          else
            customer_stripe.card = params[:stripeToken] if params[:stripeToken].present?
            customer_stripe.save
            customer_stripe.update_subscription(:plan => params[:plan])
          end
          current_user.update_account_quotas
          current_user.save!
      rescue => error
          flash[:notice] = "Could not process payment: #{error.message}"
      end
    else
      # just add/update CC info
      begin
          customer_stripe = current_user.stripe rescue nil
          if customer_stripe.blank? 
            customer = Stripe::Customer.create(
              :email => current_user.contact.email,
              :card  => params[:stripeToken]
            )
            current_user.stripe_id = customer.id
            current_user.update_account_quotas
            current_user.save!
          else
            customer_stripe.card = params[:stripeToken]
            customer_stripe.save
          end
      rescue => error
          flash[:notice] = "Could not update card: #{error.message}" 
      end
    end

    redirect_to "/profile"

  end

end
