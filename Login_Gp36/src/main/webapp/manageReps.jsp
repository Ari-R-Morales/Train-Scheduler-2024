<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Manage Customer Representatives</title>
</head>
<body>
    <h2>Customer Representatives</h2>

    <!-- Form to Add or Edit Representatives -->
    <form method="POST" action="manageRepsAction.jsp">
        <%
            // Check if editing a representative
            String action = request.getParameter("action");
            String repId = request.getParameter("repId");
            String repName = "";
            String repUsername = "";
            String repPassword = "";

            if ("edit".equals(action) && repId != null) {
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();

                    String sql = "SELECT first_name, last_name, username FROM Employees WHERE employee_id = ?";
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(repId));

                    ResultSet rs = pstmt.executeQuery();

                    if (rs.next()) {
                        repName = rs.getString("first_name") + " " + rs.getString("last_name");
                        repUsername = rs.getString("username");
                    }

                    rs.close();
                    pstmt.close();
                    db.closeConnection(con);
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                }
            }
        %>
        <input type="hidden" name="repId" value="<%= repId != null ? repId : "" %>">
        <label for="repName">Name:</label>
        <input type="text" name="repName" value="<%= repName %>" required><br>
        <label for="repUsername">Username:</label>
        <input type="text" name="repUsername" value="<%= repUsername %>" required><br>
        <label for="repPassword">Password:</label>
        <input type="password" name="repPassword" required><br>
        <button type="submit" name="action" value="<%= action != null && action.equals("edit") ? "update" : "add" %>">
            <%= action != null && action.equals("edit") ? "Update" : "Add" %> Representative
        </button>
        <% if ("edit".equals(action)) { %>
            <button type="button" onclick="window.location.href='manageReps.jsp'">Cancel</button>
        <% } %>
    </form>

    <h3>Existing Representatives</h3>
    <%
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String sql = "SELECT * FROM Employees WHERE role = 'Customer Representative'";
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            out.println("<table border='1'><tr><th>ID</th><th>Name</th><th>Actions</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("employee_id") + "</td>");
                out.println("<td>" + rs.getString("username") + "</td>");
                out.println("<td>");
                out.println("<a href='manageReps.jsp?action=edit&repId=" + rs.getInt("employee_id") + "'>Edit</a> | ");
                out.println("<a href='manageRepsAction.jsp?action=delete&repId=" + rs.getInt("employee_id") + "'>Delete</a>");
                out.println("</td>");
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

      <p><a href="adminPage.jsp">Back to Dashboard</a></p>
</body>
</html>
