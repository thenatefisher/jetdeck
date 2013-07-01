(function ($) {
    var Email = function (options) {
        this.init('email', options, Email.defaults);
    };

    //inherit from Abstract input
    $.fn.editableutils.inherit(Email, $.fn.editabletypes.abstractinput);

    $.extend(Email.prototype, {
        /**
        Renders input from tpl

        @method render() 
        **/        
        render: function() {
            Email.superclass.render.call(this);
        },
        
        value2html: function(value, element) {
            if(!value) {
                $(element).empty();
                return; 
            }
            var html = $('<div>').text(value.email).html();
            $(element).html(html); 
        },
       
       /**
        Sets value of input.
        
        @method value2input(value) 
        @param {mixed} value
       **/         
       value2input: function(value) {
           this.$input.find('input[name="email"]').val(value.email);
           this.$input.find('input[name="email_confirmation"]').val(value.email_confirmation);
       },       
       
       /**
        Returns value of input.
        
        @method input2value() 
       **/          
       input2value: function() { 
           return {
              email: this.$input.find('input[name="email"]').val(),
              email_confirmation: this.$input.find('input[name="email_confirmation"]').val()
           };
       },        
       
        /**
        Activates input: sets focus on the first field.
        
        @method activate() 
       **/        
       activate: function() {
            this.$input.find('input[name="email"]').focus();
       },  
       
       /**
        Attaches handler to submit form in case of 'showbuttons=false' mode
        
        @method autosubmit() 
       **/       
       autosubmit: function() {
           this.$input.find('input[type="text"]').keydown(function (e) {
                if (e.which === 13) {
                    $(this).closest('form').submit();
                }
           });
       }       
    });

    Email.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults, {
        tpl: '<div><input type="text" placeholder="Email" name="email" class="input"></div><br> ' +
             '<div><input type="text" placeholder="Confirm Email" name="email_confirmation" class="input"></div>',
             
        inputclass: 'editable-email'
    });

    $.fn.editabletypes.email = Email;

}(window.jQuery));