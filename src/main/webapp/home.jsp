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

    <!-- fevicon -->
    <link rel="icon" type="image/png" href="img/diet.png">

    <!-- fonts style -->
    <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet" />
</head>

<body class="bg-white">

<div class="sidebar-left">
    <h3>¡Bienvenido a ForaFood, <%= session.getAttribute("user") %>!</h3>
    <a href="index.jsp">Cerrar Sesión</a>

    <!-- TODO: aqui meter un js para boton de Feed-->
    <a href="home.jsp" style="font-weight: bold; text-decoration: none; color: black;">[ Feed ]</a>

    <!-- TODO: aqui meter un js para boton de Mapa-->
    <a href="home.jsp" style="font-weight: bold; text-decoration: none; color: black;">[ Mapa ]</a>

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
    <button class="btn-desplegar-form" id="btnCompartirPrincipal" onclick="alternarFormulario()">
        Compartir un nuevo lugar o menú
    </button>

    <div id="contenedorFormulario" class="formulario-oculto" style="border: 2px dashed #333; padding: 15px; margin-bottom: 30px; border-radius: 5px;">
        <h3>Compartir un nuevo lugar o menú</h3>

        <form action="crearpost" method="post" id="formNuevaPublicacion">
            <div style="margin-bottom: 10px;">
                <label>Título:</label><br>
                <input type="text" name="txtTitulo" placeholder="Ej. ¡Tacos buenísimos afuera de la facultad!" style="width: 100%; padding: 5px;" required>
            </div>

            <div style="margin-bottom: 10px;">
                <label>Descripción / Precios / Menú:</label><br>
                <textarea name="txtDescripcion" placeholder="Cuéntale a la comunidad qué venden, cuánto cuesta..." style="width: 100%; height: 80px; padding: 5px;" required></textarea>
            </div>

            <!-- TODO-->
            <div style="margin-bottom: 10px; display: flex; gap: 20px;">
                <div>
                    <label>Establecimiento:</label>
                    <select name="selEstablecimiento">
                        <option value="665ab987f1a2b3c4d5e6f991">Tacos El Güero</option>
                        <option value="665ab987f1a2b3c4d5e6f992">Antojitos Doña Mary</option>
                        <option value="665ab987f1a2b3c4d5e6f993">Tortas La Facultad</option>
                    </select>
                </div>
            </div>

            <!-- TODO -->
            <div style="margin-bottom: 15px;">
                <label>URL de la imagen (Opcional):</label><br>
                <input type="text" name="txtImagen" placeholder="URL o nombre de la foto" style="width: 100%; padding: 5px;">
            </div>

            <div style="display: flex; gap: 10px;">
                <button type="submit" style="background-color: #333; color: white; padding: 8px 15px; border: none; cursor: pointer; border-radius: 3px; font-weight: bold;">
                    Publicar
                </button>

                <button type="button" onclick="cancelarPublicacion()" style="background-color: #999; color: white; padding: 8px 15px; border: none; cursor: pointer; border-radius: 3px; font-weight: bold;">
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
                List<Document> mediaList = (List<Document>) post.get("multimedia");
                String rutaFotoLocal = "img/default-local.png"; // Imagen de respaldo si no subieron nada

                if (mediaList != null && !mediaList.isEmpty()) {
                    Document primeraMultimedia = mediaList.get(0);
                    rutaFotoLocal = primeraMultimedia.getString("url"); // Jala atributo privado 'url'
                }

                // extraer datos de autor desnormalizados
                String nombreAutor = post.getString("nombre_autor");
                String fotoPerfil = post.getString("foto_perfil_autor");

                if (nombreAutor == null) nombreAutor = "Anónimo";
                if (fotoPerfil == null) fotoPerfil = "img/avatar-default.png";
    %>

    <!-- post card para mandar los datos de votación si es real o no -->
        <div class="post-card" style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 24px; background: #ffffff; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); font-family: sans-serif; display: flex; gap: 20px; align-items: flex-start;">

            <div style="flex-shrink: 0; padding-top: 4px;">
                <img src="<%= fotoPerfil %>"
                     alt="Avatar"
                     style="width: 50px; height: 50px; border-radius: 50%; background: #e2e8f0; object-fit: cover; border: 1px solid #cbd5e1;"
                     onerror="this.onerror=null; this.src='https://api.dicebear.com/7.x/bottts/svg?seed=default';" />
            </div>

            <div style="flex: 1; display: flex; flex-direction: column; gap: 8px;">

                <div style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                    <strong style="color: #1e293b; font-size: 15px;"><%= nombreAutor %></strong>
                    <span style="color: #94a3b8; font-size: 13px;">•</span>
                    <span style="font-size: 13px; color: #64748b;">Comunidad Universitaria</span>
                    <span style="color: #94a3b8; font-size: 13px;">•</span>
                    <span style="font-size: 13px; color: #94a3b8; font-weight: 500;"><%= fecha_formateada %></span>
                </div>

                <h3 style="margin: 4px 0 2px 0; font-size: 22px; color: #0f172a; font-weight: 700; line-height: 1.2;">
                    <%= post.getString("titulo") %>
                </h3>

                <p style="margin: 0 0 10px 0; color: #475569; line-height: 1.5; font-size: 15px; word-break: break-word; white-space: normal;">
                    <%= post.getString("texto_publicacion") %>
                </p>

                <div style="font-size: 14px; color: #b45309; background: #fffbeb; border: 1px solid #fef3c7; padding: 8px 16px; border-radius: 6px; display: inline-flex; align-items: center; gap: 15px; width: fit-content; margin-top: 4px;">

                    <a href="votar?id=<%= post.getObjectId("_id") %>&tipo=real" style="text-decoration: none; display: flex; align-items: center; gap: 4px;">
                        <strong style="color: #16a34a;"><%= post.getInteger("votosVigente", 0) %></strong> <span style="color: #16a34a; font-weight: 500;">Es real</span>
                    </a>

                    <span style="color: #cbd5e1;">|</span>

                    <a href="votar?id=<%= post.getObjectId("_id") %>&tipo=falso" style="text-decoration: none; display: flex; align-items: center; gap: 4px;">
                        <strong style="color: #dc2626;"><%= post.getInteger("votosFalso", 0) %></strong> <span style="color: #dc2626; font-weight: 500;">Es falso</span>
                    </a>

                    <span style="color: #cbd5e1;">|</span>

                    <a href="javascript:void(0);"
                       onclick="abrirPanelComentarios('<%= post.getObjectId("_id") %>', '<%= post.getString("titulo") %>', '<%= rutaFotoLocal %>')"
                       style="text-decoration: none; display: flex; align-items: center; gap: 4px; color: #475569; font-weight: 500;">
                        <span style="color: #475569;">Comentarios</span>
                    </a>
                </div>
            </div>

            <div style="width: 140px; height: 120px; border-radius: 8px; overflow: hidden; background: #f8fafc; display: flex; align-items: center; justify-content: center; border: 1px solid #e2e8f0; flex-shrink: 0;">
                <img src="<%= rutaFotoLocal %>"
                     alt="Local Comercial"
                     style="width: 100%; height: 100%; object-fit: cover;"
                     onerror="this.src='https://placehold.co/140x120?text=ForaFood';" />
            </div>

        </div>
    <%
        }
    } else {
    %>
    <div style="text-align: center; padding: 40px; color: #64748b; font-family: sans-serif;">
        <p style="font-size: 18px; margin-bottom: 8px;">Aún no hay publicaciones en tu comunidad.</p>
        <p style="font-size: 14px; margin: 0;">¡Sé el primero en recomendar unos tacos usando la caja de arriba!</p>
    </div>
    <%
        }
    %>
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
            <textarea id="texto-comentario" placeholder="Escribe un comentario foráneo..." required style="width: 100%; height: 60px; border-radius: 6px; border: 1px solid #cbd5e1; padding: 8px; font-size: 13px; resize: none; box-sizing: border-box;"></textarea>
            <button type="submit" style="background: #1e293b; color: #fff; border: none; padding: 8px; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 13px;">
                Enviar comentario
            </button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
