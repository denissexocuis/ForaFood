<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es" data-theme="light" id="ff-root">

<!-- me inspiré de varias plantillas -->
<!-- https://plantillashtmlgratis.com/en/home/ -->
<!-- https://github.com/Dendroculus/Login-Page-Templates-->

<!-- nota: uso de IA aquí -->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>ForaFood</title>

    <link rel="stylesheet" type="text/css" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/theme.css">
    <link rel="stylesheet" href="../css/feed_style.css">

    <!-- fevicon -->
    <link rel="icon" type="image/png" href="../img/diet.png">

    <!-- fonts style -->
    <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
          integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
          crossorigin="" />

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
            integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
            crossorigin=""></script>
</head>

<body>

<%
    String userLogueado = (String) session.getAttribute("user");
    String avatarLogueado = (String) session.getAttribute("foto_perfil");
    Integer puntosLogueado = (Integer) session.getAttribute("puntos");
    String rangoLogueado = (String) session.getAttribute("rango");
    if (userLogueado == null) userLogueado = "Invitado";
    if (avatarLogueado == null) avatarLogueado = "img/avatar-default.png";
    if (puntosLogueado == null) puntosLogueado = 0;
    if (rangoLogueado == null) rangoLogueado = "Novato";

    // Sistema de rangos y XP
    int nivel = 1;
    int xpActual = puntosLogueado;
    int xpSiguiente = 100;
    String rangoDisplay = "Novato";
    String rangoEmoji = "🌱";
    if (puntosLogueado >= 1000) { nivel=6; xpSiguiente=9999; rangoDisplay="Leyenda UV"; rangoEmoji="👑"; }
    else if (puntosLogueado >= 500) { nivel=5; xpSiguiente=1000; rangoDisplay="Maestro Foráneo"; rangoEmoji="🏆"; }
    else if (puntosLogueado >= 250) { nivel=4; xpSiguiente=500; rangoDisplay="Foráneo Pro"; rangoEmoji="⭐"; }
    else if (puntosLogueado >= 100) { nivel=3; xpSiguiente=250; rangoDisplay="Foráneo Jr."; rangoEmoji="🥈"; }
    else if (puntosLogueado >= 30) { nivel=2; xpSiguiente=100; rangoDisplay="Explorador"; rangoEmoji="🥉"; }
    else { xpSiguiente=30; }
    int xpAnterior = (nivel==1)?0:(nivel==2)?0:(nivel==3)?30:(nivel==4)?100:(nivel==5)?250:500;
    int xpPct = (xpSiguiente > xpAnterior) ? Math.min(100, (puntosLogueado - xpAnterior) * 100 / (xpSiguiente - xpAnterior)) : 100;
%>

<div id="sidebar-izquierdo" class="sidebar-left position-relative" style="transition: all 0.3s ease-in-out; overflow-y: auto; overflow-x: hidden;">

    <a class="ff-logo" href="principal"><span>fora</span><span class="accent">food</span></a>

    <!-- Toggle claro/oscuro -->
    <div class="ff-theme-toggle" onclick="toggleTheme()" title="Cambiar tema" style="margin-bottom:4px;justify-content:flex-start;gap:8px;">
        <div class="toggle-track"><div class="toggle-knob"></div></div>
        <span id="theme-label" style="font-size:12px;color:var(--text-2);font-weight:600;">Modo oscuro</span>
    </div>

    <!-- Perfil gamificado -->
    <div class="ff-profile-card">
        <div class="ff-avatar-wrap">
            <img src="<%= avatarLogueado %>" alt="Avatar" onerror="this.src='img/avatar-default.png';">
            <div class="ff-level-badge">Nv.<%= nivel %></div>
        </div>
        <div class="ff-profile-name"><%= userLogueado %></div>
        <div class="ff-rank-pill"><%= session.getAttribute("rango") %></div>
        <div class="ff-pts-display">🏆 <strong><%= puntosLogueado %></strong> pts totales</div>
        <div class="ff-xp-wrap">
            <div class="ff-xp-track">
                <div class="ff-xp-fill" style="width:<%= xpPct %>%;"></div>
            </div>
            <div class="ff-xp-label"><%= puntosLogueado %> / <%= xpSiguiente %> XP → sig. rango</div>
        </div>
        <a href="perfil" class="ff-edit-link">⚙️ Editar perfil y ajustes</a>
    </div>

    <!-- Medallas -->
    <div class="ff-medals-box">
        <div class="ff-medals-title">🏅 Mis medallas</div>
        <div class="ff-medals-grid">
            <c:forEach var="medalla" items="${sessionScope.misMedallas}">
                <div class="ff-medal" title="${medalla}"><span style="font-size:15px;">⭐</span></div>
            </c:forEach>
            <c:if test="${empty sessionScope.misMedallas}">
                <div class="ff-medal locked" title="Sin desbloquear">🍕</div>
                <div class="ff-medal locked" title="Sin desbloquear">🔍</div>
                <div class="ff-medal locked" title="Sin desbloquear">💬</div>
                <div class="ff-medal locked" title="Sin desbloquear">🗺️</div>
                <div class="ff-medal locked" title="Sin desbloquear">⭐</div>
                <div class="ff-medal locked" title="Sin desbloquear">👑</div>
                <div class="ff-medal locked" title="Sin desbloquear">🔥</div>
                <div class="ff-medal locked" title="Sin desbloquear">🌮</div>
            </c:if>
        </div>
    </div>

    <!-- Navegación -->
    <div class="ff-nav-section">Explorar</div>
    <button class="ff-nav-link active" onclick="window.location='principal'"><span class="ico">🏠</span> Inicio</button>
    <button class="ff-nav-link" onclick="window.location='mapa'"><span class="ico">📍</span> Lugares</button>
    <button class="ff-nav-link"><span class="ico">⭐</span> Favoritos</button>
    <button class="ff-nav-link"><span class="ico">👥</span> Comunidad</button>

    <div class="ff-nav-section">Mi cuenta</div>
    <button class="ff-nav-link" onclick="window.location='perfil'"><span class="ico">👤</span> Perfil</button>
    <button class="ff-nav-link" onclick="window.location='perfil'"><span class="ico">⚙️</span> Ajustes</button>

    <a href="mapa" class="ff-btn-mapa">🗺️ Ver mapa completo</a>
    <a href="../index.jsp" class="ff-logout">Cerrar sesión</a>

</div>

