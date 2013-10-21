<%@ page language="java" contentType="text/html; CHARSET=UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page errorPage="login.jsp"%>
<jsp:useBean id="dbConnect" class="db.DbConnect" scope="session" />
<jsp:setProperty property="*" name="dbConnect"/>


<%
request.setCharacterEncoding("UTF-8");//Setzen der Codierung in JSP

Statement st;
ResultSet rs;
ResultSet rsGroups, rsUser;
long groupid=0;
String groupName="";

%>

<%  

// login oder raus

if(session.getAttribute("active_user_id")==null) response.sendRedirect("./login.jsp");


//--kommando von Seitenaufruf zuerst ausf�hren --
try {
	if(request.getParameter("formtyp").contains("createReme")) {
		String[] grp= request.getParameterValues("group-search");
		dbConnect.insertReMe(session.getAttribute("active_user_id"),request.getParameter("remetitle"),request.getParameter("remecontent"), grp);
	}
} catch(Exception e) {}

try {
	if(request.getParameter("formtyp").contains("createGroup")) {
		String[] user= request.getParameterValues("user-search");
		dbConnect.insertGroup(session.getAttribute("active_user_id"),request.getParameter("groupname"), user);
		
	}
} catch(Exception e) {}

try {
	if(request.getParameter("formtyp").contains("editReme")) {
		dbConnect.updateReme(session.getAttribute("active_user_id"), Long.valueOf(request.getParameter("rid")), request.getParameter("titleEdit"), request.getParameter("contentEdit"));
	}	
} catch(Exception e) {}

try {
	if(!request.getParameter("delReme").isEmpty()) {
		dbConnect.deleteReMe(session.getAttribute("active_user_id"), Long.valueOf(request.getParameter("delReme")));
	}
} catch(Exception e) {}

try {
	if(!request.getParameter("delGroup").isEmpty()) {
		dbConnect.deleteGroup(session.getAttribute("active_user_id"), Long.valueOf(request.getParameter("delGroup")));
	}
} catch(Exception e) {}

try {
	if(!request.getParameter("delLinkedGroup").isEmpty()) {
		dbConnect.deleteLinkedGroup(session.getAttribute("active_user_id"), Long.valueOf(request.getParameter("delLinkedGroup")));
	}
} catch(Exception e) {}

%>
<%-- Seite zusammensetzen --%>

