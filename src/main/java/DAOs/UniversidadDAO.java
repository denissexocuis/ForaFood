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

    private static MongoCollection<Document> collection = ConexionMongo.getDatabase().getCollection("Universidad");


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
        //System.out.println("soy findAll"); // esto para depurar :)
        List<Document> lista_unis = new ArrayList<>();

        try
        {
            // me di cuenta que no era necesario, estuve entendiendo mejor los métodos del mongo en java jejejej, upsi
            //MongoCollection<Document> collection = ConexionMongo.seleccionar_coleccion("Universidad");

            System.out.println("Testeando para ver si conectó bien con la coleccion");
            FindIterable<Document> documents = collection.find();
            for (Document doc : documents) {
                System.out.println(doc);
            }

        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        //System.out.println(lista_unis);
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
