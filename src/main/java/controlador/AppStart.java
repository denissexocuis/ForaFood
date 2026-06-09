package controlador;

import DAOs.UsuarioDAO;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

//? esto se ejecuta automáticamente al aarrancar el servidor
//? inicializa el catálogo de medallas si no existe
@WebListener
public class AppStart implements ServletContextListener
{
    @Override
    public void contextInitialized(ServletContextEvent sce)
    {
        System.out.println("[AppStart] servidor iniciado — verificando catálogo de medallas...");
        try
        {
            new UsuarioDAO().inicializar_catalogo_medallas();
            System.out.println("[AppStart] catálogo de medallas chido, todo bien.");
        } catch (Exception e) {
            System.err.println("[AppStart] error al inicializar medallas: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce)
    {
    }
}