<div class="main-content">

    <div class="ff-header-feed">
        <div style="display:flex;align-items:center;gap:10px;">
            <button id="btn-mostrar-izq" class="btn btn-sm btn-outline-success border-0" onclick="toggleSidebar('sidebar-izquierdo')" style="display:none;font-size:14px;">☰</button>
            <h2 class="ff-titulo-feed"></h2>
        </div>

        <form action="principal" method="get" style="margin:0;display:flex;gap:6px;align-items:center;">
            <input type="text" name="txtBuscar" placeholder="Buscar lugares o comida..." class="ff-search-input">
            <button type="submit" class="btn btn-sm btn-dark" style="padding:7px 13px;">🔍 Buscar</button>
        </form>
    </div>

    <p style="color: gray; margin-top: 10px;"></p>

    <!--  ? BOTON PARA INSERTAR UNA PUBLICACIÓN-->
    <button id="btnCompartirPrincipal" onclick="alternarFormulario()">
        Compartir un nuevo lugar o menú
    </button>

    <div id="contenedorFormulario" class="ff-form-container" style="display: none;">
        <h3>Compartir un nuevo lugar o menú</h3>

        <form action="crearpost" method="post" id="formNuevaPublicacion" enctype="multipart/form-data">

            <div style="margin-bottom: 12px;">
                <label class="ff-label">Título:</label><br>
                <input type="text" name="txtTitulo" placeholder="Ej. ¡Tacos buenísimos afuera de la facultad!" class="ff-input" required>
            </div>

            <div style="margin-bottom: 12px;">
                <label class="ff-label">Descripción / Precios / Menú:</label><br>
                <textarea name="txtDescripcion" placeholder="Cuéntale a la comunidad qué venden, cuánto cuesta..." class="ff-input" required></textarea>
            </div>

            <div style="margin-bottom: 15px;">
                <label class="ff-label">Establecimiento / Ubicación:</label><br>
                <div style="display: flex; align-items: center; gap: 10px; margin-top: 5px;">
                    <button type="button" onclick="abrirSelectorMapa()" class="ff-btn-mapa-sel">
                        📍 Seleccionar Ubicación en el Mapa
                    </button>
                    <span id="estado-ubicacion" style="font-size: 13px; color: #64748b; font-style: italic;">(Ninguna ubicación seleccionada)</span>
                </div>

                <input type="hidden" id="idUbicacionExistente" name="idUbicacionExistente" value="">
                <input type="hidden" id="nuevoNombreLocal" name="nuevoNombreLocal" value="">
                <input type="hidden" id="nuevoLat" name="nuevoLat" value="">
                <input type="hidden" id="nuevoLng" name="nuevoLng" value="">
            </div>

            <div style="margin-bottom: 20px;">
                <label class="ff-label">Imagen del Post:</label><br>
                <input type="file" name="fileImagen" accept="image/*" style="margin-top: 5px; font-size: 14px;">
            </div>

            <div style="display: flex; gap: 10px;">
                <button type="submit" class="ff-btn-publicar">
                    Publicar
                </button>
                <button type="button" onclick="cancelarPublicacion()" class="ff-btn-cancelar">
                    Cancelar
                </button>
            </div>
        </form>
    </div>

    <!--este script fue iado jjsjdfjsdf -->
    <script>
        // Al cargar la página, nos aseguramos al 100% de que el display esté apagado
        window.onload = function() {
            document.getElementById("contenedorFormulario").style.display = "none";
        };

        // Abre el formulario y oculta el botón principal para que no se dupliquen
        function alternarFormulario() {
            var formulario = document.getElementById("contenedorFormulario");
            var btnPrincipal = document.getElementById("btnCompartirPrincipal");

            formulario.style.display = "block";
            btnPrincipal.style.display = "none"; // Desaparece el botón de arriba mientras editas
        }

        // Acción del botón Cancelar
        function cancelarPublicacion() {
            var formulario = document.getElementById("contenedorFormulario");
            var btnPrincipal = document.getElementById("btnCompartirPrincipal");
            var formHTML = document.getElementById("formNuevaPublicacion");

            // 1. Limpia todo lo que el usuario haya escrito en las cajas de texto (Reset)
            formHTML.reset();

            // 2. Esconde el contenedor del formulario
            formulario.style.display = "none";

            // 3. Vuelve a mostrar el botón principal de "Compartir" arriba
            btnPrincipal.style.display = "block";
        }
    </script>

    <!-- ? imprimir todos los posts que esten en la base de datos -->
    <form action="principal" method="GET">
    <%
        // para que la fecha de mongo se vea bien
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        System.out.println("[GET home.jsp] mandando a dibujar publicaciones...");
        //? ir por las publicaciones que se mandaron en el servlet feed
        List<Document> listaPosts = (List<Document>) request.getAttribute("posts_comunidad");

        if (listaPosts != null && !listaPosts.isEmpty())
        {
            for (Document post : listaPosts)
            {
                //? esto lo saqué de ia D:
                //java.util.Date fecha = post.getDate("fecha_publicacion");
                java.util.Date fecha = post.getDate("fecha");
                String fecha_formateada = (fecha != null) ? sdf.format(fecha) : "Reciente";

                // extraer foto desde el array de objetos multimedia :D
                List<Document> mediaList = (List<Document>) post.get("multimedia");
                String rutaFotoLocal = "img/posts/default-local.png";

                if (mediaList != null && !mediaList.isEmpty()) {
                    Document primeraMultimedia = mediaList.get(0);
                    rutaFotoLocal = primeraMultimedia.getString("url");
                }

                boolean tieneImagen = (rutaFotoLocal != null && !rutaFotoLocal.equals("img/posts/default-local.png"));

                String nombreAutor = post.getString("nombre_autor");
                String fotoPerfil = post.getString("foto_perfil_autor");
                if (nombreAutor == null) nombreAutor = "Anónimo";
                if (fotoPerfil == null || fotoPerfil.isEmpty()) fotoPerfil = "img/avatar-default.png";

    %>

    <!-- post card para mandar los datos de votación si es real o no -->
        <div class="forafood-post-card">

            <div class="post-meta-header" style="display: flex; align-items: center; width: 100%; position: relative;">
                <img src="<%= fotoPerfil %>" style="width: 20px; height: 20px; border-radius: 50%; object-fit: cover;" onerror="this.src='https://api.dicebear.com/7.x/bottts/svg?seed=default';" />
                <span class="post-author-name" style="margin-left: 8px; font-weight: 600;"><%= nombreAutor %></span>
                <span style="margin: 0 6px; color: #64748b;">•</span>
                <span style="color: #64748b;">Comunidad Universitaria</span>
                <span style="margin: 0 6px; color: #64748b;">•</span>
                <span style="color: #64748b;"><%= fecha_formateada %></span>

                <%
                    // 🕵️‍♀️ VALIDACIÓN: Si el post es del usuario logueado, pintamos la basura en la esquina exacta
                    if (userLogueado != null && userLogueado.equals(nombreAutor)) {
                %>
                <button type="button"
                        onclick="confirmarEliminacion('<%= post.getObjectId("_id") %>')"
                        title="Eliminar publicación"
                        style="position: absolute; top: 0; right: 0; background: transparent; border: none; color: #ef4444; cursor: pointer; font-size: 16px; padding: 4px; display: flex; align-items: center; justify-content: center; transition: transform 0.2s ease-in-out;"
                        onmouseover="this.style.transform='scale(1.2)'"
                        onmouseout="this.style.transform='scale(1)'">
                    🗑️
                </button>
                <%
                    }
                %>
            </div>

            <div class="post-main-content">

                <div class="post-text-side">
                    <h3 class="post-title" ><%= post.getString("titulo") %></h3>
                    <p class="post-description" ><%= post.getString("texto_publicacion") %></p>
                </div>

                <% if (tieneImagen) { %>
                <div class="post-image-large-container">
                    <img src="<%= rutaFotoLocal %>" alt="Multimedia ForaFood" />
                </div>
                <% } %>

            </div>

            <div class="post-action-bar">

                <%
                    // Leemos la bandera que inyectó el Servlet para este post específico
                    String votoPrevio = post.getString("voto_usuario_sesion");
                    if (votoPrevio == null) votoPrevio = "ninguno";

                    boolean haVotadoVigente = "vigente".equals(votoPrevio);
                    boolean haVotadoFalso = "falso".equals(votoPrevio);
                %>
                <div class="pill-votacion">
                    <a href="javascript:void(0);"
                       id="btn-vigente-<%= post.getObjectId("_id") %>"
                       data-votado="<%= haVotadoVigente %>"
                       onclick="enviarVoto('<%= post.getObjectId("_id") %>', 'vigente', this)"
                       style="text-decoration: none; display: flex; align-items: center; gap: 4px; opacity: <%= haVotadoVigente ? "0.5" : "1.0" %>; font-weight: <%= haVotadoVigente ? "bold" : "normal" %>;">
                        <strong class="contador-votos-vigente" id="txt-vigente-<%= post.getObjectId("_id") %>" ><%= post.getInteger("votosVigente", 0) %></strong>
                        <span class="voto-real">Es real</span>
                    </a>

                    <span class="voto-separador">|</span>

                    <a href="javascript:void(0);"
                       id="btn-falso-<%= post.getObjectId("_id") %>"
                       data-votado="<%= haVotadoFalso %>"
                       onclick="enviarVoto('<%= post.getObjectId("_id") %>', 'falso', this)"
                       style="text-decoration: none; display: flex; align-items: center; gap: 4px; opacity: <%= haVotadoFalso ? "0.5" : "1.0" %>; font-weight: <%= haVotadoFalso ? "bold" : "normal" %>;">
                        <strong class="contador-votos-falso" id="txt-falso-<%= post.getObjectId("_id") %>" ><%= post.getInteger("votosFalso", 0) %></strong>
                        <span class="voto-falso">Es falso</span>
                    </a>
                </div>

                <a href="javascript:void(0);" onclick="abrirPanelComentarios('<%= post.getObjectId("_id") %>', '<%= post.getString("titulo") %>', '<%= tieneImagen ? rutaFotoLocal : "" %>', '<%= post.getObjectId("fk_establecimiento") %>')" class="btn-action-secundario">
                    💬 Comentarios
                </a>

                <button type="button" onclick="compartirEnlacePost('<%= post.getObjectId("_id") %>')" class="btn-action-secundario">
                    🔗 Compartir
                </button>
            </div>

        </div>

        <%
                }
            }
        %>

        <div class="ff-empty-state">
            <p style="font-size: 18px; margin-bottom: 8px;">Aún no hay publicaciones en tu comunidad.</p>
            <p style="font-size: 14px; margin: 0;">¡Sé el primero en recomendar unos tacos usando la caja de arriba!</p>
        </div>

    </form>

