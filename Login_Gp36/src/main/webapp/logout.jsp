<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
</head>
<body>
    <%
        if (session != null) {
            session.invalidate(); // End the session
        }
    %>
    <p>You have been successfully logged out.</p>
    <p><a href="login.jsp">Go to Login Page</a></p>
</body>
</html>
