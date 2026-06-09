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
    <title>ForaFood — Inicio</title>

    <!-- ? fav icon-->
    <link rel="icon" type="image/png" href="img/diet.png">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- ? css-->
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/index.css">
</head>
<body>

<!--? ── NAVBAR ───────────────────────────────────────────────── -->
<nav class="ff-nav" id="ffNav">
    <a class="ff-nav-logo" href="#">fora<span>food</span></a>
    <ul class="ff-nav-links">
        <li><a href="#descubrir">Descubrir</a></li>
        <li><a href="#como-funciona">Cómo funciona</a></li>
        <li><a href="#comunidad">Comunidad</a></li>
        <li><a href="#" onclick="abrirModal()" class="btn-login">Iniciar sesión</a></li>
        <li><a href="registro" style="color:var(--green);font-weight:700;border:1px solid var(--green);padding:7px 14px;border-radius:8px;">Registrarse</a></li>
    </ul>
</nav>

<!--? ── ERROR BANNER ─────────────────────────────────────────── -->
<% if ("1".equals(request.getParameter("error"))) { %>
<div class="ff-error-banner" id="errorBanner">
    Correo o contraseña incorrectos. Intenta de nuevo.
</div>
<script>setTimeout(() => document.getElementById('errorBanner')?.remove(), 4000);</script>
<% } %>

<!-- ?══ HERO ════════════════════════════════════════════════════ -->
<section class="ff-hero">
    <div class="ff-hero-content">
        <h1>
            Descubre dónde<br>
            comer <span class="accent">cerca</span><br>
            de tu facultad
        </h1>

        <p class="ff-hero-sub">
            ForaFood es la comunidad donde los estudiantes comparten,
            votan y descubren los mejores lugares para comer cerca del campus.
        </p>

        <div class="ff-hero-btns">
            <a href="registro" class="btn-primary-ff">Unirme gratis →</a>
            <a href="#como-funciona" class="btn-outline-ff">Ver cómo funciona</a>
        </div>

        <div class="ff-hero-stats">
            <div>
                <div class="ff-stat-num">100%</div>
                <div class="ff-stat-label">Opiniones de estudiantes</div>
            </div>
            <div>
                <div class="ff-stat-num">+Pts</div>
                <div class="ff-stat-label">Gana puntos y medallas</div>
            </div>
        </div>
    </div>

    <!--? Mockup flotante -->
    <div class="ff-hero-img-wrap">
        <div class="ff-hero-mockup">
            <div class="ff-mockup-bar">
                <div class="ff-mockup-dot" style="background:#f87171;"></div>
                <div class="ff-mockup-dot" style="background:#fbbf24;"></div>
                <div class="ff-mockup-dot" style="background:#4ade80;"></div>
                <div class="ff-mockup-title">ForaFood — Feed</div>
            </div>

            <div class="ff-mini-card">
                <div class="ff-mini-meta">🐥 KasaneTeto22 · Comunidad UV · hace 2h</div>
                <div class="ff-mini-title">Antojitos consejo técnico</div>
                <div class="ff-mini-desc">Los tacos están buenísimos, muy económicos y a pasos de la facultad.</div>
                <div class="ff-mini-pills">
                    <div class="ff-mini-pill real">✓ 4 Es real</div>
                    <div class="ff-mini-pill fake">✗ 0 Es falso</div>
                </div>
            </div>

            <div class="ff-mini-card">
                <div class="ff-mini-meta">🐸 sossusamogus · hace 5h</div>
                <div class="ff-mini-title">Encontré unos tacos muy buenos</div>
                <div class="ff-mini-desc">Están muy ricos, aceptan tarjeta y están cerca de la entrada principal.</div>
                <div class="ff-mini-pills">
                    <div class="ff-mini-pill real">✓ 2 Es real</div>
                    <div class="ff-mini-pill fake">✗ 0 Es falso</div>
                </div>
            </div>

            <div class="ff-mini-card">
                <div class="ff-mini-meta">🦊 Schiliskiller · hace 1d</div>
                <div class="ff-mini-title">Menú del día en el módulo 3</div>
                <div class="ff-mini-desc">Torta de milanesa + agua fresca por $35. Muy llena y económica.</div>
                <div class="ff-mini-pills">
                    <div class="ff-mini-pill real">✓ 6 Es real</div>
                    <div class="ff-mini-pill fake">✗ 1 Es falso</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!--? ══ FEATURES ════════════════════════════════════════════════ -->
