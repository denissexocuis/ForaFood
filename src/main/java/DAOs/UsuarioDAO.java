package DAOs;

// el usuario se podrá registrar y asi jsdjsdf

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelo.Usuario;

import org.bson.Document;

public class UsuarioDAO
{
    private final MongoCollection<Document> collection;

    public UsuarioDAO()
    {
        // usando la clase ConexionMongo para seleccionar la base de datos
        //MongoDatabase database = ConexionMongo.getDb();
        //this.collection = database.getCollection("Usuario");

        // hice una funcion solo para seleccionar la coleccion ya asi rapido  y no tener que estar
        collection = ConexionMongo.seleccionar_coleccion("Usuario");
    }

    // insertar un usuario en la coleccion
    public void insertar(Usuario user)
    {
        // aqui pedí ayuda de una IA porque busqué en varias paginas y me daban cosas bien bizarras T.T
        Document doc = new Document()
                .append("nombre_user", user.getNombre_user())
                .append("email", user.getEmail())
                .append("passw_hash", user.getPassw_hash())
                .append("fk_universidad", user.getFk_universidad());

        collection.insertOne(doc);
    }
}
