<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es" data-theme="light" id="ff-root">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ForaFood - Radar Gastronómico</title>

  <!-- Leer tema guardado ANTES de pintar para evitar flash de color incorrecto -->
  <script>(function(){var t=localStorage.getItem('ff-theme');if(t)document.documentElement.setAttribute('data-theme',t);})();</script>

  <link rel="stylesheet" type="text/css" href="../css/bootstrap.css">
  <link rel="stylesheet" href="../css/theme.css">
  <link rel="icon" type="image/png" href="../img/diet.png">
  <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet" />

  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

  <link rel="stylesheet" href="../css/mapa.css">
  <style>
    html, body { height: 100%; margin: 0; padding: 0; overflow: hidden; font-family: 'Poppins', sans-serif; }
    .pantalla-completa-flex { display: flex; flex-direction: column; height: 100vh; }
    .cuerpo-columnas-container { display: flex; flex: 1; width: 100%; overflow: hidden; box-sizing: border-box; }
    .columna-menu-izquierda {
      width: 240px; flex-shrink: 0;
      background: var(--bg-sidebar); border-right: 1px solid var(--border);
      padding: 20px; display: flex; flex-direction: column; gap: 15px; color: var(--text-1);
    }
    .columna-mapa-central {
      flex: 1; padding: 20px; display: flex; flex-direction: column; gap: 15px;
      background: var(--bg-feed);
    }
    .columna-comentarios-derecha {
      width: 320px; flex-shrink: 0;
      background: var(--bg-right); border-left: 1px solid var(--border);
      padding: 20px; display: flex; flex-direction: column; gap: 15px;
      box-sizing: border-box; color: var(--text-1);
    }
    /* Navbar del mapa */
    .ff-mapa-navbar {
      padding: 12px 40px;
      background: var(--bg-root);
      border-bottom: 1px solid var(--border);
      display: flex; justify-content: space-between; align-items: center; flex-shrink: 0;
    }
    .ff-mapa-logo { font-size: 22px; font-weight: 700; color: var(--green); font-family: 'Poppins', sans-serif; }
    .ff-mapa-search-input {
      padding: 8px 16px; width: 380px;
      border: 1px solid var(--border); border-radius: 20px; outline: none;
      font-size: 14px; background: var(--bg-input); color: var(--text-1);
      font-family: 'Poppins', sans-serif;
    }
    .ff-mapa-search-input::placeholder { color: var(--text-3); }
    .ff-mapa-search-btn {
      background: var(--green-btn); color: #fff; border: none;
      padding: 8px 22px; border-radius: 20px; font-weight: 600; cursor: pointer;
      font-family: 'Poppins', sans-serif; transition: background 0.18s;
    }
    .ff-mapa-search-btn:hover { background: var(--green-btn-hover); }
    /* Bloque perfil en mapa */
    .ff-mapa-perfil {
      text-align: center; padding: 12px;
      background: var(--bg-card); border-radius: 12px; border: 1px solid var(--border-card); margin-bottom: 4px;
    }
    .ff-mapa-perfil img { width: 55px; height: 55px; border-radius: 50%; object-fit: cover; border: 2px solid var(--green-btn); margin-bottom: 6px; }
    .ff-mapa-perfil h4 { margin: 0; font-size: 14px; font-weight: 700; color: var(--text-1); }
    .ff-mapa-perfil .badge-rango { font-size: 11px; background: var(--bg-badge); color: var(--green); padding: 1px 8px; border-radius: 10px; font-weight: 600; display: inline-block; margin-top: 4px; }
    .ff-mapa-perfil .pts { font-size: 11px; color: var(--text-2); margin-top: 4px; }
    .ff-mapa-perfil .pts strong { color: var(--green-mid); }
    /* Links del sidebar izq del mapa */
    .ff-mapa-link { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; color: var(--text-2); text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.18s; }
    .ff-mapa-link:hover { background: var(--bg-hover); color: var(--green); }
    .ff-mapa-link-cerrar { color: var(--red) !important; }
    .ff-mapa-link-cerrar:hover { background: var(--red-bg) !important; color: var(--red) !important; }
    hr.ff-hr { border-top: 1px solid var(--border); margin: 8px 0; }
    /* Encabezado del mapa */
    .ff-mapa-header {
      background: var(--bg-card); padding: 12px 16px; border-radius: 12px;
      border: 1px solid var(--border-card); display: flex; flex-direction: column;
    }
    .ff-mapa-header h2 { margin: 0; font-size: 16px; color: var(--text-1); font-weight: 700; }
    .ff-mapa-header span { color: var(--text-2); font-size: 12.5px; }
    /* Panel derecho comentarios */
    .ff-panel-vacio { text-align: center; margin: auto 0; padding: 20px; color: var(--text-3); }
    .ff-panel-vacio p { font-size: 13px; font-weight: 500; line-height: 1.4; color: var(--text-3); }
    /* Tabs */
    .ff-tab-bar { display: flex; border-bottom: 1px solid var(--border); margin-bottom: 10px; gap: 4px; }
    .ff-tab-btn {
      flex: 1; padding: 10px; border: none; background: none;
      font-size: 12px; font-weight: 700; color: var(--text-3); cursor: pointer;
      border-bottom: 2px solid transparent; transition: all 0.2s;
      font-family: 'Poppins', sans-serif;
    }
    .ff-tab-btn.active { color: var(--green); border-bottom-color: var(--green-btn); }
    /* Resumen puntuación */
    .ff-score-box {
      background: var(--bg-card); border: 1px solid var(--border-card); border-radius: 8px;
      padding: 12px; text-align: center; display: flex; flex-direction: column;
      gap: 2px; margin-bottom: 12px;
    }
    .ff-score-box .label { font-size: 11px; font-weight: 700; color: var(--text-3); letter-spacing: 0.5px; }
    .ff-score-box .stars { font-size: 24px; color: var(--gold); font-weight: 700; margin: 2px 0; }
    .ff-score-box .num { font-size: 14px; color: var(--text-1); font-weight: 700; }
    /* Tarjetas de comentarios generadas por JS */
    .ff-resena-card {
      background: var(--bg-card) !important; border: 1px solid var(--border-card) !important;
      border-radius: 6px !important; padding: 8px !important;
      color: var(--text-1) !important; margin-bottom: 6px !important;
    }
    /* Select y textarea en mapa */
    .ff-select, .ff-mapa-textarea {
      width: 100%; padding: 8px; border-radius: 6px;
      border: 1px solid var(--border-card); font-size: 12px;
      background: var(--bg-input); color: var(--text-1);
      font-family: 'Poppins', sans-serif;
    }
    .ff-mapa-textarea { height: 65px; resize: none; box-sizing: border-box; }
    .ff-select:focus, .ff-mapa-textarea:focus {
      outline: none; border-color: var(--green-btn);
      box-shadow: 0 0 0 3px rgba(22,163,74,0.12);
    }
    /* Botón enviar valoración */
    .ff-btn-valorar {
      background: var(--green-btn); color: white; border: none;
      padding: 8px; border-radius: 6px; font-size: 12px;
      font-weight: 700; cursor: pointer; width: 100%;
      display: flex; align-items: center; justify-content: center; gap: 6px;
      font-family: 'Poppins', sans-serif; transition: background 0.18s;
    }
    .ff-btn-valorar:hover { background: var(--green-btn-hover); }
    /* Modal de publicación */
    .ff-modal-box {
      background: var(--bg-card) !important; border: 1px solid var(--border-card);
      width: 100%; max-width: 500px; max-height: 90vh;
      border-radius: 12px; display: flex; flex-direction: column;
      overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.6);
    }
    .ff-modal-header {
      padding: 12px 16px; border-bottom: 1px solid var(--border);
      display: flex; justify-content: space-between; align-items: center;
      background: var(--bg-sidebar);
    }
    .ff-modal-header strong { font-size: 14px; color: var(--text-1); }
    .ff-modal-close {
      background: none; border: none; font-size: 16px;
      cursor: pointer; color: var(--text-2); font-weight: 700; transition: color 0.18s;
    }
    .ff-modal-close:hover { color: var(--red); }
    .ff-modal-body { padding: 16px; overflow-y: auto; }
    .ff-modal-body h3 { margin: 0 0 10px; font-size: 18px; color: var(--text-1); font-weight: 800; }
    .ff-modal-body p { margin: 0; font-size: 13px; color: var(--text-2); line-height: 1.6; white-space: pre-wrap; }
    .ff-modal-body hr { border-top: 1px solid var(--border); margin: 20px 0; }
    .ff-modal-body h5 { font-size: 13px; font-weight: 700; color: var(--text-1); margin-bottom: 10px; }
    /* Tarjeta de publicación en panel derecho del mapa */
    .ff-pub-card {
      background: var(--bg-card) !important; border: 1px solid var(--border-card) !important;
      border-radius: 8px !important; padding: 10px !important; margin-bottom: 12px !important;
    }
    .ff-pub-card h4 { margin: 0 0 4px; font-size: 13px; color: var(--text-1) !important; font-weight: 700; }
    .ff-pub-card .autor { font-size: 10px; color: var(--green-mid) !important; font-weight: 600; display: block; margin-bottom: 6px; }
    .ff-pub-card p { margin: 0 0 10px; font-size: 11px; color: var(--text-2) !important; line-height: 1.4; }
    .ff-btn-expandir {
      width: 100%; background: var(--bg-hover) !important; color: var(--text-1) !important;
      border: 1px solid var(--border-card) !important; padding: 6px; border-radius: 6px;
      font-size: 11px; font-weight: 600; cursor: pointer; transition: all 0.18s;
    }
    .ff-btn-expandir:hover { border-color: var(--green-btn) !important; color: var(--green) !important; }
    /* Burbuja comentarios en modal */
    .ff-comentario-burbuja {
      display: flex; gap: 10px;
      background: var(--bg-comment) !important; border: 1px solid var(--border-card) !important;
      border-radius: 6px !important; padding: 8px !important; margin-bottom: 8px !important;
    }
    .ff-comentario-burbuja strong { font-size: 11px; color: var(--text-1) !important; }
    .ff-comentario-burbuja p { margin: 0; font-size: 11px; color: var(--text-2) !important; white-space: pre-wrap; }
    /* Info perfil en panel derecho mapa */
    .ff-panel-perfil-info {
      display: flex; gap: 12px; align-items: center; margin-bottom: 10px;
    }
    .ff-panel-perfil-info img { width: 55px; height: 55px; border-radius: 8px; object-fit: cover; border: 1px solid var(--border-card); }
    .ff-panel-perfil-info h3 { margin: 0; font-size: 16px; font-weight: 700; color: var(--text-1); }
    .ff-panel-perfil-info span { font-size: 11px; color: var(--green-mid); font-weight: 700; }
    .ff-reseñas-label { font-weight: 700; font-size: 12px; color: var(--text-2); display: block; margin-bottom: 6px; }
    .ff-reseñas-container {
      flex-grow: 1; overflow-y: auto; display: flex; flex-direction: column;
      gap: 8px; padding-right: 2px; max-height: 180px; margin-bottom: 15px;
      border-bottom: 1px dashed var(--border-card); padding-bottom: 10px;
    }
  </style>
