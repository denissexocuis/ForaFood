package controlador;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.types.ObjectId;
import com.mongodb.client.MongoCollection;
import DAOs.PublicacionDAO;

//? este servlet se creó con ayuda de IA porque se tenía que crear un json para mandarlo a javascript
//?.....de hecho me ayudó con  comentarios, publicación y mapa-pines servlet, sobre todo a dibujar los pines
@WebServlet("/comentarios")
public class ComentariosFeed_Servlet extends HttpServlet
{
    //? basicamente esto es para obtener la lista de la bd y ponerla en el panel lateral u mostrarla
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        //? devolver la lista en JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String idPostStr = request.getParameter("idPost");
        if (idPostStr == null) { out.print("[]"); return; }

        PublicacionDAO dao = new PublicacionDAO();
        MongoCollection<Document> collection = dao.getCollection();

        Document post = collection.find(Filters.eq("_id", new ObjectId(idPostStr))).first();
        List<Document> comentarios = (List<Document>) post.get("comentarios");

        // si la lista está vacia
        if (comentarios == null)
        {
            out.print("[]");
        } else {
            //? si la lista no está vacia, esto lo saque de ia
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < comentarios.size(); i++)
            {
                Document c = comentarios.get(i);
                json.append("{")
                        .append("\"nombre_autor\":\"").append(c.getString("nombre_autor")).append("\",")
                        .append("\"foto_perfil\":\"").append(c.getString("foto_perfil_autor")).append("\",")
                        .append("\"texto\":\"").append(c.getString("texto")).append("\"")
                        .append("}");
                if (i < comentarios.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
        }
        out.flush();
    }

    //? esto es para crear un comentario :D
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String id_post_string = request.getParameter("idPost");
        String texto = request.getParameter("texto");

        HttpSession session = request.getSession();
        String nombre_autor = (String) session.getAttribute("user");
        String foto_autor = (String) session.getAttribute("foto_perfil");
        if (foto_autor == null) foto_autor = "img/avatar-default.png";

        if (id_post_string != null && texto != null && nombre_autor != null)
        {
            PublicacionDAO dao = new PublicacionDAO();
            MongoCollection<Document> collection = dao.getCollection();

            // crear el subdocumento del comentario :D
            Document nuevoComentario = new Document()
                    .append("id_comentario", new ObjectId())
                    .append("nombre_autor", nombre_autor)
                    .append("foto_perfil_autor", foto_autor)
                    .append("texto", texto)
                    .append("fecha", new Date());

            // inyectarlo directo al array de comentarios de esa publicación
            collection.updateOne(
                    Filters.eq("_id", new ObjectId(id_post_string)),
                    Updates.push("comentarios", nuevoComentario)
            );
            response.setStatus(200);
        } else {
            response.setStatus(400);
        }
    }
}