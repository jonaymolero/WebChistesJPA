$(document).ready(function() {
    console.log('ready');
    init();
});

function init(){
    validadAddChiste();
    //addChiste();
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


