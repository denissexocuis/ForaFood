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
    <link rel="stylesheet" href="css/style.css">

    <!-- fevicon -->
    <link rel="icon" type="image/png" href="img/diet.png">

    <!-- fonts style -->
    <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet" />
</head>

<body class="bg-white">

<header class="navbar-flotante">
    <div class="container-fluid px-5">
        <nav class="minimal-nav ms-auto"> <ul class="d-flex list-unstyled gap-4 mb-0">
            <li class="nav-item"><a class="nav-link" href="#">Inicio</a></li>
            <li class="nav-item"><a class="nav-link" href="#descubrir">Descubrir</a></li>
            <li class="nav-item"><a class="nav-link" href="#acerca">Acerca</a></li>
            <li class="nav-item"><a class="nav-link" href="login.jsp">Iniciar Sesión</a></li>
            <li class="nav-item"><a class="nav-link" href="registro">Registrarse</a></li>
        </ul>
        </nav>
    </div>
</header>

<div id="sliderForaFood" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="3500">
    <div class="carousel-inner">

        <div class="carousel-item active">
            <div class="container-fluid p-0">
                <div class="row g-0 vh-100 align-items-center">
                    <div class="col-md-6 d-flex justify-content-center align-items-center bg-white layout-imagen">
                        <img src="img/calabazas.png" class="img-fluid hero-img" alt="ForaFood Specials">
                    </div>
                    <div class="col-md-6 d-flex flex-column justify-content-center align-items-center bg-white px-5 text-center">
                        <h1 class="hero-titulo">Dandelion cucumber earthnut pea peanut soko zucchini</h1>
                        <div class="divisor-ornamento my-3"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="carousel-item">
            <div class="container-fluid p-0">
                <div class="row g-0 vh-100 align-items-center">
                    <div class="col-md-6 d-flex justify-content-center align-items-center bg-white layout-imagen">
                        <img src="img/desayuno.png" class="img-fluid hero-img" alt="ForaFood Breakfast">
                    </div>
                    <div class="col-md-6 d-flex flex-column justify-content-center align-items-center bg-white px-5 text-center">
                        <h1 class="hero-titulo">Veggie gram fava bean leek dandelion silver beet eggplant</h1>
                        <div class="divisor-ornamento my-3"></div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
