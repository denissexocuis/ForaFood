package DAOs;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import modelo.Universidad;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.List;

public class UniversidadDAO implements CRUD<Universidad>
{
    // usando la clase ConexionMongo para seleccionar la base de datos
    //MongoDatabase database = ConexionMongo.getDb();
    //this.collection = database.getCollection("Usuario");


    @Override
    public void insertOne(Universidad object)
    {

    }

    @Override
    public Document findOne(ObjectId object)
    {
        return null;
    }

    @Override
    public List<Document> findAll()
    {
        System.out.println("soy findAll");
        List<Document> lista_unis = new ArrayList<>();

        try
        {
            // hice una funcion solo para seleccionar la coleccion ya asi rapido  y no tener que estar haciendo eso a cada rato sjdfjsdf
            // esto no fue ia ;)
            MongoCollection<Document> collection = ConexionMongo.seleccionar_coleccion("Universidad");
            //System.out.println("ya busque la coleccion, es: " + collection);

            // aquí si, usé IA D:
                // 1. Jalamos todos los documentos de la colección
            FindIterable<Document> documentos = collection.find();

            System.out.println("sou un documento xd " + documentos);

                // 2. Los recorremos con un for-each limpio de Java (Mongo se encarga de cerrarlo internamente)
            for (Document doc : documentos)
            {
                lista_unis.add(doc);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        System.out.println("no hice na de unis");
        return lista_unis;
    }

    @Override
    public void deleteOne(ObjectId object)
    {

    }

    @Override
    public void updateOne(Universidad object)
    {

    }
}
