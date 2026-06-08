package controlador;

import DAOs.PublicacionDAO;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

//? este servlet me ayudó a hacerlo la IA porque  se tenía que pasar tipo json para que javascript lo reciba y pueda dibujar los pines en el mapa.json de los establecimientos
@WebServlet("/mapa-pines")
public class MapaPines_Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[MapaPines_Servlet GET] mandando json de pines....");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        //? validar la sesión del estudiante
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().print("[]");
            return;
        }

        //? extraer la universiad del alumno para segmentar los pines
        // TODO
        ObjectId idUniversidad = (ObjectId) session.getAttribute("fk_universidad");

        try {
            PublicacionDAO dao = new PublicacionDAO();
            MongoCollection<Document> coleccionPubs = dao.getCollection();
            DAOs.EstablecimientoDAO estabDAO = new DAOs.EstablecimientoDAO();

            //Bson filtro = Filters.eq("fk_universidad", idUniversidad);
            //List<Document> publicacionesComunidad = coleccionPubs.find(filtro).into(new ArrayList<>());
            List<Document> publicacionesComunidad = coleccionPubs.find().into(new ArrayList<>());

            StringBuilder json = new StringBuilder("[");
            boolean primeraInclusion = true;

            for (Document post : publicacionesComunidad) {
                Object fkEstabObj = post.get("fk_establecimiento");

                if (fkEstabObj != null && !fkEstabObj.toString().equals("null") && !fkEstabObj.toString().trim().isEmpty()) {

                    ObjectId fkEstab = (fkEstabObj instanceof ObjectId) ? (ObjectId) fkEstabObj : new ObjectId(fkEstabObj.toString());

                    //? buscar el local en atlas
                    Document estabDoc = estabDAO.getCollection().find(Filters.eq("_id", fkEstab)).first();

                    if (estabDoc != null) {
                        Document ubicacionDoc = (Document) estabDoc.get("ubicacion");

                        if (ubicacionDoc != null) {
                            List<?> coordenadas = (List<?>) ubicacionDoc.get("coordinates");

                            if (coordenadas != null && coordenadas.size() >= 2) {
                                //? MongoDB GeoJSON: posición 0 = Longitud, posición 1 = Latitud
                                double lng = Double.parseDouble(coordenadas.get(0).toString());
                                double lat = Double.parseDouble(coordenadas.get(1).toString());

                                //? extraer la ruta de la imagen multimedia de forma segura
                                List<Document> mediaList = (List<Document>) post.get("multimedia");
                                String urlFoto = "";
                                if (mediaList != null && !mediaList.isEmpty()) {
                                    urlFoto = mediaList.get(0).getString("url");
                                }

                                if (!primeraInclusion) {
                                    json.append(",");
                                }
                                primeraInclusion = false;

                                json.append("{");
                                //? enviar la llave foranea del local, no el id del post
                                json.append("\"id\":\"").append(fkEstab.toHexString()).append("\",");
                                json.append("\"nombre\":\"").append(estabDoc.getString("nombre_local").replace("\"", "\\\"")).append("\",");
                                json.append("\"lat\":").append(lat).append(",");
                                json.append("\"lng\":").append(lng).append(",");
                                json.append("\"url_foto\":\"").append(urlFoto != null ? urlFoto : "").append("\"");
                                json.append("}");
                            }
                        }
                    }
                }
            }
            json.append("]");

            response.getWriter().print(json.toString());

        } catch (Exception e) {
            System.out.println("[MapaPines_Servlet GET] Error al procesar el JSON de pines:");
            e.printStackTrace();
            response.getWriter().print("[]");
        }
    }

}