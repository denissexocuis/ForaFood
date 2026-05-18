package controlador;

// todos los servlets son controladores, es el que recibe la petición extrae los datos del formulario html, coordina el DAO y después puede mostrar otra página

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

@WebServlet("/registroUsuario") // remplazar al web.xml
public class Registro_Servlet extends HttpServlet
{

}
