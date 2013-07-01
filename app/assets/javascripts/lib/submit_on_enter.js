$(function() {
    $("input.submit-on-enter").keyup(function(event){
        if(event.keyCode == 13){
            $("form").submit();
        }
    });
});
