//when the document is loaded, get all the teams from the Home Team column, add them to the selector
$(document).ready(function(){

$(".hide").click(function (event) {
  event.preventDefault();
  $(this).parent().slideUp();
});

$(".bubble").click(function (event) {
  event.preventDefault();
  $(this).parent().children(".mybubble").slideToggle();
});

//get all the teams from the home column 
var elementsArray = [];
$(".team").each(function(){
var str = $.trim($(this).text());
if(str.length > 1 && $.inArray(str, elementsArray) == -1)
elementsArray.push(str);
});
elementsArray.sort();
//use those teams to add them to the drop down 
$.each(elementsArray, function(index, value) {   
     $('#showTeam')
         .append($("<option></option>")
         .text(value)); 
     $('#showVsTeam')
         .append($("<option></option>")
         .text(value)); 
});
//add an event to the select drop down to filter rows out based on team selection
$("#showVsTeam").change(function (){
	displayGames();
})
$("#showTeam").change(function (){
	displayGames();
})

function displayGames() {
	var searchFor = $.trim($("#showTeam").val());
	var searchForVs = $.trim($("#showVsTeam").val());
	//only search for the team name forget about the (red & blue)
	searchFor = searchFor.replace(/(.*)(\(.*)/gi,"$1");
	searchForVs = searchForVs.replace(/(.*)(\(.*)/gi,"$1");
	var patt1 = new RegExp(searchFor);
	var patt2 = new RegExp(searchForVs);
	$("#games tr:gt(0)").hide();
	$("#games tr")
	.filter(function () {
	return patt1.test($(this).text()) && patt2.test($(this).text());
	}).show();
	
	////always show the playoff and friendly and final 
	//$("#games td:contains('Playoff')").parent().show();
	//$("#games td:contains('Friendly')").parent().show();
	//$("#games td:contains('Final')").parent().show();
}

});
