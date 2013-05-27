(function ($) {
    var Password = function (options) {
        this.init('password', options, Password.defaults);
    };

    //inherit from Abstract input
    $.fn.editableutils.inherit(Password, $.fn.editabletypes.abstractinput);

    $.extend(Password.prototype, {
        /**
        Renders input from tpl

        @method render() 
        **/        
        render: function() {
            Password.superclass.render.call(this);
        },
        
              
       
       /**
        Sets value of input.
        
        @method value2input(value) 
        @param {mixed} value
       **/         
       value2input: function(value) {
           console.log(value);
           this.$input.find('input[name="password"]').val(value.password);
           this.$input.find('input[name="password_confirmation"]').val(value.password_confirmation);
       },       
       
       /**
        Returns value of input.
        
        @method input2value() 
       **/          
       input2value: function() { 
           return {
              password: this.$input.find('input[name="password"]').val(),
              password_confirmation: this.$input.find('input[name="password_confirmation"]').val()
           };
       },        
       
        /**
        Activates input: sets focus on the first field.
        
        @method activate() 
       **/        
       activate: function() {
            this.$input.find('input[name="password"]').focus();
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

    Password.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults, {
        tpl: '<div><input type="password" placeholder="Password" name="password" class="input"></div> ' +
             '<div><input type="password" placeholder="Confirm Password" name="password_confirmation" class="input"></div>',
             
        inputclass: 'editable-password'
    });

    $.fn.editabletypes.password = Password;

}(window.jQuery));