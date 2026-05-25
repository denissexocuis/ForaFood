package modelo;
import org.bson.types.ObjectId;

import java.io.Serializable;
import java.util.List;

// javabean, este es un catálogo de universidades
public class Universidad implements Serializable
{
    private static final long serialVersionUID = 1L;
    private ObjectId ID_Universidad;
    private String nombre_uni;
    private String dominio;

    public Universidad()
    {
    }

    private int fk_ubicacion;

    public ObjectId getID_Universidad()
    {
        return ID_Universidad;
    }

    public void setID_Universidad(ObjectId ID_Universidad)
    {
        this.ID_Universidad = ID_Universidad;
    }

    public String getNombre_uni()
    {
        return nombre_uni;
    }

    public void setNombre_uni(String nombre_uni)
    {
        this.nombre_uni = nombre_uni;
    }

    public int getFk_ubicacion()
    {
        return fk_ubicacion;
    }

    public void setFk_ubicacion(int fk_ubicacion)
    {
        this.fk_ubicacion = fk_ubicacion;
    }

    public String getDominio()
    {
        return dominio;
    }

    public void setDominio(String dominio)
    {
        this.dominio = dominio;
    }

    // metodos

    // TODO

    List listar_facultades()
    {
        return null;
    }
}
