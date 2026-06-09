package DAOs;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import modelo.Multimedia;
import modelo.Usuario;

import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.mindrot.jbcrypt.BCrypt;

import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO implements CRUD<Usuario>
{
    private final MongoCollection<Document> collection =
            ConexionMongo.getDatabase().getCollection("Usuario");

    public boolean autenticar_credenciales(String email, String passw)
    {
        try {
            Document user = this.findOne_email(email);
            if (user == null) return false;
            String hash = user.getString("passw_hash");
            if (hash == null || hash.isEmpty()) return false;
            return BCrypt.checkpw(passw, hash);
        } catch (IllegalArgumentException e) {
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void actualizar_reputacion_gamificacion(
            ObjectId usuario_id, boolean es_vigente, String votoAnterior)
    {
        try {
            MongoDatabase db = ConexionMongo.getDatabase();
            MongoCollection<Document> colUsuarios  = db.getCollection("Usuario");
            MongoCollection<Document> colMedallas  = db.getCollection("Medalla");

            Document user = colUsuarios.find(Filters.eq("_id", usuario_id)).first();
            if (user == null) return;

            //? tuve errores con los nombres
            if ("real".equals(votoAnterior)) votoAnterior = "vigente";

            String votoNuevo = es_vigente ? "vigente" : "falso";

            System.out.println("[Gamif] votoAnterior=" + votoAnterior + " votoNuevo=" + votoNuevo);

            int puntos = user.getInteger("puntos",       0);
            int votosVigente = user.getInteger("votosVigente", 0);
            int votosFalso = user.getInteger("votosFalso",   0);
            int cambioPuntos = 0;


            if (votoAnterior.equals("ninguno") && votoNuevo.equals("vigente")) {
                votosVigente++; cambioPuntos = +5;

            } else if (votoAnterior.equals("ninguno") && votoNuevo.equals("falso")) {
                votosFalso++;   cambioPuntos = -5;

            } else if (votoAnterior.equals("vigente") && votoNuevo.equals("vigente")) {
                // toggle off — desmarcó su voto real
                votosVigente = Math.max(0, votosVigente - 1);
                cambioPuntos = -5;

            } else if (votoAnterior.equals("falso") && votoNuevo.equals("falso")) {
                // toggle off — desmarcó su voto falso
                votosFalso = Math.max(0, votosFalso - 1);
                cambioPuntos = +5;

            } else if (votoAnterior.equals("falso") && votoNuevo.equals("vigente")) {
                votosFalso   = Math.max(0, votosFalso - 1);
                votosVigente++;
                cambioPuntos = +10;

            } else if (votoAnterior.equals("vigente") && votoNuevo.equals("falso")) {
                votosVigente = Math.max(0, votosVigente - 1);
                votosFalso++;
                cambioPuntos = -10;

            } else {
                System.out.println("[Gamif] Combinación no reconocida, sin cambio.");
                return;
            }

            puntos = Math.max(0, puntos + cambioPuntos);
            System.out.println("[Gamif] cambioPuntos=" + cambioPuntos + " puntosFinales=" + puntos);

            //? reputacion
            float total = votosVigente + votosFalso;
            float reputacion = (total > 0) ? (votosVigente / total) * 100f : 0f;

            //? asignar rango
            String rango;
            if (puntos >= 1000) rango = "👑 Leyenda";
            else if (puntos >= 500) rango = "🏆 Maestro";
            else if (puntos >= 250) rango = "⭐ Pro";
            else if (puntos >= 100) rango = "🥈 Jr.";
            else if (puntos >= 30) rango = "🥉 Explorador";
            else rango = "🌱 Novato";

            //? verificar medalla
            List<String> medallasActuales = (List<String>) user.get("medallas");
            if (medallasActuales == null) medallasActuales = new ArrayList<>();

            List<Document> medallasDisponibles = colMedallas.find(
                Filters.or(
                    Filters.and(Filters.eq("requisito_tipo", "votosVigente"),
                                Filters.lte("requisito_cantidad", votosVigente)),
                    Filters.and(Filters.eq("requisito_tipo", "puntos"),
                                Filters.lte("requisito_cantidad", puntos)),
                    Filters.and(Filters.eq("requisito_tipo", "votosFalso"),
                                Filters.lte("requisito_cantidad", votosFalso))
                )
            ).into(new ArrayList<>());

            List<String> nuevasMedallas = new ArrayList<>();
            for (Document m : medallasDisponibles) {
                String nombre = m.getString("nombre");
                if (!medallasActuales.contains(nombre)) nuevasMedallas.add(nombre);
            }

            //? guardar
            List<Bson> updates = new ArrayList<>();
            updates.add(Updates.set("puntos",       puntos));
            updates.add(Updates.set("reputacion",   reputacion));
            updates.add(Updates.set("rango",        rango));
            updates.add(Updates.set("votosVigente", votosVigente));
            updates.add(Updates.set("votosFalso",   votosFalso));
            if (!nuevasMedallas.isEmpty())
                updates.add(Updates.pushEach("medallas", nuevasMedallas));

            colUsuarios.updateOne(Filters.eq("_id", usuario_id), Updates.combine(updates));
            System.out.println("[Gamif] Guardado en Atlas: puntos=" + puntos + " rango=" + rango);

        } catch (Exception e) {
            System.err.println("[Gamif] Error:");
            e.printStackTrace();
        }
    }

    public String hashing(String contrasenia) {
        return BCrypt.hashpw(contrasenia, BCrypt.gensalt());
    }

    @Override
    public boolean insertOne(Usuario user)
    {
        try {
            Document doc = new Document()
                    .append("nombre_user",   user.getNombre_user())
                    .append("email",         user.getEmail())
                    .append("passw_hash",    user.getPassw_hash())
                    .append("fk_universidad",user.getFk_universidad())
                    .append("puntos",        0)
                    .append("votosVigente",  0)
                    .append("votosFalso",    0)
                    .append("reputacion",    0.0)
                    .append("rango",         "🌱 Novato")
                    .append("medallas",      new java.util.ArrayList<String>());
            collection.insertOne(doc);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Document findOne(ObjectId id) {
        return collection.find(new Document("_id", id)).first();
    }

    public Document findOne_email(String email) {
        return collection.find(Filters.eq("email", email)).first();
    }

    @Override public List<Document> findAll()       { return null; }
    @Override public void deleteOne(ObjectId id)    {}
    @Override public void updateOne(Usuario user)   {}

    public MongoCollection<Document> getCollection() { return collection; }

    public void gamificacion_por_publicacion(ObjectId usuario_id, String titulo_post)
    {
        try {
            MongoDatabase db = ConexionMongo.getDatabase();
            MongoCollection<Document> colUsuarios = db.getCollection("Usuario");
            MongoCollection<Document> colPosts    = db.getCollection("Publicacion");

            Document user = colUsuarios.find(Filters.eq("_id", usuario_id)).first();
            if (user == null) return;

            //? contar cuantas publicaciones tiene el usuario
            long total_posts = colPosts.countDocuments(Filters.eq("fk_usuario_autor", usuario_id));

            List<String> medallas = (List<String>) user.get("medallas");
            if (medallas == null) medallas = new ArrayList<>();

            List<Bson> updates = new ArrayList<>();

            //! medalla de primera reseña
            if (total_posts >= 1 && !medallas.contains("Primera Reseña")) {
                updates.add(Updates.addToSet("medallas", "Primera Reseña"));
                System.out.println("[Gamif] primera reseña desbloqueada");
            }

            //! medalla de 5 posts
            if (total_posts >= 5 && !medallas.contains("Taquero Mayor")) {
                updates.add(Updates.addToSet("medallas", "Taquero Mayor"));
                System.out.println("[Gamif] taquero mayor desbloqueado");
            }

            if (!updates.isEmpty())
                colUsuarios.updateOne(Filters.eq("_id", usuario_id), Updates.combine(updates));

        } catch (Exception e) {
            System.err.println("[Gamif] Error en gamificacion_por_publicacion: " + e.getMessage());
        }
    }

    public void gamificacion_por_comentario(ObjectId usuario_id)
    {
        try {
            MongoDatabase db = ConexionMongo.getDatabase();
            MongoCollection<Document> colUsuarios = db.getCollection("Usuario");
            MongoCollection<Document> colPosts    = db.getCollection("Publicacion");

            Document user = colUsuarios.find(Filters.eq("_id", usuario_id)).first();
            if (user == null) return;

            List<String> medallas = (List<String>) user.get("medallas");
            if (medallas == null) medallas = new ArrayList<>();

            //? ya tiene medalla?
            if (medallas.contains("Comentarista")) return;

            //? contar comentarios del usuario en todos los posts
            int totalComentarios = 0;
            String nombreUsuario = user.getString("nombre_user");
            for (Document post : colPosts.find()) {
                List<Document> comentarios = (List<Document>) post.get("comentarios");
                if (comentarios != null) {
                    for (Document c : comentarios) {
                        if (nombreUsuario.equals(c.getString("nombre_autor"))) totalComentarios++;
                    }
                }
            }

            if (totalComentarios >= 3) {
                colUsuarios.updateOne(
                    Filters.eq("_id", usuario_id),
                    Updates.addToSet("medallas", "Comentarista")
                );
                System.out.println("[Gamif] comentariasta desbloqueado");
            }

        } catch (Exception e) {
            System.err.println("[Gamif] Error en gamificacion_por_comentario: " + e.getMessage());
        }
    }
    
    //? otorga medalla de explorador al visitar el mapa la primera vez
    public void gamificacion_por_mapa(ObjectId usuario_id)
    {
        try {
            MongoDatabase db = ConexionMongo.getDatabase();
            MongoCollection<Document> colUsuarios = db.getCollection("Usuario");

            Document user = colUsuarios.find(Filters.eq("_id", usuario_id)).first();
            if (user == null) return;

            List<String> medallas = (List<String>) user.get("medallas");
            if (medallas == null) medallas = new ArrayList<>();

            if (!medallas.contains("Explorador")) {
                colUsuarios.updateOne(
                    Filters.eq("_id", usuario_id),
                    Updates.addToSet("medallas", "Explorador")
                );
                System.out.println("[Gamif] 🗺️ Explorador desbloqueada!");
            }
        } catch (Exception e) {
            System.err.println("[Gamif] Error en gamificacion_por_mapa: " + e.getMessage());
        }
    }

    //? otorga medalla detector al dar 5 votos en total
    public void gamificacion_por_voto_dado(ObjectId usuario_id)
    {
        try {
            MongoDatabase db = ConexionMongo.getDatabase();
            MongoCollection<Document> colUsuarios = db.getCollection("Usuario");
            MongoCollection<Document> colPosts    = db.getCollection("Publicacion");

            Document user = colUsuarios.find(Filters.eq("_id", usuario_id)).first();
            if (user == null) return;

            List<String> medallas = (List<String>) user.get("medallas");
            if (medallas == null) medallas = new ArrayList<>();
            if (medallas.contains("Detector")) return;

            // Contar cuántos posts tiene el voto de este usuario en historial
            String uidStr = usuario_id.toString();
            long votosData = 0;
            for (Document post : colPosts.find()) {
                List<Document> hist = (List<Document>) post.get("historial_votos");
                if (hist != null) {
                    for (Document v : hist) {
                        Object idV = v.get("usuario_id");
                        if (idV != null && idV.toString().equals(uidStr)) {
                            votosData++;
                            break; // un voto por post
                        }
                    }
                }
            }

            if (votosData >= 5) {
                colUsuarios.updateOne(
                    Filters.eq("_id", usuario_id),
                    Updates.addToSet("medallas", "Detector")
                );
                System.out.println("[Gamif] 🔍 Detector desbloqueada!");
            }

        } catch (Exception e) {
            System.err.println("[Gamif] Error en gamificacion_por_voto_dado: " + e.getMessage());
        }
    }

    //? esto me ayudó la ia, basicamente es para inicializar una vez SOLO si no existen
    public void inicializar_catalogo_medallas()
    {
        try {
            MongoDatabase db = ConexionMongo.getDatabase();
            MongoCollection<Document> colMedallas = db.getCollection("Medalla");

            if (colMedallas.countDocuments() > 0) {
                System.out.println("[Medallas] Catálogo ya existe, omitiendo.");
                return;
            }

            List<Document> catalogo = new ArrayList<>();
            catalogo.add(new Document("nombre","Primera Reseña") .append("requisito_tipo","posts")        .append("requisito_cantidad",1));
            catalogo.add(new Document("nombre","Detector")       .append("requisito_tipo","votos_dados")  .append("requisito_cantidad",5));
            catalogo.add(new Document("nombre","Comentarista")   .append("requisito_tipo","comentarios")  .append("requisito_cantidad",3));
            catalogo.add(new Document("nombre","Explorador")     .append("requisito_tipo","mapa")         .append("requisito_cantidad",1));
            catalogo.add(new Document("nombre","Estrella")       .append("requisito_tipo","puntos")       .append("requisito_cantidad",50));
            catalogo.add(new Document("nombre","Leyenda")        .append("requisito_tipo","puntos")       .append("requisito_cantidad",1000));
            catalogo.add(new Document("nombre","En Llamas")      .append("requisito_tipo","votosVigente") .append("requisito_cantidad",10));
            catalogo.add(new Document("nombre","Taquero Mayor")  .append("requisito_tipo","posts")        .append("requisito_cantidad",5));
            catalogo.add(new Document("nombre","Verificador")    .append("requisito_tipo","votosVigente") .append("requisito_cantidad",20));
            catalogo.add(new Document("nombre","Crítico")        .append("requisito_tipo","puntos")       .append("requisito_cantidad",200));
            catalogo.add(new Document("nombre","Foráneo Pro")    .append("requisito_tipo","puntos")       .append("requisito_cantidad",250));
            catalogo.add(new Document("nombre","Maestro")        .append("requisito_tipo","puntos")       .append("requisito_cantidad",500));

            colMedallas.insertMany(catalogo);
            System.out.println("[Medallas] Catálogo insertado: " + catalogo.size() + " medallas.");

        } catch (Exception e) {
            System.err.println("[Medallas] Error al insertar catálogo: " + e.getMessage());
        }
    }

}