package modelo;
import java.io.Serializable;
import java.util.List;

// javabean, este es un catálogo de universidades
public class Universidad implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Universidad;
    private String nombre_uni;

    private int fk_ubicacion;

    public int getID_Universidad()
    {
        return ID_Universidad;
    }

    public void setID_Universidad(int ID_Universidad)
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

    // metodos

    // TODO
    
    List listar_facultades()
    {
        return null;
    }
}
