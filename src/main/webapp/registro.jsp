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
                                 alt="login form" class="img-fluid" style="border-radius: 1rem 0 0 1rem;" />
                        </div>
                        <div class="col-md-6 col-lg-7 d-flex align-items-center">
                            <div class="card-body p-4 p-lg-5 text-black">

                                <form action="post" class="mb-3">

                                    <div class="d-flex align-items-center mb-3 pb-1">
                                        <i class="fas fa-cubes fa-2x me-3" style="color: #ff6219;"></i>
                                    </div>

                                    <h5 class="fw-normal mb-3 pb-3" style="letter-spacing: 1px;">Registro</h5>

                                    <div data-mdb-input-init class="form-outline mb-2">
                                        <input type="email" id="form2Example17" class="form-control form-control-lg" />
                                        <label class="form-label" for="form2Example17">Nombre de usuario</label>
                                    </div>

                                    <div data-mdb-input-init class="form-outline mb-2">
                                        <input type="password" id="form2Example27" class="form-control form-control-lg" />
                                        <label class="form-label" for="form2Example27">Email</label>
                                    </div>

                                    <div data-mdb-input-init class="form-outline mb-2">
                                        <input type="password" id="form2Example27" class="form-control form-control-lg" />
                                        <label class="form-label" for="form2Example27">Contraseña</label>
                                    </div>

                                    <div data-mdb-input-init class="form-outline mb-2">
                                        <input type="password" id="form2Example27" class="form-control form-control-lg" />
                                        <label class="form-label" for="form2Example27">Universidad</label>
                                    </div>


                                    <form action="registro" method="post">

                                        <label for="uniSelect" class="form-label text-muted">Universidad</label>

                                        <select id="uniSelect" name="txtUniversidad" class="form-select">
                                            <option selected disabled>Elige tu universidad...</option>

                                            <%
                                                // 1. AQUÍ SE PONE LA LÍNEA MÁGICA 📍
                                                // Sacamos la lista que el Servlet dejó en la canasta (request)
                                                // Asegúrate de que el nombre entre comillas sea EXACTAMENTE el mismo que pusiste en el setAttribute del Servlet
                                                java.util.List<org.bson.Document> universidades = (java.util.List<org.bson.Document>) request.getAttribute("lista_universidades");

                                                // 2. Validamos que la lista no venga vacía por si acaso
                                                if (universidades != null) {
                                                    // 3. Recorremos cada documento de la lista
                                                    for (org.bson.Document uni : universidades) {

                                                        // Extraemos los datos del documento de Mongo
                                                        // Asumiendo que tus campos en Mongo se llaman "id_uni" y "nombre" (cámbialos por los tuyos reales)
                                                        String idUni = uni.get("_id").toString();
                                                        String nombreUni = uni.getString("nombre");
                                            %>
                                            <option value="<%= idUni %>"><%= nombreUni %></option>
                                            <%
                                                    } // Cerramos el for
                                                } // Cerramos el if
                                            %>

                                        </select>

                                        <button type="submit" class="btn btn-dark mt-3 w-100">Registrarme</button>
                                    </form>

                                    <div class="pt-1 mb-4">
                                        <button data-mdb-button-init data-mdb-ripple-init class="btn btn-dark btn-lg btn-block" type="button">Siguiente</button>
                                    </div>

                                    <a class="small text-muted" href="#!">Forgot password?</a>
                                    <p class="mb-5 pb-lg-2" style="color: #393f81;">Don't have an account? <a href="#!"
                                                                                                              style="color: #393f81;">Register here</a></p>
                                    <a href="#!" class="small text-muted">Terms of use.</a>
                                    <a href="#!" class="small text-muted">Privacy policy</a>
                                </form>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

</body>

</html>
