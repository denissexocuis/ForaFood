package controlador;

// todos los servlets son controladores, es el que recibe la petición extrae los datos del formulario html, coordina el DAO y después puede mostrar otra página

import DAOs.CorreoService;
import DAOs.UniversidadDAO;
import DAOs.UsuarioDAO;
import modelo.Universidad;
import modelo.Usuario;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.mindrot.jbcrypt.BCrypt;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/registro") // remplazar al web.xml
public class Registro_Servlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        //? mandar correo de verificación, este bloque lo saqué de ia
        String accion = request.getParameter("accion");

        if (accion != null && accion.equals("mandarCodigo"))
        {
            String correo = request.getParameter("correo");

            // * generar código de 6 dígitos
            int codigo = (int)(Math.random() * 900000) + 100000;

            // * guardar en sesión para verificar después
            request.getSession().setAttribute("codigoVerificacion", codigo);

            System.out.println("Código generado: " + codigo);

            try {
                CorreoService.mandarCodigo(correo, codigo);
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\": true}");
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\": false}");
            }
            return; // para que no se siga haciendo lo de abajo
        }
        if (accion != null && accion.equals("verificarCodigo"))
        {
            int codigoIngresado = Integer.parseInt(request.getParameter("codigo"));
            int codigoGuardado = (int) request.getSession().getAttribute("codigoVerificacion");

            if (codigoIngresado == codigoGuardado)
            {
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\": true}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\": false}");
            }
            return;
        }

        //? cargar página de registro normal
        UniversidadDAO universidad = new UniversidadDAO();
        //* regresar una lista de documentos de todas las universidades
        List<Document> lista_unis = universidad.findAll();
        //System.out.println(lista_unis);

        //* mandar la lista a jsp
        request.setAttribute("lista_universidades", lista_unis);

        // lista de dominios
        List<String> lista_dominios = new ArrayList<>();
        for (Document uni : lista_unis)
        {
            lista_dominios.add(uni.getString("dominio"));
        }
        //* mandar la lista de dominios a jsp
        request.setAttribute("lista_dominios", lista_dominios);

        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String nombre_user = request.getParameter("nombreUsuario");
        String email = request.getParameter("email");
        String pwd = request.getParameter("pwd");
        String universidad = request.getParameter("txtUniversidad");
        String correoInstitucional = request.getParameter("correoInstitucional");

        //! hasheando contraseña jejej
        String passw_hash = BCrypt.hashpw(pwd, BCrypt.gensalt());

        // TODO
        ObjectId id = new ObjectId(); //* para generar un nuevo objectID
        Usuario usuario = new Usuario(id, nombre_user, email, passw_hash, universidad, correoInstitucional);

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        usuarioDAO.insertOne();

        //usuarioDAO.insertar(nombreUsuario, email, pwdHash, universidad, correoInstitucional);

        response.sendRedirect("home.jsp");
    }
}
