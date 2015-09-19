$(document).ready(function(){

  $('#locationForm').submit(formValidated);

  function formValidated(){
    if (typeof dest === 'undefined') {
      return false;
    }
    else{
      return true;
    }
  }


  $('.menu-container').delegate('.col-xs-12.col-md-6','click', function() {
    window.location = $(this).attr('data-link');
  });



});
