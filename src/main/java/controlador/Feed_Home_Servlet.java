package controlador;

import DAOs.PublicacionDAO;
import org.bson.Document;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/principal") // remplazar al web.xml
public class Feed_Home_Servlet extends HttpServlet
{
    //* obtener lo que se manda
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        System.out.println("[Feed_Servlet GET] cargando feed principal con el DAO publicacion...");

        // validar la sesión del usuario, esto lo saqué de ia btw
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null)
        {
            response.sendRedirect("index.jsp");
            return;
        }

        //? obtener los datos que se mandaron del form en jsp
        ObjectId universidad = (ObjectId) session.getAttribute("fk_universidad");
        //? obtener lo que el usuario escribió en la barra de búsqueda
        String txta_buscar = request.getParameter("txtBuscar"); // del nombre de jsp

        //* dao para buscar los datous
        PublicacionDAO publicacionDAO = new PublicacionDAO();

        List<Document> postsParaVista = publicacionDAO.buscar_portexto(universidad, txta_buscar);

        // mandar a jsp
        request.setAttribute("posts_comunidad", postsParaVista);

        // mandar a home.jsp
        request.getRequestDispatcher("home.jsp").forward(request, response);

    }
}
