$(document).ready(function() {
    console.log('ready');
    init();
});

function init(){
    validadAddChiste();
    toast();
}

function validadAddChiste(){
    $("#btnAddChiste").click(function(){
        if($("#apodo").val() != "" && $("#titulo").val() != "" && $("#descripcion").val() != "" && $("#selectCategoriaModal").val() != null) {
            addChiste();
        }
        $("#modal-chiste").modal('hide');
        document.getElementById("formAddChiste").reset();
    });
}

function addChiste(){
    $.ajax({
            type: "POST",
            url: "Controller?op=addChiste",
            data: $("#formAddChiste").serialize(),
            success : function(info) {
                $("#nuevoChiste").append(info);
            }
    });
}

function toast() {
  // Get the snackbar DIV
  var x = document.getElementById("snackbar");

  // Add the "show" class to DIV
  x.className = "show";

  // After 3 seconds, remove the show class from DIV
  setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
}



