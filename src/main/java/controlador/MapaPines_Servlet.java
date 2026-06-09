package controlador;

import DAOs.EstablecimientoDAO;
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
            DAOs.EstablecimientoDAO estabDAO = new DAOs.EstablecimientoDAO();

            // busacr los locales segmentados por universidad de forma nativa
            List<Document> listaEstablecimientos = estabDAO.getCollection()
                    .find(Filters.eq("fk_universidad", idUniversidad))
                    .into(new java.util.ArrayList<>());

            StringBuilder json = new StringBuilder();
            json.append("[");
            boolean primeraInclusion = true;

            for (Document estabDoc : listaEstablecimientos) {
                System.out.println("nombre local: " + estabDoc.get("nombre_local"));

                //? lectura de la ubicación
                Object ubiObj = estabDoc.get("ubicacion");
                if (ubiObj == null) {
                    ubiObj = estabDoc.get("geopunto");
                }

                if (ubiObj != null && ubiObj instanceof Document) {
                    Document ubicacionDoc = (Document) ubiObj;
                    java.util.List<?> coord = (java.util.List<?>) ubicacionDoc.get("coordinates");

                    if (coord != null && coord.size() >= 2) {
                        double lng = ((Number) coord.get(0)).doubleValue();
                        double lat = ((Number) coord.get(1)).doubleValue();

                        //? manejo seguro del nombre
                        String nombreFinal = estabDoc.getString("nombre_local");
                        if (nombreFinal == null) nombreFinal = estabDoc.getString("nombre_local");
                        if (nombreFinal == null) nombreFinal = "Establecimiento desconocido";

                        nombreFinal = nombreFinal.replace("\"", "\\\"");

                        //? galeria , eso me ayudo la ia
                        String urlFoto = "img/default-post.png";
                        Object galeriaObj = estabDoc.get("galeria_fotos");


                        if (galeriaObj == null) {
                            galeriaObj = new java.util.ArrayList<>();
                        }

                        if (galeriaObj instanceof List) {
                            List<?> galeria = (List<?>) galeriaObj;
                            if (!galeria.isEmpty() && galeria.get(0) instanceof Document) {
                                Document primeraFoto = (Document) galeria.get(0);
                                if (primeraFoto.containsKey("url")) {
                                    urlFoto = primeraFoto.getString("url");
                                }
                            }
                        } else if (galeriaObj instanceof String) {
                            urlFoto = (String) galeriaObj;
                        }


                        if (!primeraInclusion) {
                            json.append(",");
                        }
                        primeraInclusion = false;

                        //? armando del json
                        json.append("{");
                        json.append("\"id\":\"").append(estabDoc.getObjectId("_id").toHexString()).append("\",");
                        json.append("\"nombre\":\"").append(nombreFinal).append("\",");
                        json.append("\"lat\":").append(lat).append(",");
                        json.append("\"lng\":").append(lng).append(",");
                        json.append("\"url_foto\":\"").append(urlFoto).append("\"");
                        json.append("}");
                    }
                }
            }
            json.append("]");

            response.getWriter().print(json.toString());
            return;

        } catch (Exception e) {
            System.out.println("[MapaPines_Servlet GET] Error al armar el JSON independiente:");
            e.printStackTrace();
            response.getWriter().print("[]");
        }
    }

}