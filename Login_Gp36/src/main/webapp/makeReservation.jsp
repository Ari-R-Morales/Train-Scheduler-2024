<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.io.*,java.sql.*,javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Make a Reservation</title>
</head>
<body>
    <h2>Make a Reservation</h2>

    <form method="POST" action="makeReservationAction.jsp">
        <label for="origin">Origin Station:</label>
        <input type="text" name="origin" value="<%= request.getParameter("origin") != null ? request.getParameter("origin") : "" %>" required><br>

        <label for="destination">Destination Station:</label>
        <input type="text" name="destination" value="<%= request.getParameter("destination") != null ? request.getParameter("destination") : "" %>" required><br>

        <label for="date">Travel Date:</label>
        <input type="date" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>" required><br>

        <label for="ticketType">Ticket Type:</label>
        <select name="ticketType" required>
            <option value="One-Way" <%= "One-Way".equals(request.getParameter("ticketType")) ? "selected" : "" %>>One-Way</option>
            <option value="Round-Trip" <%= "Round-Trip".equals(request.getParameter("ticketType")) ? "selected" : "" %>>Round-Trip</option>
        </select><br>

        <label for="discount">Discount:</label>
        <select name="discount" required>
            <option value="0" <%= "0".equals(request.getParameter("discount")) ? "selected" : "" %>>None</option>
            <option value="25" <%= "25".equals(request.getParameter("discount")) ? "selected" : "" %>>Child (25%)</option>
            <option value="35" <%= "35".equals(request.getParameter("discount")) ? "selected" : "" %>>Senior (35%)</option>
            <option value="50" <%= "50".equals(request.getParameter("discount")) ? "selected" : "" %>>Disabled (50%)</option>
        </select><br>

        <button type="submit">Reserve</button>
    </form>
</body>
</html>
