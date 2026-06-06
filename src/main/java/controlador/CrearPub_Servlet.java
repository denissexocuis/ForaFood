package controlador;

import DAOs.EstablecimientoDAO;
import DAOs.PublicacionDAO;
import modelo.Establecimiento;
import modelo.Publicacion;
import org.bson.Document;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.annotation.MultipartConfig; // para la galeria

@WebServlet("/crearpost") // remplazar al web.xml
//? lo de agregar imagenes me ayudé de ia
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB máximo por foto
        maxRequestSize = 1024 * 1024 * 50     // 50MB máximo por petición total
)
public class CrearPub_Servlet extends HttpServlet
{
    //* el usuario inserta un post en la base de datos :D
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        //? codificación UTF-8 para que no se rompan los acentos ni la 'ñ'
        request.setCharacterEncoding("UTF-8");
        System.out.println("[CrearPost_Servlet POST] recibiendo datos del formulario...");

        //  validar sesión del usuario
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null)
        {
            System.out.println("[CrearPost_Servlet] sesión no válida...");
            response.sendRedirect("index.jsp");
            return;
        }

        //! sesion validada, proceder...

        // obtener universidad que se mandó desde el login al home
        ObjectId id_user_sesion = (ObjectId) session.getAttribute("_id_usuario");
        ObjectId ID_Uni_sesion = (ObjectId) session.getAttribute("fk_universidad");
        String nombre_user_sesion = (String) session.getAttribute("user");

        //? obtener foto de perfil del usuario :D
        String foto_usuario_logeado = (String) session.getAttribute("foto_perfil");
        if (foto_usuario_logeado == null) {
            foto_usuario_logeado = "img/avatar-default.png"; // por si acaso no subió foto
        }

        try
        {
            // ? recuperar los inputs del jsp
            String titulo = request.getParameter("txtTitulo");
            String texto_publicacion = request.getParameter("txtDescripcion");

            // procesar imagne desde el almacenamiento
            Part filePart = request.getPart("fileImagen");
            String ruta_foto_final = "img/default-post.png"; // por si no sube nada

            //? lo de la imagen y el geopunto lo saqué de ia
            if (filePart != null && filePart.getSize() > 0) {
                String nombre_archivo = filePart.getSubmittedFileName();
                System.out.println("[CrearPost_Servlet] El usuario subió el archivo: " + nombre_archivo);

                //? ruta absoluta en el sv para guardar la foto
                String ruta_destino_sv = getServletContext().getRealPath("/") + "img/posts/";

                //? asegurar q la carpeta exista
                java.io.File directorio = new java.io.File(ruta_destino_sv);
                if (!directorio.exists()) {
                    directorio.mkdirs();
                }

                // Clonar el archivo de la computadora al servidor
                //? clonar el archivo de la compu al servidor
                filePart.write(ruta_destino_sv + nombre_archivo);
                ruta_foto_final = "img/posts/" + nombre_archivo;
            }

            //? ubicación y geopunto
            ObjectId fk_establecimiento_final = null;

            String id_existente = request.getParameter("idUbicacionExistente");
            String nuevo_nombre_local = request.getParameter("nuevoNombreLocal");

            //? si el id no es null quiere decir que ya habia una ubi
            if (id_existente != null && !id_existente.isEmpty()) {
                //? el estudiante seleccionó un pin que ya existía
                System.out.println("[CrearPost_Servlet] Usando local existente con ID: " + id_existente);
                fk_establecimiento_final = new ObjectId(id_existente);
            }
            else if (nuevo_nombre_local != null && !nuevo_nombre_local.isEmpty()) {
                //? el estudiante picó en una zona vacía y descubrió un lugar nuevo
                System.out.println("[CrearPost_Servlet] Registrando NUEVO local: " + nuevo_nombre_local);

                double lat = Double.parseDouble(request.getParameter("nuevoLat"));
                double lng = Double.parseDouble(request.getParameter("nuevoLng"));

                //? instanciar JavaBean de establecimiento
                Establecimiento nuevoEstablecimiento = new Establecimiento();
                ObjectId nuevo_id_local = new ObjectId();

                nuevoEstablecimiento.setID_Establecimiento(nuevo_id_local);
                nuevoEstablecimiento.setNombre_estab(nuevo_nombre_local);
                nuevoEstablecimiento.setGeopunto(lng, lat);
                nuevoEstablecimiento.setFk_universidad(ID_Uni_sesion);

                //? atrbituos por defecto porque el local se acaba de agregar al mapa
                nuevoEstablecimiento.setCalificacion(5.0f);
                nuevoEstablecimiento.setDescripcion("Establecimiento agregado por la comunidad estudiantil.");

                //? insertar a mongo
                EstablecimientoDAO establecimientoDAO = new EstablecimientoDAO();
                boolean exito_local = establecimientoDAO.insertOne(nuevoEstablecimiento);

                if (exito_local)
                {
                    //? si se insertó bien asignar el id del nuevo local a la publicacion
                    fk_establecimiento_final = nuevo_id_local;
                } else
                {
                    System.out.println("[CrearPost_Servlet] Error al insertar el establecimiento en la BD.");
                }

            } else {
                //? el estudiante eligió ' no se' u omtió la ubicación
                System.out.println("[CrearPost_Servlet] Publicación sin ubicación geográfica fija.");
            }

            //? METER EN JAVA BEAN
            Publicacion nuevoPost = new Publicacion();
            nuevoPost.setTitulo(titulo);
            nuevoPost.setTexto_publicacion(texto_publicacion);
            // nuevoPost.setRuta_imagen(rutaFotoFinal); // ya no porque se maneja como una imagen y no url
            nuevoPost.setEs_valida(true);
            nuevoPost.setComentarios(new ArrayList<>());
            nuevoPost.setNombre_autor(nombre_user_sesion);
            nuevoPost.setFoto_perfil_autor(foto_usuario_logeado);

            // strings a objectid
            nuevoPost.setFk_universidad(ID_Uni_sesion);
            nuevoPost.setFk_establecimiento(fk_establecimiento_final);

            //? GUARDARLO EN LA BD
            boolean exito = new PublicacionDAO().insertOne(nuevoPost);

            if (exito)
            {
                //? si la publicación se enlazó a un local y tiene una foto, meter al array
                if (fk_establecimiento_final != null && !"img/default-post.png".equals(ruta_foto_final))
                {
                    System.out.println("[Galería] Agregando imagen al repositorio del establecimiento con addToSet...");
                    new EstablecimientoDAO().agregar_foto_galeria(fk_establecimiento_final, ruta_foto_final);
                }

                response.sendRedirect("principal");
            } else
            {
                response.sendRedirect("principal?error=db_error");
            }

        } catch (IllegalArgumentException e) {
            System.out.println("[CrearPost_Servlet] Uno de los IDs o coordenadas no tiene el formato correcto.");
            e.printStackTrace();
            response.sendRedirect("principal?error=id_invalido");
        } catch (Exception e) {
            System.out.println("[CrearPost_Servlet] un error inesperado:");
            e.printStackTrace();
            response.sendRedirect("principal?error=unknown");
        }

    }
}
