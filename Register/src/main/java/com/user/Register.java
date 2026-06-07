package com.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/Register")
@MultipartConfig
public class Register extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            String name = request.getParameter("user_name");
            String email = request.getParameter("user_email");
            String password = request.getParameter("user_password");
            Part part = request.getPart("image");

            // Validate part
            if (part == null) {
                out.println("No file part found!");
                return;
            }

            String filename = part.getSubmittedFileName();
            if (filename == null || filename.isEmpty()) {
                out.println("No file selected!");
                return;
            }

            // External upload folder
            String uploadPath = "C:\\Users\\abhi1\\uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Full path including filename
            String fullPath = uploadPath + File.separator + filename;
            System.out.println("Saving file to: " + fullPath);

            // Save file manually
            try (InputStream is = part.getInputStream();
                 FileOutputStream fos = new FileOutputStream(fullPath)) {

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }

            // Save user info + filename in DB
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/abhi", "root", "root");

                String q = "INSERT INTO user(name,password,email,image) VALUES(?,?,?,?)";
                PreparedStatement ptsmt = conn.prepareStatement(q);
                ptsmt.setString(1, name);
                ptsmt.setString(2, password);
                ptsmt.setString(3, email);
                ptsmt.setString(4, filename);

                int rows = ptsmt.executeUpdate();
                ptsmt.close();
                conn.close();

                if (rows > 0) {
                    out.println("done");
                } else {
                    out.println("error...");
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                out.println("error...");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