</head>
<body>

<div class="pantalla-completa-flex">

  <div class="ff-mapa-navbar">
    <div style="display: flex; align-items: center; gap: 10px;">
      <img src="../img/diet.png" style="width: 28px; height: 28px;">
      <span class="ff-mapa-logo">ForaFood</span>
    </div>

    <form action="principal" method="get" style="margin: 0; display: flex; gap: 8px;">
      <input type="text" name="txtBuscar" placeholder="Buscar puestos o comidas en el feed..." class="ff-mapa-search-input">
      <button type="submit" class="ff-mapa-search-btn">Buscar</button>
    </form>
    <div style="width: 120px;"></div>
  </div>

  <div class="cuerpo-columnas-container">

    <div class="columna-menu-izquierda">
      <div class="ff-mapa-perfil">
        <img src="<%= session.getAttribute("foto_perfil") != null ? session.getAttribute("foto_perfil") : "img/avatar-default.png" %>" style="width:55px;height:55px;border-radius:50%;object-fit:cover;border:2px solid #16a34a;margin-bottom:6px;">
        <h4 style="margin:0;font-size:14px;font-weight:700;color:var(--text-1);"><%= session.getAttribute("user") %></h4>
        <span class="badge-rango">
                        <%= session.getAttribute("rango") != null ? session.getAttribute("rango") : "Novato" %>
                    </span>
        <div class="pts">🏆 <strong><%= session.getAttribute("puntos") != null ? session.getAttribute("puntos") : 0 %></strong> pts</div>
      </div>

      <div style="display: flex; flex-direction: column; gap: 6px;">
        <a href="principal" class="ff-mapa-link">
          🏠 Feed de la Facultad
        </a>
        <hr class="ff-hr">
        <a href="../index.jsp" class="ff-mapa-link ff-mapa-link-cerrar">
          🚪 Cerrar Sesión
        </a>
      </div>
    </div>

    <div class="columna-mapa-central">
      <div class="ff-mapa-header">
        <h2>🗺️ Radar Gastronómico Universitario</h2>
        <span>Haz click en los pines del mapa para ver las opiniones del local en el panel derecho.</span>
      </div>

      <div id="mapaPantallaCompleta" style="width: 100%; flex-grow: 1; border-radius: 12px; border: 1px solid #cbd5e1; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02);"></div>
    </div>

    <div class="columna-comentarios-derecha" id="panel-derecho-comentarios">

      <div id="aviso-panel-vacio" class="ff-panel-vacio">
        <img src="../img/diet.png" style="width: 45px; opacity: 0.3; margin-bottom: 8px;">
        <p>Selecciona un pin del mapa para desplegar las opiniones de la comunidad.</p>
      </div>

      <div id="contenido-panel-activo" style="display: none; flex-direction: column; gap: 12px; height: 100%;">
        <div class="ff-panel-perfil-info">
          <img id="foto-local-panel" src="../img/posts/default-local.png" style="width:55px;height:55px;border-radius:8px;object-fit:cover;border:1px solid #263329;">
          <div>
            <h3 id="panel-comentarios-titulo">Nombre del Local</h3>
            <span>📍 Local Verificado</span>
          </div>
        </div>

        <div class="ff-tab-bar">
          <button id="tab-publicaciones" onclick="cambiarPestaña('publicaciones')" class="ff-tab-btn active">
            📜 PUBLICACIONES
          </button>
          <button id="tab-valoracion" onclick="cambiarPestaña('valoracion')" class="ff-tab-btn">
            ⭐ VALORACIÓN
          </button>
        </div>

        <div id="vista-publicaciones" style="display: flex; flex-direction: column; flex: 1; overflow: hidden;">
          <div id="contenedor-comentarios-scroll" style="flex: 1; overflow-y: auto; padding-right: 4px; display: flex; flex-direction: column; gap: 10px; margin-bottom: 12px;">
          </div>
        </div>

        <div id="vista-valoracion" style="display: none; flex-direction: column; flex: 1; overflow: hidden; height: 100%;">

          <div class="ff-score-box">
            <span class="label">PUNTUACIÓN DE LA COMUNIDAD</span>
            <div id="estrellas-promedio-render" class="stars">⭐⭐⭐⭐⭐</div>
            <span id="texto-promedio-num" class="num">5.0 / 5.0</span>
          </div>

          <span class="ff-reseñas-label">📋 Reseñas Históricas:</span>
          <div id="contenedor-reseñas-historicas" class="ff-reseñas-container">

            <div class="ff-resena-card" style="display:flex;flex-direction:column;gap:3px;">
              <div style="display: flex; justify-content: space-between; align-items: center;">
                <strong style="font-size:11px;color:var(--text-1);">@EstudianteUV</strong>
                <span style="color: #fbbf24; font-size: 11px;">⭐⭐⭐⭐⭐</span>
              </div>
              <p style="margin:0;font-size:11px;color:var(--text-2);line-height:1.3;">La comida está riquísima, muy limpio todo y económico.</p>
            </div>

          </div>

          <form id="form-nueva-valoracion" onsubmit="guardarValoracion(event)" style="display:flex;flex-direction:column;gap:10px;border-top:1px solid #1f2e22;padding-top:10px;margin-top:auto;">

            <input type="hidden" id="input-post-id" value="">

            <div>
              <label style="font-weight:700;font-size:12px;color:var(--text-2);display:block;margin-bottom:4px;">¿Qué tal está la comida y el precio?</label>
              <select id="select-calificacion" class="ff-select">
                <option value="5">⭐⭐⭐⭐⭐ Excelente (Súper Foráneo Friendly)</option>
                <option value="4">⭐⭐⭐⭐ Muy Bueno (Rico y llenador)</option>
                <option value="3">⭐⭐⭐ Bueno (Cumple para el bajón)</option>
                <option value="2">⭐⭐ Regular (Dos tres, algo caro)</option>
                <option value="1">⭐ Malo (No lo recomiendo)</option>
              </select>
            </div>

            <div>
              <label style="font-weight:700;font-size:12px;color:var(--text-2);display:block;margin-bottom:4px;">Escribe una reseña o tip:</label>
              <textarea id="texto-comentario-valoracion" placeholder="Ej. Los chilaquiles con milanesa están enormes..." required class="ff-mapa-textarea"></textarea>
            </div>

            <button type="submit" class="ff-btn-valorar">
              🚀 Enviar Valoración
            </button>
          </form>

        </div>

      </div>

    </div>

  </div>
