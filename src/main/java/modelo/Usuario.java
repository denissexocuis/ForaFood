package modelo;

import org.bson.types.ObjectId;

import javax.persistence.Id;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.io.Serializable;


// JabaBean

// remember that a javabean is like a container for data :D
// implements Serializable to allow data to be transferred across network or JVMs

public class Usuario implements Serializable
{
    private static final long serialVersionUID = 1L;
    @Id
    private ObjectId ID_Usuario;
    private int cant_post, puntos;
    private float reputacion;
    private String nombre_user, nombre, paterno, materno,
                    email, passw_hash, rango;
    private boolean terminos_aceptados;
    private List<String> medallas = new ArrayList<>();

    private int fk_ubicacion, fk_universidad;

    // método vacío para un jb
    public Usuario()
    {
    }

    // setters y getters

    public ObjectId getID_Usuario()
    {
        return ID_Usuario;
    }

    public void setID_Usuario(ObjectId ID_Usuario)
    {
        this.ID_Usuario = ID_Usuario;
    }

    public int getCant_post()
    {
        return cant_post;
    }

    public void setCant_post(int cant_post)
    {
        this.cant_post = cant_post;
    }

    public int getPuntos()
    {
        return puntos;
    }

    public void setPuntos(int puntos)
    {
        this.puntos = puntos;
    }

    public float getReputacion()
    {
        return reputacion;
    }

    public void setReputacion(float reputacion)
    {
        this.reputacion = reputacion;
    }

    public String getNombre_user()
    {
        return nombre_user;
    }

    public void setNombre_user(String nombre_user)
    {
        this.nombre_user = nombre_user;
    }

    public String getNombre()
    {
        return nombre;
    }

    public void setNombre(String nombre)
    {
        this.nombre = nombre;
    }

    public String getPaterno()
    {
        return paterno;
    }

    public void setPaterno(String paterno)
    {
        this.paterno = paterno;
    }

    public String getMaterno()
    {
        return materno;
    }

    public void setMaterno(String materno)
    {
        this.materno = materno;
    }

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getPassw_hash()
    {
        return passw_hash;
    }

    public void setPassw_hash(String passw_hash)
    {
        this.passw_hash = passw_hash;
    }

    public String getRango()
    {
        return rango;
    }

    public void setRango(String rango)
    {
        this.rango = rango;
    }

    public boolean isTerminos_aceptados()
    {
        return terminos_aceptados;
    }

    public void setTerminos_aceptados(boolean terminos_aceptados)
    {
        this.terminos_aceptados = terminos_aceptados;
    }

    public List<String> getMedallas()
    {
        return medallas;
    }

    public void setMedallas(List<String> medallas)
    {
        this.medallas = medallas;
    }

    public int getFk_ubicacion()
    {
        return fk_ubicacion;
    }

    public void setFk_ubicacion(int fk_ubicacion)
    {
        this.fk_ubicacion = fk_ubicacion;
    }

    public int getFk_universidad()
    {
        return fk_universidad;
    }

    public void setFk_universidad(int fk_universidad)
    {
        this.fk_universidad = fk_universidad;
    }


    // agregar metodos jsjsj
    // corrigiendo porque estos se van para UsuarioDAO.java D:

}
