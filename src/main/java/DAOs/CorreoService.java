package DAOs;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

//* esto fue IAdo :), no sabía como hacerle :(

public class CorreoService
{

    public static void mandarCodigo(String correoDestino, int codigo) throws MessagingException {

        String correoOrigen = System.getenv("CORREO");
        String password = System.getenv("CORREO_PASSWORD");

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        //props.put("mail.smtp.port", "587"); // local host

        // deployment
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(correoOrigen, password);
            }
        });

        session.setDebug(true);

        Message mensaje = new MimeMessage(session);
        mensaje.setFrom(new InternetAddress(correoOrigen));
        mensaje.setRecipients(Message.RecipientType.TO, InternetAddress.parse(correoDestino));
        mensaje.setSubject("Código de verificación - ForaFood");
        mensaje.setText("Tu código de verificación es: " + codigo);

        Transport.send(mensaje);
        System.out.println("Correo mandado a: " + correoDestino);
    }
}