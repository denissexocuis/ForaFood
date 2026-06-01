package modelo;
import org.bson.types.ObjectId;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class Publicacion implements Serializable
{
    private static final long serialVersionUID = 1L;
    private ObjectId ID_Publicacio;
    private int cant_estrellas;
    private String titulo,
                    texto_publicacion,
                    url_imagen;
    private Date fecha;
    private boolean es_valida;
    private List<String> comentarios;

    private ObjectId fk_usuario,
                    fk_establecimiento,
                    fk_universidad;
    // para lo de tipo waze :D
    private int votosVigente;
    private int votosFalso;

    public Publicacion()
    {}

    public ObjectId getID_Publicacio()
    {
        return ID_Publicacio;
    }

    public void setID_Publicacio(ObjectId ID_Publicacio)
    {
        this.ID_Publicacio = ID_Publicacio;
    }

    public int getCant_estrellas()
    {
        return cant_estrellas;
    }

    public void setCant_estrellas(int cant_estrellas)
    {
        this.cant_estrellas = cant_estrellas;
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

    public String getUrl_imagen()
    {
        return url_imagen;
    }

    public void setUrl_imagen(String url_imagen)
    {
        this.url_imagen = url_imagen;
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

    public ObjectId getFk_usuario()
    {
        return fk_usuario;
    }

    public void setFk_usuario(ObjectId fk_usuario)
    {
        this.fk_usuario = fk_usuario;
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
}
