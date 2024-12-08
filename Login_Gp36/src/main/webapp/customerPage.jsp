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
        <li><a href="viewReservations.jsp">View and Manage Reservations</a></li>
        <li><a href="viewHistory.jsp">View Travel History</a></li>
        <li><a href="browseQuestions.jsp">Browse Questions and Answers</a></li>
        <li><a href="searchQuestions.jsp">Search Questions</a></li>
        <li><a href="askQuestion.jsp">Ask a Question</a></li>
    </ul>
    
    <strong><a href="logout.jsp">Logout</a></strong>
</body>
</html>