</div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
  document.addEventListener("DOMContentLoaded", function() {
    // Inicializar el mapa centrado en la facultad (Zona UV)
    const mapa = L.map('mapaPantallaCompleta').setView([19.1622, -96.1197], 16);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap'
    }).addTo(mapa);

    // 📡 Consultar tus pines reales vinculados a los posts multimedia
    fetch('mapa-pines')
            .then(res => res.json())
            .then(locales => {
              console.log("[DEBUG] Locales recibidos para pintar:", locales);
              locales.forEach(l => {
                if (l.lat && l.lng) {
                  let marker = L.marker([l.lat, l.lng]).addTo(mapa);

                  let popupHTML = '<div style="font-family:Poppins,sans-serif;text-align:center;padding:4px;background:var(--bg-card);border-radius:6px;">' +
                                    '<b style="color:var(--text-1);font-size:13px;display:block;margin-bottom:6px;">' + l.nombre + '</b>' +
                                    '<button onclick="abrirPanelComentarios(\'' + l.id + '\', \'' + l.nombre + '\', \'' + (l.url_foto || '') + '\')" ' +
                                        'style="background:#16a34a;color:white;border:none;padding:4px 10px;border-radius:4px;font-size:11px;font-weight:700;cursor:pointer;font-family:Poppins,sans-serif;">' +
                                        '💬 Ver opiniones' +
                                    '</button>' +
                                  '</div>';

                  marker.bindPopup(popupHTML);
                }
              });
            })
            .catch(err => console.error("Error al renderizar pines de publicaciones:", err));
  });

  // 🎯 Adaptación de tu función original perfectamente enlazada para la barra del Mapa
  function abrirPanelComentarios(idPost, titulo, fotoUrl) {
    cambiarPestaña('publicaciones');
    // Apagamos el aviso inicial de panel vacío
    if (document.getElementById("aviso-panel-vacio")) {
      document.getElementById("aviso-panel-vacio").style.display = "none";
    }
    // Encendemos la caja del panel de comentarios
    if (document.getElementById("contenido-panel-activo")) {
      document.getElementById("contenido-panel-activo").style.display = "flex";
    }

    // Seteamos título e imagen correspondientes
    document.getElementById("panel-comentarios-titulo").innerText = titulo;

    const imgPanel = document.getElementById("foto-local-panel");
    if (fotoUrl && fotoUrl !== "" && fotoUrl !== "null") {
      imgPanel.src = fotoUrl;
    } else {
      imgPanel.src = "img/posts/default-local.png";
    }

    // Guardamos el ID del post en el input oculto para poder comentar asíncronamente
    document.getElementById("input-post-id").value = idPost;

    // 📡 Lanzar tu petición AJAX original que jala perfecto de la base de datos
    cargarComentariosDesdeBase(idPost);
    cargarPublicacionesDelLocal(idPost);
  }

  // 🎯 CONECTOR ASÍNCRONO: Abre la barra derecha con el ID del post de Mongo
  function conectarPinConPanel(idPost, nombreLocal, urlFoto) {
    document.getElementById("aviso-panel-vacio").style.display = "none";
    document.getElementById("contenido-panel-activo").style.display = "flex";

    document.getElementById("input-post-id").value = idPost;
    document.getElementById("panel-comentarios-titulo").innerText = nombreLocal;

    const imgLocal = document.getElementById("foto-local-panel");
    if (urlFoto && urlFoto !== "" && urlFoto !== "null") {
      imgLocal.src = urlFoto;
    } else {
      imgLocal.src = "img/posts/default-local.png";
    }

    // Invocar la carga asíncrona de opiniones
    cargarComentariosDesdeBase(idPost);
    cargarPublicacionesDelLocal(idPost);
  }


  function guardarComentario(event) {
    event.preventDefault();
    const idPost = document.getElementById("input-post-id").value;
    const texto = document.getElementById("texto-comentario").value;

    fetch('comentarios-mapa', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
      body: `idPost=${idPost}&texto=${encodeURIComponent(texto)}`
    }).then(response => {
      if(response.ok) {
        document.getElementById("texto-comentario").value = "";
        cargarComentariosDesdeBase(idPost);
      }
    });
  }

  function insertarEmoji(emoji) {
    document.getElementById("texto-comentario").value += emoji;
    document.getElementById("texto-comentario").focus();
  }

  function cambiarPestaña(tipo) {
    const btnPubs = document.getElementById("tab-publicaciones");
    const btnVal = document.getElementById("tab-valoracion");
    const vistaPubs = document.getElementById("vista-publicaciones");
    const vistaVal = document.getElementById("vista-valoracion");

    if (tipo === 'publicaciones') {
      btnPubs.classList.add("active"); btnVal.classList.remove("active");
      vistaPubs.style.display = "flex"; vistaVal.style.display = "none";
    } else {
      btnVal.classList.add("active"); btnPubs.classList.remove("active");
      vistaPubs.style.display = "none"; vistaVal.style.display = "flex";
    }
  }


  // 📡 ENVIAR VALORACIÓN DIRECTO AL ESTABLECIMIENTO
  function guardarValoracion(event) {
    event.preventDefault();

    // El input oculto contiene el ID del Establecimiento (local) seleccionado
    const idEstablecimiento = document.getElementById("input-post-id").value;
    const estrellas = document.getElementById("select-calificacion").value;
    const comentarioTexto = document.getElementById("texto-comentario-valoracion").value;

    if (!idEstablecimiento || !comentarioTexto.trim()) return;

    fetch('comentarios-mapa', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
      // Enviamos 'idPost' para que coincida exactamente con tu request.getParameter("idPost") del servlet
      body: 'idPost=' + encodeURIComponent(idEstablecimiento) +
              '&texto=' + encodeURIComponent(comentarioTexto) +
              '&calificacion=' + encodeURIComponent(estrellas)
    })
            .then(response => {
              if (!response.ok) throw new Error("Error en el servidor");
              return response.json();
            })
            .then(data => {
              if (data.success) {
                console.log("[Reseña] Éxito. Nuevo promedio acumulado:", data.nuevoPromedio);

                // 1. Forzamos la actualización inmediata de la lista histórica leyendo de la BD
                cargarComentariosDesdeBase(idEstablecimiento);

                // 2. Limpiamos el campo de texto
                document.getElementById("texto-comentario-valoracion").value = "";
              } else {
                alert("Hubo un error al procesar la valoración.");
              }
            })
            .catch(err => {
              console.error("Error en Fetch de valoraciones:", err);
            });
  }

  // 📡 LEER COMENTARIOS DIRECTO DESDE EL ESTABLECIMIENTO
  function cargarComentariosDesdeBase(idEstablecimiento) {
    // 🎯 Ahora SOLO buscamos el contenedor de las reseñas históricas
    const contenedorReseñas = document.getElementById("contenedor-reseñas-historicas");

    if (!contenedorReseñas) return;

    contenedorReseñas.innerHTML = '<p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Cargando opiniones...</p>';

    fetch('comentarios-mapa?idPost=' + idEstablecimiento)
            .then(response => response.json())
            .then(data => {
              console.log("[Fetch] Datos de MongoDB:", data);

              // 1. Actualizamos el promedio en la interfaz superior
              const promedioGlobal = data.promedio !== undefined ? data.promedio : 5.0;
              document.getElementById("texto-promedio-num").innerText = promedioGlobal.toFixed(1) + " / 5.0";
              document.getElementById("estrellas-promedio-render").innerText = "⭐".repeat(Math.round(promedioGlobal));

              // 2. Vaciamos las opiniones en caliente
              contenedorReseñas.innerHTML = "";

              const comentarios = data.lista || [];

              if (comentarios.length === 0) {
                contenedorReseñas.innerHTML = '<p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Nadie ha comentado aún. ¡Sé el primero!</p>';
                return;
              }

              comentarios.forEach(c => {
                const esMiReseña = (c.nombre_autor === '<%= session.getAttribute("user") %>');
                let botonEliminar = esMiReseña
                        ? '<span onclick="eliminarMiReseña(\'' + idEstablecimiento + '\')" style="color: #dc2626; font-size: 11px; cursor: pointer; font-weight: bold; margin-left: auto; user-select: none;">🗑️ Borrar</span>'
                        : '';

                const numEstrellas = c.calificacion || 5;
                const estrellasVisuales = "⭐".repeat(numEstrellas);
                const colorNombre = esMiReseña ? '#16a34a' : '#1e293b';
                const etiquetaAutor = esMiReseña ? '@Tú (Tu opinión)' : c.nombre_autor;

                let htmlBurbuja = '<div class="ff-resena-card" style="display:flex;flex-direction:column;gap:3px;width:100%;box-sizing:border-box;">' +
                        '<div style="display:flex;justify-content:space-between;align-items:center;">' +
                        '<strong style="font-size:11px;color:' + colorNombre + ';">' + etiquetaAutor + '</strong>' +
                        '<div style="display:flex;gap:8px;align-items:center;margin-left:auto;">' +
                        '<span style="color:#fbbf24;font-size:11px;">' + estrellasVisuales + '</span>' +
                        botonEliminar +
                        '</div>' +
                        '</div>' +
                        '<p style="margin:0;font-size:11px;color:var(--text-2);line-height:1.3;white-space:pre-wrap;">' + c.texto + '</p>' +
                        '</div>';

                contenedorReseñas.innerHTML += htmlBurbuja;
              });

              contenedorReseñas.scrollTop = 0;
            })
            .catch(err => {
              console.error("Error en Fetch de comentarios:", err);
              contenedorReseñas.innerHTML = '<p style="color: #dc2626; font-size: 12px; text-align: center; margin: auto;">Error al cargar opiniones.</p>';
            });
  }

  // 🗑️ ACCIÓN ASÍNCRONA PARA ELIMINAR VALORACIONES
  function eliminarMiReseña(idEstablecimiento) {
    if (!confirm("¿Seguro que deseas eliminar tu valoración de este establecimiento?")) return;

    fetch('comentarios-mapa?action=eliminarValoracion&idPost=' + idEstablecimiento, {
      method: 'POST'
    })
            .then(response => {
              if (response.ok) {
                console.log("[Reseña] Eliminada exitosamente");
                // Refrescamos en caliente la lista
                cargarComentariosDesdeBase(idEstablecimiento);
              } else {
                alert("Hubo un problema al borrar tu reseña.");
              }
            })
            .catch(err => console.error("Error al borrar valoración:", err));
  }

  // 🎯 NUEVA VARIABLE GLOBAL (ponla antes de tu función):
  let publicacionesGlobales = [];

  // 📸 FUNCIÓN ACTUALIZADA:
  function cargarPublicacionesDelLocal(idEstablecimiento) {
    const contenedorPubs = document.getElementById("contenedor-comentarios-scroll");
    if (!contenedorPubs) return;

    contenedorPubs.innerHTML = '<p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Buscando publicaciones en el feed...</p>';

    fetch('comentarios-mapa?action=publicaciones&idPost=' + idEstablecimiento)
            .then(res => res.json())
            .then(pubs => {
              if (!Array.isArray(pubs)) pubs = [];

              // 🎯 GUARDAMOS LOS POSTS EN LA MEMORIA RAM DEL NAVEGADOR
              publicacionesGlobales = pubs;

              contenedorPubs.innerHTML = "";

              if (pubs.length === 0) {
                contenedorPubs.innerHTML = '<p style="color: #94a3b8; font-size: 13px; text-align: center; margin: auto;">Aún no hay posts sobre este local en el feed.</p>';
                return;
              }

              pubs.forEach(p => {
                let imgHtml = p.foto ? `<img src="${p.foto}" style="width: 100%; height: 110px; object-fit: cover; border-radius: 6px; margin-bottom: 8px; border: 1px solid #e2e8f0;">` : '';

                // 🎯 CAMBIAMOS EL ONCLICK PARA QUE ABRA NUESTRO MODAL EN LUGAR DE CAMBIAR DE PÁGINA
                let tarjetaHTML = `
                <div class="ff-pub-card">
                    ${imgHtml}
                    <h4>${p.titulo}</h4>
                    <span class="autor">👤 Autor: @${p.autor}</span>
                    <p>${p.texto}</p>
                    <button onclick="abrirModalPublicacion('${p.id}')" class="ff-btn-expandir">
                        👁️ Expandir publicación
                    </button>
                </div>`;

                contenedorPubs.innerHTML += tarjetaHTML;
              });
            })
            .catch(err => {
              console.error("Error al cargar publicaciones:", err);
              contenedorPubs.innerHTML = '<p style="color: #dc2626; font-size: 12px; text-align: center;">Error al cargar el feed.</p>';
            });
  }

  // 🪟 ABRE EL POPUP TIPO FACEBOOK
  function abrirModalPublicacion(idPub) {
    // Buscamos la publicación completa dentro de nuestra memoria
    const pub = publicacionesGlobales.find(p => p.id === idPub);
    if (!pub) return;

    // Rellenamos el molde HTML con los datos de ese post en específico
    document.getElementById("modal-pub-autor").innerText = "@" + pub.autor;
    document.getElementById("modal-pub-titulo").innerText = pub.titulo;
    document.getElementById("modal-pub-texto").innerText = pub.texto;

    // Manejamos la imagen: Si tiene la mostramos, si no la ocultamos
    const imgEl = document.getElementById("modal-pub-foto");
    if (pub.foto && pub.foto !== "" && pub.foto !== "null") {
      imgEl.src = pub.foto;
      imgEl.style.display = "block";
    } else {
      imgEl.style.display = "none";
    }

    // 🎯 NUEVO: CARGAR COMENTARIOS DE LA PUBLICACIÓN DESDE EL SERVLET DEL FEED
    const contenedorComentariosModal = document.getElementById("contenedor-comentarios-modal");
    if (contenedorComentariosModal) {
      contenedorComentariosModal.innerHTML = '<p style="color: #94a3b8; font-size: 12px; text-align: center; padding: 10px;">Cargando comentarios...</p>';

      // Hacemos el fetch al servlet que maneja las publicaciones (ComentariosFeed_Servlet)
      // Recuerda verificar si la anotación de tu servlet del feed es "/comentarios" o "/comentarios-feed"
      fetch('comentarios?idPost=' + idPub)
              .then(res => res.json())
              .then(comentarios => {
                contenedorComentariosModal.innerHTML = "";

                if (comentarios.length === 0) {
                  contenedorComentariosModal.innerHTML = '<p style="color: #94a3b8; font-size: 12px; text-align: center; padding: 10px;">Nadie ha comentado esta publicación aún.</p>';
                  return;
                }

                comentarios.forEach(c => {
                  let htmlBurbuja = `
            <div class="ff-comentario-burbuja">
              <img src="${c.foto_perfil || 'img/avatar-default.png'}" style="width:30px;height:30px;border-radius:50%;object-fit:cover;">
              <div style="flex:1;">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:2px;">
                  <strong>${c.nombre_autor}</strong>
                </div>
                <p>${c.texto}</p>
              </div>
            </div>`;
                  contenedorComentariosModal.innerHTML += htmlBurbuja;
                });
              })
              .catch(err => {
                console.error("Error al obtener comentarios del post:", err);
                contenedorComentariosModal.innerHTML = '<p style="color: #dc2626; font-size: 12px; text-align: center; padding: 10px;">Error al cargar comentarios.</p>';
              });
    }

    // Encendemos el modal para que tape toda la pantalla
    document.getElementById("modal-publicacion").style.display = "flex";
  }

  // ❌ CIERRA EL POPUP
  function cerrarModalPublicacion() {
    document.getElementById("modal-publicacion").style.display = "none";
  }


</script>

<div id="modal-publicacion" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(4,9,5,0.85);z-index:9999;justify-content:center;align-items:center;padding:20px;box-sizing:border-box;">

  <div class="ff-modal-box">

    <div class="ff-modal-header">
      <div style="display: flex; align-items: center; gap: 8px;">
        <span style="font-size: 18px;">👤</span>
        <strong id="modal-pub-autor">@Autor</strong>
      </div>
      <button onclick="cerrarModalPublicacion()" class="ff-modal-close">✖</button>
    </div>

    <div class="ff-modal-body">
      <h3 id="modal-pub-titulo">Título</h3>

      <img id="modal-pub-foto" src="" style="width: 100%; max-height: 300px; object-fit: cover; border-radius: 8px; margin-bottom: 15px; display: none; border: 1px solid #e2e8f0;">

      <p id="modal-pub-texto"></p>

      <hr>

      <h5>💬 Comentarios de la comunidad</h5>
      <div id="contenedor-comentarios-modal" style="max-height: 200px; overflow-y: auto; padding-right: 5px;">
      </div>
    </div>

  </div>
</div>


</body>
</html>