//! nota: uso de IA aquí

// ? validar paso 1 antes de continuar
function siguientePaso() {
    const nombre = document.getElementById("nombreUsuario").value.trim();
    const email = document.getElementById("email").value.trim();
    const pwd = document.getElementById("pwd").value.trim();
    const uniSelect = document.getElementById("uniSelect");
    const correo = document.getElementById("correoInstitucional").value.trim();
    const dominio = correo.substring(correo.indexOf("@"));

    if (nombre === "" || email === "" || pwd === "" || uniSelect.value === "") {
        alert("Por favor llena todos los campos.");
        return;
    }

    if (!dominiosValidos.includes(dominio)) {
        alert("Tu correo no es institucional.");
        return;
    }



    // Mostrar correo en el mensaje
    document.getElementById("correoMostrado").textContent = correo;

    // Llamar al servlet para mandar el correo
    fetch("registro?accion=mandarCodigo&correo=" + correo)
        .then(response => response.json())
        .then(data => {
            if (data.ok) {
                document.getElementById("paso1").style.display = "none";
                document.getElementById("paso2").style.display = "block";
            }
        });
}

//? regresar al paso 1
function anteriorPaso() {
    document.getElementById("paso2").style.display = "none";
    document.getElementById("paso1").style.display = "block";
}

//? activar botón Registrarse solo si ambos checkboxes están marcados
document.getElementById("chkPrivacidad").addEventListener("change", verificarCheckboxes);
document.getElementById("chkTerminos").addEventListener("change", verificarCheckboxes);

function verificarCheckboxes() {
    const privacidad = document.getElementById("chkPrivacidad").checked;
    const terminos = document.getElementById("chkTerminos").checked;
    document.getElementById("btnRegistrarse").disabled = !(privacidad && terminos);
}

function mostrarCorreo() {
    const uniSelect = document.getElementById("uniSelect");

    if (uniSelect.value !== "") {
        document.getElementById("divCorreo").style.display = "block";
    } else {
        document.getElementById("divCorreo").style.display = "none";
    }
}

function verificarCodigo() {
    const codigo = document.getElementById("codigoVerificacion").value.trim();

    fetch("registro?accion=verificarCodigo&codigo=" + codigo)
        .then(response => response.json())
        .then(data => {
            if (data.ok) {
                document.getElementById("paso2").style.display = "none";
                document.getElementById("paso3").style.display = "block";
            } else {
                alert("Código incorrecto, intenta de nuevo.");
            }
        });
}