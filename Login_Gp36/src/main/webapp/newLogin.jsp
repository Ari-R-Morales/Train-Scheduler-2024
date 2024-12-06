<%@ page language="java" contentType="text/html; charset=ISO-8859-1" 
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Login Page</title>
</head>
<body>
    <%
        String username = request.getParameter("username"); // Retrieve username from form
        String password = request.getParameter("password"); // Retrieve password from form
        boolean isValidUser = false; // Flag to track if login is successful

        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // SQL query to check if username and password match a record in the users table
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            // Execute query
            ResultSet result = pstmt.executeQuery();

            // If a match is found, set isValidUser to true
            if (result.next()) {
                isValidUser = true;

                // Create a session for the user
                HttpSession userSession = request.getSession();
                userSession.setAttribute("username", username); // Store username in session

                // Redirect to the User Page
                response.sendRedirect("userPage.jsp");
                return; // Stop further execution
            }

            // Close resources
            result.close();
            pstmt.close();
            db.closeConnection(con);

        } catch (Exception e) {
            out.print("Error: " + e.getMessage());
        }

        // Display error message if login fails
        if (!isValidUser) {
    %>
            <p>Invalid username or password. Please try again.</p>
            <a href="HelloWorld.jsp">Back to Login</a>
    <%
        }
    %>
</body>
</html>
