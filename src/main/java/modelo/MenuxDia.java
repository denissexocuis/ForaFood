package modelo;
import java.awt.*;
import java.io.Serializable;

public class MenuxDia implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Menu;
    private String descripcion;
    private float precio;
    private boolean es_vigente;

    private int fk_establecimiento;

    public MenuxDia()
    {}

    public int getID_Menu()
    {
        return ID_Menu;
    }

    public void setID_Menu(int ID_Menu)
    {
        this.ID_Menu = ID_Menu;
    }

    public String getDescripcion()
    {
        return descripcion;
    }

    public void setDescripcion(String descripcion)
    {
        this.descripcion = descripcion;
    }

    public float getPrecio()
    {
        return precio;
    }

    public void setPrecio(float precio)
    {
        this.precio = precio;
    }

    public boolean isEs_vigente()
    {
        return es_vigente;
    }

    public void setEs_vigente(boolean es_vigente)
    {
        this.es_vigente = es_vigente;
    }

    public int getFk_establecimiento()
    {
        return fk_establecimiento;
    }

    public void setFk_establecimiento(int fk_establecimiento)
    {
        this.fk_establecimiento = fk_establecimiento;
    }

    // metodos, TODO
    boolean esta_disponible(String hora)
    {
        return false;
    }

    void actualizar(String descripcion, float precio)
    {

    }
}
