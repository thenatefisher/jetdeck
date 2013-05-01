$(function() {
    $("input").keyup(function(event){
        if(event.keyCode == 13){
            $("form").submit();
        }
    });
});