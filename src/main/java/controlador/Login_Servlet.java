package controlador;

// todos los servlets son controladores, es el que recibe la petición extrae los datos del formulario html, coordina el DAO y después puede mostrar otra página

import DAOs.ConexionMongo;
import DAOs.UsuarioDAO;
import com.mongodb.client.model.Filters;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.bson.Document;
import org.bson.types.ObjectId;

@WebServlet("/login") // remplazar al web.xml
public class Login_Servlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    //! método post para lo de mandar los datos y verificar si sí son correctos, esto es validación de credenciales :D
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        System.out.println("[ServletLogin POST] Iniciando sesión de usuario...");

        //? obtener los datos que se mandaron del form en jsp
        String email = request.getParameter("emailLogin");
        String contraseña = request.getParameter("pwdLogin");

        UsuarioDAO userDAO = new UsuarioDAO();

        //hashear la contraseña para ver si hace match con la que se puso en el formulario del jsp... :o (ya no es necesario)
        //String passw_hash_obtenida = userDAO.hashing(contraseña);

        //* se hace la verificación de credenciales con una función que hice
        if(userDAO.autenticar_credenciales(email, contraseña))
        {
            //? aqui si sí las credenciales están correctas :D
            System.out.println("[ServletLogin POST] Inició de sesión de forma exitosa :D. yupi");

            //?obtener el usuario usando el email que se ingresó en el jsp
            Document datos_Usuario = userDAO.findOne_email(email); // lo pasé a una función para tener más orden

            if (datos_Usuario != null)
            {
                String nombre_sesion    = datos_Usuario.getString("nombre_user");
                ObjectId id_sesion_usuario = datos_Usuario.getObjectId("_id");
                ObjectId ID_Uni_sesion     = datos_Usuario.getObjectId("fk_universidad");
                int puntos_sesion          = datos_Usuario.getInteger("puntos", 0);
                String rango_sesion        = datos_Usuario.getString("rango");
                if (rango_sesion == null) rango_sesion = "Novato";
                String foto_sesion         = datos_Usuario.getString("foto_perfil");
                if (foto_sesion == null) foto_sesion = "img/avatar-default.png";

                java.util.List<String> medallas_sesion =
                        (java.util.List<String>) datos_Usuario.get("medallas");
                if (medallas_sesion == null) medallas_sesion = new java.util.ArrayList<>();

                //? guardar todo en sesión — incluyendo gamificación
                javax.servlet.http.HttpSession sesion = request.getSession();
                sesion.setAttribute("user",           nombre_sesion);
                sesion.setAttribute("fk_universidad", ID_Uni_sesion);
                sesion.setAttribute("_id_usuario",    id_sesion_usuario);
                sesion.setAttribute("puntos",         puntos_sesion);
                sesion.setAttribute("rango",          rango_sesion);
                sesion.setAttribute("foto_perfil",    foto_sesion);
                sesion.setAttribute("misMedallas",    medallas_sesion);
            }
            // mandar al home :D
            response.sendRedirect("principal");
        }
        else
        {
            // regresar al login con un mensaje de error
            response.sendRedirect("login?error=1");
        }

    }
}
