// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone/jetdeck
//= require_tree .

$(function() {
    var results = [
        {
	        value: "Nate Fisher",
	        label: "<i class=\"icon-user\"></i> Nate Fisher",
	        desc: "Owner, Five Stories Enterprises, Inc.",
	        icon: "jquery_32x32.png"
        },
        {
	        value: "Jeff Smith",
	        label: "<i class=\"icon-user\"></i> Jeff Smith",
	        desc: "Chief Pilot, AT&T Inc.",
	        icon: "jqueryui_32x32.png"
        },
        {
	        value: "Blake Fisher",
	        label: "<i class=\"icon-user\"></i> Blake Fisher",
	        desc: "Chief Pilot, Red Hat Inc.",
	        icon: "jqueryui_32x32.png"
        },
        {
	        value: "Corey Smith",
	        label: "<i class=\"icon-user\"></i> Corey Smith",
	        desc: "COO, Albatross Ltd",
	        icon: "jqueryui_32x32.png"
        },
        {
	        value: "Ryan Towns",
	        label: "<i class=\"icon-user\"></i> Ryan Towns",
	        desc: "Owner, Kleiner Holdings",
	        icon: "jqueryui_32x32.png"
        },
        {
	        value: "208B2310 (N123TU)",
	        label: "<i class=\"icon-plane\"></i> 208B2310 (N123TU)",
	        desc: "1996 Cessna Grand Caravan ",
	        icon: "sizzlejs_32x32.png"
        },
        {
	        value: "208B1285 (PV-1123)",
	        label: "<i class=\"icon-plane\"></i> 208B1285 (PV-1123)",
	        desc: "1995 Cessna Grand Caravan ",
	        icon: "sizzlejs_32x32.png"
        },
        {
	        value: "208B1245 (N14G)",
	        label: "<i class=\"icon-plane\"></i> 208B1245 (N15G)",
	        desc: "2010 Cessna Grand Caravan ",
	        icon: "sizzlejs_32x32.png"
        },
        {
	        value: "208B8567 (N33G)",
	        label: "<i class=\"icon-plane\"></i> 208B8567 (N33G)",
	        desc: "2003 Cessna Grand Caravan ",
	        icon: "sizzlejs_32x32.png"
        },
        {
	        value: "208B223 (N143HG)",
	        label: "<i class=\"icon-plane\"></i> 208B223 (N143HG)",
	        desc: "2006 Cessna Grand Caravan ",
	        icon: "sizzlejs_32x32.png"
        }
    ];
/*
    $( ".jui-autocomplete" ).autocomplete({
        minLength: 2,
        source: results,
        select: function( event, ui ) {
	        $( ".jui-autocomplete" ).val( ui.item.value );
	        return false;
        }
    })
    .data( "autocomplete" )._renderItem = function( ul, item ) {
      ul.addClass('dropdown-menu');
      ul.addClass('typeahead');
        return $( "<li class='result' style='cursor: pointer'></li>" )
	        .data( "item.autocomplete", item )
	        .append( "<a><strong>" + item.label + "</strong><br>" + item.desc + "</a>" )
	        .appendTo( ul );
    };

    $(".result").live('hover',
      function(e){
        if (e.type == 'mouseenter')
          $(this).addClass('active');
        else
          $(this).removeClass('active');
      } );
*/
});


