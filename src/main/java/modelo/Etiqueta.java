package modelo;
import java.io.Serializable;
import java.util.List;

public class Etiqueta implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Etiqueta;
    private String nombre_etiqueta;

    public Etiqueta()
    {}

    public int getID_Etiqueta()
    {
        return ID_Etiqueta;
    }

    public void setID_Etiqueta(int ID_Etiqueta)
    {
        this.ID_Etiqueta = ID_Etiqueta;
    }

    public String getNombre_etiqueta()
    {
        return nombre_etiqueta;
    }

    public void setNombre_etiqueta(String nombre_etiqueta)
    {
        this.nombre_etiqueta = nombre_etiqueta;
    }

    // metodos TODO

    List filtar(String nombre_etiqueta)
    {
        return null;
    }

    List top_etiquetas(int limite)
    {
        return null;
    }


}
