$(document).ready(function () {
	var str = location.href.toLowerCase();
	$(".nav li a").each(function () {
		var link = this.href.toLowerCase();
		if (str == link) {
			$("li.active").removeClass("active");
			$(this).parent().addClass("active");
		}
	});


	$('#calendar_widget').fullCalendar(
		{
			header: {
				left: '',
				center: 'title',
				right: ''
			},
			monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月',
				'八月', '九月', '十月', '十一月', '十二月'
			],
			dayNamesShort: ['日', '一', '二', '三', '四',
				'五', '六']
		}
	);

});