</div>

<!-- contenedor derecho -->
<div id="sidebar-derecho" class="position-relative ff-sidebar-right-inner">
    <div id="bloque-top-lugares" class="ff-ranking-bloque">
        <h3 class="ff-ranking-titulo">
            🏆 Top 5 establecimientos
        </h3>
        <div id="contenedor-ranking-locales" style="display: flex; flex-direction: column; gap: 8px;">
            <p style="color: #94a3b8; font-size: 11px; text-align: center; margin: 0;">Cargando posiciones...</p>
        </div>
    </div>

    <div id="bloque-top-usuarios" class="ff-ranking-bloque">
        <h3 class="ff-ranking-titulo">
            🏆 Top 5 usuarios
        </h3>
        <table class="leaderboard-table" style="width: 100%;">
            <thead>
            <tr>
                <th scope="col">Rank</th>
                <th scope="col">Estudiante</th>
                <th scope="col" class="th-score">Puntos</th>
            </tr>
            </thead>
            <tbody id="cuerpo-tabla-ranking-usuarios">
            <tr>
                <td colspan="3" style="text-align: center; color: #3a5242; font-size: 12px; padding: 15px;">
                    Cargando el podio de la comunidad...
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div id="bloque-comentarios-panel" style="display: none; flex-direction: column; height: calc(100vh - 40px); gap: 15px; width: 100%; box-sizing: border-box;" class="ff-ranking-bloque">

        <div class="ff-panel-header">

            <div style="display: flex; flex-direction: column; gap: 2px; flex: 1;">
            <span class="ff-panel-label">
                📍 Establecimiento seleccionado
            </span>
                <h3 id="panel-titulo-local" class="ff-panel-titulo-local">
                    Local
                </h3>
            </div>

            <button onclick="cerrarPanelComentarios()"
                    style="background:var(--bg-hover);border:1px solid var(--border);font-size:12px;cursor:pointer;color:var(--text-2);width:26px;height:26px;border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-weight:700;"
                    onmouseover="this.style.background='var(--bg-hover)';this.style.borderColor='var(--green-btn)';this.style.color='var(--green-dark)';"
                    onmouseout="this.style.background='var(--bg-hover)';this.style.borderColor='var(--border)';this.style.color='var(--text-2)';">
                ✕
            </button>
        </div>

        <div class="ff-panel-foto-wrap">
            <img id="panel-foto-local" src="" alt="Foto local" style="width: 100%; height: 100%; object-fit: cover;" />
        </div>

        <h4 class="ff-panel-subtitulo">Comentarios comunitarios</h4>

        <div id="contenedor-lista-comentarios" class="ff-comentarios-lista">
            <p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Selecciona una publicación...</p>
        </div>

        <form id="form-nuevo-comentario" onsubmit="guardarComentario(event)" style="display: flex; flex-direction: column; gap: 8px; margin-top: auto; box-sizing: border-box;">
            <input type="hidden" id="input-post-id" name="idPost" />

            <div class="emoji-picker-bar" style="display: flex; gap: 8px; font-size: 18px; padding: 2px 4px; user-select: none;">
                <span onclick="insertarEmoji('🔥')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">🔥</span>
                <span onclick="insertarEmoji('🌮')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">🌮</span>
                <span onclick="insertarEmoji('🤮')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">🤮</span>
                <span onclick="insertarEmoji('🤑')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">🤑</span>
                <span onclick="insertarEmoji('❤️')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">❤️</span>
                <span onclick="insertarEmoji('👌')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">👌</span>
            </div>

            <textarea id="texto-comentario" placeholder="Escribe un comentario foráneo..." required class="ff-textarea-comentario"></textarea>

            <button type="submit" class="ff-btn-comentar">
                Enviar comentario
            </button>
        </form>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

    // 🎯 ACTUALIZA ESTAS DOS FUNCIONES EN TU SECCIÓN DE SCRIPTS
    function abrirPanelComentarios(idPost, titulo, fotoUrl, idEstablecimiento) {
        // Apagamos los dos rankings para dejar la columna limpia
        document.getElementById("bloque-top-lugares").style.display = "none";
        document.getElementById("bloque-top-usuarios").style.display = "none"; // 👈 ¡NUEVO!

        // Encendemos los comentarios
        document.getElementById("bloque-comentarios-panel").style.display = "flex";

        document.getElementById("panel-titulo-local").innerText = titulo;
        document.getElementById("panel-foto-local").src = (fotoUrl && fotoUrl !== "" && fotoUrl !== "null") ? fotoUrl : "img/posts/default-local.png";
        document.getElementById("input-post-id").value = idPost;

        cargarComentariosDesdeBase(idPost);
    }

    function cerrarPanelComentarios() {
        // Apagamos el panel de comentarios
        document.getElementById("bloque-comentarios-panel").style.display = "none";

        // Regresamos a la vida ambos rankings
        document.getElementById("bloque-top-lugares").style.display = "block";
        document.getElementById("bloque-top-usuarios").style.display = "block"; // 👈 ¡NUEVO!
    }

    // 📡 AJAX: Trae los comentarios de MongoAtlas sin recargar la pantalla
    function cargarComentariosDesdeBase(idPost) {
        const contenedor = document.getElementById("contenedor-lista-comentarios");
        contenedor.innerHTML = '<p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Cargando opiniones...</p>';

        fetch('comentarios?&idPost=' + idPost)
            .then(response => response.json())
            .then(comentarios => {
                contenedor.innerHTML = "";
                if(comentarios.length === 0) {
                    contenedor.innerHTML = '<p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Nadie ha comentado aún. ¡Sé el primero!</p>';
                    return;
                }
                // Dibujamos cada comentario con la foto de perfil del autor tal como tu boceto
                comentarios.forEach(c => {
                    contenedor.innerHTML += `
                    <div style="display:flex;gap:8px;background:var(--bg-comment);padding:8px;border-radius:6px;border:1px solid var(--border-card);">
                        <img src="${c.foto_perfil || 'img/avatar-default.png'}" style="width:28px;height:28px;border-radius:50%;object-fit:cover;" />
                        <div style="flex:1;">
                            <strong style="font-size:12px;color:var(--text-1);display:block;">${c.nombre_autor}</strong>
                            <p style="margin:2px 0 0 0;font-size:12px;color:var(--text-2);word-break:break-word;">${c.texto}</p>
                        </div>
                    </div>
                `;
                });
                // Auto-scroll al fondo para ver los últimos comentarios
                contenedor.scrollTop = contenedor.scrollHeight;
            });
    }

    // 📡 AJAX: Inserta el comentario en Atlas en caliente
    function guardarComentario(event) {
        event.preventDefault();
        const idPost = document.getElementById("input-post-id").value;
        const texto = document.getElementById("texto-comentario").value;

        fetch('comentarios', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: `idPost=${idPost}&texto=${encodeURIComponent(texto)}`
        }).then(response => {
            if(response.ok) {
                document.getElementById("texto-comentario").value = "";
                cargarComentariosDesdeBase(idPost); // Recargamos la cajita de comentarios
            }
        });
    }




    function alternarFormulario() {
        document.getElementById("contenedorFormulario").style.display = "block";
        document.getElementById("btnCompartirPrincipal").style.display = "none";
    }

    function cancelarPublicacion() {
        document.getElementById("formNuevaPublicacion").reset();
        document.getElementById("contenedorFormulario").style.display = "none";
        document.getElementById("btnCompartirPrincipal").style.display = "block";
        document.getElementById("estado-ubicacion").innerText = "(Ninguna ubicación seleccionada)";
        document.getElementById("estado-ubicacion").style.color = "#64748b";
        resetearVariablesUbicacion();
    }




    let mapaSeleccion;
    let markerTemporal = null;
    let marcadorElegidoData = null;

    function abrirSelectorMapa() {
        // 1. Encendemos el modal dándole el estilo flex que configuramos
        document.getElementById("modalSelectorMapa").style.display = "flex";

        // 2. Esperamos 150ms para que el DOM se dibuje por completo
        setTimeout(function() {
            const latUV = 19.1622;
            const lngUV = -96.1197;

            if (!mapaSeleccion) {
                // Inicializar el mapa centrado en la facultad
                mapaSeleccion = L.map('mapa-selector').setView([latUV, lngUV], 16);

                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(mapaSeleccion);

                // 🎯 ¡LLAMADA CLAVE! Cargamos los pines de Atlas en la primera inicialización
                cargarMarcadoresExistentes();

                // Detectar click en zona vacía para registrar local nuevo
                mapaSeleccion.on('click', function(e) {
                    if (markerTemporal) mapaSeleccion.removeLayer(markerTemporal);

                    document.getElementById("zonaNuevoLocalInput").style.display = "block";
                    document.getElementById("txtNombreNuevoLocal").value = "";

                    markerTemporal = L.marker([e.latlng.lat, e.latlng.lng]).addTo(mapaSeleccion);
                    marcadorElegidoData = { tipo: "nuevo", lat: e.latlng.lat, lng: e.latlng.lng };
                });
            } else {
                // Si el mapa ya existía creado de antes, recalculamos su tamaño para adaptarlo
                mapaSeleccion.invalidateSize();

                // 🎯 ¡LLAMADA CLAVE 2! Volvemos a consultar por si otro alumno registró un local en este rato
                cargarMarcadoresExistentes();
            }
        }, 150);
    }

    // 🎯 FUNCIÓN BLINDADA Y OPTIMIZADA EN YOUR home.jsp
    // 🎯 FUNCIÓN CORREGIDA Y BLINDADA EN home.jsp
    function cargarMarcadoresExistentes() {
        fetch('mapa-pines')
            .then(response => {
                if (!response.ok) throw new Error("Error en la respuesta del servidor /mapa-pines");
                return response.json();
            })
            .then(locales => {
                // 🕵️‍♀️ Chismoso para ver en la consola del navegador si el JSON ya llegó aquí
                console.log("[Leaflet Debug] Arreglo recibido en JS. Tamaño: " + locales.length, locales);

                if (!locales || locales.length === 0) {
                    console.log("[Leaflet] El servlet mandó un arreglo vacío.");
                    return;
                }

                // Usamos tu mapa global (asegúrate de que use el nombre correcto: 'mapaSeleccion' o 'map')
                locales.forEach(l => {
                    // Forzamos que las coordenadas se procesen como números reales
                    const latitud = parseFloat(l.lat);
                    const longitud = parseFloat(l.lng);

                    if (!isNaN(latitud) && !isNaN(longitud)) {
                        // 📍 Creamos el pin físico en el mapa
                        let pinExistente = L.marker([latitud, longitud]).addTo(mapaSeleccion);

                        // Le pegamos el globo informativo con el nombre real que viene de Atlas
                        let contenidoPopup = `
                        <div style="font-family: sans-serif; padding: 4px; min-width: 140px;">
                            <b style="color: #0f172a; font-size: 13px; display: block; margin-bottom: 2px;">${l.nombre}</b>
                            <span style="color: #16a34a; font-weight: 500; font-size: 11px; display: block; margin-top: 4px;">📍 Local Verificado</span>
                        </div>
                    `;
                        pinExistente.bindPopup(contenidoPopup);

                        // Evento cuando el estudiante selecciona este local existente
                        pinExistente.on('click', function(e) {
                            L.DomEvent.stopPropagation(e);

                            // Ocultamos la caja de texto para nombres nuevos
                            const divNuevo = document.getElementById("zonaNuevoLocalInput");
                            if (divNuevo) divNuevo.style.display = "none";

                            // Guardamos los datos en tu variable global del formulario
                            marcadorElegidoData = { tipo: "existing", id: l.id, nombre: l.nombre };
                            console.log("[Mapa] Seleccionaste: " + l.nombre);
                        });
                    } else {
                        console.error("[Leaflet] Coordenadas inválidas para el local:", l);
                    }
                });
            })
            .catch(err => {
                console.error("[Fetch Error en mapa-pines]:", err);
            });
    }

    // 🎯 3. FUNCIÓN AUXILIAR DE SELECCIÓN CONTROLADA
    // Esta función se dispara únicamente cuando el usuario presiona el botón verde del mapa
    function seleccionarLocalDesdeMapa(idLocal, nombreLocal) {
        // Ocultamos la caja de texto para ingresar nombres nuevos de locales
        const inputZona = document.getElementById("zonaNuevoLocalInput");
        if (inputZona) inputZona.style.display = "none";

        // Guardamos la información de manera limpia en la variable global para el Formulario de envío
        marcadorElegidoData = {
            tipo: "existing",
            id: idLocal,
            nombre: nombreLocal
        };

        console.log("[Mapa] Establecimiento seleccionado para publicación: " + nombreLocal + " (" + idLocal + ")");

        // Opcional: Avisarle al usuario con un pequeño texto flotante en tu formulario
        const txtFeedback = document.getElementById("localSeleccionadoFeedback");
        if (txtFeedback) {
            txtFeedback.innerHTML = "📍 Seleccionado: <b>" + nombreLocal + "</b>";
        }
    }

    function confirmarSeleccionGeografica() {
        if (!marcadorElegidoData) {
            alert("Por favor, selecciona un pin existente o haz click en el mapa para registrar uno nuevo.");
            return;
        }

        // Limpiar inputs ocultos previos
        document.getElementById("idUbicacionExistente").value = "";
        document.getElementById("nuevoNombreLocal").value = "";
        document.getElementById("nuevoLat").value = "";
        document.getElementById("nuevoLng").value = "";

        if (marcadorElegidoData.tipo === "existing") {
            document.getElementById("idUbicacionExistente").value = marcadorElegidoData.id;
            document.getElementById("estado-ubicacion").innerText = `✓ Seleccionado: ${marcadorElegidoData.nombre}`;
            document.getElementById("estado-ubicacion").style.color = "#16a34a";
        }
        else if (marcadorElegidoData.tipo === "nuevo") {
            let nombreNuevo = document.getElementById("txtNombreNuevoLocal").value.trim();
            if (nombreNuevo === "") {
                alert("Por favor, dale un nombre al nuevo local comercial.");
                return;
            }
            document.getElementById("nuevoNombreLocal").value = nombreNuevo;
            document.getElementById("nuevoLat").value = marcadorElegidoData.lat;
            document.getElementById("nuevoLng").value = marcadorElegidoData.lng;
            document.getElementById("estado-ubicacion").innerText = `✨ Nuevo local: ${nombreNuevo}`;
            document.getElementById("estado-ubicacion").style.color = "#0284c7";
        }

        cerrarSelectorMapa();
    }

    function cerrarSelectorMapa() {
        document.getElementById("modalSelectorMapa").style.display = "none";
        document.getElementById("zonaNuevoLocalInput").style.display = "none";
        if (markerTemporal) {
            mapaSeleccion.removeLayer(markerTemporal);
            markerTemporal = null;
        }
    }


    // 🔗 Función para copiar el enlace del post al portapapeles
    function compartirEnlacePost(idPost) {
        const urlFicticia = window.location.origin + window.location.pathname + "?postId=" + idPost;

        navigator.clipboard.writeText(urlFicticia).then(() => {
            alert("¡Enlace del post copiado al portapapeles! Pásaselo a tus amigos foráneos. 🍔");
        }).catch(err => {
            console.error("No se pudo copiar el enlace: ", err);
        });
    }

    // 😀 CORREGIDO: Una sola función unificada para inyectar emojis al textarea
    function insertarEmoji(emoji) {
        const inputComentario = document.getElementById("texto-comentario");
        if (inputComentario) {
            inputComentario.value += emoji;
            inputComentario.focus(); // Mantiene el cursor adentro para seguir escribiendo texto
        }
    }

    // 🎯 FUNCIÓN JAVASCRIPT DETECTORA DE ESTADOS EN home.jsp
    function enviarVoto(idPublicacion, tipoVoto, elementoA) {
        // 1. Leemos de forma estricta el atributo del botón
        const yaVotado = elementoA.getAttribute("data-votado") === "true";
        const accion = yaVotado ? "restar" : "sumar";

        // Candado extra: Si el usuario intenta votar "falso" pero ya tenía marcado "vigente" (o al revés),
        // lo ideal es no permitir el doble voto simultáneo.
        const tipoOpuesto = tipoVoto === "vigente" ? "falso" : "vigente";
        const botonOpuesto = document.getElementById(`btn-${tipoOpuesto}-${idPublicacion}`);
        if (botonOpuesto && botonOpuesto.getAttribute("data-votado") === "true") {
            alert("¡Ya votaste en esta publicación! Desmarca tu voto actual antes de cambiar tu opinión. 🍔");
            return;
        }

        // 2. Ejecutamos el fetch limpio hacia el servlet
        fetch('votar?id=' + idPublicacion + '&tipo=' + tipoVoto + '&accion=' + accion)
            .then(response => {
                if (!response.ok) throw new Error("Error en el servidor de votaciones");
                return response.json();
            })
            .then(data => {
                console.log("[JS Voto Real-Time]:", data);

                // 3. Modificamos los números exactos usando los IDs dinámicos
                const txtVigente = document.getElementById(`txt-vigente-${idPublicacion}`);
                const txtFalsos = document.getElementById(`txt-falso-${idPublicacion}`);

                if (txtVigente) txtVigente.innerText = data.reales;
                if (txtFalsos) txtFalsos.innerText = data.falsos;

                // 4. Actualizamos el perfil del alumno en la barra izquierda usando selectores nativos
                // Modificamos el strong de los puntos y el span del rango
                const contenedorPuntos = document.querySelector(".sidebar-left div div b") || document.querySelector(".sidebar-left strong");
                const contenedorRango = document.querySelector(".sidebar-left span");

                if (contenedorPuntos) {
                    contenedorPuntos.innerHTML = data.puntos;
                }
                if (contenedorRango && data.rango) {
                    contenedorRango.innerText = data.rango;
                }

                // 5. CAMBIO DE ESTADO Y FEEDBACK VISUAL
                if (accion === "sumar") {
                    elementoA.setAttribute("data-votado", "true");
                    elementoA.style.opacity = "0.5"; // Lo opacamos un poco para denotar que está "hundido/seleccionado"
                    elementoA.style.fontWeight = "bold";
                } else {
                    elementoA.setAttribute("data-votado", "false");
                    elementoA.style.opacity = "1.0";  // Regresa a su brillo normal
                    elementoA.style.fontWeight = "normal";
                }
            })
            .catch(err => console.error("Error al procesar votación asíncrona:", err));
    }



    function cargarRankingEstablecimientos() {
        const contenedor = document.getElementById("contenedor-ranking-locales");
        if (!contenedor) return;

        fetch('ranking-establecimientos')
            .then(res => res.json())
            .then(locales => {
                contenedor.innerHTML = "";

                if (locales.length === 0) {
                    contenedor.innerHTML = '<p style="color: #94a3b8; font-size: 11px; text-align: center; margin: 0;">No hay datos de ranking disponibles.</p>';
                    return;
                }

                locales.forEach((local, indice) => {
                    // Asignamos una medalla bonita por posición
                    let medalla = "🎖️";
                    if (indice === 0) medalla = "🥇";
                    else if (indice === 1) medalla = "🥈";
                    else if (indice === 2) medalla = "🥉";
                    const calificacionRaw = local.calificacion_promedio !== undefined ? local.calificacion_promedio : 0.0;
                    const calif = Number(calificacionRaw).toFixed(1);

                    let elementoHTML = `
                <div style="display:flex;align-items:center;justify-content:space-between;background:var(--bg-card);border:1px solid var(--border-card);padding:8px 10px;border-radius:9px;gap:8px;">
                    <div style="display:flex;align-items:center;gap:7px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;flex:1;">
                        <span style="font-size:14px;flex-shrink:0;">${medalla}</span>
                        <strong style="font-size:12px;color:var(--text-1);cursor:pointer;overflow:hidden;text-overflow:ellipsis;" onclick="enfocarLocalEnMapa('${local.id}')" title="Ubicar en el mapa">${local.nombre_local}</strong>
                    </div>
                    <div style="display:flex;align-items:center;gap:3px;flex-shrink:0;">
                        <span style="color:var(--gold);font-size:12px;">★</span>
                        <span style="font-size:12px;font-weight:700;color:var(--gold);">${calificacionRaw.toFixed(1)}</span>
                    </div>
                </div>`;

                    contenedor.innerHTML += elementoHTML;
                });
            })
            .catch(err => {
                console.error("Error cargando el ranking:", err);
                contenedor.innerHTML = '<p style="color: #dc2626; font-size: 11px; text-align: center; margin: 0;">Error al obtener posiciones.</p>';
            });
    }

    // Llama a la función automáticamente cuando cargue la página
    document.addEventListener("DOMContentLoaded", () => {
        cargarRankingEstablecimientos();
    });


    function cargarRankingDeUsuarios() {
        const tablaBody = document.getElementById("cuerpo-tabla-ranking-usuarios");
        if (!tablaBody) return;

        fetch('ranking-usuarios')
            .then(res => res.json())
            .then(usuarios => {
                tablaBody.innerHTML = "";

                if (usuarios.length === 0) {
                    tablaBody.innerHTML = `<tr><td colspan="3" style="text-align:center; color:#94a3b8; font-size:12px;">No hay registros de puntos todavía.</td></tr>`;
                    return;
                }

                usuarios.forEach((u, indice) => {
                    const numeroRank = indice + 1;

                    // Mapeamos dinámicamente las clases del top 3 (rank-1, rank-2, rank-3)
                    let claseFila = "";
                    if (numeroRank === 1) claseFila = 'class="rank-1"';
                    else if (numeroRank === 2) claseFila = 'class="rank-2"';
                    else if (numeroRank === 3) claseFila = 'class="rank-3"';

                    // 🎯 CORRECCIÓN CLAVE: Mapeamos con "nombre_user" que es el campo real de tu BSON
                    const nombreUsuario = u.nombre_user || 'Anónimo';

                    // Si en el futuro agregas fotos, usará u.foto_perfil, si no, usa el default
                    const fotoPerfil = u.foto_perfil || 'img/avatar-default.png';

                    // Formateamos los puntos con comas para que se vea estético
                    const puntosTotales = u.puntos !== undefined ? u.puntos.toLocaleString() : '0';

                    let filaHTML = `
                <tr ${claseFila}>
                    <td class="rank">${numeroRank}</td>

                    <td class="user-cell">
                        <div class="user-container-flex">
                            <img src="${fotoPerfil}" alt="Avatar" class="avatar-ranking" onerror="this.src='img/avatar-default.png';">
                            <span class="username">${nombreUsuario}</span>
                        </div>
                    </td>

                    <td class="score">${puntosTotales}</td>
                </tr>`;

                    tablaBody.innerHTML += filaHTML;
                });
            })
            .catch(err => {
                console.error("Error al renderizar el ranking de usuarios:", err);
                tablaBody.innerHTML = `<tr><td colspan="3" style="text-align:center; color:#dc2626; font-size:12px;">Error al actualizar posiciones.</td></tr>`;
            });
    }

    // Ejecutar automáticamente al terminar de cargar la vista
    document.addEventListener("DOMContentLoaded", function() {
        cargarRankingDeUsuarios();
    });

    // Ejecutar la carga apenas esté listo el documento
    document.addEventListener("DOMContentLoaded", () => {
        cargarRankingDeUsuarios();
    });


    // 🎯 CONTROL DEL POP-UP DINÁMICO EN PASOS
    document.addEventListener("DOMContentLoaded", function() {
        const yaVisto = localStorage.getItem("forafood_tutorial_visto");
        if (!yaVisto) {
            document.getElementById("popup-bienvenida").style.display = "flex";
        }
    });

    function irAPaso2Avatar() {
        document.getElementById("tutorial-paso-1").style.display = "none";
        document.getElementById("tutorial-paso-2").style.display = "block";
    }

    function regresarAPaso1() {
        document.getElementById("tutorial-paso-2").style.display = "none";
        document.getElementById("tutorial-paso-1").style.display = "block";
    }

    // 🎯 ACTUALIZA ESTAS FUNCIONES EN LOS SCRIPTS DE TU home.jsp

    // Variable global interna para recordar si el alumno subió un archivo propio válido
    let archivoSubidoListo = false;

    function seleccionarAvatarPredefinido(elementoImg, rutaAvatar) {
        // 1. Limpiamos las selecciones visuales previas de la galería
        document.querySelectorAll(".img-avatar-opcion, [class*='avatar-opcion']").forEach(img => {
            img.style.border = "3px solid transparent";
            img.style.boxShadow = "none";
        });

        // 2. Resaltamos el avatar predeterminado seleccionado
        elementoImg.style.border = "3px solid #3b82f6";
        elementoImg.style.boxShadow = "0 0 8px rgba(59,130,246,0.5)";

        // 3. Asignamos la ruta al input oculto y reseteamos la bandera de archivo propio
        document.getElementById("rutaAvatarElegido").value = rutaAvatar;
        archivoSubidoListo = false;

        // Limpiamos el input file por si tenía algo cargado de antes
        document.getElementById("fileAvatarTutorial").value = "";
    }

    // Se ejecuta de forma automática en cuanto el estudiante elige un archivo desde su computadora
    function detectarCambioDeArchivo() {
        const inputFile = document.getElementById("fileAvatarTutorial");
        if (inputFile.files && inputFile.files.length > 0) {
            archivoSubidoListo = true;
            // Desmarcamos los avatares predeterminados para denotar que el archivo propio tiene prioridad
            document.querySelectorAll(".img-avatar-opcion, [class*='avatar-opcion']").forEach(img => {
                img.style.border = "3px solid transparent";
                img.style.boxShadow = "none";
            });
            console.log("[Tutorial] Archivo propio detectado listo para subida:", inputFile.files[0].name);
        }
    }

    // 🚀 ESTA FUNCIÓN SE EJECUTA AL DAR CLIC AL BOTÓN VERDE "¡Guardar y empezar!"
    function finalizarTutorialYGuardarAvatar() {
        const avatarFinalDefault = document.getElementById("rutaAvatarElegido").value;
        const inputFile = document.getElementById("fileAvatarTutorial");

        // Bloqueamos el botón momentáneamente para evitar doble clic
        const btnGuardar = document.querySelector("button[onclick='finalizarTutorialYGuardarAvatar()']");
        if(btnGuardar) btnGuardar.disabled = true;

        if (archivoSubidoListo && inputFile.files.length > 0) {
            // 📤 ESCENARIO A: El estudiante subió una foto propia personalizada
            const formData = new FormData();
            formData.append("nuevaFotoPerfil", inputFile.files[0]); // Hace match exacto con tu Perfil_Servlet.java

            fetch('perfil', {
                method: 'POST',
                body: formData
            })
                .then(response => {
                    if (!response.ok) throw new Error("Error en la subida del archivo binario");
                    return response.text();
                })
                .then(data => {
                    console.log("[Tutorial] Foto propia guardada con éxito en el servidor.");
                    concluirProcesoTutorial();
                })
                .catch(err => {
                    console.error(err);
                    alert("No se pudo procesar tu imagen. Verifica que el Servlet tenga la anotación @MultipartConfig.");
                    if(btnGuardar) btnGuardar.disabled = false;
                });
        }
        else {
            // 📂 ESCENARIO B: El estudiante prefirió uno de tus avatares predeterminados del catálogo
            fetch('perfil?avatarDefault=' + encodeURIComponent(avatarFinalDefault), {
                method: 'POST'
            })
                .then(response => {
                    if (!response.ok) throw new Error("Error al guardar avatar por defecto");
                    console.log("[Tutorial] Avatar predeterminado registrado.");
                    concluirProcesoTutorial();
                })
                .catch(err => {
                    console.error(err);
                    concluirProcesoTutorial(); // Forzamos continuidad por seguridad
                });
        }
    }

    // Función de salida limpia
    function concluirProcesoTutorial() {
        document.getElementById("popup-bienvenida").style.display = "none";
        localStorage.setItem("forafood_tutorial_visto", "true");
        // Recargamos el feed para que el sidebar dibuje el nuevo rostro del alumno de inmediato
        window.location.reload();
    }

    // Dispara un fetch asíncrono en caliente al Servidor para guardar la foto personalizada si sube un archivo
    function subirAvatarPropioDesdeTutorial() {
        const inputFile = document.getElementById("fileAvatarTutorial");
        if (!inputFile.files || inputFile.files.length === 0) return;

        const formData = new FormData();
        // 🎯 CORRECCIÓN: Usamos .append() en lugar de .add() para construir el Multipart de red
        formData.append("nuevaFotoPerfil", inputFile.files[0]);

        fetch('perfil', {
            method: 'POST',
            body: formData
        })
            .then(response => {
                if (!response.ok) throw new Error("Error en la subida");
                document.getElementById("txt-feedback-upload").innerText = "✨ ¡Foto personalizada subida con éxito!";
                document.getElementById("txt-feedback-upload").style.color = "#16a34a";

                document.querySelectorAll(".img-avatar-opcion").forEach(img => img.style.border = "3px solid transparent");
            })
            .catch(err => {
                console.error(err);
                alert("Error al subir la foto. Asegúrate de que el Servlet tenga @MultipartConfig.");
            });
    }


    // 🎯 FUNCIÓN COLAPSABLE INTELIGENTE PARA FORAFOOD

    // ── TOGGLE DE TEMA CLARO/OSCURO ──────────────────────────
    function toggleTheme() {
        const root = document.getElementById('ff-root');
        const label = document.getElementById('theme-label');
        const current = root.getAttribute('data-theme');
        if (current === 'light') {
            root.setAttribute('data-theme', 'dark');
            localStorage.setItem('ff-theme', 'dark');
            if (label) label.textContent = 'Modo claro';
        } else {
            root.setAttribute('data-theme', 'light');
            localStorage.setItem('ff-theme', 'light');
            if (label) label.textContent = 'Modo oscuro';
        }
    }

    // Restaurar tema guardado al cargar
    (function() {
        const saved = localStorage.getItem('ff-theme');
        if (saved) {
            document.getElementById('ff-root').setAttribute('data-theme', saved);
            const label = document.getElementById('theme-label');
            if (label) label.textContent = saved === 'dark' ? 'Modo claro' : 'Modo oscuro';
        }
    })();

    function toggleSidebar(idSidebar) {
        const sidebar = document.getElementById(idSidebar);
        if (!sidebar) return;

        // Alternamos la clase de ocultamiento absoluto
        sidebar.classList.toggle('sidebar-oculto-total');
        const estaOculto = sidebar.classList.contains('sidebar-oculto-total');

        if (idSidebar === 'sidebar-izquierdo') {
            const btnFlipeado = document.getElementById('btn-colapso-izq');
            const btnEmergencia = document.getElementById('btn-mostrar-izq');

            if (estaOculto) {
                if(btnFlipeado) btnFlipeado.innerText = "➡️";
                if(btnEmergencia) btnEmergencia.style.display = "inline-block";
            } else {
                if(btnFlipeado) btnFlipeado.innerText = "⬅️";
                if(btnEmergencia) btnEmergencia.style.display = "none";
            }
        }
        else if (idSidebar === 'sidebar-derecho') {
            const btnFlipeado = document.getElementById('btn-colapso-der');
            const btnEmergencia = document.getElementById('btn-mostrar-der');

            if (estaOculto) {
                if(btnFlipeado) btnFlipeado.innerText = "⬅️";
                if(btnEmergencia) btnEmergencia.style.display = "inline-block";
            } else {
                if(btnFlipeado) btnFlipeado.innerText = "➡️";
                if(btnEmergencia) btnEmergencia.style.display = "none";
            }
        }
    }

    // 🎯 FUNCIÓN DE CONFIRMACIÓN DE BORRADO ASÍNCRONO
    function confirmarEliminacion(idPost) {
        if (confirm("🚨 ¿Seguro que quieres eliminar esta recomendación? Se borrarán todos sus votos y comentarios asociados de forma permanente.")) {
            // Redirige al Servlet pasándole el ID de la publicación por la URL
            window.location.href = "EliminarPublicacion?id=" + idPost;
        }
    }

