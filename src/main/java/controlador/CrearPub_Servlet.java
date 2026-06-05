package controlador;

import DAOs.PublicacionDAO;
import modelo.Publicacion;
import org.bson.Document;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/crearpost") // remplazar al web.xml
public class CrearPub_Servlet extends HttpServlet
{
    //* el usuario inserta un post en la base de datos :D
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        System.out.println("[CrearPost_Servlet POST] recibiendo datos del formulario...");

        //  validar sesión del usuario
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null)
        {
            System.out.println("[CrearPost_Servlet] sesión no válida...");
            response.sendRedirect("index.jsp");
            return;
        }

        //! sesion validada, proceder...

        // obtener universidad que se mandó desde el login al home
        ObjectId id_user_sesion = (ObjectId) session.getAttribute("_id_usuario");
        ObjectId ID_Uni_sesion = (ObjectId) session.getAttribute("fk_universidad");
        String nombre_user_sesion = (String) session.getAttribute("user");

        //? obtener foto de perfil del usuario :D
        String foto_usuario_logeado = (String) session.getAttribute("foto_perfil");
        if (foto_usuario_logeado == null) {
            foto_usuario_logeado = "img/avatar-default.png"; // por si acaso no subió foto
        }

        try
        {
            // ? recuperar los inputs del jsp
            String titulo = request.getParameter("txtTitulo");
            String texto_publicacion = request.getParameter("txtDescripcion");
            String imagen = request.getParameter("txtImagen");
            String id_establecimiento = request.getParameter("selEstablecimiento");

            //? METER EN JAVA BEAN
            Publicacion nuevoPost = new Publicacion();
            nuevoPost.setTitulo(titulo);
            nuevoPost.setTexto_publicacion(texto_publicacion);
            nuevoPost.setEs_valida(true);
            nuevoPost.setComentarios(new ArrayList<>());
            nuevoPost.setNombre_autor(nombre_user_sesion);
            nuevoPost.setFoto_perfil_autor(foto_usuario_logeado);

            // strings a objectid
            nuevoPost.setFk_universidad(ID_Uni_sesion);
            nuevoPost.setFk_establecimiento(new ObjectId(id_establecimiento));

            //? GUARDARLO EN LA BD
            boolean exito = new PublicacionDAO().insertOne(nuevoPost);

            if (exito)
            {
                response.sendRedirect("principal");
            } else
            {
                response.sendRedirect("principal?error=db_error");
            }

        } catch (IllegalArgumentException e) {
            System.out.println("[CrearPost_Servlet] uno de los IDs no es un ObjectId válido.");
            e.printStackTrace();
            response.sendRedirect("principal?error=id_invalido");
        } catch (Exception e) {
            System.out.println("[CrearPost_Servlet] un error inesperado:");
            e.printStackTrace();
            response.sendRedirect("principal?error=unknown");
        }

    }
}
