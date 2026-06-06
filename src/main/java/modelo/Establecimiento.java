package modelo;
import org.bson.types.ObjectId;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Establecimiento implements Serializable
{
    private static final long serialVersionUID = 1L;
    private ObjectId ID_Establecimiento;
    private String nombre_estab,
            horario_servicio,
            descripcion,
            rango_precios;
    private float calificacion;
    private boolean descuento_estudiante;

    // estructura GeoJSON para el Geopunto [longitud, latitud]
    private String tipoUbicacion = "Point";
    private List<Double> coordenadas;


    private ObjectId fk_universidad;
    private List<String> galeria_fotos;
    private List<String> metodos_pago; // Ej: ["Efectivo", "Transferencia"]

    //public Establecimiento()
    //{}

    public Establecimiento() {
        this.coordenadas = new java.util.ArrayList<Double>();
        this.metodos_pago = new java.util.ArrayList<String>();
        this.galeria_fotos = new java.util.ArrayList<String>();
    }

    public ObjectId getID_Establecimiento()
    {
        return ID_Establecimiento;
    }

    public void setID_Establecimiento(ObjectId ID_Establecimiento)
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

    public String getTipoUbicacion()
    {
        return tipoUbicacion;
    }

    public void setTipoUbicacion(String tipoUbicacion)
    {
        this.tipoUbicacion = tipoUbicacion;
    }

    public List<Double> getCoordenadas()
    {
        return coordenadas;
    }

    public void setCoordenadas(List<Double> coordenadas)
    {
        this.coordenadas = coordenadas;
    }

    // setear latitud y longitud rapido
    public void setGeopunto(double lng, double lat) {
        if (this.coordenadas == null) {
            this.coordenadas = new java.util.ArrayList<Double>();
        }

        this.coordenadas.clear();
        this.coordenadas.add(lng);
        this.coordenadas.add(lat);
    }

    public ObjectId getFk_universidad()
    {
        return fk_universidad;
    }

    public void setFk_universidad(ObjectId fk_universidad)
    {
        this.fk_universidad = fk_universidad;
    }

    public List<String> getGaleria_fotos()
    {
        return galeria_fotos;
    }

    public void setGaleria_fotos(List<String> galeria_fotos)
    {
        this.galeria_fotos = galeria_fotos;
    }

    public List<String> getMetodos_pago()
    {
        return metodos_pago;
    }

    public void setMetodos_pago(List<String> metodos_pago)
    {
        this.metodos_pago = metodos_pago;
    }

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

    public List<Establecimiento> locales_cercanos(String geopunto, int radio) {
        return null;
    }

}
