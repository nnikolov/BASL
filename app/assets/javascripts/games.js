//when the document is loaded, get all the teams from the Home Team column, add them to the selector
$(document).ready(function(){
//get all the teams from the home column 
var elementsArray = [];
$("tr td:nth-child(4)").each(function(){
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
});
//add an event to the select drop down to filter rows out based on team selection
$("#showTeam").change(function () {
        var searchFor = $.trim($(this).val());
//only search for the team name forget about the (red & blue)
searchFor = searchFor.replace(/(.*)(\(.*)/gi,"$1");
$("#games tr:gt(0)").hide();
if(searchFor != "All Teams"){
$("#games td:contains('" + searchFor + "')").parent().show();
}
else
{
$("#games tr").show();
}
//always show the playoff and friendly and final 
$("#games td:contains('Playoff')").parent().show();
$("#games td:contains('Friendly')").parent().show();
$("#games td:contains('Final')").parent().show();
    })
});
