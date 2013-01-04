// field validation
$(function() {

    $('#beta').popover({
      animation: true,
      placement: "bottom",
      title: "JetDeck is a Beta!",
      content: "This means it's not a commercial product yet and may have a few bugs here and there. We appreciate your feedback when something isn't perfect. In exchange for any inconvenience, you get to use all the features of JetDeck for free while we keep making it better. Fair trade, right?"
    })   

  // set input fields from DOM
  var email_field = $("input[name='email']");
  var password_field = $("input[name='password']");
  var name_field = $("input[name='name']");
  var terms_check = $("input[type='checkbox']");
  
  // handle signup button click
  $("#signup").click(function() {
  
    $("input").trigger("blur");
    
    // reset checkbox error msgs
    terms_check.parents(".control-group").removeClass("error");
    terms_check.parents(".control-group").removeClass("success");  
    terms_check.siblings(".help-inline").html("");  
    
    // check for ToC and PrivPol checkbox
    if (!terms_check.is(":checked")) {
      terms_check.parents(".control-group").addClass("error");
      var suggestion_msg = "Please agree to the terms.";
      terms_check.parents(".control-group").find(".help-inline").html(suggestion_msg);
    }
    
    if ($(".error").size() == 0) $("form").submit();
    
  });
  
  
  // validate first and last name
  name_field.on('blur', function() {
  
    $(this).parents(".control-group").removeClass("error");
    $(this).parents(".control-group").removeClass("success");
    $(this).siblings(".help-inline").html(""); 
    
    if (!nameFormatValid($(this).val())) {

      $(this).parents(".control-group").addClass("error");
      var suggestion_msg = "Please enter a first and last name";
      $(this).siblings(".help-inline").html(suggestion_msg); 
      
    } else {
    
      // capitalize the names
      var capitalized = $(this).val().capitalize();
      $(this).val(capitalized);
      
      // extract first name
      var pattern = /^([^\s]*)/;
      var first_name = pattern.exec($(this).val())[1];
      
      // show success message
      $(this).parents(".control-group").addClass("success");
      var suggestion_msg = "Hi, " + first_name + "!";
      $(this).siblings(".help-inline").html(suggestion_msg);   
        
    } 
    
  });
  
  // validate password
  password_field.on('blur', function() {
  
    $(this).parents(".control-group").removeClass("error");
    $(this).parents(".control-group").removeClass("success");
    $(this).siblings(".help-inline").html(""); 
    
    if (!passwordFormatValid($(this).val())) {

      $(this).parents(".control-group").addClass("error");
      var suggestion_msg = "Your Password must be at least 6 characters long";
      $(this).siblings(".help-inline").html(suggestion_msg); 
      
    } else {
    
      $(this).parents(".control-group").addClass("success");
      var suggestion_msg = "Your secret is safe with me!";
      $(this).siblings(".help-inline").html(suggestion_msg);   
        
    } 
    
  });
    
  // setup mailcheck on the email field
  email_field.on('blur', function() {
    $(this).mailcheck({
    
      // when there is a suggestion...
      suggested: function(element, suggestion) {
      
        // if entry is available and passes simple regex
        if (emailEntryValid(email_field)) {
        
          // show suggestions
          var suggestion_msg;
          email_field.parents(".control-group").addClass("success");
          suggestion_msg = "Did you mean ";
          suggestion_msg += "<a href='#' id='mailcheck-suggestion'>" + suggestion.full + "</a>?";
          email_field.siblings(".help-inline").html(suggestion_msg);
        
        }
        
      },
      
      // when there is no suggestion...
      empty: function(element) {
      
        // if entry is available and passes simple regex
        if (emailEntryValid(email_field)) {
                
          // good to go!       
          email_field.parents(".control-group").addClass("success");
          var suggestion_msg = "Looks good!";
          email_field.siblings(".help-inline").html(suggestion_msg); 
        
        }      
          
      }
      
    });
    
  });

  // handle mailcheck suggestion link click
  $("form").on("click", "#mailcheck-suggestion", function() {
  
    // if entry is available and passes simple regex
    if (emailEntryValid(email_field)) {
      
      // set the email field to the suggestion
      var suggestion = $(this).html();
      email_field.val(suggestion);
      email_field.parents(".control-group").addClass("success");
      email_field.siblings(".help-inline").html("Looks good!"); 
    
    }
        
  });  
  
});

// check for email format validity and also availability
function emailEntryValid(email_field) {

  // clear all error/warning styles and messages
  email_field.parents(".control-group").removeClass("error");
  email_field.parents(".control-group").removeClass("success");
  email_field.siblings(".help-inline").html(""); 
  
  // simple regex for the very basics
  if (!emailFormatValid(email_field.val())) {

    email_field.parents(".control-group").addClass("error");
    var suggestion_msg = "This doesn't look right...";
    email_field.siblings(".help-inline").html(suggestion_msg); 
    return false;
    
  }
   
  // ensure entry is not already taken (deferred for later build)
  /*email_field.siblings(".help-inline").html("Checking Availability..."); 
  if (emailTaken(email_field.val())) {    
    
    email_field.parents(".control-group").addClass("error")
    var suggestion_msg = "Looks like you already have an account! <a href='/login'>Login</a>";
    email_field.siblings(".help-inline").html(suggestion_msg); 
    return false;
    
  }
  email_field.siblings(".help-inline").html("");*/
  
  return true;
  
}

// capitalize function from mediacollege.com
String.prototype.capitalize = function(){
   return this.replace( /(^|\s)([a-z])/g , function(m,p1,p2){ return p1+p2.toUpperCase(); } );
  };

// email validation regex
function emailFormatValid(input) { 
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(input);
} 

// name validation regex
function nameFormatValid(input) { 
    var re = /(\s)/;
    return re.test(input);
} 

// password validation regex
function passwordFormatValid(input) { 
    var re = /(.{6,})/;
    return re.test(input);
} 