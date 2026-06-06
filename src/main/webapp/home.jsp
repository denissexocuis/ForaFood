<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">

<!-- me inspiré de varias plantillas -->
<!-- https://plantillashtmlgratis.com/en/home/ -->
<!-- https://github.com/Dendroculus/Login-Page-Templates-->

<!-- nota: uso de IA aquí -->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>ForaFood</title>

    <!-- bootstrap   -->
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css">

    <!-- archivo css -->
    <link rel="stylesheet" href="css/home.css">

    <link rel="stylesheet" href="css/feed_style.css">

    <!-- fevicon -->
    <link rel="icon" type="image/png" href="img/diet.png">

    <!-- fonts style -->
    <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
          integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
          crossorigin="" />

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
            integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
            crossorigin=""></script>
</head>

<body class="bg-white">

<div class="sidebar-left">
    <h3>¡Bienvenido a ForaFood!</h3>

    <%
        String userLogueado = (String) session.getAttribute("user");
        String avatarLogueado = (String) session.getAttribute("foto_perfil");
        Integer puntosLogueado = (Integer) session.getAttribute("puntos");
        String rangoLogueado = (String) session.getAttribute("rango");

        if (userLogueado == null) userLogueado = "Invitado";
        if (avatarLogueado == null) avatarLogueado = "img/avatar-default.png";
        if (puntosLogueado == null) puntosLogueado = 0;
        if (rangoLogueado == null) rangoLogueado = "Novato";
    %>

    <div style="padding: 15px; border-bottom: 1px solid #e2e8f0; margin-bottom: 15px; text-align: center; font-family: sans-serif;">
        <img src="<%= avatarLogueado %>" alt="Mi Perfil" style="width: 60px; height: 60px; border-radius: 50%; object-fit: cover; border: 2px solid #3b82f6;" />
        <h3 style="margin: 8px 0 2px 0; font-size: 16px; color: #1e293b;"><%= userLogueado %></h3>
        <span style="font-size: 11px; background: #eff6ff; color: #1d4ed8; padding: 2px 8px; border-radius: 12px; font-weight: 600;"><%= rangoLogueado %></span>
        <div style="font-size: 12px; color: #64748b; margin-top: 6px;">🏆 <strong><%= puntosLogueado %></strong> puntos</div>
    </div>



    <!-- TODO: aqui meter un js para boton de Feed-->
    <a href="home.jsp" style="font-weight: bold; text-decoration: none; color: black;">[ Feed ]</a>

    <!-- TODO: aqui meter un js para boton de Mapa-->
    <a href="home.jsp" style="font-weight: bold; text-decoration: none; color: black;">[ Mapa ]</a>

    <a href="index.jsp">Cerrar Sesión</a>

</div>

