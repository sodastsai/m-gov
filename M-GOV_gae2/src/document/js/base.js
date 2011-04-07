$(document).ready(function(){
	$("tr.tableContent:odd").addClass("odd");
	$("button").hover(function(){
		$(this).addClass("hover");
	}, function(){
		$(this).removeClass("hover");
	});
});