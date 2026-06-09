package DAOs;
import com.mongodb.client.*;
import org.bson.BsonInt64;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.Arrays;

// referencias
// https://www.baeldung.com/java-mongodb

public class ConexionMongo
{
    private static MongoClient mongoclient;
    private static MongoDatabase database;
    private static final String dbName = System.getenv("databaseName");
    private static final String uri = System.getenv("MONGODB_URI");

    //public static void main( String[] args ) {

    public static MongoDatabase conectar()
    {
        if(mongoclient == null)
        {
            // comentarios NO IA btw
            System.out.println("->>> Conectando con la base de datos de Mongo...");
            // aqui me conecto a mi base de datos
            mongoclient = MongoClients.create(uri);
            database = mongoclient.getDatabase(dbName);
            System.out.println("->>> Se conectó de forma exitosa :D");
        }
        return database;

            //try {
            //    // Send a ping to confirm a successful connection
            //    Document command = new Document("ping", new BsonInt64(1));
            //    db.runCommand(command);
            //    //System.out.println("Connected successfully to MongoDB!");
            //} catch (Exception e) {
            //    System.err.println("Connection failed: " + e.getMessage());
            //}

            //MongoCollection<Document> collection = db.getCollection("Usuario");

            // testing para buscar algo, si funciona aa
            // FindIterable<Document> documents = collection.find();
            //for (Document doc : documents) {
            //    System.out.println(doc);
            //} //-> si funciona btw
    //}
    }

    public static MongoDatabase getDatabase()
    {
        if(database == null) conectar();
        return database;
    }

    public void setDb(MongoDatabase db)
    {
        database = db;
    }
}
