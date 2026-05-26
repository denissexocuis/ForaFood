<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>ForaFood</title>

    <!-- bootstrap   -->
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css">

    <!-- archivo css -->
    <link rel="stylesheet" href="css/style.css">

    <!-- fevicon -->
    <link rel="icon" type="image/png" href="img/diet.png">

    <!-- fonts style -->
    <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet" />
</head>

<body class="bg-white">

<section class="vh-100" style="background-color: #0c3d5d;">
    <div class="container py-5 h-100">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="col col-xl-10">
                <div class="card" style="border-radius: 1rem;">
                    <div class="row g-0">
                        <div class="col-md-6 col-lg-5 d-none d-md-block">
                            <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-login-form/img1.webp"
                                 alt="register form" class="img-fluid h-100"
                                 style="border-radius: 1rem 0 0 1rem; object-fit: cover;" />
                        </div>
                        <div class="col-md-6 col-lg-7 d-flex align-items-center">
                            <div class="card-body p-4 p-lg-5 text-black">

                                <h5 class="fw-normal mb-3 pb-3" style="letter-spacing: 1px;">Iniciar Sesión</h5>

                                <!-- ! METODO POST, SERVLET LOGIN  -->
                                <form action="login" method="post" class="mb-3" novalidate>

                                    <div class="d-flex align-items-center mb-3 pb-1">
                                        <i class="fas fa-cubes fa-2x me-3" style="color: #ff6219;"></i>
                                    </div>

                                    <!--* PASO 1  DEL FORMULARIO-->
                                    <!-- uso de ia en los pasos...para el diseño ;)-->
                                    <div id="paso1">
                                        <div data-mdb-input-init class="form-outline mb-1">
                                            <label class="form-label" for="email">Email</label>
                                            <input type="email" id="email" name="emailLogin" class="form-control" />
                                        </div>

                                        <div data-mdb-input-init class="form-outline mb-1">
                                            <label class="form-label" for="pwd">Contraseña</label>
                                            <input type="password" class="form-control" id="pwd" name="pwdLogin">
                                        </div>
                                    </div>

                                    <a class="small text-muted" href="#!">¿Olvidaste tu contraseña? (WIP)</a>
                                    <p class="mb-5 pb-lg-2" style="color: #393f81;">¿No tienes una cuenta? <a href="registro"
                                                                                                              style="color: #393f81;">Registrate aquí.</a></p>

                                </form>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>



<!-- Modal Aviso de Privacidad -->
<div class="modal fade" id="modalPrivacidad" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Aviso de Privacidad</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="max-height: 400px; overflow-y: auto;">
                <!-- tu texto aquí -->
                <p>Tu texto del aviso de privacidad...</p>
            </div>
            <div class="modal-footer">
                <a href="docs/aviso-privacidad.pdf" download class="btn btn-outline-dark">
                    Descargar PDF
                </a>
                <button type="button" class="btn btn-dark" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>
