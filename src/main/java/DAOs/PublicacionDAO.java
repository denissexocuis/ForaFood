package DAOs;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.model.Updates;
import modelo.Multimedia;
import modelo.Publicacion;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class PublicacionDAO implements CRUD<Publicacion>
{
    private MongoCollection<Document> collection =
            ConexionMongo.getDatabase().getCollection("Publicacion");


    //? registra o actualiza el voto de un usuario en una publicación
    public void registrar_votoPublicacion(ObjectId id_post, ObjectId id_usuario, boolean es_vigente)
    {
        try {
            Document post = collection.find(Filters.eq("_id", id_post)).first();
            if (post == null) return;

            List<Document> historial = (List<Document>) post.get("historial_votos");
            if (historial == null) historial = new ArrayList<>();

            //? buscar si el usuario ya votó
            Document voto_anterior = null;
            String   uidStr        = id_usuario.toString();
            for (Document v : historial) {
                Object idV = v.get("usuario_id");
                if (idV != null && idV.toString().equals(uidStr)) {
                    voto_anterior = v;
                    break;
                }
            }

            int inc_vigente = 0;
            int inc_falso   = 0;

            if (voto_anterior == null) {
                //? primer voto
                inc_vigente = es_vigente ? 1 : 0;
                inc_falso   = es_vigente ? 0 : 1;
                historial.add(new Document("usuario_id", id_usuario)
                        .append("es_vigente", es_vigente));
                System.out.println("[PostDAO] Caso A — primer voto");

            } else {
                boolean tipo_anterior = Boolean.TRUE.equals(voto_anterior.getBoolean("es_vigente"));

                if (tipo_anterior == es_vigente) {
                    //? desmarca su mismo voto
                    inc_vigente = es_vigente ? -1 : 0;
                    inc_falso   = es_vigente ? 0 : -1;
                    historial.remove(voto_anterior);
                    System.out.println("[PostDAO] Caso B — toggle off");

                } else {
                    //? acmbio de opinion
                    inc_vigente = es_vigente ? 1 : -1;
                    inc_falso   = es_vigente ? -1 : 1;
                    voto_anterior.put("es_vigente", es_vigente);
                    System.out.println("[PostDAO] Caso C — cambio de opinión");
                }
            }

            collection.updateOne(
                Filters.eq("_id", id_post),
                Updates.combine(
                    Updates.inc("votosVigente", inc_vigente),
                    Updates.inc("votosFalso",   inc_falso),
                    Updates.set("historial_votos", historial)
                )
            );
            System.out.println("[PostDAO] inc_vigente=" + inc_vigente + " inc_falso=" + inc_falso);

        } catch (Exception e) {
            System.err.println("[PostDAO] Error en registrar_votoPublicacion:");
            e.printStackTrace();
        }
    }

    public List<Document> buscar_portexto(ObjectId ID_Universidad, String texto)
    {
        List<Document> resultados = new ArrayList<>();
        try {
            List<Bson> condiciones = new ArrayList<>();
            condiciones.add(Filters.eq("fk_universidad", ID_Universidad));
            if (texto != null && !texto.trim().isEmpty()) {
                condiciones.add(Filters.regex("texto_publicacion", texto, "i"));
            }
            FindIterable<Document> docs = collection
                    .find(Filters.and(condiciones))
                    .sort(Sorts.descending("_id"));
            for (Document d : docs) resultados.add(d);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultados;
    }

    public double recalcular_promedio(ObjectId idPost)
    {
        Document post = collection.find(Filters.eq("_id", idPost)).first();
        double promedio = 5.0;
        if (post != null) {
            List<Document> comentarios = (List<Document>) post.get("comentarios");
            if (comentarios != null && !comentarios.isEmpty()) {
                double suma = 0;
                for (Document c : comentarios) {
                    Integer calif = c.getInteger("calificacion");
                    suma += (calif != null) ? calif : 5;
                }
                promedio = Math.round((suma / comentarios.size()) * 10.0) / 10.0;
            }
        }
        collection.updateOne(Filters.eq("_id", idPost),
                Updates.set("calificacion_promedio", promedio));
        return promedio;
    }

    //? aqui me apoyé con ia para hacer el insert de todo xD, era demasiado texto
    @Override
    public boolean insertOne(Publicacion post)
    {
        List<Document> multimediaDocs = new ArrayList<>();
        if (post.getMultimedia() != null) {
            for (Multimedia m : post.getMultimedia()) {
                multimediaDocs.add(new Document()
                        .append("ID_Multimedia",  m.getID_Multimedia())
                        .append("url",            m.getUrl())
                        .append("fecha_subida",   m.getFecha_subida()));
            }
        }
        Document doc = new Document()
                .append("titulo",              post.getTitulo())
                .append("texto_publicacion",   post.getTexto_publicacion())
                .append("multimedia",          multimediaDocs)
                .append("url_foto",            post.getUrl_foto())
                .append("votosVigente",        post.getVotosVigente())
                .append("votosFalso",          post.getVotosFalso())
                .append("fecha",               post.getFecha())
                .append("es_valida",           post.isEs_valida())
                .append("fk_establecimiento",  post.getFk_establecimiento())
                .append("fk_universidad",      post.getFk_universidad())
                .append("fk_usuario_autor",    post.getFk_usuario_autor())
                .append("nombre_autor",        post.getNombre_autor())
                .append("foto_perfil_autor",   post.getFoto_perfil_autor())
                .append("comentarios",         post.getComentarios())
                .append("historial_votos",     new ArrayList<>());
        collection.insertOne(doc);
        return true;
    }

    @Override public void deleteOne(ObjectId id) { collection.deleteOne(new Document("_id", id)); }
    @Override public void updateOne(Publicacion o) {}
    @Override public Document findOne(ObjectId id) { return collection.find(new Document("_id", id)).first(); }
    @Override public List<Document> findAll() { return null; }

    public MongoCollection<Document> getCollection() { return collection; }
    public void setCollection(MongoCollection<Document> c) { this.collection = c; }
}
