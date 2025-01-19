package com.whatsecure.main.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.stereotype.Service;

import com.whatsecure.main.models.Users;
import com.whatsecure.main.repository.UsersRepository;

@Service
public class UsersService {
	
	@Autowired
	UsersRepository usr;

	public String addUser(Users user) {
		usr.insert(user);
		return "User added";
	}
	
	public List<Users> getAllUsers(){
		List<Users> allUsers = usr.findAll();
		return allUsers;
		
	}
	
	public String updateUserName(String userId, String userName) 
	{
		Optional<Users> opUser = usr.findById(userId);
		if(opUser.isPresent()) {
			System.err.println(userName);
			Users user = opUser.get(); 
			user.setName(userName);
			LocalDateTime now = LocalDateTime.now();
			user.setUpdatedAt(now.toString());
			usr.save(user);
		return "OK";
		}
		return "error";
	}
	
	
	public String updateUserPhone(String userId, String newPhone) 
	{
		Optional<Users> opUser = usr.findById(userId);
		if(opUser.isPresent()) {
			Users user = opUser.get(); 
			user.setId(newPhone);
			LocalDateTime now = LocalDateTime.now();
			user.setUpdatedAt(now.toString());
			usr.save(user);
			usr.deleteById(userId);
			return "OK";
		}
		return "error";
	}
	
	public String deleteUser(String userId) 
	{
		Optional<Users> opUser = usr.findById(userId);
		if(opUser.isPresent()) {
		     usr.deleteById(userId);
		     return "OK";
		}
		return "error";
	}

}

