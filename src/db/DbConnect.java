package db;


import java.sql.*;
import java.util.Iterator;

public class DbConnect {

	Statement st;

	public DbConnect() {
		Connection conn=null;
		try {
				System.out.println("Conn null");
				Class.forName("org.postgresql.Driver");
				conn=DriverManager.getConnection("jdbc:postgresql://localhost/re_me?user=christianberclaz&password=darkness69"); 
				//conn=DriverManager.getConnection("jdbc:postgresql://srv-lab-t-985.zhaw.ch/re_me?user=postgres&password=reme15"); 
				System.out.println("Conn: " + conn);
				st = conn.createStatement();
			} 
			catch (Exception e) {

			} 
	}
	
	public Statement getStatement() {
		return st;
	}
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		showMyReMes
//  Funktion:	liefert die eigenen remes im resultset zurï¿½ck
//
//////////////////////////////////////////////////////////////////////////////////////////
	public ResultSet showMyReMes(Object uid) {
		ResultSet rs;
		try {
			rs = st.executeQuery("SELECT re_me.title, re_me.content, re_me.rid FROM re_me.re_me WHERE uid ='"+uid.toString()+"' ORDER BY rid ASC;");
		} catch (Exception e) {return null ;} 
		return rs;

	}
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		showOtherReMes
//  Funktion:	liefert die remes in denen man ï¿½ber eine Gruppe verlinkt wurde im resultset
//				exklusiv den remes die man als "unsichtbar" markiert hat	
//
//////////////////////////////////////////////////////////////////////////////////////////
	public ResultSet showOtherReMes(Object uid) {
		ResultSet rs;
		try {
			rs= st.executeQuery("SELECT DISTINCT re_me.title, re_me.content, re_me.rid, zugehoerig.gid, benutzergruppe.groupname " +
					"FROM re_me.re_me, re_me.gruppenzugehoerigkeit, re_me.zugehoerig, re_me.benutzergruppe, re_me.attrinhalt " +
					"WHERE re_me.rid=zugehoerig.rid AND zugehoerig.gid=gruppenzugehoerigkeit.gid AND zugehoerig.gid=benutzergruppe.gid AND gruppenzugehoerigkeit.uid="+uid.toString()+" " +
					"EXCEPT ALL (SELECT  DISTINCT re_me.title, re_me.content, re_me.rid, zugehoerig.gid, benutzergruppe.groupname " +
						"FROM re_me.re_me, re_me.gruppenzugehoerigkeit, re_me.zugehoerig, re_me.benutzergruppe, re_me.attrinhalt " +
						"WHERE attrinhalt.inhaltname='hide' AND attrinhalt.inhaltwert='"+uid.toString()+"' AND re_me.rid=zugehoerig.rid AND zugehoerig.gid=gruppenzugehoerigkeit.gid " +
						"AND zugehoerig.gid=benutzergruppe.gid AND gruppenzugehoerigkeit.uid='"+uid.toString()+"' AND attrinhalt.rid=re_me.rid) " +
					"ORDER BY groupname ASC"); 
			} catch (Exception e) {return null ;} 
		return rs;
	}
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		showGroups
//  Funktion:	liefert die eigenen gruppen mit Name und gid im resultset
//
//////////////////////////////////////////////////////////////////////////////////////////
	public ResultSet showGroups(Object uid) {
		ResultSet rs;
		try {
			rs = st.executeQuery("SELECT benutzergruppe.groupname, benutzergruppe.gid FROM re_me.benutzergruppe WHERE uid ='"+uid.toString()+"' ORDER BY groupname ASC;" );
		} catch (Exception e) {return null ;} 
		return rs;
	} 
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		showLinkedGroups
//  Funktion:	liefert die Gruppen in denen man verlinkt wurde
//
//////////////////////////////////////////////////////////////////////////////////////////
	public ResultSet showLinkedGroups(Object uid) {
		ResultSet rs;
		try {
			rs = st.executeQuery("SELECT DISTINCT benutzergruppe.groupname, benutzergruppe.gid FROM re_me.benutzergruppe, re_me.gruppenzugehoerigkeit WHERE benutzergruppe.gid=gruppenzugehoerigkeit.gid AND gruppenzugehoerigkeit.uid='"+uid.toString()+"' ORDER BY groupname ASC;" );
		} catch (Exception e) {return null ;} 
		return rs;
	}

/////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		showGroupUsers
//  Funktion:	Zeigt die Benutzer pro Benutzergruppe an	
// 	
//////////////////////////////////////////////////////////////////////////////////////////
	public ResultSet showGroupUsers (Object owneruid) {
		try {
			
			ResultSet rs = null;
				//System.out.println("Probiere showGroupUsers mit owner: "+owneruid);
				rs = st.executeQuery("SELECT gruppenzugehoerigkeit.gid, benutzergruppe.groupname, benutzer.vname, benutzer.nname  FROM re_me.gruppenzugehoerigkeit, re_me.benutzergruppe, re_me.benutzer WHERE gruppenzugehoerigkeit.owneruid = "+owneruid.toString()+" AND benutzergruppe.gid = gruppenzugehoerigkeit.gid  AND gruppenzugehoerigkeit.uid = benutzer.uid ORDER BY gid;");
				//System.out.println("Query showGroupUsers erfolgreich");	
			return rs;
		}  catch (Exception e) {} 
		return null;
	}
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		showUser
//  Funktion:	liefert alle angemelteten User mit Name/Vorname im resultset
//
//////////////////////////////////////////////////////////////////////////////////////////
	public ResultSet showUser() {
		ResultSet rs;
		try {
			rs = st.executeQuery("SELECT benutzer.uid, benutzer.nname, benutzer.vname, benutzer.email FROM re_me.benutzer ORDER BY nname ASC;");
		} catch (Exception e) {return null ;} 
		return rs;
	} 
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		showUserinfo
//  Funktion:	liefert alle informationen zum angemeldeten User
//
//////////////////////////////////////////////////////////////////////////////////////////
	public ResultSet showUserinfo(Object uid) {
		ResultSet rs;
		try {
			rs = st.executeQuery("SELECT benutzer.uid, benutzer.nname, benutzer.vname, benutzer.email FROM re_me.benutzer WHERE benutzer.uid='"+uid.toString()+"' ORDER BY nname ASC;");
		} catch (Exception e) {return null ;} 
		return rs;
	} 
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		insertReMe
//  Funktion:	erstellt ein neues Reme in der Datenbank und verlinkt es mit den allenfalls
//				gewï¿½hlten Usergroups
//
//////////////////////////////////////////////////////////////////////////////////////////
	public void insertReMe(Object uid, String title, String content, String[] grp) {
		int i=0;
		long rid=0;
		ResultSet rs;
		try {
			st.execute("INSERT INTO re_me.re_me (uid, title, content, createdate) VALUES ("+uid.toString()+", '"+title+"', '"+content+"', localtimestamp);", Statement.RETURN_GENERATED_KEYS);
			rs= st.getGeneratedKeys();
			rs.next();
			rid= rs.getLong(2);
			for(i=0;i<grp.length;i++) {
				st.execute("INSERT INTO re_me.zugehoerig(owneruid, gid, rid) VALUES ('"+uid.toString()+"', '"+Long.parseLong(grp[i])+"', '"+rid+"');");
			}
		} catch (Exception e) {} 
	}
	
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		insertGroup
//  Funktion:	erstellt eine neue persï¿½nliche Benutzergruppe und verlinkt diese
//				mit den ausgewï¿½hlten Benutzern
//
//////////////////////////////////////////////////////////////////////////////////////////
	public void insertGroup(Object uid, String groupname, String[] user) {
		int i=0;
		long gid=0;
		ResultSet rs;
		try {
			st.execute("INSERT INTO re_me.benutzergruppe (uid, groupname) VALUES ('"+uid.toString()+"', '"+groupname+"')", Statement.RETURN_GENERATED_KEYS);
			rs= st.getGeneratedKeys();
			rs.next();
			gid=rs.getLong(2);
			for(i=0;i<user.length;i++) {
				st.execute("INSERT INTO re_me.gruppenzugehoerigkeit(owneruid, gid, uid) VALUES ('"+uid.toString()+"', '"+gid+"' , '"+Long.parseLong(user[i])+"');");
			}
		} catch (Exception e) {} 
	}
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		updateReMe
//  Funktion:	Inhalt des remes wird upgedatet
//
//////////////////////////////////////////////////////////////////////////////////////////	
	public void updateReme(Object uid, long rid, String title, String content) {
		try {
			st.execute("UPDATE re_me.re_me SET title='"+title+"', content='"+content+"' WHERE rid='"+rid+"' AND uid='"+uid.toString()+"';");
		} catch (Exception e) {} 		
	}
	
/////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		updateGroup
//  Funktion:	Updated eine oder mehrere Benutzergruppen mit den ausgewÃ¤hlten Benutzern	
// 	
//////////////////////////////////////////////////////////////////////////////////////////
	public void updateGroup(Object owneruid, String[] gid, String[] uid) {
		
		ResultSet rs;
		try {
			//LÃ¶schvorgang
			for(int i=0;i<gid.length;i++) {
				for(int j=0; j<uid.length; j++) {
					System.out.println("LÃ¶schen: "+owneruid+"GID: "+gid[i]+" UID: "+ uid[j]);
					st.execute("DELETE FROM re_me.gruppenzugehoerigkeit WHERE owneruid ='"+owneruid.toString()+"' AND gid ='"+Integer.parseInt(gid[i])+"';");
				}
			}
			//EinfÃ¼gevorgang
			for(int i=0;i<gid.length;i++) {
				for(int j=0; j<uid.length; j++) {
					boolean status = st.execute("INSERT INTO re_me.gruppenzugehoerigkeit(owneruid, gid, uid) VALUES ('"+owneruid.toString()+"', '"+Integer.parseInt(gid[i])+"' , '"+Integer.parseInt(uid[j])+"');");
					System.out.println("EinfÃ¼gen: "+owneruid+"GID: "+gid[i]+" UID: "+ uid[j]+" Status: "+ status);
			
				}
			}
		} catch (Exception e) {} 
	}	
		
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		deleteReMe
//  Funktion:	lšscht das gewŠhlt reme:
//				ersteller:			reme und alle querverweise werden aus der Datenbank entfernt
//				verlinkter user:	neuer eintrag in der DB, um reme fŸr den user "unsichtbar" zu machen
//////////////////////////////////////////////////////////////////////////////////////////
	public void deleteReMe(Object uid, long rid) {
		ResultSet rs;
		long tempRuid;
		try {
			rs= st.executeQuery("SELECT re_me.uid FROM re_me.re_me WHERE rid='"+rid+"';");
			rs.next();
			tempRuid=rs.getLong(1);
			System.out.println("Temp rUid: "+tempRuid);
			if(tempRuid==Long.parseLong(uid.toString())) {
				// reme aus der db lï¿½schen
				st.execute("DELETE FROM re_me.zugehoerig WHERE rid="+rid+" AND owneruid='"+uid.toString()+"';");
				st.execute("DELETE FROM re_me.attrinhalt WHERE rid="+rid+" AND uid='"+uid.toString()+"';");
				st.execute("DELETE FROM re_me.re_me WHERE rid='"+rid+"' AND uid='"+uid.toString()+"';");
			} else {
				// reme fï¿½r den entsprechenden user unsichtbar machen, jedoch nicht aus der DB lï¿½schen
				st.execute("INSERT INTO re_me.attrinhalt(uid, rid, inhaltname, inhaltwert) VALUES ('"+tempRuid+"', '"+rid+"', 'hide', '"+uid.toString()+"' );");
				
			}
		} catch (Exception e) {} 
	}

//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		deleteGroup
//  Funktion:	lšsch die gewŠhlte gruppe mit allen querverweisen aus der DB
//
//////////////////////////////////////////////////////////////////////////////////////////
	public void deleteGroup(Object uid, long gid)
	{
		try {
			st.execute("DELETE FROM re_me.gruppenzugehoerigkeit WHERE gid = "+gid+" AND owneruid='"+uid.toString()+"';");
			st.execute("DELETE FROM re_me.zugehoerig WHERE owneruid ='"+uid.toString()+"' AND gid = "+gid+";");
			st.execute("DELETE FROM re_me.benutzergruppe WHERE uid ='"+uid.toString()+"' AND gid = "+gid+";");
		} catch (Exception e){}
	}

//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		deleteLinkedGroup
//  Funktion:	entfernt User aus der gewŸnschten verlinkten gruppe
//	Fazit:		alle reme dieser Gruppe sind fŸr den User nicht mehr sichtbar
//////////////////////////////////////////////////////////////////////////////////////////	
	public void deleteLinkedGroup(Object uid, long gid)
	{
		try {
			st.execute("DELETE FROM re_me.gruppenzugehoerigkeit WHERE gid = "+gid+" AND uid='"+uid.toString()+"';");
		} catch (Exception e){}
	}	
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		createUser
//  Funktion:	erstellt in der DB einen neuen User mit allen angaben (name, vorname, mail, pwd)
//
//////////////////////////////////////////////////////////////////////////////////////////
	public long createUser(String vname, String nname, String email,String email_control, String pass, String pass_control) {
		ResultSet rs;
		if( !(email.equals(email_control) && pass.equals(pass_control)) ) return -2;
			try {
				st.execute("INSERT INTO re_me.benutzer (vname, nname, email,pwdhash) VALUES ('"+vname.toString()+"', '"+nname+"', '"+email+"', md5('"+pass+"'));", Statement.RETURN_GENERATED_KEYS);
				rs = st.getGeneratedKeys();
				rs.next();			
				return rs.getLong(1);
			} catch (Exception e) { }
			
		return -1;
	}	

//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		getUID
//  Funktion:	liefert die Uid eines Users anhand der Eingegebenen Email
//
//////////////////////////////////////////////////////////////////////////////////////////	
	public long getUID(Object email) {
		ResultSet rs;
		try {
			rs = st.executeQuery("SELECT re_me.benutzer.uid FROM re_me.benutzer WHERE benutzer.email='"+email.toString()+"';");
			rs.next();
			System.out.println("getuid"+rs.getLong(1));
			return rs.getLong(1);
		} catch (Exception e) { return 0; }
	}
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		getEmail
//  Funktion:	liefert die email adresse des angemeldeten Users
//
//////////////////////////////////////////////////////////////////////////////////////////
	public String getEmail(Object uid) {
		ResultSet rs;
		try {
			rs = st.executeQuery("SELECT benutzer.email FROM re_me.benutzer WHERE benutzer.uid='"+uid.toString()+"';");
			rs.next();
			System.out.println("getuEMail: "+rs.getString(1));
			return rs.getString(1);
		} catch (Exception e) { return ""; }
	}	

//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		user_changeName
//  Funktion:	Šndert name und vorname des angemeldeten Users
//
//////////////////////////////////////////////////////////////////////////////////////////	
	public void user_changeName(Object uid, String vname, String nname) {
		try {
			st.execute("UPDATE re_me.benutzer SET vname='"+vname+"', nname='"+nname+"' WHERE uid='"+uid.toString()+"';");
		} catch (Exception e) {} 
	}
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		user_changePWD
//  Funktion:	Šndert das passwort des angemeldeten Users (md5 Kodierung)
//
//////////////////////////////////////////////////////////////////////////////////////////
	public void user_changePWD(Object uid, String pass) {
		try {
			st.execute("UPDATE re_me.benutzer SET pwdhash=md5('"+pass+"') WHERE uid='"+uid.toString()+"';");
		} catch (Exception e) {} 
	}
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		user_delete
//  Funktion:	Lšscht den angemeldeten User inkl. sŠmtlichen erstellte benutzergruppen,
//				remes und querverweien aus der DB
//
//////////////////////////////////////////////////////////////////////////////////////////
	public void user_delete(Object uid) {
		try {
			st.execute("DELETE FROM re_me.gruppenzugehoerigkeit WHERE owneruid='"+uid.toString()+"';");				
			st.execute("DELETE FROM re_me.gruppenzugehoerigkeit WHERE uid='"+uid.toString()+"';");
			st.execute("DELETE FROM re_me.zugehoerig WHERE owneruid ='"+uid.toString()+"';");
			st.execute("DELETE FROM re_me.benutzergruppe WHERE uid ='"+uid.toString()+"';");
			st.execute("DELETE FROM re_me.attrinhalt WHERE uid ='"+uid.toString()+"';");
			st.execute("DELETE FROM re_me.re_me WHERE uid ='"+uid.toString()+"';");
			st.execute("DELETE FROM re_me.benutzer WHERE uid ='"+uid.toString()+"';");
		} catch (Exception e) {}
	}

//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		passIsOk
//  Funktion:	prŸft anhand von email und pwd ob die Eingabe richtig war
//			
//////////////////////////////////////////////////////////////////////////////////////////	
	public boolean passIsOk(String email, String pass) {
		ResultSet rs;
		try {
			rs = st.executeQuery("SELECT  count(*) FROM re_me.benutzer WHERE benutzer.email='"+email.toString()+"' AND benutzer.pwdhash=md5('"+pass.toString()+"');");
			rs.next();			
			System.out.println("passreslts: "+rs.getLong(1));
			return rs.getLong(1)==1;
		} catch (Exception e) { 		return false; }
	}		
	
//////////////////////////////////////////////////////////////////////////////////////////
//	Name: 		test
//  Funktion:	Dies ist eine Testfunktion um den Input von Feldern mit Returntype String 
//				zu Ã¼berprÃ¼fen.
//////////////////////////////////////////////////////////////////////////////////////////
	public void test(String[] a, String[] b)
	{
		try {
			for (int i = 0; i < a.length; i++)
			{
				System.out.println("Wert a: "+a[i]);
			}
			for (int j = 0; j < b.length; j++)
			{
				System.out.println("Wert b: "+b[j]);
			}
		} catch (Exception e) {  }
	}
		
}