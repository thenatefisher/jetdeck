(function ($) {
    var NewDetailItem = function (options) {
        this.init('newdetailitem', options, NewDetailItem.defaults);
    };

    //inherit from Abstract input
    $.fn.editableutils.inherit(NewDetailItem, $.fn.editabletypes.abstractinput);

    $.extend(NewDetailItem.prototype, {
        /**
        Renders input from tpl

        @method render() 
        **/        
        render: function() {
            NewDetailItem.superclass.render.call(this);
        },
        
        /**
        Default method to show value in element. Can be overwritten by display option.
        
        @method value2html(value, element) 
        **/
        value2html: function(value, element) {
            if(!value) {
                $(element).empty();
                return; 
            }
            var html = $('<div>').text(value.label).html() + ', ' + $('<div>').text(value.value).html();
            $(element).html(html); 
        },
        
        /**
        Gets value from element's html
        
        @method html2value(html) 
        **/        
        html2value: function(html) {        
          /*
            you may write parsing method to get value by element's html
            e.g. "Moscow, st. Lenina, bld. 15" => {label: "Moscow", street: "Lenina", building: "15"}
            but for complex structures it's not recommended.
            Better set value directly via javascript, e.g. 
            editable({
                value: {
                    label: "Moscow", 
                    street: "Lenina", 
                    building: "15"
                }
            });
          */ 
          return null;  
        },
      
       /**
        Converts value to string. 
        It is used in internal comparing (not for sending to server).
        
        @method value2str(value)  
       **/
       value2str: function(value) {
           var str = '';
           if(value) {
               for(var k in value) {
                   str = str + k + ':' + value[k] + ';';  
               }
           }
           return str;
       }, 
       
       /*
        Converts string to value. Used for reading value from 'data-value' attribute.
        
        @method str2value(str)  
       */
       str2value: function(str) {
           /*
           this is mainly for parsing value defined in data-value attribute. 
           If you will always set value by javascript, no need to overwrite it
           */
           return str;
       },                
       
       /**
        Sets value of input.
        
        @method value2input(value) 
        @param {mixed} value
       **/         
       value2input: function(value) {
           this.$input.find('select[name="label"]').val(value.label);
           this.$input.find('input[name="value"]').val(value.value);
       },       
       
       /**
        Returns value of input.
        
        @method input2value() 
       **/          
       input2value: function() { 
           return {
              label: this.$input.find('select[name="label"]').val(), 
              value: this.$input.find('input[name="value"]').val()
           };
       },        
       
        /**
        Activates input: sets focus on the label field.
        
        @method activate() 
       **/        
       activate: function() {
            this.$input.find('select[name="label"]').focus();
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

    NewDetailItem.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults, {
        tpl: '<div><select name="label" id="new_item_label" class="input-small" style="width: 110px">\
                <option value="Title">Title</option>\
                <option value="Website">Website</option>\
                <option value="Nickname">Nickname</option>\
                <option value="Spouse">Spouse</option>\
                <option value="Assistant">Assistant</option>\
                <option value="Mobile">Mobile Phone</option>\
                <option value="Address">Address</option>\
                <option value="Birthday">Birthday</option>\
                <option value="Anniversary">Anniversary</option>\
                <option value="Email2">Email2</option>\
                <option value="Fax">Fax</option>\
              </select>&nbsp;' +
             '<input type="text" id="new_item_value_freetext" placeholder="Value" name="value_freetext" class="input"></div>',
             
        inputclass: 'editable-newdetailitem'
    });

    

    $.fn.editabletypes.newdetailitem = NewDetailItem;

}(window.jQuery));