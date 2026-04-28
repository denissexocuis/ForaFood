package modelo;
import java.io.Serializable;

// catalogo-bean jsdjsdf
public class Categoria implements Serializable
{
    private static final long serialVersionUID = 1L;

    private int ID_Categoria;
    private String nombre_categoria;

    public Categoria()
    {}

    public int getID_Categoria()
    {
        return ID_Categoria;
    }

    public void setID_Categoria(int ID_Categoria)
    {
        this.ID_Categoria = ID_Categoria;
    }

    public String getNombre_categoria()
    {
        return nombre_categoria;
    }

    public void setNombre_categoria(String nombre_categoria)
    {
        this.nombre_categoria = nombre_categoria;
    }
}
