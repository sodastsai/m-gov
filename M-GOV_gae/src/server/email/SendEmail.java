package server.email;

import gae.GAEDataBase;
import gae.GAENodeDebug;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("email")
public class SendEmail {

	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}/{c2}/{c3}")		
	public static String go(@PathParam("c1") String user,@PathParam("c2") String subject,@PathParam("c3") String context)
	{
        Properties props = new Properties();
        Session session = Session.getDefaultInstance(props, null);

        System.setProperty("mail.mime.charset", "UTF-8"); 
        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress("mgov.ntu@gmail.com"));
            msg.addRecipient(Message.RecipientType.TO,
                             new InternetAddress(user));
            msg.setHeader("Content-Type","text/plain; charset=\"utf-8\"");
            msg.setHeader("Content-Transfer-Encoding", "quoted-printable");

            msg.setSubject(subject);
            msg.setText(context);
            Transport.send(msg);

        } catch (AddressException e) {
            // ...
        	GAEDataBase.store(new GAENodeDebug("email_exception",e.toString()));
        	e.printStackTrace();
        } catch (MessagingException e) {
            // ...
        	GAEDataBase.store(new GAENodeDebug("email_exception",e.toString()));
        	e.printStackTrace();
        }
        return "done";
	}
}
