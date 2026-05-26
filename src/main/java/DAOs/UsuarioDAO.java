package DAOs;

// el usuario se podrá registrar y asi jsdjsdf

// https://foojay.io/today/abstracting-data-access-in-java-with-the-dao-pattern/


import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import modelo.Multimedia;
import modelo.Usuario;

import org.bson.Document;
import org.bson.types.ObjectId;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

public class UsuarioDAO implements CRUD<Usuario>
{
    // usando la clase ConexionMongo para seleccionar la base de datos
    //MongoDatabase database = ConexionMongo.getDb();
    //this.collection = database.getCollection("Usuario");

    // hice una funcion solo para seleccionar la coleccion ya asi rapido  y no tener que estar haciendo eso a cada rato sjdfjsdf ->>>> me di cuenta que esto no era necesario, entendí bien los métodos del mongo en java jejejej, upsi

    //private final MongoCollection<Document> collection = ConexionMongo.seleccionar_coleccion("Usuario");
    private final MongoCollection<Document> collection = ConexionMongo.getDatabase().getCollection("Usuario");

    // métodos principales
    void registrarse(String email, String passw, String nombre, String paterno, String materno, String nombre_user)
    {

    }

    public boolean autenticar_credenciales(String email, String passw)
    {
        //* fetch el usuario con el email :D
        Document user = (Document) collection.find(Filters.eq("email", email));

        // aqui busca la contraseña hasheada guardada en la base de datos :)
        String hash_guardada = user.getString("passw_hash");

        // verifica el input de la contraseña con la contraseña guardada
        return BCrypt.checkpw(passw, hash_guardada);
    }

    void subir_foto(Multimedia img)
    {

    }

    String actualizar_rep(int puntos)
    {
        return "TODOOO aaa";
    }

    String actualizar_rango(List medallas)
    {
        return "TODOO";
    }

    int actualizar_puntos(int puntos_nuevos)
    {
        return 1;
    }

    int cont_post()
    {
        return 1;
    }

    public String hashing(String contrasenia)
    {
        return BCrypt.hashpw(contrasenia, BCrypt.gensalt());
    }

    boolean verificar_cuenta(String email)
    {
        return false;
    }


    // métodos CRUD
    @Override
    public void insertOne(Usuario user)
    {

        // para lo de abajo pedí ayuda de una IA porque busqué en varias paginas y me daban cosas bien bizarras T.T, no sabía como hacerle el insert D:
        //esta es la información que se pedirá para el registro :D
        Document doc = new Document()
                .append("nombre_user", user.getNombre_user())
                .append("email", user.getEmail())
                .append("passw_hash", user.getPassw_hash())
                .append("fk_universidad", user.getFk_universidad());

        collection.insertOne(doc);
    }

    @Override
    public Document findOne(ObjectId user)
    {
        return collection.find(new Document("_id", user)).first();
    }

    @Override
    public List<Document> findAll()
    {
        return null;
    }

    @Override
    public void deleteOne(ObjectId id)
    {

    }

    @Override
    public void updateOne(Usuario user)
    {

    }

    public MongoCollection<Document> getCollection()
    {
        return collection;
    }
}
