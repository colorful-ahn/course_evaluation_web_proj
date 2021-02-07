<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="java.util.Properties" %>
<%@ page import="util.Gmail"%>
<%@ page import="user.userDAO"%>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	userDAO userDAO = new userDAO();
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
	}
	boolean emailChecked = userDAO.getUserEmailChecked(userID);
	request.setCharacterEncoding("UTF-8");
	String reportTitle = null;
	String reportContent = null;
	String reportCategory = null;
	if(request.getParameter("reportTitle")!=null){
		reportTitle = request.getParameter("reportTitle");
	}
	if(request.getParameter("reportContent")!=null){
		reportContent = request.getParameter("reportContent");
	}
	if(request.getParameter("reportCategory")!=null){
		reportCategory = request.getParameter("reportCategory");
	}
	if(reportTitle ==null || reportContent == null || reportCategory==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이있습니다.');");
		script.println("history.back()");
		script.println("</script>");
		script.close();
	}
	
	String host = "http://localhost:8080/web/";
	String from = "akrnote97@gmail.com";
	String to = "akrnote@naver.com";
	String subject = "강의평가 사이트에서 신고된 내용입니다.";
	String content = "신고자 :" + userID +
						"<br>제목: " +reportTitle +
						"<br>항목: " +reportCategory +
						"<br>내용: " + reportContent;


		
	Properties p = new Properties();
	p.put("mail.smtp.user",from);
	p.put("mail.smtp.host","smtp.googlemail.com");
	p.put("mail.smtp.port","465");
	p.put("mail.smtp.auth","true");
	p.put("mail.smtp.stattls.enable","true");
	p.put("mail.smtp.debug","true");
	p.put("mail.smtp.socketFactory.port","465");
	p.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback","false");
	
	try{
	Authenticator auth = new Gmail();
	Session ses = Session.getInstance(p,auth);
	ses.setDebug(true);
	MimeMessage msg = new MimeMessage(ses);
	msg.setSubject(subject);
	Address fromAddr = new InternetAddress(from);
	msg.setFrom(fromAddr);
	Address toAddr = new InternetAddress(to);
	msg.addRecipient(Message.RecipientType.TO, toAddr);
	msg.setContent(content, "text/html; charset=UTF8");
	Transport.send(msg);
	}catch(Exception e){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생하였습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('정상적으로 신고되었습니다.');");
	script.println("location.href = 'index.jsp'");
	script.println("</script>");
	script.close();
%>
 