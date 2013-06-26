(function ($) {
    var NewAircraftItem = function (options) {
        this.init('newaircraftitem', options, NewAircraftItem.defaults);
    };

    //inherit from Abstract input
    $.fn.editableutils.inherit(NewAircraftItem, $.fn.editabletypes.abstractinput);

    $.extend(NewAircraftItem.prototype, {
        /**
        Renders input from tpl

        @method render() 
        **/        
        render: function() {
            NewAircraftItem.superclass.render.call(this);
            $(this.$input[0]).find(".value_aircraft").autocomplete({
               minLength: 2,
               autofocus: true,
               focus: function (event, ui) {
                  $(".value_aircraft").val(ui.item.value)
                  event.preventDefault(); 
                },
               source: [
                 "2007 King Air B200GT (N3243GH)", 
                 "2001 Gulfstream G550 (N324KK)", 
                 "1999 Pilatus PC-12 (N324P)", 
                 "2005 Grand Caravan (N32PG)"
               ],
               select: function ( event, ui ) {
                  $(".value_aircraft").val(ui.item.value)
                  return false
                }
            })
            .data("autocomplete")._renderItem = function( ul, item ) {
               ul.addClass("dropdown-menu");
               ul.addClass("typeahead");
               return $( "<li class=\"result\" style=\"cursor: pointer\"></li>" )
                  .data( "item.autocomplete", item )
                  .append( "<a>" + item.value + "</a>" )
                  .appendTo( ul );
                }
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

    NewAircraftItem.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults, {
        tpl: '<div><select name="label" id="label_aircraft" class="input-small" style="width: 110px">\
                <option value="Pilot">Pilot Of</option>\
                <option value="Owner">Owner Of</option>\
                <option value="Operator">Operator Of</option>\
                <option value="Broker">Broker Of</option>\
              </select>&nbsp;' +
             '<input type="text" class="value_aircraft" name="value" style="width:250px">',
             
        inputclass: 'editable-newaircraftitem'
    });

    $.fn.editabletypes.newaircraftitem = NewAircraftItem;

}(window.jQuery));