<!DOCTYPE HTML>
<html>
  <head>
    <title>re:me-Board</title>
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

	  <div id="controll">
		<div id="newItems">
			<div onclick="switchMenu('reme_new');"><img id="newReme" src="img/noteNew.png" border="0"  alt="NEW Reme" /></div>
			<div onclick="switchMenu('groups_new');"><img id="newGroup" src="img/newGroup.png" border="0"  alt="NEW Group" /></div>
			
		</div>
	  	<div id="listedGroups">
	  		<hr>
	  		<p class="title_small_w">Linked Groups:</p>
	  		<% rsGroups = dbConnect.showLinkedGroups(session.getAttribute("active_user_id"));
			while (rsGroups.next()) {
			%>
			<a class="del" href="./?delLinkedGroup=<%=rsGroups.getString(2)%>"><img src="img/b_drop.png" border="0"  alt="Delete" width="16" heigh="16" /></a>
			<a href="#G<%=rsGroups.getString(2)%>"><%=rsGroups.getString(1)%></a>
			<br>
			<%}%>
		</div>
	  </div>	
      <div id="page_content">
		<div id="remes">
		<ul>
		  <li>		
		  <p class="title_small_w">deine re:mes</p>
	 	    <% rs = dbConnect.showMyReMes(session.getAttribute("active_user_id"));
			   while (rs.next()) {
				   
		    %>
		    	<div class="reme">
					<div>
				    <p class="title_reme"><%=rs.getString(1) %></p>
				    <a class="del" onclick="controlBox('./?delReme=<%=rs.getString(3)%>');"><img src="img/b_drop.png" border="0"  alt="Delete" /></a>
				    <p class="edit" onclick="switchMenu('remeEditField_<%=rs.getString(3)%>');"><img src="img/b_edit.png" border="0"  alt="Edit" /></p>
				    <p class="content"><%=rs.getString(2) %></p>		    	
					</div>
			    	<form id="remeEditField_<%=rs.getString(3)%>" class="remeEditField" method="post" action="." style="display:none;" accept-charset="utf-8">
						<div>
							<input type="text" class="titleEdit" name="titleEdit" value="<%=rs.getString(1) %>"/>
						</div>
						<div>
							<textarea class="contentEdit"  name="contentEdit" cols="20" rows="5" maxlength="160" onkeyup="document.getElementById('charsleft_<%=rs.getString(3)%>').innerHTML = 160 - this.value.length"><%=rs.getString(2) %></textarea>
							<p id="charsleft_<%=rs.getString(3)%>">160</p>
							<input type="hidden" id="formtyp" value="editReme" name="formtyp"/>
							<input type="hidden" id="formtyp" value="<%=rs.getString(3)%>" name="rid"/>
		      				<input class="but_reme" type="submit" value="re:me speichern"/>
						</div>
					</form>	    
			    </div>
			<%}%>
		  <% 
		  System.out.println("active user ID: " + session.getAttribute("active_user_id"));
		  rs = dbConnect.showOtherReMes(session.getAttribute("active_user_id"));
			   while (rs.next()) {
				   System.out.println("groupRemeID: " + rs.getLong(4));
					if(groupid!= rs.getLong(4)) {
					groupid=rs.getLong(4);
					groupName=rs.getString(5);
					%></li><br />
					  <li>
					  <p class="title_small_w" id="G<%=groupid%>" ><%=groupName %></p>
					<%
					}
		    		%>
		    		<div class="reme">
						<div>
					    <p class="title_reme"><%=rs.getString(1) %></p>
					    <a class="del" onclick="controlBox('./?delReme=<%=rs.getString(3)%>');"><img src="img/b_drop.png" border="0"  alt="Delete" /></a>
					    <p class="content"><%=rs.getString(2) %></p>		    	
						</div>
	    
			    	</div>
			<%}
			%>
		  </li>		
		</ul>	
		</div>
      </div>
    </div>
	<div id="reme_new" style="display:none;">
		<div id="reme_new_background" onclick="switchMenu('reme_new');">
		</div>
		<div id="reme_input" >	  
		  <form id="remeForm" method="post" action="." accept-charset="UTF-8">
		  	<p class="title_small">Neues re:me erstellen:</p>
		  	<input type="text" id="remetitle" placeholder="re:me Titel" name="remetitle"/>
		  	<textarea id="remecontent" name="remecontent" cols="27" rows="8" maxlength="160"></textarea>
		  	<hr>
		  	<br>
		  	<p class=" title_small">Add to Group?</p>
		  	<select name="group-search" size="4" multiple>
		  		<% rsGroups= dbConnect.showGroups(session.getAttribute("active_user_id"));
				while (rsGroups.next()) {
				%>
				<option value="<%=rsGroups.getString(2)%>"><%=rsGroups.getString(1) %></option>
				<%}%>
		  	</select>
		  	<p> </p>
			<input class="but_board" type="submit" value="create re:me"/>
		  <input type="hidden" id="formtyp" value="createReme" name="formtyp"/>
		</form>
		</div>
	</div>
	<div id="groups_new" style="display:none;">
		<div id="groups_new_background" onclick="switchMenu('groups_new');">
		</div>
		<div id="user_input">
		    <form id="groupForm" method="post" action="." accept-charset="UTF-8">		    
			    <p class="title_small">Benutzergruppe erstellen:</p>
			    <p><input type="text" id="groupname" placeholder="Gruppenname" name="groupname"></p>
			    <br>
				<p class="text">W&auml;hle die Benutzer, welche die neue Gruppe sehen d&uuml;rfen:</p>
				<div id="selection-lists">
		  			<select name="user-search" size="4" multiple>
		  			<% rsUser= dbConnect.showUser();
						while (rsUser.next()) {
						%>
						<option value="<%=rsUser.getString(1) %>"><%=rsUser.getString(4) %>
						</option>
					<%}%>
		  			</select>
				</div>
				<input class="but_board"  type="submit" value="Gruppe erstellen"/>
				<input type="hidden" id="formtyp" value="createGroup" name="formtyp"/>
		    </form>
		</div>
<%-- 	<div id="groups">
      	  	<p class="title_small">Gruppen:</p>
      	  	<hr>
	  		<br>
			<% rsGroups = dbConnect.showGroups(session.getAttribute("active_user_id"));
			while (rsGroups.next()) {
			%>
			<a class="del" href="./?delGroup=<%=rsGroups.getString(2)%>"><img src="img/b_drop.png" border="0"  alt="Delete" /></a>
			<%=rsGroups.getString(1) %>
		    <br>
			<%}%>
	  </div> --%>
    </div> 
  </body>
</html>





