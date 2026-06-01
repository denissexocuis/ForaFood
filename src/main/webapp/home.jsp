<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
        <h2>ForaFood</h2> <form action="home" method="get" style="margin: 0; display: flex; gap: 5px;">
        <input type="text" name="txtBuscar" placeholder="Buscar lugares o comida..." style="padding: 6px; width: 250px;">
        <button type="submit">🔍 Buscar</button>
    </form>
    </div>

    <p style="color: gray; margin-top: 10px;">Posts⬇️</p>

    <!--  BOTON PARA INSERTAR UNA PUBLICACIÓN-->
    <button class="btn-desplegar-form" id="btnCompartirPrincipal" onclick="alternarFormulario()">
        ✨ Compartir un nuevo lugar o menú
    </button>

    <div id="contenedorFormulario" class="formulario-oculto" style="border: 2px dashed #333; padding: 15px; margin-bottom: 30px; border-radius: 5px;">
        <h3>✨ Compartir un nuevo lugar o menú</h3>

        <form action="crearpost" method="post" id="formNuevaPublicacion">
            <div style="margin-bottom: 10px;">
                <label>Título de la publicación:</label><br>
                <input type="text" name="txtTitulo" placeholder="Ej. ¡Tacos buenísimos afuera de la facultad!" style="width: 100%; padding: 5px;" required>
            </div>

            <div style="margin-bottom: 10px;">
                <label>Descripción / Precios / Menú:</label><br>
                <textarea name="txtDescripcion" placeholder="Cuéntale a la comunidad qué venden, cuánto cuesta..." style="width: 100%; height: 80px; padding: 5px;" required></textarea>
            </div>

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

            <div style="margin-bottom: 15px;">
                <label>URL de la imagen (Opcional):</label><br>
                <input type="text" name="txtImagen" placeholder="URL o nombre de la foto" style="width: 100%; padding: 5px;">
            </div>

            <div style="display: flex; gap: 10px;">
                <button type="submit" style="background-color: #333; color: white; padding: 8px 15px; border: none; cursor: pointer; border-radius: 3px; font-weight: bold;">
                    🚀 Publicar en el Feed
                </button>

                <button type="button" onclick="cancelarPublicacion()" style="background-color: #999; color: white; padding: 8px 15px; border: none; cursor: pointer; border-radius: 3px; font-weight: bold;">
                    ❌ Cancelar
                </button>
            </div>
        </form>
    </div>

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

    <%
        List<Document> listaPosts = (List<Document>) request.getAttribute("posts_comunidad");
        if (listaPosts != null && !listaPosts.isEmpty()) {
            for (Document post : listaPosts) {
    %>
    <div class="post-card">
        <div style="display: flex; justify-content: space-between;">
            <div>
                <h3><%= post.getString("titulo") %></h3>
                <p><%= post.getString("texto_publicacion") %></p>

                <span style="font-size: 14px; color: #cc7a00;">
                                    ⭐ Valoración / Confiabilidad:
                                    👍 <%= post.getInteger("votosVigente", 0) %> vigentes |
                                    👎 <%= post.getInteger("votosFalso", 0) %> falsos
                                </span>
            </div>

            <div style="width: 100px; height: 80px; border: 1px dashed gray; display: flex; align-items: center; justify-content: center; background: #eee;">
                [ Imagen ]
            </div>
        </div>
    </div>
    <%
        }
    } else {
    %>
    <div class="post-card">
        <h3>@KasaneTeto22</h3>
        <p>¡Los tacos de la esquina de la facultad están a 5x25 pesos hoy! Super recomendados.</p>
        <span style="color: gold;">⭐⭐⭐ 4.5 valoración / confiabilidad</span>
    </div>
    <div class="post-card">
        <h3 style="color: gray;">otro post</h3>
    </div>
    <div class="post-card">
        <h3 style="color: gray;">otro post</h3>
    </div>
    <%
        }
    %>
</div>


<div class="sidebar-right">
    <h3 style="letter-spacing: 1px;">TOP LUGARES</h3>
    <ol style="padding-left: 20px; line-height: 2.5;">
        <li>Tacos "El Güero"</li>
        <li>Antojitos Doña Mary</li>
        <li>Tortas La Facultad</li>
        <li>Comida Casera Económica</li>
    </ol>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
