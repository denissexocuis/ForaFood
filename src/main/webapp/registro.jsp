<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<!-- ! nota: la parte del frontend (estilos, colores, etc) las mejoré con ia :D
        estuve buscando plantillas y creando mi propio diseño pero me tomó
        como 1 mes realizar la parte del login y registro T.T
-->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ForaFood — Registrarse</title>
    <link rel="icon" type="image/png" href="img/diet.png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/registro.css">
</head>
<body>

<%
    //? preparar dominios para js
    List<String> dominios = (List<String>) request.getAttribute("lista_dominios");
    List<Document> universidades = (List<Document>) request.getAttribute("lista_universidades");
    StringBuilder dominiosJson = new StringBuilder("[");
    if (dominios != null) {
        for (int i = 0; i < dominios.size(); i++) {
            dominiosJson.append("\"").append(dominios.get(i)).append("\"");
            if (i < dominios.size() - 1) dominiosJson.append(",");
        }
    }
    dominiosJson.append("]");
%>

<!--? ── NAVBAR ───────────────────────────────────────────────── -->
<nav class="ff-nav">
    <a class="ff-nav-logo" href="index.jsp">fora<span>food</span></a>
    <a class="ff-nav-link" href="index.jsp">← Volver al inicio</a>
</nav>

<!--? ── LAYOUT ───────────────────────────────────────────────── -->
<div class="ff-registro-wrap">

    <!-- panel izquierdo -->
    <div class="ff-panel-left">
        <h2 class="ff-left-title">
            Come mejor.<br>
            Comparte más.<br>
            <span>Sube de nivel.</span>
        </h2>
        <p class="ff-left-sub">
            Crea tu cuenta gratis y forma parte de la red estudiantil
            que descubre los mejores lugares para comer cerca del campus.
        </p>

        <div class="ff-benefit">
            <div class="ff-benefit-icon">🗺️</div>
            <div class="ff-benefit-text">
                <strong>Mapa interactivo</strong><br>
                Ubica puestos y restaurantes cerca de tu facultad.
            </div>
        </div>
        <div class="ff-benefit">
            <div class="ff-benefit-icon">🏆</div>
            <div class="ff-benefit-text">
                <strong>Gamificación real</strong><br>
                Gana puntos, medallas y sube del rango Novato a Leyenda.
            </div>
        </div>
        <div class="ff-benefit">
            <div class="ff-benefit-icon">🛡️</div>
            <div class="ff-benefit-text">
                <strong>Solo universitarios</strong><br>
                Verificación con correo institucional. Solo tu comunidad.
            </div>
        </div>
    </div>

    <!-- Panel derecho -->
    <div class="ff-panel-right">
        <h1 class="ff-form-title">Crear cuenta</h1>
        <p class="ff-form-sub">
            ¿Ya tienes cuenta? <a href="index.jsp">Inicia sesión</a>
        </p>

        <!-- Indicador de pasos -->
        <div class="ff-steps-indicator">
            <div class="ff-step-dot active" id="dot1">1</div>
            <div class="ff-step-line" id="line1"></div>
            <div class="ff-step-dot" id="dot2">2</div>
            <div class="ff-step-line" id="line2"></div>
            <div class="ff-step-dot" id="dot3">✓</div>
        </div>
        <div class="ff-steps-labels">
            <div class="ff-step-lbl" style="margin-left:-14px;">Tu cuenta</div>
            <div class="ff-step-lbl">Verificar</div>
            <div class="ff-step-lbl" style="margin-right:-14px;">Listo</div>
        </div>

        <form action="registro" method="post" id="formRegistro" novalidate>

            <!-- ══ PASO 1 — Datos básicos ══════════════════════ -->
            <div id="paso1">
                <div class="ff-group">
                    <label class="ff-label">Nombre de usuario</label>
                    <input type="text" id="nombreUsuario" name="nombreUsuario"
                           class="ff-input" placeholder="ej. taquero_uv22">
                    <div class="ff-hint">Usa un alias, no tu nombre real.</div>
                    <div class="ff-error-msg" id="err-nombre">Ingresa un nombre de usuario.</div>
                </div>

                <div class="ff-group">
                    <label class="ff-label">Correo personal</label>
                    <input type="email" id="email" name="email"
                           class="ff-input" placeholder="tu@correo.com">
                    <div class="ff-hint">Con este correo inicias sesión.</div>
                    <div class="ff-error-msg" id="err-email">Ingresa un correo válido.</div>
                </div>

                <div class="ff-group">
                    <label class="ff-label">Contraseña</label>
                    <input type="password" id="pwd" name="pwd"
                           class="ff-input" placeholder="Mínimo 8 caracteres"
                           oninput="actualizarFuerza(this.value)">
                    <div class="ff-pwd-strength">
                        <div class="ff-pwd-bar-wrap">
                            <div class="ff-pwd-bar" id="pwdBar"></div>
                        </div>
                        <div class="ff-pwd-label" id="pwdLabel">Escribe tu contraseña</div>
                    </div>
                    <div class="ff-error-msg" id="err-pwd">Mínimo 8 caracteres, un número y un símbolo.</div>
                </div>

                <div class="ff-group">
                    <label class="ff-label">Universidad</label>
                    <select id="uniSelect" name="txtUniversidad" class="ff-select"
                            onchange="mostrarCorreo()">
                        <option value="" disabled selected>Seleccionar universidad…</option>
                        <%
                            if (universidades != null) {
                                for (Document uni : universidades) {
                                    String idUni     = uni.get("_id").toString();
                                    String nombreUni = uni.getString("nombre_uni");
                        %>
                        <option value="<%= idUni %>"><%= nombreUni %></option>
                        <% } } %>
                    </select>
                    <div class="ff-error-msg" id="err-uni">Selecciona tu universidad.</div>
                </div>

                <!-- Correo institucional — aparece al elegir uni -->
                <div class="ff-correo-wrap" id="correoWrap">
                    <div class="ff-correo-dominio" id="correoDominio"></div>
                    <label class="ff-label">Correo institucional</label>
                    <input type="email" id="correoInstitucional" name="correoInstitucional"
                           class="ff-input" placeholder="usuario@universidad.edu.mx">
                    <div class="ff-error-msg" id="err-correo">Ingresa un correo institucional válido.</div>
                </div>

                <button type="button" class="ff-btn ff-btn-primary"
                        onclick="siguientePaso()">Continuar →</button>
            </div>

            <!-- ══ PASO 2 — Verificación ═══════════════════════ -->
            <div id="paso2" style="display:none;">
                <p style="font-size:13px;color:var(--text-2);margin-bottom:4px;">
                    Enviamos un código de 6 dígitos a:
                </p>
                <p style="font-size:14px;font-weight:700;color:var(--text-1);margin-bottom:20px;"
                   id="correoMostrado"></p>

                <p style="font-size:13px;color:var(--text-2);margin-bottom:4px;">
                    Checa tu carpeta de spam si es necesario.
                </p>

                <div class="ff-code-inputs">
                    <input type="text" class="ff-code-digit" maxlength="1"
                           inputmode="numeric" oninput="avanzarDigito(this,0)">
                    <input type="text" class="ff-code-digit" maxlength="1"
                           inputmode="numeric" oninput="avanzarDigito(this,1)">
                    <input type="text" class="ff-code-digit" maxlength="1"
                           inputmode="numeric" oninput="avanzarDigito(this,2)">
                    <input type="text" class="ff-code-digit" maxlength="1"
                           inputmode="numeric" oninput="avanzarDigito(this,3)">
                    <input type="text" class="ff-code-digit" maxlength="1"
                           inputmode="numeric" oninput="avanzarDigito(this,4)">
                    <input type="text" class="ff-code-digit" maxlength="1"
                           inputmode="numeric" oninput="avanzarDigito(this,5)">
                </div>
                <!-- Input hidden que recibe el código completo -->
                <input type="hidden" id="codigoVerificacion" name="codigoVerificacion">

                <div class="ff-error-msg" id="err-codigo" style="text-align:center;">
                    Código incorrecto. Inténtalo de nuevo.
                </div>

                <button type="button" class="ff-btn ff-btn-primary"
                        onclick="verificarCodigo()">Verificar código</button>
                <button type="button" class="ff-btn ff-btn-ghost"
                        onclick="anteriorPaso()">← Atrás</button>
            </div>

            <!-- ══ PASO 3 — Términos ═══════════════════════════ -->
            <div id="paso3" style="display:none;">
                <p style="font-size:13px;color:var(--text-2);margin-bottom:16px;">
                    Ya casi listo. Lee y acepta para crear tu cuenta.
                </p>

                <label class="ff-check-row">
                    <input type="checkbox" id="chkPrivacidad" name="chkPrivacidad"
                           onchange="revisarChecks()">
                    <div class="ff-check-text">
                        He leído y acepto el
                        <a href="#" onclick="abrirModalDoc('privacidad');return false;">
                            Aviso de Privacidad
                        </a>
                    </div>
                </label>

                <label class="ff-check-row">
                    <input type="checkbox" id="chkTerminos" name="chkTerminos"
                           onchange="revisarChecks()">
                    <div class="ff-check-text">
                        He leído y acepto los
                        <a href="#" onclick="abrirModalDoc('terminos');return false;">
                            Términos y Condiciones
                        </a>
                    </div>
                </label>

                <div class="ff-error-msg" id="err-checks">
                    Debes aceptar ambos documentos para continuar.
                </div>

                <button type="submit" class="ff-btn ff-btn-primary"
                        id="btnRegistrarse" disabled>
                    Crear mi cuenta
                </button>
                <button type="button" class="ff-btn ff-btn-ghost"
                        onclick="anteriorPaso()">← Atrás</button>
            </div>

        </form>
    </div>
