package controlador;

import DAOs.ConexionMongo;
import DAOs.EstablecimientoDAO;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

//! esto me ayudó ia tambien D:
//? básicamente los que eran en formato json me ayudó, se supone que hacerlo manual
//? es más rápido y eso hace que la solicitud no tarde mucho

@WebServlet("/comentarios-mapa")
public class ComentariosMapa_Servlet extends HttpServlet
{
    //! obtener comentarios y promedio para el mapa.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("[ComentariosMapa_Servlet GET] Obteniendo comentarios y publicaciones para el mapa.json");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        String idStr = request.getParameter("idPost");

        //? validar si el ID viene nulo
        if (idStr == null || idStr.trim().isEmpty()) {
            if ("publicaciones".equals(action)) out.print("[]");
            else out.print("{\"promedio\":5.0,\"lista\":[]}");
            return;
        }

        ObjectId idMongo;
        try { idMongo = new ObjectId(idStr.trim()); }
        catch (Exception e) {
            if ("publicaciones".equals(action)) out.print("[]");
            else out.print("{\"promedio\":5.0,\"lista\":[]}");
            return;
        }

        MongoDatabase db = ConexionMongo.getDatabase();
        MongoCollection<Document> collectionEstab = db.getCollection("Establecimiento");

        //? buscar local
        Document local = collectionEstab.find(Filters.eq("_id", idMongo)).first();
        if (local == null) {
            com.mongodb.client.MongoCollection<Document> collectionPub = db.getCollection("Publicacion");
            Document pub = collectionPub.find(Filters.eq("_id", idMongo)).first();
            if (pub != null && pub.getObjectId("fk_establecimiento") != null) {
                idMongo = pub.getObjectId("fk_establecimiento");
                local = collectionEstab.find(Filters.eq("_id", idMongo)).first();
            }
        }


        //? si se piden las publicaciones del feed
        if ("publicaciones".equals(action)) {
            if (local == null) {
                out.print("[]");
                return;
            }
            MongoCollection<Document> collectionPub = db.getCollection("Publicacion");
            List<Document> pubsDelLocal = collectionPub.find(Filters.eq("fk_establecimiento", idMongo)).into(new ArrayList<>());

            StringBuilder jsonPubs = new StringBuilder("[");
            for (int i = 0; i < pubsDelLocal.size(); i++) {
                Document p = pubsDelLocal.get(i);

                String titulo = p.getString("titulo") != null ? p.getString("titulo").replace("\"", "\\\"") : "Sin título";
                String texto = p.getString("texto_publicacion") != null ? p.getString("texto_publicacion").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "";
                String autor = p.getString("nombre_autor") != null ? p.getString("nombre_autor") : "Estudiante";
                String idPub = p.getObjectId("_id").toHexString();

                List<Document> media = (List<Document>) p.get("multimedia");
                String foto = (media != null && !media.isEmpty()) ? media.get(0).getString("url") : "";

                jsonPubs.append("{")
                        .append("\"id\":\"").append(idPub).append("\",")
                        .append("\"titulo\":\"").append(titulo).append("\",")
                        .append("\"texto\":\"").append(texto).append("\",")
                        .append("\"autor\":\"").append(autor).append("\",")
                        .append("\"foto\":\"").append(foto).append("\"")
                        .append("}");
                if (i < pubsDelLocal.size() - 1) jsonPubs.append(",");
            }
            jsonPubs.append("]");
            out.print(jsonPubs.toString());
            out.flush();
            return;
        }

        //? si se piden las estrellas se devuelve un objeto json
        if (local == null) {
            out.print("{\"promedio\":5.0,\"lista\":[]}");
            return;
        }

        double promedioGlobal = 5.0;
        if (local.get("calificacion_promedio") != null) {
            Object val = local.get("calificacion_promedio");
            if (val instanceof Number) promedioGlobal = ((Number) val).doubleValue();
        }

