<%-- 
    Document   : chisteNuevo
    Created on : 01-mar-2019, 17:32:15
    Author     : Usuario
--%>

<%@page import="entities.Puntos"%>
<%@page import="entities.Chiste"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Chiste chiste=(Chiste) request.getAttribute("chiste");
    int total=0;
    int media=0;
%>
<%if(chiste!=null){%>
    <div class="card text-center mt-3">
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
<%}%>
