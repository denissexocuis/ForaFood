package controlador;

import DAOs.PublicacionDAO;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/votar")
public class Votacion_Servlet extends HttpServlet
{
    //! aquí tuve que checar por qué era Post, tuve ayuda de IA
    //? Regla de oro de los navegadores web: Todos los enlaces <a> de HTML, cuando les das un clic, disparan obligatoriamente una petición de tipo GET. Los enlaces no saben cómo mandar un POST.
    //?esto es porque en el servlet home, el botón de votación
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");
        System.out.println("[Votacion_Servlet GET] haciendo votación...");

        //? obtener los datos de la publicación que está en el jsp :D
        String id_publicacion = request.getParameter("id");
        String tipo_voto = request.getParameter("tipo");

        //? sacar la sesión para saber quien está votando :0
        HttpSession session = request.getSession();
        ObjectId id_usuario_votante = (ObjectId) session.getAttribute("_id_usuario");

        if (id_publicacion != null && tipo_voto != null && id_usuario_votante != null) {
            ObjectId OI_Publicacion = new ObjectId(id_publicacion);
            boolean es_vigente = tipo_voto.equals("real");

            // mandarlo al DAO
            PublicacionDAO postDAO = new PublicacionDAO();
            System.out.println("[Votacion_Servlet GET] mandarlo al DAO para registrar voto...");
            postDAO.registrar_votoPublicacion(OI_Publicacion, id_usuario_votante, es_vigente);

            //? recuperar el documento actualizado desde mongo
            org.bson.Document postActualizado = postDAO.findOne(OI_Publicacion);
            if (postActualizado != null)
            {
                int reales = postActualizado.getInteger("votosVigente", 0);
                int falsos = postActualizado.getInteger("votosFalso", 0);

                //? esto lo saque de ia, configurar cabecera e imprimir json porque lo espera el javascript
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().print("{\"reales\":" + reales + ", \"falsos\":" + falsos + "}");
                return;
            }
        }

        //response.sendRedirect("principal");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