<section class="ff-section" id="descubrir"
    style="border-top: 1px solid var(--border);">
    <div class="ff-section-tag">¿Por qué ForaFood?</div>
    <h2 class="ff-section-title">Todo lo que necesitas<br>para comer bien en la uni</h2>
    <p class="ff-section-sub">Una plataforma hecha por estudiantes, para estudiantes. Sin restaurantes patrocinados, sin reseñas falsas.</p>

    <div class="ff-features-grid">
        <div class="ff-feature-card">
            <div class="ff-feature-icon">🗳️</div>
            <div class="ff-feature-title">Votos comunidad</div>
            <div class="ff-feature-desc">Cada publicación se valida con votos de "Es real" o "Es falso". La comunidad filtra el contenido sola.</div>
        </div>
        <div class="ff-feature-card">
            <div class="ff-feature-icon">🗺️</div>
            <div class="ff-feature-title">Mapa interactivo</div>
            <div class="ff-feature-desc">Ubica los puestos y restaurantes en el mapa del campus. Nunca más preguntar "¿dónde queda?"</div>
        </div>
        <div class="ff-feature-card">
            <div class="ff-feature-icon">🏆</div>
            <div class="ff-feature-title">Puntos y medallas</div>
            <div class="ff-feature-desc">Gana puntos por publicar y recibir votos. Sube de rango y desbloquea medallas exclusivas.</div>
        </div>
        <div class="ff-feature-card">
            <div class="ff-feature-icon">⚡</div>
            <div class="ff-feature-title">Tiempo real</div>
            <div class="ff-feature-desc">Los votos y comentarios se reflejan al instante.</div>
        </div>
        <div class="ff-feature-card">
            <div class="ff-feature-icon">🔒</div>
            <div class="ff-feature-title">Solo universitarios</div>
            <div class="ff-feature-desc">Acceso exclusivo con correo universitario. Tu comunidad, tu comida, tu red.</div>
        </div>
        <div class="ff-feature-card">
            <div class="ff-feature-icon">🚫</div>
            <div class="ff-feature-title">Cero patrocinio</div>
            <div class="ff-feature-desc">No hay restaurantes que paguen para aparecer. Todo lo que ves es orgánico y real.</div>
        </div>
    </div>
</section>

<!--? ══ CÓMO FUNCIONA ═══════════════════════════════════════════ -->
<section class="ff-section ff-steps" id="como-funciona">
    <div class="ff-section-tag">Simple y rápido</div>
    <h2 class="ff-section-title">Cómo funciona</h2>
    <div class="ff-steps-grid">
        <div class="ff-step">
            <div class="ff-step-num">01</div>
            <div class="ff-step-icon">📝</div>
            <div class="ff-step-title">Regístrate gratis</div>
            <div class="ff-step-desc">Crea tu cuenta con tu correo universitario en menos de 2 minutos.</div>
        </div>
        <div class="ff-step">
            <div class="ff-step-num">02</div>
            <div class="ff-step-icon">📍</div>
            <div class="ff-step-title">Descubre lugares</div>
            <div class="ff-step-desc">Explora el feed y el mapa para encontrar dónde comen tus compañeros hoy.</div>
        </div>
        <div class="ff-step">
            <div class="ff-step-num">03</div>
            <div class="ff-step-icon">✍️</div>
            <div class="ff-step-title">Comparte lo que encontraste</div>
            <div class="ff-step-desc">Publica un lugar nuevo con foto, descripción y ubícalo en el mapa del campus.</div>
        </div>
        <div class="ff-step">
            <div class="ff-step-num">04</div>
            <div class="ff-step-icon">🎖️</div>
            <div class="ff-step-title">Gana puntos y sube de rango</div>
            <div class="ff-step-desc">Cada publicación y voto recibido te da puntos. Escala el ranking y gana medallas.</div>
        </div>
    </div>
</section>

