package modelo;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class Establecimiento implements Serializable
{
    private static final long serialVersionUID = 1L;
    private int ID_Establecimiento;
    private String nombre_estab, horario_servicio, descripcion, rango_precios;
    private float calificacion;
    private boolean descuento_estudiante;

    private int fk_ubicacion, fk_multimetia, fk_metodo_pago;

    public Establecimiento()
    {}

    public int getID_Establecimiento()
    {
        return ID_Establecimiento;
    }

    public void setID_Establecimiento(int ID_Establecimiento)
    {
        this.ID_Establecimiento = ID_Establecimiento;
    }

    public String getNombre_estab()
    {
        return nombre_estab;
    }

    public void setNombre_estab(String nombre_estab)
    {
        this.nombre_estab = nombre_estab;
    }

    public String getHorario_servicio()
    {
        return horario_servicio;
    }

    public void setHorario_servicio(String horario_servicio)
    {
        this.horario_servicio = horario_servicio;
    }

    public String getDescripcion()
    {
        return descripcion;
    }

    public void setDescripcion(String descripcion)
    {
        this.descripcion = descripcion;
    }

    public String getRango_precios()
    {
        return rango_precios;
    }

    public void setRango_precios(String rango_precios)
    {
        this.rango_precios = rango_precios;
    }

    public float getCalificacion()
    {
        return calificacion;
    }

    public void setCalificacion(float calificacion)
    {
        this.calificacion = calificacion;
    }

    public boolean isDescuento_estudiante()
    {
        return descuento_estudiante;
    }

    public void setDescuento_estudiante(boolean descuento_estudiante)
    {
        this.descuento_estudiante = descuento_estudiante;
    }

    public int getFk_ubicacion()
    {
        return fk_ubicacion;
    }

    public void setFk_ubicacion(int fk_ubicacion)
    {
        this.fk_ubicacion = fk_ubicacion;
    }

    public int getFk_multimetia()
    {
        return fk_multimetia;
    }

    public void setFk_multimetia(int fk_multimetia)
    {
        this.fk_multimetia = fk_multimetia;
    }

    public int getFk_metodo_pago()
    {
        return fk_metodo_pago;
    }

    public void setFk_metodo_pago(int fk_metodo_pago)
    {
        this.fk_metodo_pago = fk_metodo_pago;
    }

    // metodos, todo

    float cal_promedio_calif()
    {
        return 0;
    }

    void mostrar_menu()
    {

    }

    void mostrar_promociones(Date fecha)
    {

    }

    // esto creo lo modificare
    void actualizar(String datos)
    {

    }

    List locales_cercanos(String geopunto, int radio)
    {
        return null;
    }

}
