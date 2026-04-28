package modelo;
import java.io.Serializable;

public class Metodo_Pago implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Metodo;
    private String nombre;

    public Metodo_Pago()
    {}

    public int getID_Metodo()
    {
        return ID_Metodo;
    }

    public void setID_Metodo(int ID_Metodo)
    {
        this.ID_Metodo = ID_Metodo;
    }

    public String getNombre()
    {
        return nombre;
    }

    public void setNombre(String nombre)
    {
        this.nombre = nombre;
    }

    // es un catalogo-bean jsjs
}
