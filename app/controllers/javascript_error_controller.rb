class JavascriptErrorController < ApplicationController

  def javascript_error
    # post the error to newrelic.
    # You could also send an email, notify hipchat, whatever.
    NewRelic::Agent.notice_error("Javascript error: #{params[:error]}", {:uri => params[:location], :params => params})
    head :ok
  end
end