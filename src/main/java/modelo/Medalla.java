package modelo;
import java.io.Serializable;

public class Medalla implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Medalla;
    private String nombre_medalla, descripcion;

    public Medalla()
    {
    }

    public int getID_Medalla()
    {
        return ID_Medalla;
    }

    public void setID_Medalla(int ID_Medalla)
    {
        this.ID_Medalla = ID_Medalla;
    }

    public String getNombre_medalla()
    {
        return nombre_medalla;
    }

    public void setNombre_medalla(String nombre_medalla)
    {
        this.nombre_medalla = nombre_medalla;
    }

    public String getDescripcion()
    {
        return descripcion;
    }

    public void setDescripcion(String descripcion)
    {
        this.descripcion = descripcion;
    }

    // metodos, TODO
    void asignar_medalla(int id_usuario)
    {

    }

    void quitar_medalla(int id_usuario)
    {

    }

}
