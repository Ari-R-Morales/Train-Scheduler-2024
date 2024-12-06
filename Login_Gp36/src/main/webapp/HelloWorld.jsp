<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Train Scheduler Group 36</title>
</head>
<body>
	<main>
		<h1>Welcome to SpeedySchedule!</h1>
		<h3>Subtitle</h3>
			<form method="post" action="newLogin.jsp">
				    <h4> Login</h4>
   				 <label id="username-label" for="username">Username</label>
    			<input class="text-box" id="username" name="username" type="text" required placeholder="john.smith" />
    			<label id="password-label" for="password">Password</label>
    			<input class="text-box" id="password" name="password" type="password" required placeholder="password123" />
    			<button class="submit" id="submit">Submit</button>
			</form>
	</main>
</body>
</html>