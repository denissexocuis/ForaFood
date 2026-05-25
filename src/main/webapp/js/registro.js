//? validar paso 1 antes de continuar
function siguientePaso() {
    const nombre = document.getElementById("nombreUsuario").value.trim();
    const email = document.getElementById("email").value.trim();
    const pwd = document.getElementById("pwd").value.trim();
    const uni = document.getElementById("uniSelect").value;

    if (nombre === "" || email === "" || pwd === "" || uni === "Seleccionar Universidad...") {
        alert("Por favor llena todos los campos.");
        return;
    }

    document.getElementById("paso1").style.display = "none";
    document.getElementById("paso2").style.display = "block";
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