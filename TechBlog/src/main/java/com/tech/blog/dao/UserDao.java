package com.tech.blog.dao;

import java.sql.*;

import com.tech.blog.entities.User;

public class UserDao {

	private Connection con;

	public UserDao(Connection con) {
		super();
		this.con = con;
	}

	// Method to insert user to data base

	public boolean saveUser(User user) {
		boolean f = false;
		try {
			// user --> Database
			String query = "insert into user(name,email,password,gender,about) values(?,?,?,?,?)";
			PreparedStatement pstmt = this.con.prepareStatement(query);
			pstmt.setString(1, user.getName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getPassword());
			pstmt.setString(4, user.getGender());
			pstmt.setString(5, user.getAbout());
			pstmt.setString(6, user.getProfile());
			pstmt.executeUpdate();
			f = true;
		} catch (Exception e) {
			// TODO: handle exception
		}
		return f;
	}

	// Get User by user mail and user password

	public User getUser(String email, String password) {

		User user = null;
		try {

			String query = "select * from user where email = ? and password = ?";
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setString(1, email);
			pstmt.setString(2, password);

			ResultSet set = pstmt.executeQuery();

			if (set.next()) {
				user = new User();
				String name = set.getString("name");
				user.setName(name);
				user.setId(set.getInt("id"));
				user.setEmail(set.getString("email"));
				user.setPassword(set.getString("password"));
				user.setGender(set.getString("gender"));
				user.setAbout(set.getString("about"));
				user.setProfile(set.getString("profile"));
				user.setRegistration_date(set.getTimestamp("registration_date"));
			}

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return user;

	}

}
