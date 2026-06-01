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
        try
        {
            //* fetch el usuario con el email :D
            Document user = this.findOne_email(email);

            // si el correo no existe en atlas, return
            if (user == null)
            {
                System.out.println("[autenticar_credenciales] el correo '" + email + "' no existe en la base de datos :C.");
                return false;
            }

            // si existe, sacar el hash guardado
            String hash_guardada = user.getString("passw_hash");

            // si el hash está vacío en la bd
            if (hash_guardada == null || hash_guardada.isEmpty())
            {
                System.out.println("[autenticar_credenciales] el usuario existe, pero su contraseña está vacía en la base de datos :C");
                return false;
            }

            // pasando a bcrypt el hash de la bd:
            System.out.println("[autenticar_credenciales] pass guardada en la bd: " + hash_guardada);

            // checar contaseña guardada con la ingresada, si son iguales
            return BCrypt.checkpw(passw, hash_guardada);

        }
        catch (IllegalArgumentException e)
        {
            // si la contraseña no está encriptada..
            System.out.println("[autenticar_credenciales] la contraseña en la BD no está encriptada correctamente (osea Invalid salt version).");
            return false;
        } catch (Exception e)
        {
            System.out.println("[autenticar_credenciales] hay otro error en la autenticación:");
            e.printStackTrace();
            return false;
        }
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
    public boolean insertOne(Usuario user)
    {

        // para lo de abajo pedí ayuda de una IA porque busqué en varias paginas y me daban cosas bien bizarras T.T, no sabía como hacerle el insert D:
        //esta es la información que se pedirá para el registro :D
        Document doc = new Document()
                .append("nombre_user", user.getNombre_user())
                .append("email", user.getEmail())
                .append("passw_hash", user.getPassw_hash())
                .append("fk_universidad", user.getFk_universidad());

        collection.insertOne(doc);
        return false;
    }

    @Override
    public Document findOne(ObjectId user)
    {
        return collection.find(new Document("_id", user)).first();
    }

    // función que hice para retornar el usuario que encuentre dependiendo del 'email'
    // esto es para el Login_Servlet
    public Document findOne_email(String email)
    {
        //Document doc = collection.find(Filters.eq("email", email)).first();
        // depurar jeje
        //System.out.println("[findOne_email] documento real que leyó java " + doc.toJson());
        return collection.find(Filters.eq("email", email)).first();
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