</script>



<div id="modalSelectorMapa" style="position:fixed!important;top:0;left:0;width:100vw;height:100vh;background:rgba(20,16,8,.72);z-index:99999!important;display:none;justify-content:center;align-items:center;box-sizing:border-box;">

    <div class="modal-mapa-box" style="background:var(--bg-card);border:1px solid var(--border-card);width:90%;max-width:650px;height:540px;border-radius:14px;padding:24px;display:flex;flex-direction:column;gap:14px;box-shadow:0 24px 50px rgba(0,0,0,.3);box-sizing:border-box;">

        <h3 style="margin:0;font-size:15px;color:var(--text-1);font-family:'Poppins',sans-serif;font-weight:700;">📍 Selecciona un local o toca zona vacía para registrar uno nuevo</h3>

        <div id="mapa-selector" style="flex:1;width:100%;min-height:300px;border-radius:10px;border:1px solid var(--border-card);"></div>

        <div id="zonaNuevoLocalInput" style="background:var(--green-bg);padding:12px;border-radius:8px;border:1px solid var(--green-btn);display:none;box-sizing:border-box;">
            <label style="font-weight:700;color:var(--green-dark);font-size:12px;font-family:'Poppins',sans-serif;text-transform:uppercase;letter-spacing:.06em;">✨ ¡Local nuevo! Dale un nombre:</label>
            <input type="text" id="txtNombreNuevoLocal" placeholder="Ej. Antojitos Cloroformo / Tortas El Inge" style="width:100%;padding:9px 12px;margin-top:6px;border:1px solid var(--border-card);border-radius:8px;box-sizing:border-box;font-size:13px;background:var(--bg-input);color:var(--text-1);font-family:'Poppins',sans-serif;outline:none;">
        </div>

        <div class="modal-mapa-actions" style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 5px;">
            <button type="button" onclick="cerrarSelectorMapa()" class="btn-cancelar">
                Omitir / Cancelar
            </button>
            <button type="button" onclick="confirmarSeleccionGeografica()" class="btn-confirmar">
                Confirmar Destino
            </button>
        </div>

    </div>
