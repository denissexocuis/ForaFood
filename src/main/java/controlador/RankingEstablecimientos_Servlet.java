package controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import DAOs.ConexionMongo;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Sorts;
import org.bson.Document;

//? este servlet básicamente se encarga de las peticiones para el ranking de establecimintos
//? el ranking es basado en la calificación promedio que tienen los establecimientos
//?las valoraciones se hacen desde mapa.jsp :D

//! notas:
//! básicamente ha lo que he estado investigando, se usa la función AJAX en javascript
//! esto significa que basicamente no hace falta recargar la página para que los datos se actualicen
//! el jsp le pide al Servlet "bloques de datos" (JSON) para actualizar dinámicamente componentes específicos (como el contador de votos, el modal o la lista del ranking).
@WebServlet("/ranking-establecimientos")
public class RankingEstablecimientos_Servlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        System.out.println("[RankingEsta_Servlet GET] Obteniendo establecimientos para el ranking y mandandolos al frontend...");

        try
        {
            //? obtener la coleccion de la base de datos
            MongoCollection<Document> coleccion = ConexionMongo.getDatabase().getCollection("Establecimiento");

            //! esto me ayudó la ia para convertir a json y lo pueda recibir el javascrip

            //? traer los locales ordenados por promedio de mayor a menor
            List<Document> listaRanking = coleccion.find()
                    .sort(Sorts.descending("calificacion_promedio"))
                    .limit(5)
                    .into(new ArrayList<>());

            //? armar el arreglo JSON usando el poder del mongodb
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < listaRanking.size(); i++)
            {
                //? .toJson convierte todo el documento de mongo automaticamente
                json.append(listaRanking.get(i).toJson());

                //? agregar coma si no es el ultimo elemento
                if (i < listaRanking.size() - 1)
                {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString()); //? mandar el json al frontend
        }
        catch (Exception e)
        {
            System.err.println("[Ranking_Servlet] Error al calcular el top: " + e.getMessage());
            e.printStackTrace();
            out.print("[]"); //? si algo truena, mandar un arreglo vacío para que no se rompa el JS
        }
        out.flush();
    }
}
