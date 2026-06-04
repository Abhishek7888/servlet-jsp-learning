package com.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Servlet implementation class Register
 */
@WebServlet("/Register")
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Register() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		try (PrintWriter out = response.getWriter()) {
			

			// Getting all the incoming details from the request.
			String name = request.getParameter("user_name");
			String email = request.getParameter("user_email");
			String password = request.getParameter("user_password");
			// Connection........
			try {
				Thread.sleep(3000);
				Class.forName("com.mysql.cj.jdbc.Driver");

				Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/abhi", "root", "root");

				// Query.........
				String q = "insert into user(name,password,email) values(?,?,?)";
				PreparedStatement ptsmt = conn.prepareStatement(q);
				ptsmt.setString(1, name);
				ptsmt.setString(2, password);
				ptsmt.setString(3, email);
				ptsmt.executeUpdate();
				out.println("done");
			} catch (ClassNotFoundException | SQLException | InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				out.println("error...");
			}
	
		}
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		processRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		processRequest(request, response);
	}

}
