package controlador;

// todos los servlets son controladores, es el que recibe la petición extrae los datos del formulario html, coordina el DAO y después puede mostrar otra página

import DAOs.UniversidadDAO;
import modelo.Universidad;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/registro") // remplazar al web.xml
public class Registro_Servlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        UniversidadDAO universidad = new UniversidadDAO();
        // regresar una lista de documentos de todas las universidades
        List<Document> lista_unis = universidad.findAll();

        // mandar la lista a jsp
        request.setAttribute("lista_universidades", lista_unis);

        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }
}
