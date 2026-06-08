package modelo;
import org.bson.types.ObjectId;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class Publicacion implements Serializable
{
    private static final long serialVersionUID = 1L;
    private ObjectId ID_Publicacion;
    private String titulo,
                    texto_publicacion;
    private List<Multimedia> multimedia;
    private Date fecha;
    private boolean es_valida;
    private List<String> comentarios;
    private String url_foto;

    private ObjectId fk_usuario_autor,
                    fk_establecimiento,
                    fk_universidad;
    // para lo de tipo waze :D
    private int votosVigente;
    private int votosFalso;

    private String nombre_autor;
    private String foto_perfil_autor;

    public Publicacion()
    {}

    public ObjectId getID_Publicacion()
    {
        return ID_Publicacion;
    }

    public void setID_Publicacion(ObjectId ID_Publicacion)
    {
        this.ID_Publicacion = ID_Publicacion;
    }

    public String getTitulo()
    {
        return titulo;
    }

    public void setTitulo(String titulo)
    {
        this.titulo = titulo;
    }

    public String getTexto_publicacion()
    {
        return texto_publicacion;
    }

    public void setTexto_publicacion(String texto_publicacion)
    {
        this.texto_publicacion = texto_publicacion;
    }

    public Date getFecha()
    {
        return fecha;
    }

    public void setFecha(Date fecha)
    {
        this.fecha = fecha;
    }

    public boolean isEs_valida()
    {
        return es_valida;
    }

    public void setEs_valida(boolean es_valida)
    {
        this.es_valida = es_valida;
    }

    public List<String> getComentarios()
    {
        return comentarios;
    }

    public void setComentarios(List<String> comentarios)
    {
        this.comentarios = comentarios;
    }

    public ObjectId getFk_establecimiento()
    {
        return fk_establecimiento;
    }

    public void setFk_establecimiento(ObjectId fk_establecimiento)
    {
        this.fk_establecimiento = fk_establecimiento;
    }

    public ObjectId getFk_universidad()
    {
        return fk_universidad;
    }

    public void setFk_universidad(ObjectId fk_universidad)
    {
        this.fk_universidad = fk_universidad;
    }

    public int getVotosVigente()
    {
        return votosVigente;
    }

    public void setVotosVigente(int votosVigente)
    {
        this.votosVigente = votosVigente;
    }

    public int getVotosFalso()
    {
        return votosFalso;
    }

    public void setVotosFalso(int votosFalso)
    {
        this.votosFalso = votosFalso;
    }

    public List<Multimedia> getMultimedia()
    {
        return multimedia;
    }

    public void setMultimedia(List<Multimedia> multimedia)
    {
        this.multimedia = multimedia;
    }

    public ObjectId getFk_usuario_autor()
    {
        return fk_usuario_autor;
    }

    public void setFk_usuario_autor(ObjectId fk_usuario_autor)
    {
        this.fk_usuario_autor = fk_usuario_autor;
    }

    public String getNombre_autor()
    {
        return nombre_autor;
    }

    public void setNombre_autor(String nombre_autor)
    {
        this.nombre_autor = nombre_autor;
    }

    public String getFoto_perfil_autor()
    {
        return foto_perfil_autor;
    }

    public void setFoto_perfil_autor(String foto_perfil_autor)
    {
        this.foto_perfil_autor = foto_perfil_autor;
    }

    public String getUrl_foto()
    {
        return url_foto;
    }

    public void setUrl_foto(String url_foto)
    {
        this.url_foto = url_foto;
    }
}
