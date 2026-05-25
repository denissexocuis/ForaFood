<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<!DOCTYPE html>
<html lang="es">

<!-- plantillas

 https://mdbootstrap.com/docs/standard/extended/login/
 -->

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

<section class="vh-100" style="background-color: #1c7430;">
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

                                <!-- ! METODO POST, SERVLET REGISTRO  -->
                                <form action="registro" method="post" class="mb-3">

                                    <div class="d-flex align-items-center mb-3 pb-1">
                                        <i class="fas fa-cubes fa-2x me-3" style="color: #ff6219;"></i>
                                    </div>

                                    <h5 class="fw-normal mb-3 pb-3" style="letter-spacing: 1px;">Registro</h5>

                                    <div id="paso1">
                                        <div data-mdb-input-init class="form-outline mb-1">
                                            <label class="form-label" for="nombreUsuario">Nombre de usuario</label>
                                            <input type="text" id="nombreUsuario" name="nombreUsuario" class="form-control" />
                                            <small class="text-muted">Usa un nombre ficticio, no tu nombre real.</small>
                                        </div>

                                        <div data-mdb-input-init class="form-outline mb-1">
                                            <label class="form-label" for="email">Email</label>
                                            <input type="email" id="email" name="email" class="form-control" />
                                        </div>

                                        <div data-mdb-input-init class="form-outline mb-1">
                                            <label class="form-label" for="pwd">Contraseña</label>
                                            <input type="password" class="form-control" id="pwd" name="pwd" required>
                                            <small class="text-muted">Mínimo 8 caracteres, incluye al menos un número y un símbolo.</small>
                                            <div class="invalid-feedback">
                                                Debe ser al menos de 8 caracteres con un número y símbolo.
                                            </div>
                                        </div>

                                        <!-- ? Seleccionar la universidad -->
                                        <label class="form-label" for="uniSelect">Universidad:</label>

                                        <select id="uniSelect" name="txtUniversidad" class="form-control mb-2">
                                            <option selected disabled>Seleccionar Universidad...</option>

                                            <%
                                                // AQUÍ SI USE IA...
                                                // 1. sacar la lista que el servlet dejó en request
                                                List<Document> universidades = (List<Document>) request.getAttribute("lista_universidades");

                                                // 2. validar que la lista no venga vacía por si acaso
                                                if (universidades != null)
                                                {
                                                    // 3. recorrer cada documento de la lista
                                                    for (Document uni : universidades)
                                                    {
                                                        // 4. extraer los datos del documento de Mongo
                                                        String idUni = uni.get("_id").toString();
                                                        String nombreUni = uni.getString("nombre_uni");
                                            %>
                                            <option value="<%= idUni %>"><%= nombreUni %></option>
                                            <%
                                                    } // cerrar for
                                                } // cerrar if
                                            %>

                                        </select>
                                        <div data-mdb-input-init class="form-outline mb-1">
                                            <label class="form-label" for="email">Correo Institucional:</label>
                                            <input type="email" id="emailInstitucional" name="email" class="form-control" />
                                        </div>

                                        <button type="button" class="btn btn-dark mt-3 w-100" onclick="siguientePaso()">Siguiente</button>
                                    </div>

                                    <div id="paso2" style="display: none;">

                                        <!-- Checkboxes -->
                                        <div class="mb-2">
                                            <input type="checkbox" id="chkPrivacidad" name="chkPrivacidad" required>
                                            <label for="chkPrivacidad">Acepto el
                                                <a href="#" data-bs-toggle="modal" data-bs-target="#modalPrivacidad">Aviso de Privacidad</a>
                                            </label>
                                        </div>

                                        <div class="mb-2">
                                            <input type="checkbox" id="chkTerminos" name="chkTerminos" required>
                                            <label for="chkTerminos">Acepto los
                                                <a href="#" data-bs-toggle="modal" data-bs-target="#modalTerminos">Términos y Condiciones</a>
                                            </label>
                                        </div>

                                        <!-- ? Botón desactivado hasta que acepten -->
                                        <button type="submit" class="btn btn-dark mt-3 w-100" id="btnRegistrarse" disabled>
                                            Registrarse
                                        </button>
                                        <button type="button" class="btn btn-dark mt-3 w-100" onclick="anteriorPaso()">Atrás</button>
                                    </div>


                                    <a class="small text-muted" href="#!">Forgot password?</a>
                                    <p class="mb-5 pb-lg-2" style="color: #393f81;">Don't have an account? <a href="#!"
                                                                                                              style="color: #393f81;">Register here</a></p>

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

<!-- ! Modal Términos y Condiciones -->
<div class="modal fade" id="modalTerminos" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Términos y Condiciones</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="max-height: 400px; overflow-y: auto;">
                <p>Tu texto de términos y condiciones...</p>
            </div>
            <div class="modal-footer">
                <a href="docs/terminos.pdf" download class="btn btn-outline-dark">
                    Descargar PDF
                </a>
                <button type="button" class="btn btn-dark" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/registro.js"></script>

</body>

</html>
