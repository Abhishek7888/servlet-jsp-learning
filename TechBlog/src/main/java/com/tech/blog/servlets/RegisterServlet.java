package com.tech.blog.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.tech.blog.dao.UserDao;
import com.tech.blog.entities.User;
import com.tech.blog.helper.ConnectionProvider;

/**
 * Servlet implementation class RegisterServlet
 */
@MultipartConfig
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RegisterServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		var out = response.getWriter();
		out.println();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		response.setContentType("text/html");
		var out = response.getWriter();

		// Get checkbox value
		String check = request.getParameter("check");
		if (check == null) {
			out.println("box not checked.");
		} else {
			String name = request.getParameter("user_name");
			String email = request.getParameter("user_email");
			String password = request.getParameter("user_password");
			String gender = request.getParameter("user_gender");
			String about = request.getParameter("about");

			User user = new User(name, email, password, gender, about);

			// Create USER DAO object
			UserDao dao = new UserDao(ConnectionProvider.getConnection());
			if (dao.saveUser(user)) {
				out.println("done");
			} else {
				out.println("error");
			}
		}
	}

}
