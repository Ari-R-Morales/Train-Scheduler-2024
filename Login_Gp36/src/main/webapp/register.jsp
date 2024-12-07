<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Registration Page</title>
</head>
<body>
    <h2>Register</h2>
    <form method="POST" action="registerAction.jsp">
        <label for="firstName">First Name:</label>
        <input type="text" name="firstName" required><br>
        <label for="lastName">Last Name:</label>
        <input type="text" name="lastName" required><br>
        <label for="email">Email:</label>
        <input type="email" name="email" required><br>
        <label for="username">Username:</label>
        <input type="text" name="username" required><br>
        <label for="password">Password:</label>
        <input type="password" name="password" required><br>
        <button type="submit">Register</button>
    </form>

    <p>Already have an account? <a href="login.jsp">Log in here</a></p>
</body>
</html>
