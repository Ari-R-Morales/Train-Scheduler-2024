<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Send Question</title>
</head>
<body>
    <h2>Send a Question</h2>
    <form method="POST" action="sendQuestionAction.jsp">
        <label for="questionText">Your Question:</label><br>
        <textarea name="questionText" rows="5" cols="50" required></textarea><br>
        <button type="submit">Submit</button>
    </form>
</body>
</html>
