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

});
