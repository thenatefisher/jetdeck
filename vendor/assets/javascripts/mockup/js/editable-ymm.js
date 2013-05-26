(function ($) {
    var AircraftYMM = function (options) {
        this.init('aircraft_ymm', options, AircraftYMM.defaults);
    };

    //inherit from Abstract input
    $.fn.editableutils.inherit(AircraftYMM, $.fn.editabletypes.abstractinput);

    $.extend(AircraftYMM.prototype, {
        /**
        Renders input from tpl

        @method render() 
        **/        
        render: function() {
            AircraftYMM.superclass.render.call(this);
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
            var html = $('<div>').text(value.year).html() + ' ' + $('<div>').text(value.make).html() + ' ' + $('<div>').text(value.modelName).html();
            $(element).html(html); 
        },
        
        /**
        Gets value from element's html
        
        @method html2value(html) 
        **/        
        html2value: function(html) {        
          /*
            you may write parsing method to get value by element's html
            e.g. "Moscow, st. Lenina, bld. 15" => {first: "Moscow", street: "Lenina", building: "15"}
            but for complex structures it's not recommended.
            Better set value directly via javascript, e.g. 
            editable({
                value: {
                    first: "Moscow", 
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
           this.$input.find('input[name="year"]').val(value.year);
           this.$input.find('input[name="make"]').val(value.make);
           this.$input.find('input[name="modelName"]').val(value.modelName);
       },       
       
       /**
        Returns value of input.
        
        @method input2value() 
       **/          
       input2value: function() { 
           return {
              year: this.$input.find('input[name="year"]').val(), 
              make: this.$input.find('input[name="make"]').val(),
              modelName: this.$input.find('input[name="modelName"]').val()
           };
       },        
       
        /**
        Activates input: sets focus on the first field.
        
        @method activate() 
       **/        
       activate: function() {
            this.$input.find('input[name="year"]').focus();
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

    AircraftYMM.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults, {
        tpl: '<div><input type="text" placeholder="Year" name="year" class="input-mini"> '+
             '<input type="text" placeholder="Make" name="make" class="input-medium"> '+
             '<input type="text" placeholder="Model" name="modelName" class="input-medium"></div>',
             
        inputclass: 'editable-aircraft_ymm'
    });

    $.fn.editabletypes.aircraft_ymm = AircraftYMM;

}(window.jQuery));