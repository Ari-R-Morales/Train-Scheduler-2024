<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Manage Train Schedules</title>
</head>
<body>
    <h2>Manage Train Schedules</h2>

    <%
        // Check if editing a schedule
        String action = request.getParameter("action");
        String scheduleId = request.getParameter("scheduleId");
        String transitLine = "";
        String departureDatetime = "";
        String arrivalDatetime = "";
        String fare = "";

        if ("edit".equals(action) && scheduleId != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                String sql = "SELECT transit_line_name, departure_datetime, arrival_datetime, fare FROM Train_Schedules WHERE schedule_id = ?";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(scheduleId));

                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    transitLine = rs.getString("transit_line_name");
                    departureDatetime = rs.getString("departure_datetime").replace(" ", "T"); // Convert to datetime-local format
                    arrivalDatetime = rs.getString("arrival_datetime").replace(" ", "T"); // Convert to datetime-local format
                    fare = rs.getString("fare");
                }

                rs.close();
                pstmt.close();
                db.closeConnection(con);

            } catch (Exception e) {
                out.println("<p>Error loading schedule for edit: " + e.getMessage() + "</p>");
            }
        }
    %>

    <% if ("edit".equals(action)) { %>
    <h3>Edit Train Schedule</h3>
    <form method="POST" action="manageSchedulesAction.jsp">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="scheduleId" value="<%= scheduleId %>">
        <label for="transitLine">Transit Line:</label>
        <input type="text" name="transitLine" value="<%= transitLine %>" required><br>
        <label for="departureDatetime">Departure Datetime:</label>
        <input type="datetime-local" name="departureDatetime" value="<%= departureDatetime %>" required><br>
        <label for="arrivalDatetime">Arrival Datetime:</label>
        <input type="datetime-local" name="arrivalDatetime" value="<%= arrivalDatetime %>" required><br>
        <label for="fare">Fare:</label>
        <input type="number" name="fare" step="0.01" value="<%= fare %>" required><br>
        <button type="submit">Update Schedule</button>
        <a href="manageSchedules.jsp"><button type="button">Cancel</button></a>
    </form>
    <% } %>

    <h3>Existing Train Schedules</h3>
    <%
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String sql = "SELECT ts.schedule_id, t.train_name, ts.transit_line_name, ts.departure_datetime, ts.arrival_datetime, ts.fare " +
                         "FROM Train_Schedules ts " +
                         "JOIN Trains t ON ts.train_id = t.train_id";
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            out.println("<table border='1'><tr><th>ID</th><th>Train</th><th>Transit Line</th><th>Departure</th><th>Arrival</th><th>Fare</th><th>Actions</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("schedule_id") + "</td>");
                out.println("<td>" + rs.getString("train_name") + "</td>");
                out.println("<td>" + rs.getString("transit_line_name") + "</td>");
                out.println("<td>" + rs.getTimestamp("departure_datetime") + "</td>");
                out.println("<td>" + rs.getTimestamp("arrival_datetime") + "</td>");
                out.println("<td>$" + rs.getDouble("fare") + "</td>");
                out.println("<td><a href='manageSchedules.jsp?action=edit&scheduleId=" + rs.getInt("schedule_id") + "'>Edit</a> | ");
                out.println("<a href='manageSchedulesAction.jsp?action=delete&scheduleId=" + rs.getInt("schedule_id") + "'>Delete</a></td>");
                out.println("</tr>");
            }
            out.println("</table>");

            rs.close();
            pstmt.close();
            db.closeConnection(con);

        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>

    <p><a href="repPage.jsp">Back to Dashboard</a></p>
</body>
</html>
