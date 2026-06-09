package controlador;

import DAOs.PublicacionDAO;
import DAOs.UsuarioDAO;
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
        ObjectId id_usuario = (ObjectId) session.getAttribute("_id_usuario");
        ObjectId universidad = (ObjectId) session.getAttribute("fk_universidad");
        //? obtener lo que el usuario escribió en la barra de búsqueda
        String txta_buscar = request.getParameter("txtBuscar"); // del nombre de jsp

        //* dao para buscar los datous
        PublicacionDAO publicacionDAO = new PublicacionDAO();
        List<Document> postsParaVista = publicacionDAO.buscar_portexto(universidad, txta_buscar);

        //? validación de historial por los votos
        if (postsParaVista != null && id_usuario != null) {
            String idUsuarioStr = id_usuario.toString();

            for (Document post : postsParaVista) {
                String yaVotoTipo = "ninguno";

                //? extraer el historial de votos que guarda la publicacion
                List<Document> historial = (List<Document>) post.get("historial_votos");
                if (historial != null) {
                    for (Document votoDoc : historial) {
                        Object idVotanteObj = votoDoc.get("usuario_id");
                        if (idVotanteObj != null && idVotanteObj.toString().equals(idUsuarioStr)) {
                            yaVotoTipo = votoDoc.getBoolean("es_vigente") ? "vigente" : "falso";
                            break;
                        }
                    }
                }

                //? mandar bandera temporal al jsp
                post.append("voto_usuario_sesion", yaVotoTipo);
            }
        }

        //? refresh de gamificación :D
        if (id_usuario != null) {
            Document userActualizado = new UsuarioDAO().findOne(id_usuario);
            if (userActualizado != null) {
                //? actualizar los atributos individuales en la sesión
                session.setAttribute("puntos", userActualizado.getInteger("puntos", 0));
                session.setAttribute("rango", userActualizado.getString("rango"));

                //? sacar el arreglo de medallas de la bd y subirlo
                List<String> medallasBD = (List<String>) userActualizado.get("medallas");
                if (medallasBD == null) {
                    medallasBD = new java.util.ArrayList<>();
                }
                session.setAttribute("misMedallas", medallasBD);
                System.out.println("[Feed_Servlet] Gamificación y medallas (" + medallasBD.size() + ") actualizadas para " + session.getAttribute("user"));
            }
        }

        // mandar a jsp
        request.setAttribute("posts_comunidad", postsParaVista);

        // tambien dejar el texto que se habia puesto en la barra de busqueda
        //request.setAttribute("textoBuscadoAnterior", txta_buscar);

        // mandar a home.jsp
        request.getRequestDispatcher("home.jsp").forward(request, response);

    }
}
