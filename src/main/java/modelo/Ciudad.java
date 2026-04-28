package modelo;
import java.io.Serializable;

//javabean catalogo
public class Ciudad implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Ciudad;
    private String nombre_ciudad;

    public Ciudad()
    {
    }

    public int getID_Ciudad()
    {
        return ID_Ciudad;
    }

    public void setID_Ciudad(int ID_Ciudad)
    {
        this.ID_Ciudad = ID_Ciudad;
    }

    public String getNombre_ciudad()
    {
        return nombre_ciudad;
    }

    public void setNombre_ciudad(String nombre_ciudad)
    {
        this.nombre_ciudad = nombre_ciudad;
    }

}
