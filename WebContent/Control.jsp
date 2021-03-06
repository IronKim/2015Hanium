<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*, java.util.*" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="http://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<title>Shome 컨트롤러</title>

<style type="text/css">
	.wrap {
		width: 100%;
		height: 120%;
		position: relative;
		<!-- background-color: blue; -->
	}
	.wrap_left{
		width: 50%;
	}
	.wrap_right{
		width: 50%;
	}
	.margin-center {
		margin: 0 auto;
		width: 53%;	
	}
</style>
</head>


<%
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	//String id = (String)request.getAttribute("id");
	String id = (String)session.getAttribute("id");
	String light_state = "";
	String fan_state = "";
	String light_IP = (String)session.getAttribute("light_IP");
	String fan_IP = (String)session.getAttribute("fan_IP");
	int counter = 0;
	try
	{
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Shome",
				"root","Shome");
		stmt = conn.createStatement();
		rs = stmt.executeQuery("SELECT * FROM light;");
%>



<body>
	<nav class="navbar navbar-default"><!--메뉴관련 더 있음-->
  		<div class="navbar-header">
    		<button class="navbar-toggle" data-toggle="collapse" data-target=".target"><!--모바일일경우-->
    			<span class="icon-bar"></span>
    			<span class="icon-bar"></span>
    			<span class="icon-bar"></span>
    		</button>
    		<a class="navbar-brand" href="#">Shome</a>
   		</div>
 		<div class="collapse navbar-collapse target"><!--숨겨지는부분-->
    		<ul class="nav navbar-nav">
     			<li class="active"><a href="#">리모콘</a></li>
     			<li><a href="Statistics.jsp">통계</a></li>
    		</ul>
    		<ul class="nav navbar-nav navbar-right">
     			<li><a href="ProfileFix.jsp"><%=id %></a></li>
            	<li><a href="Logout.jsp">로그아웃</a></li>
    		</ul>
		</div>
  	</nav>



<%
		rs.next();
		light_state = rs.getString("state");
		if(light_state.equals("Y"))
		{
%>
			<iframe name="arduino" src="http://<%=light_IP %>/ON1" style="display: none;" width = "0" height= "0"></iframe>
<% 
		}
		else
		{
%>
			<iframe name="arduino" src="http://<%=light_IP %>/OFF1" style="display: none;" width = "0" height= "0"></iframe>
<%
		}
		rs = stmt.executeQuery("SELECT * FROM fan;");
		rs.next();
		fan_state = rs.getString("state");
		if(fan_state.equals("Y"))
		{
%>
			<iframe name="arduino" src="http://<%=fan_IP %>/ON2" style="display: none;" width = "0" height= "0"></iframe>
<% 
		}
		else
		{
%>
			<iframe name="arduino" src="http://<%=fan_IP %>/OFF2" style="display: none;" width = "0" height= "0"></iframe>
<%
		}
	}
	catch(SQLException e)
	{
%>
		SQLException!
<%
	}
	catch(Exception e)
	{
%>
		Exception!
<%
	}
	finally
	{
		if(rs!=null)
		{
			try
			{
				rs.close();
			}
			catch(SQLException e)
			{
			}
		}
		if(stmt != null)
		{
			try
			{
				stmt.close();
			}
			catch(SQLException e)
			{
			}
			if(conn != null)
			{
				try
				{
					conn.close();
				}
				catch(Exception e)
				{
				}
			}
		}
	}
%>


<div class="wrap">
	<form method=post action="LightChange.jsp">
<%
		if(light_state.equals("Y"))
		{
%>
			<input type="hidden" name="state" value="<%=light_state%>">
			<center><input  TYPE="IMAGE" src="light_on.jpg" name="Submit" value="Submit"  align="absmiddle"></center>

<%
		}
		else
		{
%>
			<input type="hidden" name="state" value="<%=light_state%>">		
			<center><input  TYPE="IMAGE" src="light_off.jpg" name="Submit" value="Submit"  align="middle"></center>

<%
		}
%>
	</form>
		<form method=post action="FanChange.jsp">
<%
		if(fan_state.equals("Y"))
		{
%>
			<input type="hidden" name="state" value="<%=fan_state%>">		
			<center><input  TYPE="IMAGE" src="fan_on.jpg" name="Submit" value="Submit"  align="middle"></center>

<%
		}
		else
		{
%>
			<input type="hidden" name="state" value="<%=fan_state%>">			
			<center><input  TYPE="IMAGE" src="fan_off.jpg" name="Submit" value="Submit"  align="middle"></center>

<%
		}
%>
	</form>
</div>
</body>
</html>