<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Top Transit Lines</title>
</head>
<body>
    <h2>Top 5 Most Active Transit Lines</h2>
    <%
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String sql = "SELECT ts.transit_line_name, COUNT(r.reservation_id) AS total_reservations " +
                         "FROM Reservations r " +
                         "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                         "GROUP BY ts.transit_line_name " +
                         "ORDER BY total_reservations DESC LIMIT 5";

            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>No data available for the top transit lines.</p>");
            } else {
                out.println("<table border='1'><tr><th>Transit Line</th><th>Total Reservations</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("transit_line_name") + "</td>");
                    out.println("<td>" + rs.getInt("total_reservations") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }

            rs.close();
            pstmt.close();
            db.closeConnection(con);

        } catch (Exception e) {
            out.println("<p>Error retrieving top transit lines: " + e.getMessage() + "</p>");
        }
    %>
    <p><a href="adminPage.jsp">Back to Dashboard</a></p>
</body>
</html>
