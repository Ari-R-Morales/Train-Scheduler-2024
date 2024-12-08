<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Browse Schedules</title>
</head>
<body>
    <h2>Search Train Schedules</h2>
    <form method="GET" action="browseSchedules.jsp">
        <label for="origin">Origin Station:</label>
        <input type="text" name="origin" value="<%= request.getParameter("origin") != null ? request.getParameter("origin") : "" %>" required><br>
        
        <label for="destination">Destination Station:</label>
        <input type="text" name="destination" value="<%= request.getParameter("destination") != null ? request.getParameter("destination") : "" %>" required><br>
        
        <label for="date">Date of Travel:</label>
        <input type="date" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>" required><br>
        
        <label for="sortBy">Sort By:</label>
        <select name="sortBy">
            <option value="departure_datetime" <%= "departure_datetime".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Departure Time</option>
            <option value="arrival_datetime" <%= "arrival_datetime".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Arrival Time</option>
            <option value="fare" <%= "fare".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Fare</option>
        </select><br>

        <button type="submit">Search</button>
    </form>

    <h3>Search Results</h3>
    <%
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String date = request.getParameter("date");
        String sortBy = request.getParameter("sortBy");
        String scheduleId = request.getParameter("scheduleId");

        if (origin != null && destination != null && date != null) {
            try {
                if (sortBy == null || sortBy.isEmpty()) {
                    sortBy = "departure_datetime";
                }

                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                String sql = "SELECT ts.schedule_id, t.train_name, ts.departure_datetime, ts.arrival_datetime, ts.fare " +
                             "FROM Train_Schedules ts " +
                             "JOIN Stations s1 ON ts.origin_station_id = s1.station_id " +
                             "JOIN Stations s2 ON ts.destination_station_id = s2.station_id " +
                             "JOIN Trains t ON ts.train_id = t.train_id " +
                             "WHERE s1.station_name = ? AND s2.station_name = ? AND DATE(ts.departure_datetime) = ? " +
                             "ORDER BY " + sortBy;

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, origin);
                pstmt.setString(2, destination);
                pstmt.setString(3, date);

                ResultSet rs = pstmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No schedules found for your search criteria.</p>");
                } else {
                    out.println("<table border='1'>");
                    out.println("<tr><th>Train Name</th><th>Departure Time</th><th>Arrival Time</th><th>Fare</th><th>Actions</th></tr>");
                    while (rs.next()) {
                        int currentScheduleId = rs.getInt("schedule_id");
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("train_name") + "</td>");
                        out.println("<td>" + rs.getTimestamp("departure_datetime") + "</td>");
                        out.println("<td>" + rs.getTimestamp("arrival_datetime") + "</td>");
                        out.println("<td>$" + rs.getDouble("fare") + "</td>");
                        out.println("<td><a href='browseSchedules.jsp?origin=" + origin + "&destination=" + destination + "&date=" + date + "&sortBy=" + sortBy + "&scheduleId=" + currentScheduleId + "'>View Stops</a></td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }

                rs.close();
                pstmt.close();

                // Show stops for the selected schedule
                if (scheduleId != null) {
                    String stopsSql = "SELECT s.station_name, st.arrival_time, st.departure_time, st.fare_per_stop " +
                                      "FROM Stops st " +
                                      "JOIN Stations s ON st.station_id = s.station_id " +
                                      "WHERE st.schedule_id = ? " +
                                      "ORDER BY st.stop_number";

                    PreparedStatement stopsPstmt = con.prepareStatement(stopsSql);
                    stopsPstmt.setInt(1, Integer.parseInt(scheduleId));

                    ResultSet stopsRs = stopsPstmt.executeQuery();

                    out.println("<h3>Stops for Schedule ID: " + scheduleId + "</h3>");
                    if (!stopsRs.isBeforeFirst()) {
                        out.println("<p>No stops found for this schedule.</p>");
                    } else {
                        out.println("<table border='1'>");
                        out.println("<tr><th>Stop Name</th><th>Arrival Time</th><th>Departure Time</th><th>Fare</th></tr>");
                        while (stopsRs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + stopsRs.getString("station_name") + "</td>");
                            out.println("<td>" + stopsRs.getTime("arrival_time") + "</td>");
                            out.println("<td>" + stopsRs.getTime("departure_time") + "</td>");
                            out.println("<td>$" + stopsRs.getDouble("fare_per_stop") + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table>");
                    }

                    stopsRs.close();
                    stopsPstmt.close();
                }

                db.closeConnection(con);

            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
    %>
    
        <p><a href="customerPage.jsp">Back to Dashboard</a></p>
</body>
</html>
