json.(@user, :id, :activated, :storage_usage, :airframes_quota, :help_enabled)
json.storage_quota @user.storage_quota * 1048576
json.contact (@user.contact)
json.airframes @user.airframes.count
json.contacts @user.contacts.count
json.leads @user.airframes.reduce(0) { |s,v| s += v.leads.count }
json.signature h @user.signature
json.plan "Trial"
json.standard_plan_available @user.standard_plan_available
json.trial_time_remaining @user.trial_time_remaining

if @user.stripe.present?
    json.charges @user.stripe.charges do |x|
        json.created DateTime.strptime(x.created.to_s, "%s").to_formatted_s(:long_ordinal) rescue nil
        json.amount number_to_currency(x.amount/100) rescue nil
        json.paid (x.paid) ? "Approved" : "Failed" 
    end
    json.balance number_to_currency(@user.stripe.account_balance.to_i) rescue nil
    json.plan (@user.plan.present?) ? @user.plan : "Trial"
    json.card "#{@user.stripe.active_card.type} ...#{@user.stripe.active_card.last4}" rescue nil
    json.scheduled_amount number_to_currency(@user.stripe.subscription.plan.amount/100) rescue nil
    json.scheduled_date DateTime.strptime(@user.stripe.subscription.current_period_end.to_s, "%s").to_formatted_s(:short) rescue nil
end

json.stripe_key Rails.configuration.stripe[:publishable_key]
