package com.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.GenericServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;


@WebServlet(urlPatterns = "/second", name = "SecondServlet")
public class SecondServlet extends GenericServlet {

	@Override
	public void service(ServletRequest arg0, ServletResponse arg1) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		System.out.println("This is serlvet using generic serlvet");	
		System.out.println("Login servlet Works");
		PrintWriter writer = arg1.getWriter();
		writer.println("<h1/>From Servlet </h1>");
		
	}

}
