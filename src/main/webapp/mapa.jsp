<%--
  Created by IntelliJ IDEA.
  User: denissexocuis
  Date: 05/06/2026
  Time: 20:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>ForaFood - Mapa de Cercanía</title>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

  <link rel="stylesheet" href="css/mapa.css" />
</head>
<body>

<div class="modulo-mapa-container">

  <div class="mapa-central">
    <div id="map"></div>
  </div>

  <div id="panel-derecho-mapa" class="panel-detalles-mapa">

    <div class="panel-mapa-header">
      <h3 id="mapa-panel-titulo">Local Comercial</h3>
      <button onclick="cerrarPanelMapa()" class="btn-cerrar-panel">✕</button>
    </div>

    <div class="panel-mapa-foto-wrapper">
      <img id="mapa-panel-foto" src="" alt="Foto del local" />
    </div>

    <h4 class="panel-mapa-subtitulo">Opiniones de la facultad:</h4>

    <div id="mapa-panel-comentarios" class="panel-mapa-comentarios-list">
    </div>

  </div>

</div>

<script>
  // Coordenadas base de la Zona UV de ejemplo
  const latFacultad = 19.1622;
  const lngFacultad = -96.1197;

  // Inicializamos el mapa
  const map = L.map('map').setView([latFacultad, lngFacultad], 16);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
  }).addTo(map);

  // Pin de la Facultad (Pin de Origen)
  L.marker([latFacultad, lngFacultad]).addTo(map)
          .bindPopup("<b>Estás Aquí (Facultad)</b>").openPopup();

  // 🔵 Círculo azul de rango para estudiantes a pie
  L.circle([latFacultad, lngFacultad], {
    color: '#3b82f6',
    fillColor: '#93c5fd',
    fillOpacity: 0.25,
    radius: 400
  }).addTo(map);

  // Interacción asíncrona para pintar el panel derecho con clases CSS limpias
  function mostrarDetallesEnPanel(nombre, foto, idPost) {
    document.getElementById("panel-derecho-mapa").style.display = "flex";
    document.getElementById("mapa-panel-titulo").innerText = nombre;
    document.getElementById("mapa-panel-foto").src = foto;

    const contenedor = document.getElementById("mapa-panel-comentarios");
    contenedor.innerHTML = "<p style='color:#94a3b8; text-align:center; font-size:12px;'>Buscando opiniones...</p>";

    fetch('comentarios?action=listar&idPost=' + idPost)
            .then(res => res.json())
            .then(comentarios => {
              contenedor.innerHTML = "";
              if(comentarios.length === 0) {
                contenedor.innerHTML = "<p style='color:#94a3b8; text-align:center; font-size:12px; margin:auto;'>Sin comentarios aún en este local.</p>";
                return;
              }
              comentarios.forEach(c => {
                contenedor.innerHTML += `
                            <div class="comentario-item-mapa">
                                <strong>${c.nombre_autor}</strong>
                                ${c.texto}
                            </div>
                        `;
              });
            });
  }

  function cerrarPanelMapa() {
    document.getElementById("panel-derecho-mapa").style.display = "none";
  }

  // Ejemplo estático para probar que el switch de CSS funcione al dar click
  L.marker([19.1630, -96.1185]).addTo(map)
          .bindPopup("<b>Tacos El Güero</b><br>Toca para ver el menú completo")
          .on('click', function() {
            mostrarDetallesEnPanel("Tacos El Güero", "https://placehold.co/140x120?text=Tacos", "ID_POST_MONGO");
          });
</script>
</body>
</html>