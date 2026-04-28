package modelo;
import java.io.Serializable;
import java.util.Date;

public class Multimedia implements Serializable
{
    private static final long serialVersionUID = 1L;

    private int ID_Multimedia;
    private String url;
    private Date fecha_subida;

    private int fk_usuario, fk_establecimiento;

    public Multimedia()
    {
    }

    public int getID_Multimedia()
    {
        return ID_Multimedia;
    }

    public void setID_Multimedia(int ID_Multimedia)
    {
        this.ID_Multimedia = ID_Multimedia;
    }

    public String getUrl()
    {
        return url;
    }

    public void setUrl(String url)
    {
        this.url = url;
    }

    public Date getFecha_subida()
    {
        return fecha_subida;
    }

    public void setFecha_subida(Date fecha_subida)
    {
        this.fecha_subida = fecha_subida;
    }

    public int getFk_usuario()
    {
        return fk_usuario;
    }

    public void setFk_usuario(int fk_usuario)
    {
        this.fk_usuario = fk_usuario;
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
    void subir_multimedia(String archivo, int id_propietario)
    {

    }

    void eliminar_multimedia(int id_multimedia)
    {

    }
}
