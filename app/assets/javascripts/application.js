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
///= require jquery_ujs
//= require jquery-ui.min
//= require twitter/bootstrap

//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require collection_book
//= require jetdeck

//= require jquery.multi-select
//= require jquery.quicksearch
//= require jquery.autoGrowInput

//= require uploader/jquery.ui.widget
//= require uploader/jquery.postmessage-transport
//= require uploader/jquery.xdr-transport
//= require uploader/load-image.min
//= require uploader/canvas-to-blob.min.js
//= require uploader/bootstrap-image-gallery.min
//= require uploader/jquery.iframe-transport
//= require uploader/tmpl.min
//= require uploader/jquery.fileupload
//= require uploader/jquery.fileupload-fp
//= require uploader/jquery.fileupload-ui
//= require uploader/locale

//= require_tree .


Number.prototype.formatMoney = function(c, d, t) {
	var n = this, c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "," : d, t = t == undefined ? "." : t, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
	return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

function modal(content) {
    if (content != "" && content != null) {
        $("#jetdeckModal").html(content);
        $("#jetdeckModal").modal();
    }
}

var alertSuccessTimeout;
function alertSuccess(content) {
    if (content != "" && content != null) {
        $("#jetdeck-notification div.notification-content").html(content)
        $("#jetdeck-notification").fadeIn('fast');
        alertSuccessTimeout = setTimeout("alertSuccessClose()", 2500);
    }
}

function alertSuccessClose() {
    $("#jetdeck-notification").fadeOut('fast');
}

function editInline(model, fname, value) {
    model.set(fname, value);
    model.save(null);
}

$(".dropdown-menu li").live('hover',
  function(e){
    if (e.type == 'mouseenter') {
      $("i", this).addClass("icon-white");
    } else {
      $("i", this).removeClass("icon-white");
    }
  } );

/*
$(function() {

    var results = [
        {
	        value: "Jeb Fisher",
	        label: "<i class=\"icon-user\"></i> Jeb Fisher",
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
	        value: "208B1245 (N14IS)",
	        label: "<i class=\"icon-plane\"></i> 208B1245 (N15IS)",
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

    $( ".jui-autocomplete" ).autocomplete({
        minLength: 2,
        source: results,
        select: function( event, ui ) {
	        $( ".jui-autocomplete" ).val( ui.item.value );
	        return false;
        }
    });

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
        if (e.type == 'mouseenter') {
          $(this).addClass('active');
          $("i", this).addClass("icon-white");
        } else {
          $(this).removeClass('active');
          $("i", this).removeClass("icon-white");
        }
      } );

});*/
