var BREWERIES = {};

BREWERIES.show = function(){
    $("#brewerytable tr:gt(0)").remove();

    var table = $("#brewerytable");

    $.each(BREWERIES.list, function(index, brewery){
        var retired = "Active";
        if (brewery['active'] == false){
            retired = "Retired"
        }

        table.append('<tr>'
        + '<td>' + brewery['name']+'</td>'
        + '<td>' + brewery['year']+'</td>'
        + '<td>' + brewery['beer_amount']+'</td>'
        + '<td>' + retired+'</td>');
    });
};

BREWERIES.sort_by_name = function() {
  BREWERIES.list.sort( function(a,b){
      return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BREWERIES.sort_by_year = function(){
  BREWERIES.list.sort( function(a,b) {
      return a.year - b.year
  });
};

BREWERIES.sort_by_amount_of_beers = function(){
    BREWERIES.list.sort( function(a,b){
       return b.beer_amount - a.beer_amount;
    });
};

$(document).ready(function () {
    if( $("#brewerytable").length>0) {

        $("#name").click(function(e) {
            BREWERIES.sort_by_name();
            BREWERIES.show();
            e.preventDefault();
        });

        $("#year").click(function(e) {
           BREWERIES.sort_by_year();
           BREWERIES.show();
           e.preventDefault();
        });

        $("#beercount").click(function(e){
            BREWERIES.sort_by_amount_of_beers();
            BREWERIES.show();
            e.preventDefault();
        })

        $.getJSON('breweries.json', function (breweries) {
            BREWERIES.list = breweries;
            BREWERIES.show();
        });
    };
});