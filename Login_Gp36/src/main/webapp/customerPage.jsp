<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Customer Dashboard</title>
</head>
<body>
    <h1>Welcome, <%= session.getAttribute("username") %>!</h1>
    <ul>
        <li><a href="browseSchedules.jsp">Browse Train Schedules</a></li>
        <li><a href="makeReservation.jsp">Make a Reservation</a></li>
        <li><a href="viewHistory.jsp">View Travel History</a></li>
    </ul>
    
    <Strong><a href="logout.jsp">Logout</a></Strong>
    
</body>
</html>
