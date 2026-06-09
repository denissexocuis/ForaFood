package controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import DAOs.ConexionMongo;
import com.google.gson.Gson;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Sorts;
import org.bson.Document;

@WebServlet("/ranking-usuarios")
//? parecido al servlet de ranking de establecimientos pero para usuarios, los va a rankear por puntos obtenidos
public class RankingUsuarios_Servlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        System.out.println("[RankingUsuarios_Servlet GET] Obteniendo usuarios para el ranking y mandandolos al frontend...");

        try
        {
            //? obtener la coleccion de la base de datos
            MongoCollection<Document> coleccion = ConexionMongo.getDatabase().getCollection("Usuario");

            //? traer los usuarios ordenados de forma ascendente por puntos
            List<Document> lista_rank_users = coleccion.find()
                    .sort(Sorts.descending("puntos"))
                    .limit(5)
                    .into(new ArrayList<>());

            //? lista de mapas puros de java para ser escalable
            List<Map<String, Object>> lista_limpia = new ArrayList<>();

            for (Document doc : lista_rank_users)
            {
                //? clonar todo el documento a un mapa de java
                Map<String, Object> mapa = new HashMap<>(doc);

                //? reemplazar unicamente el id por su texto plano
                if (doc.get("_id") != null)
                {
                    mapa.put("_id", doc.getObjectId("_id").toHexString());
                }

                lista_limpia.add(mapa);
            }

            //? GSON recibe objetos puros de java
            Gson gson = new Gson();
            String jsonResultado = gson.toJson(lista_limpia);

            //? mandar el json al frontend (javascript)
            out.print(jsonResultado);
        }
        catch (Exception e)
        {
            System.err.println("[RankingUsuarios_Servlet] Error al calcular el top: " + e.getMessage());
            e.printStackTrace();
            out.print("[]"); //? si algo truena, mandar un arreglo vacío para que no se rompa el JS
        }
        out.flush();
    }
}
