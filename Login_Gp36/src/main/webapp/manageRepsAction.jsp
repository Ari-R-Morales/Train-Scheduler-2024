<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<%
    String action = request.getParameter("action");

    try {
        // Establish database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        if ("add".equals(action)) {
            // Add a new representative
            String repName = request.getParameter("repName");
            String repUsername = request.getParameter("repUsername");
            String repPassword = request.getParameter("repPassword");

            String sql = "INSERT INTO Employees (first_name, last_name, username, password, role) " +
                         "VALUES (?, ?, ?, ?, 'Customer Representative')";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, repName.split(" ")[0]); // First name
            pstmt.setString(2, repName.split(" ").length > 1 ? repName.split(" ")[1] : ""); // Last name
            pstmt.setString(3, repUsername);
            pstmt.setString(4, repPassword);

            pstmt.executeUpdate();
            pstmt.close();

        } else if ("update".equals(action)) {
            // Update existing representative
            int repId = Integer.parseInt(request.getParameter("repId"));
            String repName = request.getParameter("repName");
            String repUsername = request.getParameter("repUsername");
            String repPassword = request.getParameter("repPassword");

            String sql = "UPDATE Employees SET first_name = ?, last_name = ?, username = ?, password = ? WHERE employee_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, repName.split(" ")[0]); // First name
            pstmt.setString(2, repName.split(" ").length > 1 ? repName.split(" ")[1] : ""); // Last name
            pstmt.setString(3, repUsername);
            pstmt.setString(4, repPassword);
            pstmt.setInt(5, repId);

            pstmt.executeUpdate();
            pstmt.close();

        } else if ("delete".equals(action)) {
            // Delete representative
            int repId = Integer.parseInt(request.getParameter("repId"));

            String sql = "DELETE FROM Employees WHERE employee_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, repId);

            pstmt.executeUpdate();
            pstmt.close();
        } else {
            out.println("<p>Invalid action.</p>");
        }

        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }

    response.sendRedirect("manageReps.jsp");
%>
