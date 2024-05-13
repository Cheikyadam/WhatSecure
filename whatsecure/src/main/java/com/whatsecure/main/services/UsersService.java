package com.whatsecure.main.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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

}

