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
    public boolean insertOne(Universidad object)
    {

        return false;
    }

    @Override
    public Document findOne(ObjectId object)
    {
        return null;
    }

    @Override
    public List<Document> findAll()
    {
        //System.out.println("soy findAll"); // esto para depurar :)
        List<Document> lista_unis = new ArrayList<>();

        try
        {
            // me di cuenta que no era necesario, estuve entendiendo mejor los métodos del mongo en java jejejej, upsi
            //MongoCollection<Document> collection = ConexionMongo.seleccionar_coleccion("Universidad");

            MongoCollection<Document> collection = ConexionMongo.getDatabase().getCollection("Universidad"); // obtener coleccion especifica
            FindIterable<Document> cursor = collection.find();
            MongoCursor<Document> iterador = cursor.iterator();
            while (iterador.hasNext())
            {
                lista_unis.add(iterador.next()); // ir iterando en cada documento y agregarlo a una lista
            }
            //System.out.println(lista_unis); ya funcionaaa
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        System.out.println("Mandando universidades al select del html...");
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
