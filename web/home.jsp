<%-- 
    Document   : home
    Created on : 25-feb-2019, 12:00:58
    Author     : Diurno
--%>

<%@page import="entities.Puntos"%>
<%@page import="entities.Chiste"%>
<%@page import="entities.Categoria"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<%
    List<Categoria> listaCategorias=(List<Categoria>)session.getAttribute("listaCategorias");
    List<Chiste> listaChistes=(List<Chiste>) session.getAttribute("listaChiste");
    String idcategoria=(String) session.getAttribute("idCategoria");
    String ficha=(String) session.getAttribute("ficha");
%>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/fontawesome.css">
        <link rel="stylesheet" type="text/css" href="css/mycss.css" media="screen"/>

        <title>Chistes!</title>
    </head>
    <body>
        <div class="container shadow bg-white rounded">
            <div class="row bg-primary">
                <nav class="navbar navbar-expand-md navbar-dark bg-primary">
                    <a class="navbar-brand text-white">Chistes</a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav ml-auto">
                            <li class="nav-item">
                                <a class="nav-link <%=(ficha.equals("categorias")?"active":"")%>" href="Controller?op=categoriasomejores&ficha=categorias">Por categorias<span class="sr-only">(current)</span></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <%=(ficha.equals("mejores")?"active":"")%>" href="Controller?op=categoriasomejores&ficha=mejores">Mejores chistes</a>
                            </li>
                        </ul>
                    </div>
                </nav>
            </div>
            <div class="row bg-primary">
                <div class="col-md-12">
                    <img class="mx-auto d-block" src="img/logo.png" alt="logo"/>
                </div>
            </div>
            <%if(ficha.equals("categorias")){%>               
            <div class="row categorias">
                <div class="col-sm-12 col-md-4 offset-md-2 mt-3">
                    <form action="Controller?op=categoria" method="post">
                        <div class="form-group">
                            <label class="font-weight-bold" for="selectCategorias">Categorias:</label>
                            <select class="form-control" name="idCategoria" id="selectCategoria" onchange='this.form.submit()'>
                                <option value="">Elige una categoria</option>
                                <%for(Categoria categoria:listaCategorias){%>
                                    <option value="<%=categoria.getId()%>"><%=categoria.getNombre()%></option>
                                <%}%>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="col-sm-12 col-md-2 mt-3">
                    <button type="button" style="width: 100%;" class="btn btn-danger mt-4" data-toggle="modal" data-target="#modal-categoria">
                        Añadir Categoria
                    </button>
                </div>
            </div>
            <div class="row categorias">
                <div class="col-sm-12 col-md-2 offset-md-5 text-center">
                    <button type="button" style="width: 100%;" class="btn btn-danger my-3" data-toggle="modal" data-target="#modal-chiste">
                            Añadir Chiste
                    </button>
                </div>
            </div>
            <%}
            if(listaChistes!=null){%>
            <div class="row">
                <%for(Chiste chiste:listaChistes){
                    int total=0;
                    int media=0;
                %>
                <div class="col-md-12 mt-3">
                    <div class="card text-center">
                        <div class="card-header" id="cabeceras">
                            <h1>
                                <%=chiste.getTitulo()%> (<%=chiste.getIdcategoria().getNombre()%>)
                                <%  
                                    if(chiste.getPuntosList().size()!=0){
                                        for(Puntos puntos:chiste.getPuntosList()){
                                            String punto=String.valueOf(puntos.getPuntos());
                                            total+=Integer.parseInt(punto);
                                        }
                                        media=total/chiste.getPuntosList().size();   
                                    }%>
                                (<%=media%>)
                                <p>
                                    <%for(int i=0;i<media;i++){%>
                                        <img src="img/star.png"/>   
                                    <%}%>
                                </p>
                            </h1>
                        </div>
                        <div class="card-body">
                          <h5 class="card-title"><%=chiste.getAdopo()%></h5>
                          <p class="card-text"><%=chiste.getDescripcion()%></p>
                        </div>
                        <div class="card-footer text-muted">
                            <span class="rating">
                                <a href="Controller?op=rating&rating=1&chisteid=<%=chiste.getId()%>">&#9733;</a>
                                <a href="Controller?op=rating&rating=2&chisteid=<%=chiste.getId()%>">&#9733;</a>
                                <a href="Controller?op=rating&rating=3&chisteid=<%=chiste.getId()%>">&#9733;</a>
                                <a href="Controller?op=rating&rating=4&chisteid=<%=chiste.getId()%>">&#9733;</a>
                                <a href="Controller?op=rating&rating=5&chisteid=<%=chiste.getId()%>">&#9733;</a>
                            </span>
                        </div>
                    </div>
                </div>
                <%}%>
                <div class="col-md-12" id="nuevoChiste">
                    <!--Se rellena con AJAX-->
                </div>
            </div>
            <%}else{%>
            <div class="row">
                <div class="col-md-12 mt-3">
                    <img src="img/chiste.png" class="img-fluid" alt="Responsive image"/>
                </div>
            </div>
            <%}%>
            <div class="row bg-primary mt-3">
                <div class="col-md-12 text-center">
                    <h3 class="text-white">CHISTES IES-AZARQUIEL</h3>
                </div>
            </div>
        </div>
            
        <!-- The snackbar -->
        <% String mensaje = (String)request.getAttribute("mensaje");
            if (mensaje!=null){
                %>
                <div id="snackbar"><%=mensaje%></div>
                <script type="text/javascript">
                    toast();
                </script>
            <%}
        %>

        <!-- Modal Chiste-->
        <div class="modal fade" id="modal-chiste" tabindex="-1" role="dialog" aria-labelledby="modal-chiste" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Nuevo chiste</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="formAddChiste">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="apodo">Apodo:</label>
                                <input type="text" class="form-control" id="apodo" name="apodo" aria-describedby="apodo" placeholder="Enter apodo" required>
                            </div>
                            <div class="form-group">
                                <label for="titulo">Titulo:</label>
                                <input type="text" class="form-control" id="titulo" name="titulo" placeholder="Titulo" required>
                            </div>
                            <div class="form-group">
                                <label for="descripcion">Descripcion:</label>
                                <textarea class="form-control" id="descripcion" name="descripcion" placeholder="Descripcion" required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="selectCategoriaModal">Elige una categoria:</label>
                                <select class="form-control" id="selectCategoriaModal" name="selectCategoriaModal">
                                    <option value="" selected disabled>Seleccione una categoria</option>
                                    <%for(Categoria categoria:listaCategorias){%>
                                        <option value="<%=categoria.getId()%>"><%=categoria.getNombre()%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            <button type="button" id="btnAddChiste" class="btn btn-primary">Aceptar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Categoria-->
        <div class="modal fade" id="modal-categoria" tabindex="-1" role="dialog" aria-labelledby="modal-categoria" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Nueva Categoria</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form action="Controller?op=addCategoria" method="post">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="tituloCategoria">Categoria:</label>
                                <input type="text" class="form-control" id="tituloCategoria" name="tituloCategoria" placeholder="Titulo categoria" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Aceptar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="js/jquery-3.3.1.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <!-- MyJS -->
        <script type="text/javascript" src="js/myjs.js"></script>
        <% if(idcategoria!=null){ %>
        <script type="text/javascript">
            $('#selectCategoria').val('<%=idcategoria%>');
        </script>
      <% } %>
    </body>
</html>
