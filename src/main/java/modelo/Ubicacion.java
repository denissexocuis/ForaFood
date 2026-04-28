package modelo;
import java.io.Serializable;

public class Ubicacion implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Ubicacion,
            CP, num_exterior;
    private String colonia, calle;
    private double latitud, longitud;

    private int fk_ciudad;

    public Ubicacion()
    {
    }

    public int getID_Ubicacion()
    {
        return ID_Ubicacion;
    }

    public void setID_Ubicacion(int ID_Ubicacion)
    {
        this.ID_Ubicacion = ID_Ubicacion;
    }

    public int getCP()
    {
        return CP;
    }

    public void setCP(int CP)
    {
        this.CP = CP;
    }

    public int getNum_exterior()
    {
        return num_exterior;
    }

    public void setNum_exterior(int num_exterior)
    {
        this.num_exterior = num_exterior;
    }

    public String getColonia()
    {
        return colonia;
    }

    public void setColonia(String colonia)
    {
        this.colonia = colonia;
    }

    public String getCalle()
    {
        return calle;
    }

    public void setCalle(String calle)
    {
        this.calle = calle;
    }

    public double getLatitud()
    {
        return latitud;
    }

    public void setLatitud(double latitud)
    {
        this.latitud = latitud;
    }

    public double getLongitud()
    {
        return longitud;
    }

    public void setLongitud(double longitud)
    {
        this.longitud = longitud;
    }

    public int getFk_ciudad()
    {
        return fk_ciudad;
    }

    public void setFk_ciudad(int fk_ciudad)
    {
        this.fk_ciudad = fk_ciudad;
    }

    // metodos, TODO
    boolean validar_ubi(double latidud, double longitud)
    {
        return false;
    }

    String obtener_geopunto()
    {
        return "todoo";
    }
}