/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import entities.Categoria;
import entities.Chiste;
import entities.Puntos;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import jpautil.JPAUtil;

/**
 *
 * @author Diurno
 */
@WebServlet(name = "Controller", urlPatterns = {"/Controller"})
public class Controller extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher;
        
        String op;
        String sql;
        Query query;
        List<Chiste> listaChistes=null;
        Categoria categoriaSeleccionada;
        EntityManager em = null;
        EntityTransaction transaction;
        
        if (em == null) {
            em = JPAUtil.getEntityManagerFactory().createEntityManager();
            session.setAttribute("em", em);
        }
        
        op = request.getParameter("op");
        
        if(op.equals("inicio")) {
            
            query=em.createNamedQuery("Categoria.findAll");
            List<Categoria> listaCategorias=query.getResultList();
            
            session.setAttribute("listaCategorias",listaCategorias);
            session.setAttribute("ficha", "categorias");
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
            
        }else if(op.equals("categoria")){
            
            try{
                short idCategoria=Short.parseShort(request.getParameter("idCategoria"));
                categoriaSeleccionada=em.find(Categoria.class, idCategoria);
                listaChistes=categoriaSeleccionada.getChisteList();
            }catch(Exception e){
            }
            session.setAttribute("idCategoria", request.getParameter("idCategoria"));
            session.setAttribute("listaChiste", listaChistes);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
            
        }else if(op.equals("categoriasomejores")){
            
            String ficha=request.getParameter("ficha");
            
            if(ficha.equals("mejores")){
                sql="select p.idchiste from Puntos p group by p.idchiste order by avg(p.puntos) desc";
                query = em.createQuery(sql);
                listaChistes=query.getResultList();
            }else{
                try{
                    String idCategoria=(String) session.getAttribute("idCategoria");
                    categoriaSeleccionada=em.find(Categoria.class, Short.parseShort(idCategoria));
                    listaChistes=categoriaSeleccionada.getChisteList();
                }catch(Exception e){
                }
            }
            
            session.setAttribute("ficha", ficha);
            session.setAttribute("listaChiste", listaChistes);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("rating")){
            BigDecimal puntuacion=BigDecimal.valueOf(Integer.parseInt(request.getParameter("rating")));
            Chiste chiste=em.find(Chiste.class, Short.parseShort(request.getParameter("chisteid")));
            String ficha=(String) session.getAttribute("ficha");
            
            Puntos puntos=new Puntos();
            puntos.setId(3);
            puntos.setIdchiste(chiste);
            puntos.setPuntos(puntuacion);
            
            transaction = em.getTransaction();
            transaction.begin();
            em.persist(puntos);
            transaction.commit();
            
            em.refresh(chiste);
            categoriaSeleccionada=em.find(Categoria.class, chiste.getIdcategoria().getId());
            em.refresh(categoriaSeleccionada);
            
            em.getEntityManagerFactory().getCache().evictAll();
            
            if(ficha.equals("mejores")){
                sql="select p.idchiste from Puntos p group by p.idchiste order by avg(p.puntos) desc";
                query = em.createQuery(sql);
                listaChistes=query.getResultList();
            }else{
                //categoriaSeleccionada=em.find(Categoria.class, chiste.getIdcategoria().getId());
                listaChistes=categoriaSeleccionada.getChisteList();
            }
            
            session.setAttribute("listaChiste", listaChistes);
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("addCategoria")){
            categoriaSeleccionada=new Categoria();
            categoriaSeleccionada.setNombre(request.getParameter("tituloCategoria"));
            
            transaction = em.getTransaction();
            transaction.begin();
            em.persist(categoriaSeleccionada);
            transaction.commit();
            em.getEntityManagerFactory().getCache().evictAll();
            
            query=em.createNamedQuery("Categoria.findAll");
            List<Categoria> listaCategorias=query.getResultList();
            
            session.setAttribute("listaCategorias",listaCategorias);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("addChiste")){
            Chiste chisteNuevo=new Chiste();
            chisteNuevo.setAdopo(request.getParameter("apodo"));
            chisteNuevo.setTitulo(request.getParameter("titulo"));
            chisteNuevo.setDescripcion(request.getParameter("descripcion"));
            chisteNuevo.setIdcategoria(em.find(Categoria.class, Short.parseShort(request.getParameter("selectCategoriaModal"))));
            
            transaction = em.getTransaction();
            transaction.begin();
            em.persist(chisteNuevo);
            transaction.commit();
            em.getEntityManagerFactory().getCache().evictAll();
            
            if(request.getParameter("selectCategoriaModal").equals(session.getAttribute("idCategoria"))){
                query=em.createNamedQuery("Chiste.findUltimoChiste");
                Chiste chiste=(Chiste) query.getSingleResult();
                request.setAttribute("chiste", chiste);
            
                dispatcher = request.getRequestDispatcher("chisteNuevo.jsp");
                dispatcher.forward(request, response);
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
