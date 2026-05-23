package com.session;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.CookieHandler;
import java.util.Iterator;

/**
 * Servlet implementation class Servlet2
 */
@WebServlet("/Servlet2")
public class Servlet2 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Servlet2() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		try (PrintWriter out = response.getWriter()) {
			out.println("<html><body>");
			// Getting all cookies
			Cookie[] cookies = request.getCookies();
			boolean f = false;
			String name = "";
			if (cookies == null) {
				System.out.println("<h1>You are new user go to homepage and submit your name </h1>");
				return;
			} else {
				for (Cookie c : cookies) {
					String tname = c.getName();
					if (tname.equals("user_name")) {
						f = true;
						name = c.getValue();
					}
				}
			}
			if (f) {
				out.println("<h1>Hello , " + name + " Welcome back to Website...<h1/>");
			 } else {
				System.out.println("<h1>You are new user go to homepage and submit your name </h1>");
			}

			out.println("<h2>Thank you for visiting.</h2>");
			out.println("</body></html>");
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
