# Flujo del proceso
### Esto me sirve de guía y para entender el funcionamiento

Check framework AAA

Fuentes de información que me ayudaron más:
https://medium.com/@rintoprie/building-a-simple-web-application-with-java-servlet-jsp-and-hibernate-in-2025-e93f17d0ddcc

https://medium.com/@tejveersing1322/java-servlets-and-jsp-building-dynamic-web-applications-92e5b34b3ef0

https://www.ibm.com/docs/es/i/7.4.0?topic=java-jsp-servlet-programming

https://www.geeksforgeeks.org/java/introduction-java-servlets/

Incluso cursito de youtube: https://www.youtube.com/watch?v=0FpLve7ffoY&list=PLfu_Bpi_zcDOn8ajnuLY6g1C6hc_eeDFl

_Nota: me ayudé con IA para que me ayudara con la explicación._

##### ¿Qué es TomCat?
Tomcat es el motor web (Servlet Container). Es el programa que:
- Se queda corriendo en tu computadora "escuchando" el puerto 8080.
- Cuando tú entras a localhost, Tomcat recibe el impacto de la red.
- Traduce esa petición web extraña en objetos que Java sí entiende (HttpServletRequest).
- Busca tu Servlet y le dice: "Ey, te buscan, toma los datos que llegaron".


1. El usuario llena un formulario HTML/JSP en su navegador y da clic en "Registrar". El navegador empaqueta esa información en una petición HTTP (normalmente de tipo POST) y la manda al servidor **Tomcat.**

   `<input type="email" name="correoDeUsuario">`
2. Tomcat recibe la petición (por ejemplo, a la ruta /registrarUsuario). Como Tomcat no sabe qué hacer solo, consulta el archivo web.xml. Este archivo tiene un mapa que dice:
   *"Si llega una petición a /registrarUsuario, despáchala al Servlet llamado RegistroServlet".*

(Nota: En versiones modernas de Java, este archivo se puede omitir si usas la anotación **@WebServlet("/registrarUsuario")** justo arriba de tu Servlet.)
3. El Servlet toma el control a través de su método **doPost.** Sus tareas son secuenciales:
   1. Lee los datos sueltos que envió el navegador usando request.getParameter().
   2. Junta esos datos sueltos y los mete dentro de un JavaBean (por ejemplo, hace un new Usuario(nombre, email, password)). Ahora los datos viajan seguros y ordenados en un solo objeto.
   3. Le pasa este JavaBean al DAO llamando a su método correspondiente: usuarioDAO.insertOne(user).

    ```
   // 1. El Servlet saca el texto del formulario
   String correoCachado = request.getParameter("correoDeUsuario");
   // 2. Crea el JavaBean (el objeto vacío) y le mete el correo
    Usuario userBean = new Usuario();
    userBean.setEmail(correoCachado);

    // 3. ¡Aquí se lo pasa al DAO! Invoca al método del DAO y le manda el objeto completo
    miUsuarioDAO.insertOne(userBean);
   ```
4. El DAO recibe el JavaBean. Como el DAO es el especialista en la base de datos:
   1. Desempaqueta el JavaBean.
   2. Traduce esos datos al lenguaje que entienda tu base de datos (Document de MongoDB).
   3. Ejecuta la operación en la colección de Mongo y le avisa al Servlet que todo salió bien.

    ```
   @Override
    public void insertOne(Usuario user) { // <-- Aquí llegó el objeto que mandó el Servlet
    Document doc = new Document()
    // Saca el dato del Bean y lo mete a Mongo
    .append("email", user.getEmail());
    
        collection.insertOne(doc);
    }
   ```
5. Una vez que el DAO termina, el control regresa al Servlet. El Servlet decide a qué página enviar al usuario. Si quiere mostrar datos en la siguiente pantalla:
   1. Guarda la información en el "carrito" de la petición: request.setAttribute("clave", objeto).
   2. Hace un Forward (redirige el tráfico) hacia el archivo JSP.
6. El archivo JSP entra en acción. Es mayoritariamente código HTML (estilizado con Bootstrap), pero tiene la capacidad de "leer" el carrito que dejó el Servlet usando etiquetas especiales (como Expression Language ${clave}).