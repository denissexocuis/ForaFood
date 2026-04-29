package DAOs;

// el usuario se podrá registrar y asi jsdjsdf

// https://foojay.io/today/abstracting-data-access-in-java-with-the-dao-pattern/



import com.mongodb.client.MongoCollection;
import modelo.Usuario;

import org.bson.Document;

public class UsuarioDAO implements CRUD<Usuario>
{
    // usando la clase ConexionMongo para seleccionar la base de datos
    //MongoDatabase database = ConexionMongo.getDb();
    //this.collection = database.getCollection("Usuario");

    // hice una funcion solo para seleccionar la coleccion ya asi rapido  y no tener que estar haciendo eso a cada rato sjdfjsdf

    private final MongoCollection<Document> collection = ConexionMongo.seleccionar_coleccion("Usuario");

    void registrarse(String email, String passw, String nombre, String paterno, String materno, String nombre_user)
    {

    }

    // para el CRUD
    @Override
    public void insertOne(Usuario user)
    {
        // aqui pedí ayuda de una IA porque busqué en varias paginas y me daban cosas bien bizarras T.T, no sabía como hacerle el insert D:
        Document doc = new Document()
                .append("nombre_user", user.getNombre_user())
                .append("email", user.getEmail())
                .append("passw_hash", user.getPassw_hash())
                .append("fk_universidad", user.getFk_universidad());

        collection.insertOne(doc);
    }

    @Override
    public void findOne(Usuario user)
    {

    }

    @Override
    public void find(Usuario user)
    {

    }

    @Override
    public void deleteOne(Usuario user)
    {

    }

    @Override
    public void updateOne(Usuario user)
    {

    }
}
