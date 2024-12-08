<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>View Schedules by Station</title>
</head>
<body>
    <h2>View Train Schedules by Station</h2>
    <form method="GET" action="viewSchedules.jsp">
        <label for="stationName">Station Name:</label>
        <input type="text" name="stationName" value="<%= request.getParameter("stationName") != null ? request.getParameter("stationName") : "" %>" required><br>
        <button type="submit">Search</button>
    </form>
    <%
        String stationName = request.getParameter("stationName");

        if (stationName != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                // Query for schedules where the station is the origin
                String sqlOrigin = "SELECT ts.schedule_id, ts.transit_line_name, ts.departure_datetime, ts.arrival_datetime, ts.fare " +
                                   "FROM Train_Schedules ts " +
                                   "JOIN Stations s ON ts.origin_station_id = s.station_id " +
                                   "WHERE s.station_name = ?";
                PreparedStatement pstmtOrigin = con.prepareStatement(sqlOrigin);
                pstmtOrigin.setString(1, stationName);

                ResultSet rsOrigin = pstmtOrigin.executeQuery();

                out.println("<h3>Schedules Where '" + stationName + "' is the Origin</h3>");
                if (!rsOrigin.isBeforeFirst()) {
                    out.println("<p>No schedules found where the station is the origin.</p>");
                } else {
                    out.println("<table border='1'><tr><th>ID</th><th>Transit Line</th><th>Departure</th><th>Arrival</th><th>Fare</th></tr>");
                    while (rsOrigin.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rsOrigin.getInt("schedule_id") + "</td>");
                        out.println("<td>" + rsOrigin.getString("transit_line_name") + "</td>");
                        out.println("<td>" + rsOrigin.getTimestamp("departure_datetime") + "</td>");
                        out.println("<td>" + rsOrigin.getTimestamp("arrival_datetime") + "</td>");
                        out.println("<td>$" + rsOrigin.getDouble("fare") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }
                rsOrigin.close();
                pstmtOrigin.close();

                // Query for schedules where the station is the destination
                String sqlDestination = "SELECT ts.schedule_id, ts.transit_line_name, ts.departure_datetime, ts.arrival_datetime, ts.fare " +
                                        "FROM Train_Schedules ts " +
                                        "JOIN Stations s ON ts.destination_station_id = s.station_id " +
                                        "WHERE s.station_name = ?";
                PreparedStatement pstmtDestination = con.prepareStatement(sqlDestination);
                pstmtDestination.setString(1, stationName);

                ResultSet rsDestination = pstmtDestination.executeQuery();

                out.println("<h3>Schedules Where '" + stationName + "' is the Destination</h3>");
                if (!rsDestination.isBeforeFirst()) {
                    out.println("<p>No schedules found where the station is the destination.</p>");
                } else {
                    out.println("<table border='1'><tr><th>ID</th><th>Transit Line</th><th>Departure</th><th>Arrival</th><th>Fare</th></tr>");
                    while (rsDestination.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rsDestination.getInt("schedule_id") + "</td>");
                        out.println("<td>" + rsDestination.getString("transit_line_name") + "</td>");
                        out.println("<td>" + rsDestination.getTimestamp("departure_datetime") + "</td>");
                        out.println("<td>" + rsDestination.getTimestamp("arrival_datetime") + "</td>");
                        out.println("<td>$" + rsDestination.getDouble("fare") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }
                rsDestination.close();
                pstmtDestination.close();

                db.closeConnection(con);

            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
    %>

    <p><a href="repPage.jsp">Back to Dashboard</a></p>
</body>
</html>
