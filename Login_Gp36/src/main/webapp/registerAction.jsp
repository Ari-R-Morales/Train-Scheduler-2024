<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Registration Action</title>
</head>
<body>
    <%
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String sql = "INSERT INTO Customers (first_name, last_name, email, username, password) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, email);
            pstmt.setString(4, username);
            pstmt.setString(5, password);

            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                out.println("<p>Registration successful!</p>");
                out.println("<a href='login.jsp'>Go to Login</a>");
            } else {
                out.println("<p>Registration failed. Please try again.</p>");
                out.println("<a href='register.jsp'>Back to Register</a>");
            }

            pstmt.close();
            db.closeConnection(con);

        } catch (Exception e) {
            out.print("Error: " + e.getMessage());
        }
    %>
</body>
</html>
