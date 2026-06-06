package DAOs;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import modelo.Establecimiento;
import modelo.Publicacion;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.List;

public class EstablecimientoDAO implements CRUD<Establecimiento>
{
    private MongoCollection<Document> collection = ConexionMongo.getDatabase().getCollection("Establecimiento");

    public boolean agregar_foto_galeria(ObjectId idEstablecimiento, String rutaFoto) {
        try {
            //? filtrar por el ID del local
            Bson filtro = Filters.eq("_id", idEstablecimiento);

            //? agregar la ruta de la foto al array de galeria fotos sin duplicar
            //? esto lo hacemos con addToSet pa evitar duuplicados
            Bson operacion = Updates.addToSet("galeria_fotos", rutaFoto);

            collection.updateOne(filtro, operacion);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean insertOne(Establecimiento establecimiento)
    {
        try {
            Document geopuntoDoc = new Document("type", "Point")
                    .append("coordinates", establecimiento.getCoordenadas());

            Document doc = new Document()
                    .append("_id", establecimiento.getID_Establecimiento())
                    .append("nombre_local", establecimiento.getNombre_estab())
                    .append("ubicacion", geopuntoDoc)
                    .append("fk_universidad", establecimiento.getFk_universidad())
                    .append("calificacion", establecimiento.getCalificacion())
                    .append("descripcion", establecimiento.getDescripcion());

            collection.insertOne(doc);
            return true;
        } catch (Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Document findOne(ObjectId object)
    {
        return null;
    }

    @Override
    public List<Document> findAll()
    {
        List<Document> lista_locales = new ArrayList<>();

        try
        {
            lista_locales = collection.find().into(new ArrayList<>());
            return lista_locales;
        } catch (Exception e)
        {
            System.out.println("[EstablecimientoDAO] Error al consultar locales: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void deleteOne(ObjectId object)
    {

    }

    @Override
    public void updateOne(Establecimiento object)
    {

    }
}
