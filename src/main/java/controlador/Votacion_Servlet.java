package controlador;

import DAOs.PublicacionDAO;
import DAOs.UsuarioDAO;
import org.bson.Document;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

//! este servet lo hice como 4 o 5 veces porque tenia errores con la votación
//! me apoyé de ia porque siempre se bugeaba y no sé que pasaba con los votos, hasta se duplicaban D:
@WebServlet("/votar")
public class Votacion_Servlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");

        String id_publicacion = request.getParameter("id");
        String tipo_voto      = request.getParameter("tipo");

        HttpSession session = request.getSession();
        ObjectId id_usuario_votante = (ObjectId) session.getAttribute("_id_usuario");

        int reales = 0;
        int falsos = 0;
        int puntosUsuario = 0;
        String rangoUsuario = "Novato";

        if (id_publicacion != null && tipo_voto != null && id_usuario_votante != null)
        {
            try {
                ObjectId oid_post  = new ObjectId(id_publicacion);
                boolean  es_vigente = "vigente".equals(tipo_voto);

                PublicacionDAO postDAO = new PublicacionDAO();

                //? leer voto anterior
                String votoAnterior = "ninguno";
                Document postActual = postDAO.findOne(oid_post);
                if (postActual != null) {
                    List<Document> hist = (List<Document>) postActual.get("historial_votos");
                    if (hist != null) {
                        String uidStr = id_usuario_votante.toString();
                        for (Document v : hist) {
                            Object idV = v.get("usuario_id");
                            if (idV != null && idV.toString().equals(uidStr)) {
                                votoAnterior = Boolean.TRUE.equals(v.getBoolean("es_vigente"))
                                        ? "vigente" : "falso";
                                break;
                            }
                        }
                    }
                }
                System.out.println("[Votar] votoAnterior=" + votoAnterior + " | tipoNuevo=" + tipo_voto);


                //? actualizar historial y contadores del post
                postDAO.registrar_votoPublicacion(oid_post, id_usuario_votante, es_vigente);

                //? leer contadors frescos
                Document postFresco = postDAO.findOne(oid_post);
                if (postFresco != null) {
                    reales = postFresco.getInteger("votosVigente", 0);
                    falsos = postFresco.getInteger("votosFalso", 0);

                    //? gamificacion del autor
                    ObjectId id_autor = postFresco.getObjectId("fk_usuario_autor");
                    if (id_autor != null) {
                        UsuarioDAO usuDAO = new UsuarioDAO();
                        usuDAO.actualizar_reputacion_gamificacion(id_autor, es_vigente, votoAnterior);
                    }
                }

                //? gamificacion del votante
                UsuarioDAO usuDAO = new UsuarioDAO();
                // ? solo al sumar un voto nuevo (no al quitar)
                if (!votoAnterior.equals("ninguno") == false) { // es primer voto en este post
                    usuDAO.gamificacion_por_voto_dado(id_usuario_votante);
                }
                //? siempre llamar para cubrir el caso de toggle y cambio
                usuDAO.gamificacion_por_voto_dado(id_usuario_votante);

                //? leer puntos y medallas 'frescas'
                Document votanteFresco = usuDAO.findOne(id_usuario_votante);
                if (votanteFresco != null) {
                    puntosUsuario = votanteFresco.getInteger("puntos", 0);
                    rangoUsuario  = votanteFresco.getString("rango");
                    if (rangoUsuario == null) rangoUsuario = "Novato";
                    session.setAttribute("puntos",     puntosUsuario);
                    session.setAttribute("rango",      rangoUsuario);
                    // Actualizar medallas en sesión para que el sidebar se refresque
                    java.util.List<String> medallasFrescas =
                        (java.util.List<String>) votanteFresco.get("medallas");
                    if (medallasFrescas == null) medallasFrescas = new java.util.ArrayList<>();
                    session.setAttribute("misMedallas", medallasFrescas);
                }

            } catch (Exception e) {
                System.err.println("[Votar] Error: " + e.getMessage());
                e.printStackTrace();
            }
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(
            "{\"reales\":" + reales +
            ",\"falsos\":" + falsos +
            ",\"puntos\":" + puntosUsuario +
            ",\"rango\":\"" + rangoUsuario + "\"}"
        );
        response.getWriter().flush();
    }
}
