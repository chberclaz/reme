<%@page import="org.omg.PortableInterceptor.SYSTEM_EXCEPTION"%>
<%@ page language="java" contentType="text/html"%>
<jsp:useBean id="dbConnect" class="db.DbConnect" scope="session" />
<jsp:setProperty property="*" name="dbConnect" />
	<%
		long uid=0;
		try {
			request.setCharacterEncoding("UTF-8"); //Setzen der Codierung in JSP
			if (request.getParameter("logout").toString().equals("logout")) session.removeAttribute("active_user_id");
		} catch (Exception e) { };

		try {
			if (request.getParameter("bt").equals("Anmelden")) {
				if (dbConnect.passIsOk(request.getParameter("email"), request.getParameter("pass"))) {
					session.setAttribute("active_user_id", dbConnect.getUID(request.getParameter("email")));
					System.out.println("LOGIN:" + dbConnect.getUID(request.getParameter("email")));
					response.sendRedirect("./index.jsp");
				}
			}
		} catch (Exception e) { };

		try {
			if (request.getParameter("bt").equals("Registrieren")) {
				uid = dbConnect.createUser(request.getParameter("vname"),request.getParameter("nname"),
										   request.getParameter("r_email"),request.getParameter("r_email_control"),
										   request.getParameter("r_pass"),request.getParameter("r_pass_control"));
				System.out.println("REGISTER: " + uid);
 				if (uid>0) {
 					session.setAttribute("active_user_id", uid);
 					response.sendRedirect("./index.jsp");}
			}
		} catch (Exception e) { };
		
	%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="./css/styles_reg.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>re:me Startseite</title>
</head>
<body>

<div id="header">
	<div id="wrapper">
	<div id="linke_spalte">
		<h1>re:me</h1>
	</div>
	<div id="rechte_spalte">
			<form id="login" name="login" method="post" action="./login.jsp" accept-charset="UTF-8">
				<fieldset class="login">
				<table>		
					<tr>
						<td><label for="email" class="login">E-Mail:</label></td>
						<td><input type="email" name="email" size="255" value="a@b.c" required /></td>
						<td><input class="but1" type="submit" name="bt" value="Anmelden" /></td>
						</tr>
						<tr>
						<td><label for="pwd" class="login">Passwort:</label></td>
						<td><input type="password" name="pass" size="32" value="a" required /></td>
						<td>&nbsp;</td>
					</tr>
				</table>
				</fieldset>
			</form>
	</div>
	</div>
</div>
	<div id="wrapper2">
		<div id="linke_spalte">
			<p class="text"><br>re:me hilft dir, deinen Alltag besser zu organisieren.
			Gruppiere deine re:mes oder teile sie mit deinen Freunden.</h4>
			</p>
			<img src="img/login_pic.png"/>
		</div>
		<div id="rechte_spalte">
		<br>
		<h3>Registriere dich gratis:</h3>
		<br>
		<fieldset class="register">
			<form id="register" name="register" method="post" action="./login.jsp" accept-charset="UTF-8">
				<table>
				<% if(uid==-1) { %>
					<tr>
						<td><p class="error">Fehler:</p></td>
						<td><p class="error">Benutzer existiert bereits</p></td>
					</tr>
				<%} %>
				<%if(uid==-2) { %>
					<tr>
						<td><p class="error">Fehler:</p></td>
						<td><p class="error">fehlerhafte Eingaben</p></td>
					</tr>
				<% } %>
				<% String vname = request.getParameter("vname")==null ? "" : request.getParameter("vname"); 
			       String nname = request.getParameter("nname")==null ? "" : request.getParameter("nname"); 
				%>
				
				
				
				
					<tr>
						<td><label for="vorname">Vorname:</label></td>
						<td><input type="text" name="vname" size="45" value="<%=vname%>" required /></td>
					</tr>
					<tr>
						<td><label for="nachname">Nachname:</label></td>
						<td><input type="text" name="nname" size="45" value="<%=nname%>" required /></td>
					</tr>
					<tr>
						<td><label for="email">E-mail:</label></td>
						<td><input type="email" name="r_email" size="255" value="" required /></td>
					</tr>
					<tr>
						<td><label for="email">E-mail&nbsp;best&auml;tigen:</label></td>
						<td><input type="email" name="r_email_control" size="255" value="" required /></td>
					</tr>
					<tr>
						<td><label for="pwd">Passwort:</label></td>
						<td><input type="password" name="r_pass" size="32" value="" required /></td>
					</tr>
					<tr>
						<td><label for="pwd">Passwort&nbsp;best&auml;tigen:</label></td>
						<td><input type="password" name="r_pass_control" size="32" value="" required /></td>
					</tr>
		
					<tr>
						<td></td>
						<td><input class="but2" type="submit" name="bt" value="Registrieren" /></td>
					</tr>
				</table>
			</form>
		</fieldset>
		</div>
	</div>
<div id=footer>
	<p class="footer">Entwickelt von der Gang of five :-D<br />Avanzini, Berclaz, Bucic, Savary, Süss, als Projekt an der ZHAW, weiterentwickelt von Berclaz</p>
</div>
</body>
</html>




