// Main Js
$(document).ready(function(){
	$(".verticalCenter").wrapInner('<div></div>');
	$("tr.tableSectionContent > td:first-child").addClass("leftestCell");
    $("tr.tableSectionContent > td:last-child").addClass("rightestCell");
});