<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    String scheduleId = request.getParameter("scheduleId");
    String fare = request.getParameter("fare");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String sql = "UPDATE Train_Schedules SET fare = ? WHERE schedule_id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setDouble(1, Double.parseDouble(fare));
        pstmt.setInt(2, Integer.parseInt(scheduleId));

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            out.println("<p>Schedule updated successfully!</p>");
        } else {
            out.println("<p>Failed to update schedule. Please check the Schedule ID.</p>");
        }

        pstmt.close();
        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<a href="browseSchedules.jsp">Back to Browse</a>
