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
        <input type="text" name="origin" required><br>

        <label for="destination">Destination Station:</label>
        <input type="text" name="destination" required><br>

        <label for="date">Travel Date:</label>
        <input type="date" name="date" required><br>

        <label for="ticketType">Ticket Type:</label>
        <select name="ticketType" required>
            <option value="One-Way">One-Way</option>
            <option value="Round-Trip">Round-Trip</option>
        </select><br>

        <label for="discount">Discount:</label>
        <select name="discount">
            <option value="0">None</option>
            <option value="25">Child (25%)</option>
            <option value="35">Senior (35%)</option>
            <option value="50">Disabled (50%)</option>
        </select><br>

        <button type="submit">Reserve</button>
    </form>
</body>
</html>
