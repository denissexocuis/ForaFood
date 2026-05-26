package controlador;

// todos los servlets son controladores, es el que recibe la petición extrae los datos del formulario html, coordina el DAO y después puede mostrar otra página

import DAOs.UsuarioDAO;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

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
    protected void doPost(HttpServletRequest request, HttpServletResponse responde) throws ServletException, IOException
    {
        System.out.println("[ServletLogin POST] Iniciando sesión de usuario...");

        // obtener los datos que se mandaron del form en jsp
        String email = request.getParameter("emailLogin");
        String contraseña = request.getParameter("pwdLogin");

        UsuarioDAO userDAO = new UsuarioDAO();

        // hashear la contraseña para ver si hace match con la que se puso en el formulario del jsp... :o
        String passw_hash_obtenida = userDAO.hashing(contraseña);

        // se crea un javabean de usuario :D
        Usuario usuario = new Usuario(email, passw_hash_obtenida);

        //* se hace la verificación
        if(userDAO.autenticar_credenciales(email, passw_hash_obtenida))
        {
            System.out.println("[ServletLogin POST] Inició de sesión de forma exitosa :D. yupi");
        }

    }
}
