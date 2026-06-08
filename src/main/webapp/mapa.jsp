<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ForaFood - Radar Gastronómico</title>

  <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
  <link rel="stylesheet" href="css/home.css">
  <link rel="stylesheet" href="css/feed_style.css">
  <link rel="icon" type="image/png" href="img/diet.png">
  <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet" />

  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

  <style>
    /* 🔥 PARCHE MAESTRO CSS PARA EVITAR COLAPSOS */
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      overflow: hidden; /* Evita scrolls dobles feos en la pantalla principal */
      font-family: 'Poppins', sans-serif;
    }
    .pantalla-completa-flex {
      display: flex;
      flex-direction: column;
      height: 100vh;
    }
    .cuerpo-columnas-container {
      display: flex;
      flex: 1;
      width: 100%;
      overflow: hidden;
      box-sizing: border-box;
    }
    /* Definición estricta de anchos para que Bootstrap no los apriete */
    .columna-menu-izquierda {
      width: 240px;
      flex-shrink: 0;
      background: #f8fafc;
      border-right: 1px solid #e2e8f0;
      padding: 20px;
      display: flex;
      flex-direction: column;
      gap: 15px;
    }
    .columna-mapa-central {
      flex: 1; /* Ocupa todo el espacio que sobre al centro de forma dinámica */
      padding: 20px;
      display: flex;
      flex-direction: column;
      gap: 15px;
      background: #ffffff;
    }
    .columna-comentarios-derecha {
      width: 320px;
      flex-shrink: 0;
      background: #ffffff;
      border-left: 1px solid #e2e8f0;
      padding: 20px;
      display: flex;
      flex-direction: column;
      gap: 15px;
      box-sizing: border-box;
    }
  </style>
</head>
<body>