<div class="main-content">

    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 10px;">
        <!-- ! aqui FORM DE GET PARA LA BÚSQUEDA :D -->
        <h2>ForaFood</h2> <form action="principal" method="get" style="margin: 0; display: flex; gap: 5px;">
        <input type="text" name="txtBuscar" placeholder="Buscar lugares o comida..." style="padding: 6px; width: 250px;">
        <button type="submit">🔍 Buscar</button>
    </form>
    </div>

    <p style="color: gray; margin-top: 10px;"></p>

    <!--  ? BOTON PARA INSERTAR UNA PUBLICACIÓN-->
    <button class="btn-desplegar-form" id="btnCompartirPrincipal" onclick="alternarFormulario()" style="background-color: #333; color: white; padding: 10px 20px; border: none; cursor: pointer; border-radius: 3px; font-weight: bold;">
        Compartir un nuevo lugar o menú
    </button>

    <div id="contenedorFormulario" style="border: 2px dashed #333; padding: 20px; margin-bottom: 30px; border-radius: 5px; display: none;">
        <h3>Compartir un nuevo lugar o menú</h3>

        <form action="crearpost" method="post" id="formNuevaPublicacion" enctype="multipart/form-data">

            <div style="margin-bottom: 12px;">
                <label style="font-weight: bold;">Título:</label><br>
                <input type="text" name="txtTitulo" placeholder="Ej. ¡Tacos buenísimos afuera de la facultad!" style="width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px;" required>
            </div>

            <div style="margin-bottom: 12px;">
                <label style="font-weight: bold;">Descripción / Precios / Menú:</label><br>
                <textarea name="txtDescripcion" placeholder="Cuéntale a la comunidad qué venden, cuánto cuesta..." style="width: 100%; height: 90px; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px;" required></textarea>
            </div>

            <div style="margin-bottom: 15px;">
                <label style="font-weight: bold;">Establecimiento / Ubicación:</label><br>
                <div style="display: flex; align-items: center; gap: 10px; margin-top: 5px;">
                    <button type="button" onclick="abrirSelectorMapa()" style="background-color: #0f172a; color: white; padding: 10px 14px; border: none; border-radius: 4px; cursor: pointer; font-weight: 500;">
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
                <label style="font-weight: bold;">Imagen del Post:</label><br>
                <input type="file" name="fileImagen" accept="image/*" style="margin-top: 5px; font-size: 14px;">
            </div>

            <div style="display: flex; gap: 10px;">
                <button type="submit" style="background-color: #333; color: white; padding: 10px 20px; border: none; cursor: pointer; border-radius: 3px; font-weight: bold;">
                    Publicar
                </button>
                <button type="button" onclick="cancelarPublicacion()" style="background-color: #999; color: white; padding: 10px 20px; border: none; cursor: pointer; border-radius: 3px; font-weight: bold;">
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
                java.util.Date fecha = post.getDate("fecha_publicacion");
                String fecha_formateada = (fecha != null) ? sdf.format(fecha) : "Reciente";

                // extraer foto desde el array de objetos multimedia :D

                // extraer foto directa de la publicacion
                String rutaFotoLocal = post.getString("url_imagen"); // asi la puse en mongo desde el principio


                boolean tieneImagen = (rutaFotoLocal != null && !rutaFotoLocal.isEmpty() && !rutaFotoLocal.equals("img/default-post.png"));

                // Si viene vacío o nulo, le asignamos la imagen genérica pero con la ruta webapp real
                if (rutaFotoLocal == null || rutaFotoLocal.isEmpty()) {
                    rutaFotoLocal = "img/posts/default-local.png"; // Asegúrate de tener una imagen de respaldo ahí
                }

                String nombreAutor = post.getString("nombre_autor");
                String fotoPerfil = post.getString("foto_perfil_autor");
                if (nombreAutor == null) nombreAutor = "Anónimo";
                if (fotoPerfil == null || fotoPerfil.isEmpty()) fotoPerfil = "img/avatar-default.png";

    %>

    <!-- post card para mandar los datos de votación si es real o no -->
        <div class="forafood-post-card">

            <div class="post-meta-header">
                <img src="<%= fotoPerfil %>" style="width: 20px; height: 20px; border-radius: 50%; object-fit: cover;" onerror="this.src='https://api.dicebear.com/7.x/bottts/svg?seed=default';" />
                <span class="post-author-name"><%= nombreAutor %></span>
                <span>•</span>
                <span>Comunidad Universitaria</span>
                <span>•</span>
                <span><%= fecha_formateada %></span>
            </div>

            <div class="post-main-content">
                <div class="post-text-side">
                    <h3 class="post-title"><%= post.getString("titulo") %></h3>
                    <p class="post-description"><%= post.getString("texto_publicacion") %></p>
                </div>

                <% if (tieneImagen) { %>
                <div class="post-image-side">
                    <img src="<%= rutaFotoLocal %>" alt="Foto del menú" />
                </div>
                <% } %>
            </div>

            <div class="post-action-bar">

                <div class="pill-votacion">
                    <a href="votar?id=<%= post.getObjectId("_id") %>&tipo=real" class="voto-real">
                        ▲ <span><%= post.getInteger("votosVigente", 0) %> Real</span>
                    </a>
                    <span class="voto-separador">|</span>
                    <a href="votar?id=<%= post.getObjectId("_id") %>&tipo=falso" class="voto-falso">
                        ▼ <span><%= post.getInteger("votosFalso", 0) %> Falso</span>
                    </a>
                </div>

                <a href="javascript:void(0);"
                   onclick="abrirPanelComentarios('<%= post.getObjectId("_id") %>', '<%= post.getString("titulo") %>', '<%= tieneImagen ? rutaFotoLocal : "" %>')"
                   class="btn-action-secundario">
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
        <div style="text-align: center; padding: 40px; color: #64748b; font-family: sans-serif;">
            <p style="font-size: 18px; margin-bottom: 8px;">Aún no hay publicaciones en tu comunidad.</p>
            <p style="font-size: 14px; margin: 0;">¡Sé el primero en recomendar unos tacos usando la caja de arriba!</p>
        </div>

    </form>

</div>

