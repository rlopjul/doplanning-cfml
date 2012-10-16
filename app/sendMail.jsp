<%@page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@page import="java.util.*"%>
<%@page import="javax.mail.*"%>
<%@page import="javax.mail.internet.*"%>
<%
	try
	{
		String email_from = request.getParameter("email_from");
		String email_to = request.getParameter("email_to");
		String email_bcc = request.getParameter("email_bcc");
		String email_failto = request.getParameter("email_failto");
		String email_subject = request.getParameter("email_subject");
		String email_content = request.getParameter("email_content");

	
		Properties props = new Properties();
		props.put("mail.smtp.host", "10.72.32.4");
		props.put("mail.mime.charset", "UTF-8");
		
		Session s = Session.getInstance(props, null);
		MimeMessage message = new MimeMessage(s);
		InternetAddress from = new InternetAddress(email_from);
		message.setFrom(from);
		
		email_to = email_to.replace(";",",");
		
		InternetAddress addressTo[] = InternetAddress.parse(email_to);
		//InternetAddress to = new InternetAddress(email_to);
		message.addRecipients(Message.RecipientType.TO, addressTo);
		if(email_bcc.length() > 0)
		{
			email_bcc = email_bcc.replace(";",",");
			message.addRecipients(Message.RecipientType.BCC, email_bcc);
		}
		//message.addReplyTo();
		message.setSubject(email_subject, "UTF-8");
		message.setText(email_content,"UTF-8","html");
		
		Transport.send(message);
%><response status="ok">	
	<result></result>
</response><%
	}
	catch (Exception e)
	{
		%><response status="error">	
			<error>
				<title><![CDATA[<%= e.getMessage() %>]]></title>
			</error>
		</response><%
	}
%>