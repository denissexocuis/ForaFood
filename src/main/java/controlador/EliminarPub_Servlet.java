package controlador;

import DAOs.PublicacionDAO;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EliminarPublicacion")
public class EliminarPub_Servlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        //? verificar la sesión del estudiante
        HttpSession session = request.getSession(false);
        String user_logueado = (String) (session != null ? session.getAttribute("user") : null);

        if (user_logueado == null)
        {
            //? si no hay sesión activa, mandar al index
            response.sendRedirect("index.jsp");
            return;
        }

        //? capturar el id del post enviado desde el jsp y el boton de basura
        String idPostString = request.getParameter("id");
        if (idPostString != null && !idPostString.isEmpty()) {
            try
            {
                //? instanciar el dao
                PublicacionDAO dao = new PublicacionDAO();

                //? convertir el string a objectid
                ObjectId id_aeliminar = new ObjectId(idPostString);

                dao.deleteOne(id_aeliminar); //? mandar a eliminar mediante el id

                System.out.println("[EliminarPub GET] pub " + idPostString + " eliminada con éxito por " + user_logueado + "!");

            } catch (Exception e)
            {
                System.out.println("Error crítico al intentar borrar el documento en Atlas: " + e.getMessage());
                e.printStackTrace();
            }
        }

        response.sendRedirect("principal");
    }
}
