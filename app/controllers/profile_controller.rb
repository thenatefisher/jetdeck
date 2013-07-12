class ProfileController < ApplicationController
  before_filter :authorize, :sanitize_params

  def index
    @user = @current_user
  end

  def resendActivation
    # send activation email
    UserMailer.activation(@current_user).deliver
    render :json => @current_user
  end

  def update

    errors = Hash.new()

    if params[:profile][:contact]

      if params[:profile][:signature].present?
        @current_user.signature = params[:profile][:signature]
        @current_user.save
      end

      if params[:profile][:contact][:password_confirmation].present?

        @current_user.update_attributes(
        params[:profile][:contact].slice(:password,:password_confirmation))

        if @current_user.errors.count > 0
          errors.merge! @current_user.errors.full_messages
        end

      end

      contact_whitelist = params[:profile][:contact].slice(
        :email,
        :email_confirmation,
        :first,
        :last,
        :phone,
        :website,
        :title,
      :company)

      @current_user.contact.update_attributes(contact_whitelist)

      if errors.count > 0 || @current_user.contact.errors.count > 0
        errors.merge! @current_user.contact.errors.full_messages
        render :json => errors,
          :status => :unprocessable_entity
      else
        render :json => @current_user.contact
      end

    end

  end

  def destroy

    # cancel stripe plan
    begin
      customer_stripe = @current_user.stripe
      customer_stripe.cancel_subscription if customer_stripe.present?
    rescue
    end
    # destroy user record
    @current_user.destroy
    # confirm
    render :json => "OK", :status => :ok

  end

end
