class XSpecMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "retailMailer"
  
  def sendRetail(xspec, contact)
    
    @contact = contact
    @url  = xspec.urlCode
    
    mail(:to => contact.email,
         :subject => "Spec For You") do |format|
      format.html 
      format.text
    end
    
  end
    
end
