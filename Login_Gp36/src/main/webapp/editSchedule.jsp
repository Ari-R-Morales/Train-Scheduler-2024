<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Edit Schedule</title>
</head>
<body>
    <h2>Edit Train Schedule</h2>
    <form method="POST" action="editScheduleAction.jsp">
        <label for="scheduleId">Schedule ID:</label>
        <input type="text" name="scheduleId" required><br>

        <label for="fare">New Fare:</label>
        <input type="number" step="0.01" name="fare" required><br>

        <button type="submit">Update Schedule</button>
    </form>
</body>
</html>
