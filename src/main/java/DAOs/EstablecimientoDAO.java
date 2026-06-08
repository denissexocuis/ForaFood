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

    public double recalcular_promedio_establecimiento(ObjectId idEstablecimiento) {
        try {
            Document local = collection.find(Filters.eq("_id", idEstablecimiento)).first();
            if (local == null) return 5.0;

            List<Document> comentarios = (List<Document>) local.get("comentarios");
            double promedio = 5.0;

            if (comentarios != null && !comentarios.isEmpty()) {
                double suma = 0;
                for (Document c : comentarios) {
                    // Soportamos si viene como Integer o Double de la base de datos
                    Number nota = (Number) c.get("calificacion");
                    suma += (nota != null) ? nota.doubleValue() : 5.0;
                }
                promedio = suma / comentarios.size();
                // Redondear a un decimal (Ej: 4.6)
                promedio = Math.round(promedio * 10.0) / 10.0;
            }

            // Guardamos el nuevo promedio calculado directamente en el documento del Establecimiento
            collection.updateOne(Filters.eq("_id", idEstablecimiento), Updates.set("calificacion_promedio", promedio));
            return promedio;

        } catch (Exception e) {
            System.out.println("[EstablecimientoDAO] Error al recalcular promedio: " + e.getMessage());
            return 5.0;
        }
    }

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

    public MongoCollection<Document> getCollection()
    {
        return collection;
    }

    public void setCollection(MongoCollection<Document> collection)
    {
        this.collection = collection;
    }
}
