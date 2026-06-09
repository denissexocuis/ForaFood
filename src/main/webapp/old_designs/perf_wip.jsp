<%--
  Created by IntelliJ IDEA.
  User: denissexocuis
  Date: 08/06/2026
  Time: 10:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Perfil - ForaFood</title>
    <link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/feed_style.css">
    <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet" />
    <style>
        .perfil-container { display: flex; gap: 30px; padding: 40px; font-family: 'Poppins', sans-serif; }
        .card-stat { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; text-align: center; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); flex: 1; }
        .card-stat h3 { font-size: 24px; font-weight: 700; margin: 0; color: #0f172a; }
        .card-stat p { font-size: 12px; color: #64748b; margin: 4px 0 0 0; text-transform: uppercase; font-weight: 600; }
        .config-box { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 30px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-top: 30px; }
    </style>
</head>
<body class="bg-light">

<div style="display: flex;">

    <div style="padding: 20px; position: absolute; top: 0; left: 0;">
        <a href="principal" style="background: #0f172a; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600;">← Volver al Feed</a>
    </div>

    <div class="container" style="max-width: 1000px; margin-top: 60px;">

        <div style="display: flex; gap: 15px; margin-bottom: 30px;">
            <div class="card-stat">
                <h3>${cantPosts}</h3>
                <p>📝 Posts Creados</p>
            </div>
            <div class="card-stat">
                <h3>${cantLugares}</h3>
                <p>🗺️ Locales Descubiertos</p>
            </div>
            <div class="card-stat">
                <h3 style="color: #16a34a;">+${votosReales}</h3>
                <p>👍 Votos Reales Recibidos</p>
            </div>
            <div class="card-stat">
                <h3 style="color: #dc2626;">-${votosFalsos}</h3>
                <p>👎 Votos Falsos Recibidos</p>
            </div>
        </div>

        <div class="config-box">
            <h2 style="font-size: 18px; font-weight: 700; color: #0f172a; margin-bottom: 20px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">⚙️ Configuración de Cuenta</h2>

            <form action="perfil" method="POST" enctype="multipart/form-data" id="formConfig">

                <div class="row">
                    <div class="col-md-6" style="margin-bottom: 15px;">
                        <label style="font-weight: 600; font-size: 13px; color: #334155;">Cambiar Nombre de Usuario:</label>
                        <input type="text" name="nuevoUser" value="<%= session.getAttribute("user") %>" class="form-control" style="font-size: 13px; padding: 10px;">
                    </div>

                    <div class="col-md-6" style="margin-bottom: 15px;">
                        <label style="font-weight: 600; font-size: 13px; color: #334155;">Actualizar Foto de Perfil:</label>
                        <input type="file" name="nuevaFotoPerfil" accept="image/*" class="form-control" style="font-size: 13px;">
                    </div>
                </div>

                <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; margin-top: 15px;">
                    <h3 style="font-size: 14px; font-weight: 700; color: #1e293b; margin-bottom: 12px;">🔒 Seguridad: Cambiar Contraseña</h3>

                    <div class="row">
                        <div class="col-md-4">
                            <label style="font-size: 12px; color: #475569;">Nueva Contraseña:</label>
                            <input type="password" id="txtPass" name="nuevaPassword" class="form-control" style="font-size: 13px;">
                        </div>
                        <div class="col-md-4">
                            <label style="font-size: 12px; color: #475569;">Código de Verificación:</label>
                            <div style="display: flex; gap: 5px;">
                                <input type="text" name="codigoVerificacion" placeholder="Ej. 4829" class="form-control" style="font-size: 13px;">
                                <button type="button" onclick="solicitarCodigo()" style="background: #0284c7; color: white; border: none; padding: 0 10px; border-radius: 4px; font-size: 11px; font-weight: 600; white-space: nowrap;">Pedir Código</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div style="margin-top: 25px; text-align: right;">
                    <button type="submit" style="background: #1e293b; color: white; padding: 10px 24px; border: none; border-radius: 6px; font-weight: 600; font-size: 13px; cursor: pointer;">Guardar Cambios</button>
                </div>

            </form>
        </div>

    </div>
</div>

<script>
    // Función asíncrona para simular o mandar el código de seguridad por consola del sv/alert
    function solicitarCodigo() {
        const pass = document.getElementById("txtPass").value;
        if(!pass.trim()) {
            alert("Por favor, escribe primero tu nueva contraseña.");
            return;
        }

        fetch('perfil?solicitarCodigo=true')
            .then(res => res.text())
            .then(msg => {
                alert("🔐 [ForaFood Security]: Tu código de verificación temporal es de 4 dígitos. Revisa la consola o usa tu código fijo de desarrollo.");
            });
    }
</script>
</body>
</html>
