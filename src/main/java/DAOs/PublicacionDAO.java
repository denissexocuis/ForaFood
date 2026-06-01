package DAOs;

// el usuario se podrá registrar y asi jejejse

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import modelo.Publicacion;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class PublicacionDAO implements  CRUD<Publicacion>
{
    private MongoCollection<Document> collection = ConexionMongo.getDatabase().getCollection("Publicacion");
    // metodosss, TODO

    void validar(int voto_estudiante)
    {

    }

    void votar_contenido(int cant_estrellas)
    {

    }

    void generar_reporte(String motivo)
    {

    }

    public List<Document> buscar_portexto(ObjectId ID_Universidad, String texto)
    {
        List<Document> resultados_filtrados = new ArrayList<>();
        try
        {
            // TODO
            List<Bson> condiciones = new ArrayList<>();

            // se filtra por universidad
            condiciones.add(Filters.eq("fk_universidad", ID_Universidad));

            // si el usuario escribió algo en la barra, filtrar por coincidencia de texto
            //* uso de IA aquí abajitou
            if (texto != null && !texto.trim().isEmpty())
            {
                // "i" es para que ignore mayúsculas y minúsculas (case-insensitive)
                condiciones.add(Filters.regex("texto_publicacion", texto, "i"));
            }
            // juntar todos los filtros con un AND
            Bson filtro = Filters.and(condiciones);

            FindIterable<Document> documentos = collection.find(filtro);
            for (Document doc : documentos)
            {
                resultados_filtrados.add(doc);
            }

            System.out.println("[PublicacionDAO] se hace búsqueda para '" + texto + "' y devolvió " + resultados_filtrados.size() + " resultados.");

        }
        catch (Exception e)
        {
            System.out.println("[PublicacionDAO] error al buscar publicaciones por texto:c");
            e.printStackTrace();
        }
        return resultados_filtrados;
    }

    // métodos CRUD
    @Override
    public boolean insertOne(Publicacion post)
    {
        Document doc = new Document()
                .append("titulo", post.getTitulo())
                .append("texto_publicacion", post.getTexto_publicacion())
                .append("url_imagen", post.getUrl_imagen())
                .append("cant_estrellas", post.getCant_estrellas())
                .append("votosVigente", post.getVotosVigente())
                .append("votosFalso", post.getVotosFalso())
                .append("fecha", post.getFecha())
                .append("es_valida", post.isEs_valida())
                .append("fk_establecimiento", post.getFk_establecimiento())
                .append("fk_universidad", post.getFk_universidad())
                .append("fk_usuario", post.getFk_usuario())
                .append("comentarios", post.getComentarios());

        collection.insertOne(doc);
        return false;
    }

    @Override
    public void deleteOne(ObjectId id)
    {
        collection.deleteOne(new Document("_id", id));
    }

    @Override
    public void updateOne(Publicacion object)
    {

    }

    @Override
    public Document findOne(ObjectId id)
    {
        return collection.find(new Document("_id", id)).first();
    }

    @Override
    public List<Document> findAll()
    {
        return null;
    }

}
