Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'] || Jetdeck::Application.config.stripe_public_key,
  :secret_key      => ENV['STRIPE_SECRET_KEY'] || Jetdeck::Application.config.stripe_private_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]