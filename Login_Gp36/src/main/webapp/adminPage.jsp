<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Admin Dashboard</title>
</head>
<body>
    <h1>Welcome, Admin</h1>
    <ul>
        <li><a href="manageReps.jsp">Manage Customer Representatives</a></li>
        <li><a href="salesReport.jsp">View Sales Reports</a></li>
        <li><a href="reservationsList.jsp">View Reservations by Transit Line or Customer Name</a></li>
        <li><a href="revenueReport.jsp">View Revenue by Transit Line or Customer Name</a></li>
        <li><a href="topCustomers.jsp">Best Customer</a></li>
        <li><a href="topTransitLines.jsp">Top 5 Most Active Transit Lines</a></li>
    </ul>
    
    <Strong><a href="logout.jsp">Logout</a></Strong>
</body>
</html>
