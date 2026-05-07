package DAOs;

// el usuario se podrá registrar y asi jejejse

import modelo.Publicacion;
import org.bson.types.ObjectId;
import org.bson.Document;

public class PublicacionDAO implements  CRUD<Publicacion>
{
    private final com.mongodb.client.MongoCollection<Document> collection = ConexionMongo.seleccionar_coleccion("Publicacion");

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

    // métodos CRUD
    @Override
    public void insertOne(Publicacion post)
    {
        org.bson.Document doc = new Document()
                .append("titulo", post.getTitulo())
                .append("descripcion", post.getTexto_publicacion())
                .append("fecha", post.getFecha())
                .append("fk_usuario", post.getFk_usuario())
                .append("puntuacion", post.getPuntuacion())
                .append("es_comentario", post.isEs_comentario())
                .append("url_imagen", post.getUrl_imagen())
                .append("es_validada", post.isEs_valida())
                .append("cant_estrellas", post.getCant_estrellas())
                .append("establecimiento", post.getFk_establecimiento());

        collection.insertOne(doc);
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
    public void find(Publicacion object)
    {

    }

}
