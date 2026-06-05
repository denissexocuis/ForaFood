package DAOs;

// el usuario se podrá registrar y asi jsdjsdf

// https://foojay.io/today/abstracting-data-access-in-java-with-the-dao-pattern/


import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import modelo.Multimedia;
import modelo.Usuario;

import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.mindrot.jbcrypt.BCrypt;

import javax.ejb.AsyncResult;
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

    //? método para actualizar la reputación y gamificación de acuerdo de los puntos que obtiene el usuario referente a los posts
    public void actualizar_reputacion_gamificacion(ObjectId usuario_id, boolean voto_positivo)
    {
        try
        {
            // buscar datos actuales del usuario
            Document user_bd = collection.find(Filters.eq("_id", usuario_id)).first();
            // es decir, retornar todo lo que tenga el usuario en la bd
            if (user_bd == null) return; // si no existe el documento en la base de datos

            //? extraer los valores actuales (si son null, van en 0)
            int puntos_actuales = user_bd.getInteger("puntos", 0);
            int votosVigente = user_bd.getInteger("votosVigente", 0);
            int votosFalso = user_bd.getInteger("votosFalso", 0);

            // aqui use ia
            if (voto_positivo)
            {
                votosVigente += 1;
                puntos_actuales += 10; // 10 puntos por info verídica
            } else
            {
                votosFalso += 1;
            }

            // cálculo de la reputación, porcentaje de efectividad
            float total_votos = votosVigente + votosFalso; // aqui usé ia
            float nuevaReputacion = (total_votos > 0) ? ((float) votosVigente / total_votos) * 100 : 0;

            //asignar rangos según los puntos acumulados
            String nuevoRango = "Novato";
            if (puntos_actuales >= 500)
            {
                nuevoRango = "Crítico de Oro";
            } else if (puntos_actuales >= 200)
            {
                nuevoRango = "Experto";
            } else if (puntos_actuales >= 50)
            {
                nuevoRango = "Explorador";
            }

            //? mandar actualización a mongodb
            Bson actualizaciones = Updates.combine(
                    Updates.set("votosVigente", votosVigente),
                    Updates.set("votosFalso", votosFalso),
                    Updates.set("puntos", puntos_actuales),
                    Updates.set("reputacion", nuevaReputacion),
                    Updates.set("rango", nuevoRango)
            );

            // mandar las actualizaciones
            collection.updateOne(Filters.eq("_id", usuario_id), actualizaciones);
            System.out.println("[UserDAO] Gamificación actualizada para el usuario. Rango: " + nuevoRango + " | Puntos: " + puntos_actuales);

            // asignar medallas
            List<String> medallas = (List<String>) user_bd.get("medallas");
            if (puntos_actuales >= 500 && (medallas == null || !medallas.contains("🎖️ Leyenda Forafood")))
            {
                collection.updateOne(Filters.eq("_id", usuario_id), Updates.addToSet("medallas", "🎖️ Leyenda Forafood"));
                System.out.println("[UserDAO] ¡Medalla otorgada!");
            }

        } catch (Exception e) {
            e.printStackTrace();
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
        try
        {
            // para lo de abajo pedí ayuda de una IA porque busqué en varias paginas y me daban cosas bien bizarras T.T, no sabía como hacerle el insert D:
            //esta es la información que se pedirá para el registro :D
            Document doc = new Document()
                    .append("nombre_user", user.getNombre_user())
                    .append("email", user.getEmail())
                    .append("passw_hash", user.getPassw_hash())
                    .append("fk_universidad", user.getFk_universidad())
                    // atributos por defecto en cero
                    .append("puntos", 0)
                    .append("votosVigente", 0)
                    .append("votosFalso", 0)
                    .append("reputacion", 0.0)
                    .append("rango", "Novato")
                    .append("medallas", new java.util.ArrayList<String>()); // array vacío listo para llenarse

            collection.insertOne(doc);
            return true;
        } catch (Exception e)
        {
            System.out.println("[UserDAO] Error al registrar usuario:");
            e.printStackTrace();
            return false;
        }
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