</div>

<!-- ══ MODAL AVISO DE PRIVACIDAD ══════════════════════════════ -->
<div class="ff-modal-overlay" id="modalPrivacidad"
     onclick="cerrarModalDoc('privacidad',event)">
    <div class="ff-modal-doc" onclick="event.stopPropagation()">
        <div class="ff-modal-doc-header">
            📄 Aviso de Privacidad
            <button class="ff-btn-sm ff-btn-sm-ghost"
                    onclick="cerrarModalDoc('privacidad',null)">✕</button>
        </div>
        <div class="ff-modal-doc-body">
            <p>Tu texto del aviso de privacidad.... WIP</p>
        </div>
        <div class="ff-modal-doc-footer">
            <a href="docs/aviso-privacidad.pdf" download
               class="ff-btn-sm ff-btn-sm-ghost" style="text-decoration:none;">
                Descargar (trabajo a futuro XD)
            </a>
            <button class="ff-btn-sm ff-btn-sm-solid"
                    onclick="cerrarModalDoc('privacidad',null)">Entendido</button>
        </div>
    </div>
</div>

<!-- ══ MODAL TÉRMINOS Y CONDICIONES ════════════════════════════ -->
<div class="ff-modal-overlay" id="modalTerminos"
     onclick="cerrarModalDoc('terminos',event)">
    <div class="ff-modal-doc" onclick="event.stopPropagation()">
        <div class="ff-modal-doc-header">
            📋 Términos y Condiciones
            <button class="ff-btn-sm ff-btn-sm-ghost"
                    onclick="cerrarModalDoc('terminos',null)">✕</button>
        </div>
        <div class="ff-modal-doc-body">
            <p>Tu texto de términos y condiciones... WIP</p>
        </div>
        <div class="ff-modal-doc-footer">
            <a href="docs/terminos.pdf" download
               class="ff-btn-sm ff-btn-sm-ghost" style="text-decoration:none;">
                Descargar (trabajo a futuro XD)
            </a>
            <button class="ff-btn-sm ff-btn-sm-solid"
                    onclick="cerrarModalDoc('terminos',null)">Entendido</button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    //! ia aqui
    // ── Dominios válidos desde Java ──────────────────────────────
    const dominiosValidos = <%= dominiosJson %>;

    // ── Estado de pasos ──────────────────────────────────────────
    let pasoActual = 1;

    function irAPaso(n) {
        [1,2,3].forEach(i => {
            document.getElementById('paso'+i).style.display = i===n ? 'block' : 'none';
        });
        pasoActual = n;
        actualizarIndicador(n);
    }

    function actualizarIndicador(n) {
        [1,2,3].forEach(i => {
            const dot  = document.getElementById('dot'+i);
            if (!dot) return;
            dot.classList.remove('active','done');
            if (i < n)       dot.classList.add('done');
            else if (i === n) dot.classList.add('active');
        });
        [1,2].forEach(i => {
            const line = document.getElementById('line'+i);
            if (!line) return;
            line.classList.toggle('done', i < n);
        });
    }

    // ── Fuerza de contraseña ─────────────────────────────────────
    function actualizarFuerza(val) {
        const bar   = document.getElementById('pwdBar');
        const label = document.getElementById('pwdLabel');
        let score = 0;
        if (val.length >= 8)           score++;
        if (/[0-9]/.test(val))         score++;
        if (/[^a-zA-Z0-9]/.test(val))  score++;
        if (val.length >= 12)          score++;
        const configs = [
            { w:'0%',   bg:'var(--border)',    txt:'Escribe tu contraseña' },
            { w:'25%',  bg:'#f87171',          txt:'Muy débil' },
            { w:'50%',  bg:'#fbbf24',          txt:'Regular' },
            { w:'75%',  bg:'#a3c45a',          txt:'Buena' },
            { w:'100%', bg:'var(--green)',      txt:'¡Excelente!' },
        ];
        const c = configs[score] || configs[0];
        bar.style.width      = c.w;
        bar.style.background = c.bg;
        label.textContent    = c.txt;
        label.style.color    = c.bg === 'var(--border)' ? 'var(--text-3)' : c.bg;
    }

    // ── Mostrar correo institucional ─────────────────────────────
    function mostrarCorreo() {
        const select = document.getElementById('uniSelect');
        const idx    = select.selectedIndex;
        if (idx <= 0) return;
        const domRaw2 = dominiosValidos[idx - 1] || '';
        const dominio = domRaw2.startsWith('@') ? domRaw2 : '@' + domRaw2;
        const dominioLimpio = domRaw2.startsWith('@') ? domRaw2.slice(1) : domRaw2;
        const wrap    = document.getElementById('correoWrap');
        const hint    = document.getElementById('correoDominio');
        wrap.classList.add('show');
        hint.textContent = '📧 Correo requerido con dominio: ' + dominio;
        document.getElementById('correoInstitucional').placeholder =
            'usuario@' + dominioLimpio;
    }

    // ── Validación paso 1 ────────────────────────────────────────
    function siguientePaso() {
        let ok = true;

        const nombre = document.getElementById('nombreUsuario').value.trim();
        mostrarError('err-nombre', 'nombreUsuario', !nombre);
        if (!nombre) ok = false;

        const email = document.getElementById('email').value.trim();
        const emailOk = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        mostrarError('err-email', 'email', !emailOk);
        if (!emailOk) ok = false;

        const pwd = document.getElementById('pwd').value;
        const pwdOk = pwd.length>=8 && /[0-9]/.test(pwd) && /[^a-zA-Z0-9]/.test(pwd);
        mostrarError('err-pwd', 'pwd', !pwdOk);
        if (!pwdOk) ok = false;

        const uni = document.getElementById('uniSelect').value;
        mostrarError('err-uni', 'uniSelect', !uni);
        if (!uni) ok = false;

        const correoWrap = document.getElementById('correoWrap');
        if (correoWrap.classList.contains('show')) {
            const ci = document.getElementById('correoInstitucional').value.trim();
            const idx = document.getElementById('uniSelect').selectedIndex;
            // Limpiar el @ si el dominio ya lo trae (ej. "@estudiantes.uv.mx" → "estudiantes.uv.mx")
            const domRaw = dominiosValidos[idx-1] || '';
            const dom = domRaw.startsWith('@') ? domRaw.slice(1) : domRaw;
            // Validar que termine en @dominio y tenga algo antes del @
            const ciOk = dom && ci.endsWith('@' + dom) && ci.indexOf('@') > 0;
            mostrarError('err-correo', 'correoInstitucional', !ciOk);
            if (!ciOk) ok = false;
        }

        if (!ok) return;

        // Enviar código al correo institucional
        const ci = document.getElementById('correoInstitucional').value.trim();
        document.getElementById('correoMostrado').textContent = ci;
        // Limpiar dígitos
        document.querySelectorAll('.ff-code-digit').forEach(d => {
            d.value=''; d.classList.remove('ff-code-ok');
        });

        irAPaso(2);
        // Llamar al endpoint que envía el código
        fetch('registro?accion=mandarCodigo&correo=' + encodeURIComponent(ci)).catch(()=>{});
    }

    function mostrarError(idErr, idInput, show) {
        const el = document.getElementById(idErr);
        const inp = document.getElementById(idInput);
        if (el)  el.classList.toggle('show', show);
        if (inp) inp.classList.toggle('error', show);
    }

    // ── Inputs de código de 6 dígitos ───────────────────────────
    function avanzarDigito(el, idx) {
        el.value = el.value.replace(/\D/,''); // solo números
        if (el.value) {
            el.classList.add('ff-code-ok');
            const next = document.querySelectorAll('.ff-code-digit')[idx+1];
            if (next) next.focus();
        } else {
            el.classList.remove('ff-code-ok');
        }
        // Juntar los 6 dígitos en el input hidden
        const digits = [...document.querySelectorAll('.ff-code-digit')];
        document.getElementById('codigoVerificacion').value =
            digits.map(d=>d.value).join('');
    }

    function verificarCodigo() {
        const codigo = document.getElementById('codigoVerificacion').value;
        if (codigo.length < 6) {
            document.getElementById('err-codigo').classList.add('show');
            return;
        }
        document.getElementById('err-codigo').classList.remove('show');
        // Llamar al endpoint de verificación
        fetch('registro?accion=verificarCodigo&codigo=' + codigo)
            .then(r => r.json())
            .then(data => {
                if (data.ok) {
                    irAPaso(3);
                } else {
                    document.getElementById('err-codigo').classList.add('show');
                    document.querySelectorAll('.ff-code-digit').forEach(d => {
                        d.value=''; d.classList.remove('ff-code-ok');
                    });
                    document.querySelectorAll('.ff-code-digit')[0].focus();
                }
            })
            .catch(() => irAPaso(3)); // fallback si no hay endpoint aún
    }

    function anteriorPaso() { irAPaso(pasoActual - 1); }

    // ── Habilitar botón de registro ──────────────────────────────
    function revisarChecks() {
        const priv = document.getElementById('chkPrivacidad').checked;
        const term = document.getElementById('chkTerminos').checked;
        document.getElementById('btnRegistrarse').disabled = !(priv && term);
        document.getElementById('err-checks').classList.toggle('show', false);
    }

    // ── Modales de documentos legales ───────────────────────────
    function abrirModalDoc(tipo) {
        const id = tipo === 'privacidad' ? 'modalPrivacidad' : 'modalTerminos';
        document.getElementById(id).classList.add('open');
        document.body.style.overflow = 'hidden';
    }
    function cerrarModalDoc(tipo, e) {
        const id = tipo === 'privacidad' ? 'modalPrivacidad' : 'modalTerminos';
        const el = document.getElementById(id);
        if (e === null || e.target === el) {
            el.classList.remove('open');
            document.body.style.overflow = '';
        }
    }
    document.addEventListener('keydown', e => {
        if (e.key !== 'Escape') return;
        ['modalPrivacidad','modalTerminos'].forEach(id => {
            document.getElementById(id)?.classList.remove('open');
        });
        document.body.style.overflow = '';
    });
</script>
</body>
</html>
