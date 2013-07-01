var jetdeck_$ = jQuery.noConflict(true);

function show_jetdeck() {

	// container
	jetdeck_container = (jetdeck_$("div#jetdeck").length > 0) ? jetdeck_$("div#jetdeck") : jetdeck_$("<div id='jetdeck'></div>").appendTo("body");

	// backbone setup
	window.Jetdeck.router = new Jetdeck.Routers.BookmarkletRouter();
	window.Jetdeck.router.index();
	
	// init position
	jetdeck_$("div#jetdeck").css('top', '-300px');
	jetdeck_$("div#jetdeck").animate({top: '10px'}, 500);
   
   	// auto close
    window.jetdeck_timeout = setTimeout('close_jetdeck()', 7000);
   	jetdeck_$("div#jetdeck").hover(function(){
   		clearTimeout(window.jetdeck_timeout);
   	});

}

function close_jetdeck() {

	clearTimeout(window.jetdeck_timeout);

	jetdeck_$("div#jetdeck").animate({top: '-300px'}, 1000);
 
}
