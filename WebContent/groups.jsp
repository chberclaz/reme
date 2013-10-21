<%@page import="com.sun.corba.se.spi.orbutil.fsm.Action"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.Out"%>
<%@ page language="java" contentType="text/html; CHARSET=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %> 

<jsp:useBean id="dbConnect" class="db.DbConnect" scope="session" />
<jsp:setProperty property="*" name="dbConnect"/>


<%! 
Statement st;
ResultSet rs;
ResultSet rsGroups, rsUser, rsGroupUsers, rsUserInfo; 
%>


<%  

// login oder raus
if(session.getAttribute("active_user_id")==null) response.sendRedirect("./login.jsp");


//--kommando von Seitenaufruf zuerst ausführen --
try {
	if(request.getParameter("formtyp").contains("assignGroup")) {
		
		String[] groups = request.getParameterValues("checkbox_group");
		String[] users  = request.getParameterValues("checkbox_user");
		//String userid = (String)session.getAttribute("active_user_id");
		//dbConnect.test(groups, users);
		dbConnect.updateGroup(session.getAttribute("active_user_id"), groups, users);
		//dbConnect.insertGroup(session.getAttribute("active_user_id"),request.getParameter("groupname"), user);
		//long owner = Long.session.getAttribute("active_user_id");
		//long group = Long.parseLong(rsGroups.getString(1));
		//long user = Long.parseLong(rsUser.getString(1));
		//dbConnect.assignUserToGroup(owner,group,user);
	}
} catch(Exception e) {}





%>
<%-- Seite zusammensetzen --%>

<!DOCTYPE HTML>
<html>
  <head>
    <title>re:me</title>
<!--       <meta http-equiv="Content-Type" content="text/html; CHARSET=UTF-8"/> -->
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
      </script>
  </head>
  <body id="main">
	  <%
      rsUser= dbConnect.showUserinfo(session.getAttribute("active_user_id"));
      rsUser.next();
      %>
      <div id="header">
		<h1>re:me-Board von <%=rsUser.getString(3) %></h1>
      </div>
      <div id="navigation">
	    <ul>
			<li id="index"><a href="./">&Uuml;bersicht</a></li>
			<li id="group"><a href="groups.jsp">Meine Gruppen</a></li>
			<li id="account"><a href="konto.jsp">Konto</a></li>
			<li id="logout"><a href="login.jsp?logout=logout">Logout</a></li>
	    </ul>
      </div> 
    <div id="page_content_gruppen">
    	<h2>Gruppeneinstellungen / Berechtigungen</h2>
		<br>
		<br>
	<div id="GroupUsers">
		<br>
			<%
			rsGroups= dbConnect.showGroups(session.getAttribute("active_user_id"));		
				//String uid = rsGroups.getString(1);
				rsGroupUsers = dbConnect.showGroupUsers(session.getAttribute("active_user_id"));
				String previous = "something";
				boolean first = true;
					while (rsGroupUsers.next()) {
						%>
						<%if (previous.compareTo(rsGroupUsers.getString(1)) != 0)
						{
							if (!first)
							{
								first = false;
							}%>
						
						<table border="0" width="250" class="remeEditTable">
						 <tr>
						    <td><p class="title_small_w"><%=rsGroupUsers.getString(2) %></p></td>
						  </tr>
						<%  }%>
						  <tr>
						    <td><p class="text_w"><%=rsGroupUsers.getString(3) %>&nbsp;<%=rsGroupUsers.getString(4) %></p></td>
						  </tr>
						
					<%	
					previous = rsGroupUsers.getString(1);	
					%>
					
					<%
					}
					%>
					</table>
			<br />
	</div>
	<div id="editGroups">	  
	<!--Hier kann einer Gruppe ein User Zugewiesen werden -->
		<p class="text">Zu mutierende Gruppen:</p>
		<br/>
		<br/>
		<form id="groupassign" name="groupassign" method="post" action="./groups.jsp"  accept-charset="UTF-8">
			<!--Anzeigen aller verfügbaren Gruppen-->
			<%
			rsGroups= dbConnect.showGroups(session.getAttribute("active_user_id"));
			while (rsGroups.next()) {
			%>
				<input type="checkbox" name="checkbox_group" value="<%=rsGroups.getString(2)%>" /><%=rsGroups.getString(1) %><br />
				
			<%
			}
			%>
			<br />
			<hr>
			<br />
			<!--Anzeigen aller verfügbaren User-->
			<p class="text">Diese Benutzer sind für die gewählten Gruppen berechtigt:</p>
			<br />
			<% 
			rsUser= dbConnect.showUser();
			while (rsUser.next()) {
			%>
				<input type="checkbox" name="checkbox_user" value="<%=rsUser.getString(1) %>" /><%=rsUser.getString(2) %> <%=rsUser.getString(3) %>&nbsp;(<%=rsUser.getString(4) %>)<br />
				
			<%
			}
			%>
			<input type="hidden" id="formtyp" value="assignGroup" name="formtyp"/>
			<input class="but_board" type="submit" value="Submit" />
		</form>
	</div>	
 </div> <!--re:me_edit-->

  </body>
</html>









