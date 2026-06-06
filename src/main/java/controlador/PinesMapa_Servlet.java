package controlador;


//? este servlet lo que hará solo es responder con texto en formato JSON para que el javascript lo pueda entender
//?

import DAOs.EstablecimientoDAO;
import org.bson.Document;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/mapa-pines")
public class PinesMapa_Servlet extends HttpServlet
{
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        //? configurar respuesta como JSON con codificacion utf-8
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        //? traer la lista de documentos de la base de datossssss
        EstablecimientoDAO establecimientoDAO = new EstablecimientoDAO();
        List<Document> establecimientos_lista_bd = establecimientoDAO.findAll();

        //? esto me ayudó la ia:
        // Construir manualmente el string JSON para no depender de librerías externas pesadas (Gson/Jackson)
        StringBuilder json = new StringBuilder();
        json.append("[");

        for (int i = 0; i < establecimientos_lista_bd.size(); i++) {
            Document doc = establecimientos_lista_bd.get(i);

            ObjectId id = doc.getObjectId("_id");
            String nombre = doc.getString("nombre_local");

            // Extraer el subdocumento GeoJSON 'ubicacion' -> { type: "Point", coordinates: [lng, lat] }
            Document ubicacionDoc = (Document) doc.get("ubicacion");

            if (ubicacionDoc != null) {
                List<Double> coordinates = (List<Double>) ubicacionDoc.get("coordinates");

                if (coordinates != null && coordinates.size() == 2) {
                    double lng = coordinates.get(0);
                    double lat = coordinates.get(1);

                    json.append("{");
                    json.append("\"id\":\"").append(id.toHexString()).append("\",");
                    json.append("\"nombre\":\"").append(nombre.replace("\"", "\\\"")).append("\",");
                    json.append("\"lat\":").append(lat).append(",");
                    json.append("\"lng\":").append(lng);
                    json.append("}");

                    if (i < establecimientos_lista_bd.size() - 1) {
                        json.append(",");
                    }
                }
            }
        }

        // Si el JSON termina con una coma colgada por un registro inválido, la limpiamos rápidamente
        if (json.toString().endsWith(",")) {
            json.deleteCharAt(json.length() - 1);
        }

        json.append("]");

        // Escupir el JSON hacia el cliente (JavaScript)
        out.print(json.toString());
        out.flush();
    }

}
