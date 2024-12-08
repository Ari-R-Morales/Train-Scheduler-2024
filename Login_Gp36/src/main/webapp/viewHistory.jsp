<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Reservation History</title>
</head>
<body>
    <h2>Your Reservation History</h2>
    <%
        session = request.getSession(false);
        if (session == null || session.getAttribute("customer_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int customerId = (Integer) session.getAttribute("customer_id");

        try {
            // Establish database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // Fetch current reservations (upcoming or ongoing)
            String sqlCurrent = "SELECT reservation_id, reservation_date, total_fare, ticket_type, discount_type, " +
                                "s1.station_name AS origin, s2.station_name AS destination, ts.departure_datetime, ts.arrival_datetime " +
                                "FROM Reservations r " +
                                "JOIN Stations s1 ON r.origin_station_id = s1.station_id " +
                                "JOIN Stations s2 ON r.destination_station_id = s2.station_id " +
                                "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                                "WHERE r.customer_id = ? AND ts.departure_datetime >= NOW() " +
                                "ORDER BY ts.departure_datetime ASC";
            PreparedStatement pstmtCurrent = con.prepareStatement(sqlCurrent);
            pstmtCurrent.setInt(1, customerId);

            ResultSet rsCurrent = pstmtCurrent.executeQuery();

            out.println("<h3>Current Reservations</h3>");
            if (!rsCurrent.isBeforeFirst()) {
                out.println("<p>No current reservations.</p>");
            } else {
                out.println("<table border='1'>");
                out.println("<tr><th>Reservation ID</th><th>Origin</th><th>Destination</th><th>Departure</th><th>Arrival</th>" +
                            "<th>Fare</th><th>Ticket Type</th><th>Discount</th></tr>");
                while (rsCurrent.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rsCurrent.getInt("reservation_id") + "</td>");
                    out.println("<td>" + rsCurrent.getString("origin") + "</td>");
                    out.println("<td>" + rsCurrent.getString("destination") + "</td>");
                    out.println("<td>" + rsCurrent.getTimestamp("departure_datetime") + "</td>");
                    out.println("<td>" + rsCurrent.getTimestamp("arrival_datetime") + "</td>");
                    out.println("<td>$" + rsCurrent.getDouble("total_fare") + "</td>");
                    out.println("<td>" + rsCurrent.getString("ticket_type") + "</td>");
                    out.println("<td>" + rsCurrent.getString("discount_type") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            rsCurrent.close();
            pstmtCurrent.close();

            // Fetch past reservations (completed)
            String sqlPast = "SELECT reservation_id, reservation_date, total_fare, ticket_type, discount_type, " +
                             "s1.station_name AS origin, s2.station_name AS destination, ts.departure_datetime, ts.arrival_datetime " +
                             "FROM Reservations r " +
                             "JOIN Stations s1 ON r.origin_station_id = s1.station_id " +
                             "JOIN Stations s2 ON r.destination_station_id = s2.station_id " +
                             "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                             "WHERE r.customer_id = ? AND ts.departure_datetime < NOW() " +
                             "ORDER BY ts.departure_datetime DESC";
            PreparedStatement pstmtPast = con.prepareStatement(sqlPast);
            pstmtPast.setInt(1, customerId);

            ResultSet rsPast = pstmtPast.executeQuery();

            out.println("<h3>Past Reservations</h3>");
            if (!rsPast.isBeforeFirst()) {
                out.println("<p>No past reservations.</p>");
            } else {
                out.println("<table border='1'>");
                out.println("<tr><th>Reservation ID</th><th>Origin</th><th>Destination</th><th>Departure</th><th>Arrival</th>" +
                            "<th>Fare</th><th>Ticket Type</th><th>Discount</th></tr>");
                while (rsPast.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rsPast.getInt("reservation_id") + "</td>");
                    out.println("<td>" + rsPast.getString("origin") + "</td>");
                    out.println("<td>" + rsPast.getString("destination") + "</td>");
                    out.println("<td>" + rsPast.getTimestamp("departure_datetime") + "</td>");
                    out.println("<td>" + rsPast.getTimestamp("arrival_datetime") + "</td>");
                    out.println("<td>$" + rsPast.getDouble("total_fare") + "</td>");
                    out.println("<td>" + rsPast.getString("ticket_type") + "</td>");
                    out.println("<td>" + rsPast.getString("discount_type") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            rsPast.close();
            pstmtPast.close();

            db.closeConnection(con);

        } catch (Exception e) {
            out.println("<p>Error retrieving reservations: " + e.getMessage() + "</p>");
        }
    %>
    <p><a href="customerPage.jsp">Back to Dashboard</a></p>
</body>
</html>