package com.practice;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("Welcome to Register Servlet");

		String name = request.getParameter("user_name");
		String password = request.getParameter("user_password");
		String email = request.getParameter("user_email");
		String gender = request.getParameter("user_gender");
		String course = request.getParameter("User_Course");
		String cond = request.getParameter("condition");

		if (cond != null) {

			if (cond.equals("checked")) {
				out.println("<html><body>");
				out.println("<h2>Registration Details</h2>");
				out.println("<p><strong>Name:</strong> " + name + "</p>");
				out.println("<p><strong>Email:</strong> " + email + "</p>");
				out.println("<p><strong>Password:</strong> " + password + "</p>");
				out.println("<p><strong>Gender:</strong> " + gender + "</p>");
				out.println("<p><strong>Course:</strong> " + course + "</p>");
				out.println("</body></html>");
			}

		} else {
			out.println("<p><strong> You have not accepted terms and conditions.");
		}
	}

}
