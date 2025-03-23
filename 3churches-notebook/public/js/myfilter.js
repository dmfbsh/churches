$(document).ready(function(){
  $("#myInput").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#myTable .fr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
    $('#myTable tr').show();
    $('#myTable tr').each(function() {
    if($(this).find('.fr:visible').length == 0){
      $(this).hide();
    }
  });
});
});
