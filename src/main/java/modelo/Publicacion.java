package modelo;
import java.io.Serializable;
import java.util.Date;

public class Publicacion implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Publicacion, cant_estrellas;
    private String texto_publicacion, url_imagen, titulo;
    private float puntuacion;
    private Date fecha;
    private boolean es_comentario, es_valida;

    private int fk_usuario, fk_establecimiento;

    public Publicacion()
    {}

    public int getID_Publicacion()
    {
        return ID_Publicacion;
    }

    public void setID_Publicacion(int ID_Publicacion)
    {
        this.ID_Publicacion = ID_Publicacion;
    }

    public int getCant_estrellas()
    {
        return cant_estrellas;
    }

    public void setCant_estrellas(int cant_estrellas)
    {
        this.cant_estrellas = cant_estrellas;
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

    public String getTitulo()
    {
        return titulo;
    }

    public void setTitulo(String titulo)
    {
        this.titulo = titulo;
    }

    public float getPuntuacion()
    {
        return puntuacion;
    }

    public void setPuntuacion(float puntuacion)
    {
        this.puntuacion = puntuacion;
    }

    public Date getFecha()
    {
        return fecha;
    }

    public void setFecha(Date fecha)
    {
        this.fecha = fecha;
    }

    public boolean isEs_comentario()
    {
        return es_comentario;
    }

    public void setEs_comentario(boolean es_comentario)
    {
        this.es_comentario = es_comentario;
    }

    public boolean isEs_valida()
    {
        return es_valida;
    }

    public void setEs_valida(boolean es_valida)
    {
        this.es_valida = es_valida;
    }

    public int getFk_usuario()
    {
        return fk_usuario;
    }

    public void setFk_usuario(int fk_usuario)
    {
        this.fk_usuario = fk_usuario;
    }

    public int getFk_establecimiento()
    {
        return fk_establecimiento;
    }

    public void setFk_establecimiento(int fk_establecimiento)
    {
        this.fk_establecimiento = fk_establecimiento;
    }
}