<!-- contenedor derecho -->
<div id="columna-derecha" style="width: 320px; flex-shrink: 0; background: #f8fafc; border-left: 1px solid #e2e8f0; padding: 20px; min-height: 100vh; position: sticky; top: 0;">

    <div id="bloque-top-lugares">
        <h2 style="font-size: 20px; color: #0f172a; margin-top: 0; font-weight: 700;">TOP LUGARES</h2>
        <ol style="padding-left: 20px; color: #334155; line-height: 2;">
            <li>Tacos "El Güero"</li>
            <li>Antojitos Doña Mary</li>
            <li>Tortas La Facultad</li>
            <li>Comida Casera Económica</li>
        </ol>
    </div>

    <div id="bloque-comentarios-panel" style="display: none; flex-direction: column; height: calc(100vh - 40px); gap: 15px;">

        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h3 id="panel-titulo-local" style="margin: 0; font-size: 18px; color: #0f172a; font-weight: 700;">Local</h3>
            <button onclick="cerrarPanelComentarios()" style="background: none; border: none; font-size: 18px; cursor: pointer; color: #94a3b8;">✕</button>
        </div>

        <div style="width: 100%; height: 180px; border-radius: 8px; overflow: hidden; border: 1px solid #e2e8f0; background: #eee;">
            <img id="panel-foto-local" src="" alt="Foto local" style="width: 100%; height: 100%; object-fit: cover;" />
        </div>

        <h4 style="margin: 5px 0 0 0; color: #475569; font-size: 14px;">Comentarios comunitarios</h4>
        <div id="contenedor-lista-comentarios" style="flex: 1; overflow-y: auto; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; display: flex; flex-direction: column; gap: 10px; max-height: 250px;">
            <p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Selecciona una publicación...</p>
        </div>

        <form id="form-nuevo-comentario" onsubmit="guardarComentario(event)" style="display: flex; flex-direction: column; gap: 8px; margin-top: auto;">
            <input type="hidden" id="input-post-id" name="idPost" />

            <div class="emoji-picker-bar" style="display: flex; gap: 8px; font-size: 18px; padding: 2px 4px; user-select: none;">
                <span onclick="insertarEmoji('🔥')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">🔥</span>
                <span onclick="insertarEmoji('🌮')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">🌮</span>
                <span onclick="insertarEmoji('🤮')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">🤮</span>
                <span onclick="insertarEmoji('🤑')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">🤑</span>
                <span onclick="insertarEmoji('❤️')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">❤️</span>
                <span onclick="insertarEmoji('👌')" style="cursor: pointer; transition: transform 0.1s ease;" onmouseover="this.style.transform='scale(1.2)'" onmouseout="this.style.transform='scale(1)'">👌</span>
            </div>

            <textarea id="texto-comentario" placeholder="Escribe un comentario foráneo..." required style="width: 100%; height: 60px; border-radius: 6px; border: 1px solid #cbd5e1; padding: 8px; font-size: 13px; resize: none; box-sizing: border-box; font-family: sans-serif;"></textarea>

            <button type="submit" style="background: #1e293b; color: #fff; border: none; padding: 8px; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 13px;">
                Enviar comentario
            </button>
        </form>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Intercambia los páneles y carga la info base
    function abrirPanelComentarios(idPost, titulo, fotoUrl) {
        document.getElementById("bloque-top-lugares").style.display = "none";
        document.getElementById("bloque-comentarios-panel").style.display = "flex";

        document.getElementById("panel-titulo-local").innerText = titulo;
        document.getElementById("panel-foto-local").src = fotoUrl;
        document.getElementById("input-post-id").value = idPost;

        // Llamar al Servlet que devuelve la lista fresca de comentarios en formato JSON
        cargarComentariosDesdeBase(idPost);
    }

    function cerrarPanelComentarios() {
        document.getElementById("bloque-comentarios-panel").style.display = "none";
        document.getElementById("bloque-top-lugares").style.display = "block";
    }

    // 📡 AJAX: Trae los comentarios de MongoAtlas sin recargar la pantalla
    function cargarComentariosDesdeBase(idPost) {
        const contenedor = document.getElementById("contenedor-lista-comentarios");
        contenedor.innerHTML = '<p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Cargando opiniones...</p>';

        fetch('comentarios?action=listar&idPost=' + idPost)
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
                    <div style="display: flex; gap: 8px; background: #f8fafc; padding: 8px; border-radius: 6px; border: 1px solid #f1f5f9;">
                        <img src="${c.foto_perfil || 'img/avatar-default.png'}" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover;" />
                        <div style="flex: 1;">
                            <strong style="font-size: 12px; color: #1e293b; display: block;">${c.nombre_autor}</strong>
                            <p style="margin: 2px 0 0 0; font-size: 12px; color: #475569; word-break: break-word;">${c.texto}</p>
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
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
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

    // Esta función lee tu Servlet de Java (/mapa-pines) que devuelve el JSON
    function cargarMarcadoresExistentes() {
        fetch('mapa-pines')
            .then(response => {
                if (!response.ok) throw new Error("Error al traer pines de base de datos");
                return response.json();
            })
            .then(locales => {
                console.log("[Leaflet] Cargando " + locales.length + " locales desde Atlas...");

                locales.forEach(l => {
                    // Creamos el pin físico usando la latitud y longitud del JSON
                    let pinExistente = L.marker([l.lat, l.lng]).addTo(mapaSeleccion);

                    // Le pegamos un globo popup informativo
                    pinExistente.bindPopup(`
                        <div style="font-family: sans-serif; padding: 2px;">
                            <b style="color: #0f172a; font-size: 14px;">${l.nombre}</b><br>
                            <span style="color: #16a34a; font-weight: 500; font-size: 12px; cursor: pointer;">✨ Click para seleccionar</span>
                        </div>
                    `);

                    // Cuando el estudiante le dé clic al pin existente
                    pinExistente.on('click', function(e) {
                        L.DomEvent.stopPropagation(e); // Evita activar el click de zona vacía

                        // Ocultamos la caja del nombre nuevo (porque este ya existe)
                        document.getElementById("zonaNuevoLocalInput").style.display = "none";

                        // Guardamos la información en nuestra variable global temporal de selección
                        marcadorElegidoData = { tipo: "existing", id: l.id, nombre: l.nombre };

                        // Abrimos el popup con confirmación visual
                        pinExistente.bindPopup(`<b>📍 Seleccionado: ${l.nombre}</b>`).openPopup();
                    });
                });
            })
            .catch(err => {
                // CORREGIDO: Usamos console.log nativo del navegador, no System.out de Java
                console.log("[Fetch] Aún no respondiendo el servlet /mapa-pines o base vacía.");
            });
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

    // 😀 Función para inyectar emojis al input de comentarios activo
    function insertarEmoji(emoji) {
        // Asumiendo que tu input de texto del panel lateral derecho se llama 'txtNuevoComentario'
        const inputComentario = document.getElementById("txtNuevoComentario");
        if(inputComentario) {
            inputComentario.value += emoji;
            inputComentario.focus(); // No pierde el foco de escritura
        }
    }

    function insertarEmoji(emoji) {
        // Apuntamos exactamente al id de tu textarea existente: 'texto-comentario'
        const inputComentario = document.getElementById("texto-comentario");
        if (inputComentario) {
            inputComentario.value += emoji;
            inputComentario.focus(); // Mantiene el cursor adentro para seguir escribiendo texto
        }
    }

</script>



<div id="modalSelectorMapa" style="position: fixed !important; top: 0; left: 0; width: 100vw; height: 100vh; background-color: rgba(15, 23, 42, 0.75); z-index: 99999 !important; display: none; justify-content: center; align-items: center; box-sizing: border-box;">

    <div class="modal-mapa-box" style="background-color: #ffffff; width: 90%; max-width: 650px; height: 540px; border-radius: 12px; padding: 24px; display: flex; flex-direction: column; gap: 14px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3); box-sizing: border-box;">

        <h3 style="margin: 0; font-size: 16px; color: #1e293b; font-family: sans-serif; font-weight: bold;">
            📍 Selecciona un local existente o toca en una zona vacía para registrar uno nuevo:
        </h3>

        <div id="mapa-selector" style="flex: 1; width: 100%; min-height: 300px; border-radius: 8px; border: 1px solid #cbd5e1; background: #f1f5f9;"></div>

        <div id="zonaNuevoLocalInput" style="background-color: #f8fafc; padding: 12px; border-radius: 6px; border: 1px solid #e2e8f0; display: none; box-sizing: border-box;">
            <label style="font-weight: bold; color: #1e293b; font-size: 13px; font-family: sans-serif;">
                ✨ ¡Local no registrado! Dale un nombre para agregarlo al mapa:
            </label>
            <input type="text" id="txtNombreNuevoLocal" placeholder="Ej. Antojitos Cloroformo / Tortas El Inge" style="width: 100%; padding: 10px; margin-top: 6px; border: 1px solid #cbd5e1; border-radius: 4px; box-sizing: border-box; font-size: 14px;">
        </div>

        <div class="modal-mapa-actions" style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 5px;">
            <button type="button" onclick="cerrarSelectorMapa()" style="background-color: #94a3b8; color: #ffffff; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 14px;">
                Omitir / Cancelar
            </button>
            <button type="button" onclick="confirmarSeleccionGeografica()" style="background-color: #0f172a; color: #ffffff; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 14px;">
                Confirmar Destino
            </button>
        </div>

    </div>
</div>




</body>

</html>
