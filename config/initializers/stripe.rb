Rails.configuration.stripe = {
  :publishable_key => "***REMOVED***", #ENV['PUBLISHABLE_KEY'],
  :secret_key      => "***REMOVED***" #ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]