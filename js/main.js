$(document).ready(function () {
	var str = location.href.toLowerCase();
	$(".nav li a").each(function () {
		var link = this.href.toLowerCase();
		if (str == link) {
			$("li.active").removeClass("active");
			$(this).parent().addClass("active");
		}
	});
});
