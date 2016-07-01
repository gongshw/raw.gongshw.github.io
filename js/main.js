$(function() {
    var str = location.href.toLowerCase();
    $(".nav li a").each(function() {
        var link = this.href.toLowerCase();
        if (str == link) {
            $("li.active").removeClass("active");
            $(this).parent().addClass("active");
        }
    });

    $search = $('#search_text');
    $search.focus(function() {
        $search.animate({
            width: "190px",
            cursor: "auto",
            padding: "7px 11px 7px 28px"
        }, function(argument) {
            $search.click().val($search.val());
        })
    });

    $search.blur(function() {
        $search.animate({
            width: "0px",
            cursor: "pointer",
            padding: "7px 11px 7px 20px"
        })
    });

    $( ".highlighttable" ).animate({opacity:1}).wrap("<div class='highlighttable-wrap'></div>");
});
