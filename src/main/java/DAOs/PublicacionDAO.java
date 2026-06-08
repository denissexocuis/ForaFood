package DAOs;

// el usuario se podrá registrar y asi jejejse

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

public class PublicacionDAO implements  CRUD<Publicacion>
{
    private MongoCollection<Document> collection = ConexionMongo.getDatabase().getCollection("Publicacion");
    // metodosss, TODO

    void validar(int voto_estudiante)
    {

    }

    @SuppressWarnings("all")
    public void registrar_votoPublicacion(ObjectId id_publicacion, ObjectId id_usuario, boolean es_vigente)
    {
        System.out.println("[PublicacionDAO] registrando voto de la publicacion...");
        try
        {
            System.out.println("[PublicacionDAO] buscando publicacion en la bd...");
            //?buscar la publicación de la base de datos de acuerdo a su id
            Document publicacion_atlas = collection.find(Filters.eq("_id", id_publicacion)).first();
            if(publicacion_atlas == null) return;

            //? buscar el id del autor de esa publicación de acuerdo a la publicación_atlas que se encontró :D
            ObjectId id_autor = publicacion_atlas.getObjectId("fk_usuario_autor");
            // checar si el voto que se hizo es real o falso
            String tipo_nuevo = es_vigente ? "real" : "falso";

            //? extraer el historial de votos (si es null, se crea una lista vacía)
            //?esto es para tener un control del usuario que votó y ver si ya votó algo
            List<Document> historial = (List<Document>) publicacion_atlas.get("historial_votos");
            if(historial == null)
            {
                historial = new ArrayList<>();
            }

            //? buscar si ese usuario ya votó antes en el post
            Document voto_anterior = null;
            for (Document v : historial)
            {
                if (v.getObjectId("id_usuario_votante").equals(id_usuario)) {
                    voto_anterior = v;
                    break;
                }
            }

            //? variables para ver cuanto le vamos a sumar o restar a los contadores
            //?// esto lo saque de ia btw
            int inc_vigente = 0;
            int inc_falso = 0;
            boolean cambio_reputacion = false;

            if (voto_anterior == null)
            {
                //* primer voto del usuario?
                inc_vigente= es_vigente ? 1 : 0;
                inc_falso = !es_vigente ? 1 : 0;

                historial.add(new Document("id_usuario_votante", id_usuario).append("tipo", tipo_nuevo));

            } else {
                //* el usuario ya había votado antes?
                String tipo_viejo = voto_anterior.getString("tipo");

                if (tipo_viejo.equals(tipo_nuevo))
                {
                    // si presionó el mismo botón
                    inc_vigente = es_vigente ? -1 : 0;
                    inc_falso = !es_vigente ? -1 : 0;

                    historial.remove(voto_anterior);
                } else {
                    //* alternó entre real y falso
                    inc_vigente = es_vigente ? 1 : -1;
                    inc_falso = !es_vigente ? 1 : -1;

                    voto_anterior.put("tipo", tipo_nuevo);
                }
            }

            //? mandar la actualización combinada al Post en Atlas
            Bson actualizacion_publicacion = Updates.combine(
                    Updates.inc("votosVigente", inc_vigente),
                    Updates.inc("votosFalso", inc_falso),
                    Updates.set("historial_votos", historial)
            );
            collection.updateOne(Filters.eq("_id", id_publicacion), actualizacion_publicacion);
            System.out.println("[PostDAO] Contadores del post actualizados: Vigentes(" + inc_vigente + ") Falsos(" + inc_falso + ")");

            //* actualizar la reputación del creador de la publicación si es que hubo cambio
            if (cambio_reputacion)
            {
                UsuarioDAO userDAO = new UsuarioDAO();
                // checar si fue un voto positivo o no
                boolean fue_voto_positivo = (inc_vigente > 0 || inc_falso < 0);
                userDAO.actualizar_reputacion_gamificacion(id_autor, fue_voto_positivo);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void generar_reporte(String motivo)
    {

    }

    public List<Document> buscar_portexto(ObjectId ID_Universidad, String texto)
    {
        List<Document> resultados_filtrados = new ArrayList<>();
        try
        {
            // TODO
            List<Bson> condiciones = new ArrayList<>();

            // se filtra por universidad
            condiciones.add(Filters.eq("fk_universidad", ID_Universidad));

            // si el usuario escribió algo en la barra, filtrar por coincidencia de texto
            //* uso de IA aquí abajitou
            if (texto != null && !texto.trim().isEmpty())
            {
                // "i" es para que ignore mayúsculas y minúsculas (case-insensitive)
                condiciones.add(Filters.regex("texto_publicacion", texto, "i"));
            }
            // juntar todos los filtros con un AND
            Bson filtro = Filters.and(condiciones);

            // agregar el método sort antes del bucle, esto es para que aparezcan los más recientes!!
            FindIterable<Document> documentos = collection.find(filtro)
                    .sort(Sorts.descending("_id"));

            for (Document doc : documentos)
            {
                resultados_filtrados.add(doc);
            }

            System.out.println("[PublicacionDAO] se hace búsqueda para '" + texto + "' y devolvió " + resultados_filtrados.size() + " resultados");

        }
        catch (Exception e)
        {
            System.out.println("[PublicacionDAO] error al buscar publicaciones por texto:c");
            e.printStackTrace();
        }
        return resultados_filtrados;
    }

    // 🎯 MÉTODO TRASLADADO AL DAO: Calcula el promedio matemático y actualiza Atlas
    //? calcular el promedio que tiene un local
    public double recalcular_promedio(ObjectId idPost)
    {
        Bson filtroPost = Filters.eq("_id", idPost);
        Document postActualizado = collection.find(filtroPost).first();
        double nuevoPromedio = 5.0;

        if (postActualizado != null) {
            List<Document> todosLosComentarios = (List<Document>) postActualizado.get("comentarios");
            if (todosLosComentarios != null && !todosLosComentarios.isEmpty()) {
                double suma = 0;
                for (Document c : todosLosComentarios) {
                    // Buscamos la calificación, si por alguna razón es nula usamos 5 por defecto
                    Integer calif = c.getInteger("calificacion");
                    suma += (calif != null) ? calif : 5;
                }
                nuevoPromedio = suma / todosLosComentarios.size();
                nuevoPromedio = Math.round(nuevoPromedio * 10.0) / 10.0; // Redondea a un decimal (ej: 4.7)
            }
        }

        // Persistimos el promedio directamente en el documento de Atlas
        collection.updateOne(filtroPost, Updates.set("calificacion_promedio", nuevoPromedio));

        return nuevoPromedio;
    }

    // métodos CRUD
    @Override
    public boolean insertOne(Publicacion post)
    {
        List<Document> lista_multimedia_docs = new ArrayList<>();

        if (post.getMultimedia() != null)
        {
            // crear documentos con atributos del javabean Multimedia.java
            for (Multimedia media : post.getMultimedia())
            {
                Document mediaDoc = new Document()
                        .append("ID_Multimedia", media.getID_Multimedia())
                        .append("url", media.getUrl())
                        .append("fecha_subida", media.getFecha_subida());

                lista_multimedia_docs.add(mediaDoc);
            }
        }

        //? insertar documento de la publicacion
        Document doc = new Document()
                .append("titulo", post.getTitulo())
                .append("texto_publicacion", post.getTexto_publicacion())
                .append("multimedia", lista_multimedia_docs)
                .append("url_foto", post.getUrl_foto())
                .append("votosVigente", post.getVotosVigente())
                .append("votosFalso", post.getVotosFalso())
                .append("fecha", post.getFecha())
                .append("es_valida", post.isEs_valida())
                .append("fk_establecimiento", post.getFk_establecimiento())
                .append("fk_universidad", post.getFk_universidad())
                .append("fk_usuario_autor", post.getFk_usuario_autor())
                .append("nombre_autor", post.getNombre_autor())
                .append("foto_perfil_autor", post.getFoto_perfil_autor())
                .append("comentarios", post.getComentarios())
                .append("historial_votos", new ArrayList<>());

        collection.insertOne(doc);
        return true;
    }

    @Override
    public void deleteOne(ObjectId id)
    {
        collection.deleteOne(new Document("_id", id));
    }

    @Override
    public void updateOne(Publicacion object)
    {

    }

    @Override
    public Document findOne(ObjectId id)
    {
        return collection.find(new Document("_id", id)).first();
    }

    @Override
    public List<Document> findAll()
    {
        return null;
    }

    public MongoCollection<Document> getCollection()
    {
        return collection;
    }

    public void setCollection(MongoCollection<Document> collection)
    {
        this.collection = collection;
    }
}
