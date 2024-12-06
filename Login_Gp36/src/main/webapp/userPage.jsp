<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <title>User Page</title>
</head>
<body>
    <%
        // Retrieve the existing session
        HttpSession currentSession = request.getSession(false); // false prevents creating a new session if none exists
        if (currentSession == null || currentSession.getAttribute("username") == null) {
            // No valid session or no username in session, redirect to login page
            response.sendRedirect("HelloWorld.jsp");
            return; // Ensure no further code is executed
        }

        // Retrieve username from session
        String username = (String) currentSession.getAttribute("username");
    %>
    <h1>Welcome, <%= username %>!</h1>
    <form method="post" action="HelloWorld.jsp">
        <button type="submit">Logout</button>
    </form>
</body>
</html>
