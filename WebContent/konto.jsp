<%@page import="org.omg.PortableInterceptor.SYSTEM_EXCEPTION"%>
<%@ page language="java" contentType="text/html"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page errorPage="login.jsp"%>
<jsp:useBean id="dbConnect" class="db.DbConnect" scope="session" />
<jsp:setProperty property="*" name="dbConnect" />
<%
request.setCharacterEncoding("UTF-8");//Setzen der Codierung in JSP

Statement st;
ResultSet rs;
ResultSet rsGroups, rsUser;
long groupid=0;
String groupName="";

%>
<%
if(session.getAttribute("active_user_id")==null) response.sendRedirect("./login.jsp");

long uid=0;
try {
			request.setCharacterEncoding("UTF-8"); //Setzen der Codierung in JSP
			if (request.getParameter("logout").toString().equals("logout")) session.removeAttribute("active_user_id");
		} catch (Exception e) { };

try {
	if (request.getParameter("bt").equals("save Changes")) {
		System.out.println("change name");
		dbConnect.user_changeName(session.getAttribute("active_user_id"), request.getParameter("vname"),request.getParameter("nname"));			
	}
} catch (Exception e) { };

try {
//	if (request.getParameter("bt").equals("Passwort ändern")) {
	if (request.getParameter("bt").equals("change Password")) {
		if (dbConnect.passIsOk(dbConnect.getEmail(session.getAttribute("active_user_id")),request.getParameter("oldpass"))  && (request.getParameter("r_pass").equals(request.getParameter("r_pass_control"))))  {
			System.out.println("PWD OK");
			dbConnect.user_changePWD(session.getAttribute("active_user_id"), request.getParameter("r_pass"));
		}
	}
} catch (Exception e) { };	


try {
	if (request.getParameter("bt").equals("delete Profile")) {
		if (request.getParameter("pass").equals(request.getParameter("pass_control")))  {
			System.out.println("pass OK");
			if(dbConnect.passIsOk(dbConnect.getEmail(session.getAttribute("active_user_id")),request.getParameter("pass_control"))) {
				System.out.println("email & pass OK");
				if(request.getParameter("email").equals(dbConnect.getEmail(session.getAttribute("active_user_id")))) {
					System.out.println("check OK");	
					dbConnect.user_delete(session.getAttribute("active_user_id"));
				}
			}
		}

	}
} catch (Exception e) { };	
%>
	
<html>
  <head>
    <title>re:me</title>
      <meta http-equiv="Content-Type" content="text/html; CHARSET=UTF-8"/>
      <link rel="stylesheet" type="text/css" href="css/styles_main.css" />
      <script type="text/javascript">
		function switchMenu(obj) {
			var el = document.getElementById(obj);
			if( el.style.display != "none" ) {
		  		el.style.display = 'none';
			}
			else{
		  	el.style.display = 'block';
			}
		}
		function controlBox(link){
			Check = confirm("Wollen Sie dieses re:me wirklich entfernen?");
			if (Check)
				window.location.href=link;
		}
      </script>
  </head>
  <body id="main">
    <div id="page">
      <div id="header">
      <%
      rsUser= dbConnect.showUserinfo(session.getAttribute("active_user_id"));
      rsUser.next();
      %>
		<h1>re:me-Board von <%=rsUser.getString(3) %></h1>
		      <div id="navigation">
			    <ul>
				<li id="index"><a href="./">&Uuml;bersicht</a></li>
				<li id="group"><a href="groups.jsp">Meine Gruppen</a></li>
				<li id="account"><a href="konto.jsp">Konto</a></li>
				<li id="logout"><a href="login.jsp?logout=logout">Logout</a></li>
			    </ul>
		      </div> 
      </div>
	  <div id="page_konto">
	  <br>
	  <br>
	  <br>
	  <form id="changeName" name="changeName" method="post" action="konto.jsp" accept-charset="UTF-8">
	  	<h3>Name, Vorname &auml;ndern:</h3>
	  	<br>
		<table>
			<tr>
				<td><label for="nachname">Nachname:</label></td>
				<td><input type="text" name="nname" size="45" value="<%=rsUser.getString(2)%>" required /></td>
			</tr>
			<tr>
				<td><label for="vorname">Vorname:</label></td>
				<td><input type="text" name="vname" size="45" value="<%=rsUser.getString(3)%>" required /></td>
			</tr>
			<tr>
				<td></td>
				<td><input class="butKonto" type="submit" name="bt" value="save Changes" /></td>
			</tr>
		</table>				
	  </form>
		<br>
		<hr>
		<br>
	  <form id="changePWD" name="changePWD" method="post" action="konto.jsp" accept-charset="UTF-8">
	  	<h3>Passwort &auml;ndern:</h3>
	  	<br>
		<table>
			<tr>
				<td><label for="nachname">altes Passwort:</label></td>
				<td><input type="text" name="oldpass" size="45" value="" required /></td>
			</tr>
			<tr>
				<td><label for="pwd">neues Passwort:</label></td>
				<td><input type="password" name="r_pass" size="32" value="" required /></td>
			</tr>
			<tr>
				<td><label for="pwd">neues Passwort&nbsp;best&auml;tigen:</label></td>
				<td><input type="password" name="r_pass_control" size="32" value="" required /></td>
			</tr>
			<tr>
				<td></td>
				<td><input id="changePWDbuz" class="butKonto" type="submit" name="bt" value="change Password" /></td>
			</tr>
		</table>				
	  </form>
	  <br>
	  <hr>
	  <br>
	  <form id="delUser" name="changeName" method="post" action="konto.jsp" accept-charset="UTF-8">
	  	<h3>Dein Konto l&ouml;schen:</h3>
	  	<br>
		<table>
			<tr>
				<td><label for="nachname">E-Mail:</label></td>
				<td><input type="email" name="email" size="45" value="" required /></td>
			</tr>
			<tr>
				<td><label for="pwd">Passwort:</label></td>
				<td><input type="password" name="pass" size="32" value="" required /></td>
			</tr>
			<tr>
				<td><label for="pwd">Passwort&nbsp;best&auml;tigen:</label></td>
				<td><input type="password" name="pass_control" size="32" value="" required /></td>
			</tr>
			<tr>
				<td></td>
				<td><input class="butKonto" type="submit" name="bt" value="delete Profile" /></td>
			</tr>
		</table>				
	  </form>	
	</div>
	</div>
</body>
</html>