        List<Document> comentarios = (List<Document>) local.get("comentarios");
        StringBuilder jsonLista = new StringBuilder("[");

        if (comentarios != null && !comentarios.isEmpty()) {
            for (int i = 0; i < comentarios.size(); i++) {
                Document c = comentarios.get(i);
                int nota = c.getInteger("calificacion") != null ? c.getInteger("calificacion") : 5;
                String textoLimpio = c.getString("texto") != null ? c.getString("texto") : "";
                textoLimpio = textoLimpio.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");

                jsonLista.append("{")
                        .append("\"nombre_autor\":\"").append(c.getString("nombre_autor")).append("\",")
                        .append("\"foto_perfil\":\"").append(c.getString("foto_perfil_autor")).append("\",")
                        .append("\"texto\":\"").append(textoLimpio).append("\",")
                        .append("\"calificacion\":").append(nota)
                        .append("}");
                if (i < comentarios.size() - 1) jsonLista.append(",");
            }
        }
        jsonLista.append("]");

        out.print("{\"promedio\":" + promedioGlobal + ",\"lista\":" + jsonLista.toString() + "}");
        out.flush();
}

    //? esto es para crear un comentario :D
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        System.out.println("[Comentarios_Servlet POST] Subiendo comentario...");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null)
        {
            String nombre_autor = (String) session.getAttribute("user");
            String foto_autor = (session.getAttribute("foto_perfil") != null) ? (String) session.getAttribute("foto_perfil") : "img/perfiles/default.png";

            String action = request.getParameter("action");
            String idStr = request.getParameter("idPost");
            String texto = request.getParameter("texto");
            String califStr = request.getParameter("calificacion");

            if (idStr != null && !idStr.trim().isEmpty())
            {
                ObjectId idEstablecimiento = new ObjectId(idStr.trim());
                MongoDatabase db = ConexionMongo.getDatabase();
                MongoCollection<Document> collection = db.getCollection("Establecimiento");

                Document local = collection.find(Filters.eq("_id", idEstablecimiento)).first();

                if (local != null) {
                    if ("eliminarValoracion".equals(action)) {
                        Bson operacionPull = Updates.pull("comentarios", Filters.eq("nombre_autor", nombre_autor));
                        collection.updateOne(Filters.eq("_id", idEstablecimiento), operacionPull);
                    }
                    else if (texto != null && califStr != null) {
                        int calificacion = Integer.parseInt(califStr);
                        Bson filtroUsuario = Filters.and(Filters.eq("_id", idEstablecimiento), Filters.eq("comentarios.nombre_autor", nombre_autor));

                        if (collection.find(filtroUsuario).first() != null) {
                            Bson operacionUpdate = Updates.combine(
                                    Updates.set("comentarios.$.texto", texto),
                                    Updates.set("comentarios.$.calificacion", calificacion),
                                    Updates.set("comentarios.$.fecha", new Date())
                            );
                            collection.updateOne(filtroUsuario, operacionUpdate);
                        } else {
                            Document nuevoComentario = new Document()
                                    .append("id_comentario", new ObjectId())
                                    .append("nombre_autor", nombre_autor)
                                    .append("foto_perfil_autor", foto_autor)
                                    .append("texto", texto)
                                    .append("fecha", new Date())
                                    .append("calificacion", calificacion);
                            collection.updateOne(Filters.eq("_id", idEstablecimiento), Updates.push("comentarios", nuevoComentario));
                        }
                    }

                    EstablecimientoDAO estabDAO = new EstablecimientoDAO();
                    double nuevoPromedio = estabDAO.recalcular_promedio_establecimiento(idEstablecimiento);

                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().print("{\"success\": true, \"nuevoPromedio\": " + nuevoPromedio + "}");
                    response.setStatus(200);
                    return;
                }
            }
            response.setStatus(400);
        } else {
            response.setStatus(401);
        }
    }

}
