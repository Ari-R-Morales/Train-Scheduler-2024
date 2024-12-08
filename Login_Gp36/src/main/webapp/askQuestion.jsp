<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Ask a Question</title>
</head>
<body>
    <h2>Ask Customer Service</h2>

    <form method="POST" action="askQuestionAction.jsp">
        <label for="questionText">Your Question:</label><br>
        <textarea name="questionText" rows="5" cols="50" required></textarea><br><br>
        <button type="submit">Submit Question</button>
    </form>

    <p><a href="customerPage.jsp">Back to Dashboard</a></p>
</body>
</html>
