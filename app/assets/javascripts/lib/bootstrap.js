// bootstrap.js
$("a[rel=popover]").popover()
$(".tooltip").tooltip()
$("a[rel=tooltip]").tooltip()

// jquery-placeholder for IE support
$(function() {$('input').placeholder();});