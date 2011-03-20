$(document).ready(function(){
	// Home
	$("button").click(function(){
		window.location = "/"
	});

	// Get original input
	lines = $("pre.json").html().split("\n");
	// Add span
	formatted = ""
	for (i=0; i<lines.length; i++) {
		// Comment
		targetString = lines[i].match(/\/\/.*$/);
		resultString = lines[i].replace(/\/\/.*$/, "<span class=\"comment\">"+targetString+"</span>");
		formatted+=resultString+"\n"
	}
	// Write back
	$("pre.json").html(formatted);
});