</div>


<div id="popup-bienvenida" class="ff-popup-overlay" style="display: none;">

    <div class="ff-popup-box">

        <div id="tutorial-paso-1">
            <div style="text-align: center; margin-bottom: 20px;">
                <span style="font-size: 40px;">💚️</span>
                <h2 class="ff-popup-h2">¡Te damos la bienvenida a ForaFood!</h2>
                <p class="ff-popup-sub">Aquí tienes un pequeño tutorial...</p>
            </div>

            En ForaFood puedes:
            <div style="display:flex;flex-direction:column;gap:10px;margin-bottom:22px;font-size:13px;line-height:1.5;color:var(--text-2);">

                <div class="ff-tutorial-item">
                    <div>Descubrir locales cerca ti o tu facultad seleccionando: <span style="color: #000000; font-weight: bold;">'mapa'</span> </div>
                </div>

                <div class="ff-tutorial-item">
                    <div>Votar si las publicaciones que hacen otros estudiantes sobre un puesto es <span style="color:var(--green-mid);font-weight:700;">Real</span> o <span style="color:var(--red);font-weight:700;">Falsa</span>.</div>
                </div>

                <div class="ff-tutorial-item">
                    <div>Marcar en el mapa nuevos locales que descubriste</div>
                </div>

                <div class="ff-tutorial-item">
                    <div>Hacer puntuaciones sobre locales que descubrieron otros estudiantes</div>
                </div>
            </div>

            <button onclick="irAPaso2Avatar()" class="ff-btn-siguiente">
                Siguiente
            </button>
        </div>

        <div id="tutorial-paso-2" style="display: none;">
            <div style="text-align: center; margin-bottom: 20px;">
                <span style="font-size: 40px;">👤</span>
                <h2 style="margin:5px 0;font-size:18px;color:var(--text-1);font-weight:700;">Selecciona un avatar o sube tu foto</h2>
                <p style="margin:0;font-size:12px;color:var(--text-3);">Se puede cambiar en Ajustes después.</p>
            </div>

            <label style="font-size:11px;font-weight:700;color:var(--text-2);text-transform:uppercase;letter-spacing:.07em;display:block;margin-bottom:8px;">
                1. Avatares predeterminados:
            </label>

            <div style="display:flex;flex-wrap:wrap;justify-content:center;gap:10px;margin-bottom:18px;background:var(--bg-root);padding:14px;border-radius:10px;border:1px solid var(--border);max-width:100%;box-sizing:border-box;">

                <img src="../img/avatar-default.png" onclick="seleccionarAvatarPredefinido(this, 'img/avatar-default.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid #3b82f6; box-shadow: 0 0 8px rgba(59,130,246,0.5);" title="Patito Forafood" class="img-avatar-opcion">

                <img src="../img/profiles/panda.png" onclick="seleccionarAvatarPredefinido(this, 'img/profiles/panda.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid transparent;" title="Pandita Forafood" class="img-avatar-opcion">

                <img src="../img/profiles/rabbit.png" onclick="seleccionarAvatarPredefinido(this, 'img/profiles/rabbit.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid transparent;" title="Conejito Forafood" class="img-avatar-opcion">

                <img src="../img/profiles/default.png" onclick="seleccionarAvatarPredefinido(this, 'img/profiles/default.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid transparent;" title="Gatito Forafood" class="img-avatar-opcion">

                <img src="../img/profiles/bear.png" onclick="seleccionarAvatarPredefinido(this, 'img/profiles/bear.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid transparent;" title="Osito Forafood" class="img-avatar-opcion">

                <img src="../img/profiles/meerkat.png" onclick="seleccionarAvatarPredefinido(this, 'img/profiles/meerkat.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid transparent;" title="Suricata Forafood" class="img-avatar-opcion">

                <img src="../img/profiles/dog.png" onclick="seleccionarAvatarPredefinido(this, 'img/profiles/dog.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid transparent;" title="Perro Forafood" class="img-avatar-opcion">

                <img src="../img/profiles/gorilla.png" onclick="seleccionarAvatarPredefinido(this, 'img/profiles/gorilla.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid transparent;" title="Gorila Forafood" class="img-avatar-opcion">

                <img src="../img/profiles/lion.png" onclick="seleccionarAvatarPredefinido(this, 'img/profiles/lion.png')" style="width: 48px; height: 48px; border-radius: 50%; object-fit: cover; cursor: pointer; border: 3px solid transparent;" title="Leonsito Forafood" class="img-avatar-opcion">

            </div>

            <div style="margin-bottom: 25px;">
                <label style="font-size:11px;font-weight:700;color:var(--text-2);text-transform:uppercase;letter-spacing:.07em;display:block;margin-bottom:6px;">2. O sube tu propio archivo:</label>
                <span style="font-size:11px;color:var(--text-3);">Por seguridad no subas fotos de tu rostro.</span>
                <input type="file" id="fileAvatarTutorial" accept="image/*" onchange="detectarCambioDeArchivo()" class="form-control" style="font-size: 13px;">
            </div>

            <input type="hidden" id="rutaAvatarElegido" value="img/avatar-default.png">

            <div style="display: flex; gap: 10px;">
                <button onclick="regresarAPaso1()" class="ff-btn-atras">Atrás</button>
                <button onclick="finalizarTutorialYGuardarAvatar()" class="ff-btn-guardar">Guardar</button>
            </div>
        </div>

    </div>
</div>




</body>

</html>