<div class="pantalla-completa-flex">

  <div style="padding: 12px 40px; background: #ffffff; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; flex-shrink: 0;">
    <div style="display: flex; align-items: center; gap: 10px;">
      <img src="img/diet.png" style="width: 28px; height: 28px;">
      <span style="font-size: 22px; font-weight: 700; color: #16a34a; font-family: 'Poppins', sans-serif;">ForaFood</span>
    </div>

    <form action="principal" method="get" style="margin: 0; display: flex; gap: 8px;">
      <input type="text" name="txtBuscar" placeholder="Buscar puestos o comidas en el feed..." style="padding: 8px 16px; width: 380px; border: 1px solid #cbd5e1; border-radius: 20px; outline: none; font-size: 14px;">
      <button type="submit" style="background: #16a34a; color: white; border: none; padding: 8px 22px; border-radius: 20px; font-weight: 600; cursor: pointer;">Buscar</button>
    </form>
    <div style="width: 120px;"></div>
  </div>

  <div class="cuerpo-columnas-container">

    <div class="columna-menu-izquierda">
      <div style="text-align: center; padding: 12px; background: white; border-radius: 12px; border: 1px solid #e2e8f0; margin-bottom: 10px;">
        <img src="<%= session.getAttribute("foto_perfil") != null ? session.getAttribute("foto_perfil") : "img/avatar-default.png" %>" style="width: 55px; height: 55px; border-radius: 50%; object-fit: cover; border: 2px solid #16a34a; margin-bottom: 6px;">
        <h4 style="margin: 0; font-size: 14px; font-weight: 700; color: #1e293b;"><%= session.getAttribute("user") %></h4>
        <span style="font-size: 11px; background: #dcfce7; color: #16a54a; padding: 1px 8px; border-radius: 10px; font-weight: 600; display: inline-block; margin-top: 4px;">
                        <%= session.getAttribute("rango") != null ? session.getAttribute("rango") : "Novato" %>
                    </span>
        <div style="font-size: 11px; color: #64748b; margin-top: 4px;">🏆 <strong><%= session.getAttribute("puntos") != null ? session.getAttribute("puntos") : 0 %></strong> pts</div>
      </div>

      <div style="display: flex; flex-direction: column; gap: 6px;">
        <a href="principal" style="display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px;">
          🏠 Feed de la Facultad
        </a>
        <hr style="margin: 8px 0; border-top: 1px solid #e2e8f0;">
        <a href="index.jsp" style="display: flex; align-items: center; gap: 10px; padding: 10px 12px; color: #dc2626; text-decoration: none; font-weight: 600; font-size: 14px;">
          🚪 Cerrar Sesión
        </a>
      </div>
    </div>

    <div class="columna-mapa-central">
      <div style="background: white; padding: 12px 16px; border-radius: 12px; border: 1px solid #e2e8f0; display: flex; flex-direction: column;">
        <h2 style="margin: 0; font-size: 16px; color: #0f172a; font-weight: 700;">🗺️ Radar Gastronómico Universatario</h2>
        <span style="color: #64748b; font-size: 12.5px;">Haz click en los pines del mapa para mandar llamar las opiniones del local al panel derecho.</span>
      </div>

      <div id="mapaPantallaCompleta" style="width: 100%; flex-grow: 1; border-radius: 12px; border: 1px solid #cbd5e1; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02);"></div>
    </div>

    <div class="columna-comentarios-derecha" id="panel-derecho-comentarios">

      <div id="aviso-panel-vacio" style="text-align: center; margin: auto 0; padding: 20px; color: #94a3b8;">
        <img src="img/diet.png" style="width: 45px; opacity: 0.3; margin-bottom: 8px;">
        <p style="font-size: 13px; font-weight: 500; line-height: 1.4;">Selecciona un pin del mapa para desplegar las opiniones de la comunidad.</p>
      </div>

      <div id="contenido-panel-activo" style="display: none; flex-direction: column; gap: 12px; height: 100%;">
        <div style="display: flex; gap: 12px; align-items: center; margin-bottom: 15px;">
          <img id="foto-local-panel" src="img/posts/default-local.png" style="width: 55px; height: 55px; border-radius: 8px; object-fit: cover; border: 1px solid #e2e8f0;">
          <div>
            <h3 id="panel-comentarios-titulo" style="margin: 0; font-size: 16px; font-weight: bold; color: #0f172a;">Nombre del Local</h3>
            <span style="font-size: 11px; color: #16a34a; font-weight: bold;">📍 Local Verificado</span>
          </div>
        </div>

        <div style="display: flex; border-bottom: 2px solid #e2e8f0; margin-bottom: 15px; gap: 4px;">
          <button id="tab-publicaciones" onclick="cambiarPestaña('publicaciones')" style="flex: 1; padding: 10px; border: none; background: none; font-size: 12px; font-weight: bold; color: #16a34a; border-bottom: 2px solid #16a34a; cursor: pointer; transition: all 0.2s;">
            📜 PUBLICACIONES
          </button>
          <button id="tab-valoracion" onclick="cambiarPestaña('valoracion')" style="flex: 1; padding: 10px; border: none; background: none; font-size: 12px; font-weight: bold; color: #64748b; cursor: pointer; transition: all 0.2s;">
            ⭐ VALORACIÓN
          </button>
        </div>

        <div id="vista-publicaciones" style="display: flex; flex-direction: column; flex: 1; overflow: hidden;">
          <div id="contenedor-comentarios-scroll" style="flex: 1; overflow-y: auto; padding-right: 4px; display: flex; flex-direction: column; gap: 10px; margin-bottom: 12px;">
          </div>
        </div>

        <div id="vista-valoracion" style="display: none; flex-direction: column; flex: 1; overflow: hidden; height: 100%;">

          <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px; text-align: center; display: flex; flex-direction: column; gap: 2px; margin-bottom: 12px;">
            <span style="font-size: 11px; font-weight: bold; color: #64748b; letter-spacing: 0.5px;">PUNTUACIÓN DE LA COMUNIDAD</span>
            <div id="estrellas-promedio-render" style="font-size: 24px; color: #fbbf24; font-weight: bold; margin: 2px 0;">⭐⭐⭐⭐⭐</div>
            <span id="texto-promedio-num" style="font-size: 14px; color: #0f172a; font-weight: 700;">5.0 / 5.0</span>
          </div>

          <span style="font-weight: bold; font-size: 12px; color: #475569; display: block; margin-bottom: 6px;">📋 Reseñas Históricas:</span>
          <div id="contenedor-reseñas-historicas" style="flex-grow: 1; overflow-y: auto; display: flex; flex-direction: column; gap: 8px; padding-right: 2px; max-height: 180px; margin-bottom: 15px; border-bottom: 1px dashed #cbd5e1; padding-bottom: 10px;">

            <div style="background: #ffffff; border: 1px solid #e2e8f0; border-radius: 6px; padding: 8px; display: flex; flex-direction: column; gap: 3px;">
              <div style="display: flex; justify-content: space-between; align-items: center;">
                <strong style="font-size: 11px; color: #1e293b;">@EstudianteUV</strong>
                <span style="color: #fbbf24; font-size: 11px;">⭐⭐⭐⭐⭐</span>
              </div>
              <p style="margin: 0; font-size: 11px; color: #475569; line-height: 1.3;">La comida está riquísima, muy limpio todo y económico.</p>
            </div>

          </div>

          <form id="form-nueva-valoracion" onsubmit="guardarValoracion(event)" style="display: flex; flex-direction: column; gap: 10px; border-top: 1px solid #e2e8f0; padding-top: 10px; margin-top: auto;">

            <input type="hidden" id="input-post-id" value="">

            <div>
              <label style="font-weight: bold; font-size: 12px; color: #1e293b; display: block; margin-bottom: 4px;">¿Qué tal está la comida y el precio?</label>
              <select id="select-calificacion" style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 12px; font-family: sans-serif; background: white; color: #334155;">
                <option value="5">⭐⭐⭐⭐⭐ Excelente (Súper Foráneo Friendly)</option>
                <option value="4">⭐⭐⭐⭐ Muy Bueno (Rico y llenador)</option>
                <option value="3">⭐⭐⭐ Bueno (Cumple para el bajón)</option>
                <option value="2">⭐⭐ Regular (Dos tres, algo caro)</option>
                <option value="1">⭐ Malo (No lo recomiendo)</option>
              </select>
            </div>

            <div>
              <label style="font-weight: bold; font-size: 12px; color: #1e293b; display: block; margin-bottom: 4px;">Escribe una reseña o tip:</label>
              <textarea id="texto-comentario-valoracion" placeholder="Ej. Los chilaquiles con milanesa están enormes..." required style="width: 100%; height: 65px; padding: 8px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 12px; font-family: sans-serif; resize: none; box-sizing: border-box;"></textarea>
            </div>

            <button type="submit" style="background: #16a34a; color: white; border: none; padding: 8px; border-radius: 6px; font-size: 12px; font-weight: bold; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 6px;">
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

                  let popupHTML = '<div style="font-family: sans-serif; text-align: center; padding: 2px;">' +
                                    '<b style="color: #0f172a; font-size: 13px; display: block; margin-bottom: 5px;">' + l.nombre + '</b>' +
                                    '<button onclick="abrirPanelComentarios(\'' + l.id + '\', \'' + l.nombre + '\', \'' + (l.url_foto || '') + '\')" ' +
                                        'style="background: #16a34a; color: white; border: none; padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: bold; cursor: pointer;">' +
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
      // Activar publicaciones
      btnPubs.style.color = "#16a34a";
      btnPubs.style.borderBottom = "2px solid #16a34a";
      btnVal.style.color = "#64748b";
      btnVal.style.borderBottom = "none";

      vistaPubs.style.display = "flex";
      vistaVal.style.display = "none";
    } else {
      // Activar valoración
      btnVal.style.color = "#16a34a";
      btnVal.style.borderBottom = "2px solid #16a34a";
      btnPubs.style.color = "#64748b";
      btnPubs.style.borderBottom = "none";

      vistaPubs.style.display = "none";
      vistaVal.style.display = "flex";
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

                let htmlBurbuja = '<div style="background: #ffffff; border: 1px solid #e2e8f0; border-radius: 6px; padding: 8px; display: flex; flex-direction: column; gap: 3px; margin-bottom: 6px; width: 100%; box-sizing: border-box;">' +
                        '<div style="display: flex; justify-content: space-between; align-items: center;">' +
                        '<strong style="font-size: 11px; color: ' + colorNombre + ';">' + etiquetaAutor + '</strong>' +
                        '<div style="display: flex; gap: 8px; align-items: center; margin-left: auto;">' +
                        '<span style="color: #fbbf24; font-size: 11px;">' + estrellasVisuales + '</span>' +
                        botonEliminar +
                        '</div>' +
                        '</div>' +
                        '<p style="margin: 0; font-size: 11px; color: #475569; line-height: 1.3; white-space: pre-wrap;">' + c.texto + '</p>' +
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
                <div style="background: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; margin-bottom: 12px; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">
                    ${imgHtml}
                    <h4 style="margin: 0 0 4px 0; font-size: 13px; color: #0f172a; font-weight: 700;">${p.titulo}</h4>
                    <span style="font-size: 10px; color: #16a34a; font-weight: 600; display: block; margin-bottom: 6px;">👤 Autor: @${p.autor}</span>

                    <p style="margin: 0 0 10px 0; font-size: 11px; color: #475569; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                        ${p.texto}
                    </p>

                    <button onclick="abrirModalPublicacion('${p.id}')" style="width: 100%; background: #f8fafc; color: #334155; border: 1px solid #cbd5e1; padding: 6px; border-radius: 6px; font-size: 11px; font-weight: 600; cursor: pointer;">
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
            <div style="display: flex; gap: 10px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 8px; margin-bottom: 8px;">
              <img src="${c.foto_perfil || 'img/avatar-default.png'}" style="width: 30px; height: 30px; border-radius: 50%; object-fit: cover;">
              <div style="flex: 1;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2px;">
                  <strong style="font-size: 11px; color: #1e293b;">${c.nombre_autor}</strong>
                </div>
                <p style="margin: 0; font-size: 11px; color: #475569; white-space: pre-wrap;">${c.texto}</p>
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

<div id="modal-publicacion" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.7); z-index: 9999; justify-content: center; align-items: center; padding: 20px; box-sizing: border-box; backdrop-filter: blur(3px);">

  <div style="background: #ffffff; width: 100%; max-width: 500px; max-height: 90vh; border-radius: 12px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.2);">

    <div style="padding: 12px 16px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; background: #f8fafc;">
      <div style="display: flex; align-items: center; gap: 8px;">
        <span style="font-size: 18px;">👤</span>
        <strong style="font-size: 14px; color: #0f172a;" id="modal-pub-autor">@Autor</strong>
      </div>
      <button onclick="cerrarModalPublicacion()" style="background: none; border: none; font-size: 16px; cursor: pointer; color: #64748b; font-weight: bold;">✖</button>
    </div>

    <div style="padding: 16px; overflow-y: auto;">
      <h3 id="modal-pub-titulo" style="margin: 0 0 10px 0; font-size: 18px; color: #1e293b; font-weight: 800;">Título</h3>

      <img id="modal-pub-foto" src="" style="width: 100%; max-height: 300px; object-fit: cover; border-radius: 8px; margin-bottom: 15px; display: none; border: 1px solid #e2e8f0;">

      <p id="modal-pub-texto" style="margin: 0; font-size: 13px; color: #475569; line-height: 1.6; white-space: pre-wrap;"></p>

      <hr style="border-top: 1px solid #e2e8f0; margin: 20px 0;">

      <h5 style="font-size: 13px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">💬 Comentarios de la comunidad</h5>
      <div id="contenedor-comentarios-modal" style="max-height: 200px; overflow-y: auto; padding-right: 5px;">
      </div>
    </div>

  </div>
</div>


</body>
</html>