<!--? ══ GAMIFICACIÓN / RANKING ═══════════════════════════════════ -->
<section class="ff-section" id="comunidad"
    style="border-top: 1px solid var(--border);">
    <div class="ff-gamif-wrap">
        <div>
            <div class="ff-section-tag">Comunidad activa</div>
            <h2 class="ff-section-title">Sube al ranking.<br>Hazte leyenda.</h2>
            <p class="ff-section-sub" style="margin-bottom: 24px;">
                Cada post que publicas y cada voto que recibes te acerca al siguiente rango.
                Desde Novato hasta Leyenda — ¿hasta dónde llegas?
            </p>
            <div class="ff-badges-row">
                <div class="ff-badge-chip">🌱 Novato</div>
                <div class="ff-badge-chip">🥉 Explorador</div>
                <div class="ff-badge-chip">🥈 Jr.</div>
                <div class="ff-badge-chip">⭐ Pro</div>
                <div class="ff-badge-chip">🏆 Maestro</div>
                <div class="ff-badge-chip">👑 Leyenda</div>
            </div>
        </div>

        <div class="ff-rank-preview">
            <div class="ff-rank-header">🏆 Top usuarios</div>
            <div class="ff-rank-row">
                <div class="ff-rank-pos gold">1</div>
                <div class="ff-rank-av" style="background:#eef0d0;">🐥</div>
                <div class="ff-rank-info">
                    <div class="ff-rank-name">KasaneTeto22</div>
                    <div class="ff-rank-sub">👑 Leyenda</div>
                </div>
                <div class="ff-rank-pts">840 pts</div>
            </div>
            <div class="ff-rank-row">
                <div class="ff-rank-pos silver">2</div>
                <div class="ff-rank-av" style="background:#f0e8d8;">🐸</div>
                <div class="ff-rank-info">
                    <div class="ff-rank-name">sossusamogus</div>
                    <div class="ff-rank-sub">🏆 Maestro</div>
                </div>
                <div class="ff-rank-pts">620 pts</div>
            </div>
            <div class="ff-rank-row">
                <div class="ff-rank-pos bronze">3</div>
                <div class="ff-rank-av" style="background:#e8eed8;">🦊</div>
                <div class="ff-rank-info">
                    <div class="ff-rank-name">Schiliskiller</div>
                    <div class="ff-rank-sub">⭐ Pro</div>
                </div>
                <div class="ff-rank-pts">410 pts</div>
            </div>
            <div class="ff-rank-row">
                <div class="ff-rank-pos other">4</div>
                <div class="ff-rank-av" style="background:#f8f0e0;">🐻</div>
                <div class="ff-rank-info">
                    <div class="ff-rank-name">tlapalero99</div>
                    <div class="ff-rank-sub">🥈 Jr.</div>
                </div>
                <div class="ff-rank-pts">280 pts</div>
            </div>
            <div class="ff-rank-row">
                <div class="ff-rank-pos other">5</div>
                <div class="ff-rank-av" style="background:#eef8f0;">🐝</div>
                <div class="ff-rank-info">
                    <div class="ff-rank-name">susanita33</div>
                    <div class="ff-rank-sub">🥉 Explorador</div>
                </div>
                <div class="ff-rank-pts">135 pts</div>
            </div>
        </div>
    </div>
</section>

<!--? ══ CTA FINAL ═══════════════════════════════════════════════ -->
<section class="ff-cta">
    <h2>¿Listo para encontrar<br>tu <span>lugar favorito</span>?</h2>
    <p>Únete a la comunidad estudiantil que ya comparte los mejores lugares para comer cerca del campus.</p>
    <a href="registro" class="btn-cta-ff">Crear mi cuenta gratis →</a>
</section>

<!--? ══ FOOTER ══════════════════════════════════════════════════ -->
<footer class="ff-footer">
    <div class="ff-footer-logo">fora<span>food</span></div>
    <div>Hecho por estudiantes, para estudiantes</div>
    <div>
        <a href="#" onclick="abrirModal()" style="color:#8a7a5a;text-decoration:none;margin-right:16px;">Iniciar sesión</a>
        <a href="registro" style="color:#a3c45a;text-decoration:none;font-weight:600;">Registrarse</a>
    </div>
</footer>

<!-- ══ MODAL DE LOGIN ══════════════════════════════════════════ -->
<div class="ff-modal-overlay" id="loginModal" onclick="cerrarModal(event)">
    <div class="ff-modal-box" onclick="event.stopPropagation()">
        <button class="ff-modal-close" onclick="cerrarModal(null)">✕</button>

        <div class="ff-modal-logo">fora<span>food</span></div>
        <div class="ff-modal-sub">Inicia sesión con tu cuenta universitaria</div>

        <form action="login" method="post">
            <div class="ff-form-group">
                <label class="ff-form-label">Correo universitario</label>
                <input type="email" name="emailLogin" class="ff-form-input"
                       placeholder="usuario@universidad.edu.mx" required>
            </div>
            <div class="ff-form-group">
                <label class="ff-form-label">Contraseña</label>
                <input type="password" name="pwdLogin" class="ff-form-input"
                       placeholder="••••••••" required>
            </div>
            <button type="submit" class="ff-btn-submit">Entrar al feed →</button>
        </form>

        <div class="ff-modal-divider">
            <hr><span>¿No tienes cuenta?</span><hr>
        </div>
        <a href="registro" class="ff-btn-register">Crear cuenta gratis</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    //! uso de ia D:
    // Navbar scroll effect
    const nav = document.getElementById('ffNav');
    window.addEventListener('scroll', () => {
        nav.classList.toggle('scrolled', window.scrollY > 40);
    });

    // Modal de login
    function abrirModal() {
        document.getElementById('loginModal').classList.add('open');
        document.body.style.overflow = 'hidden';
    }
    function cerrarModal(e) {
        if (e === null || e.target === document.getElementById('loginModal')) {
            document.getElementById('loginModal').classList.remove('open');
            document.body.style.overflow = '';
        }
    }
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') cerrarModal(null);
    });

    // Abrir modal automáticamente si hay error de login
    <% if ("1".equals(request.getParameter("error"))) { %>
        window.addEventListener('load', () => abrirModal());
    <% } %>

    // Scroll suave para los anchors
    document.querySelectorAll('a[href^="#"]').forEach(a => {
        a.addEventListener('click', e => {
            const href = a.getAttribute('href');
            if (href === '#') return;
            e.preventDefault();
            document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
        });
    });
</script>



</body>
</html>
