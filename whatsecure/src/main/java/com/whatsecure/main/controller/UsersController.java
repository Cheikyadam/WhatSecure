package com.whatsecure.main.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.whatsecure.main.models.Users;
import com.whatsecure.main.services.UsersService;

@RestController
public class UsersController {
	
	@Autowired
	UsersService uss;

	@PostMapping("/newuser")
	public String addUser(@RequestBody Users user) {
		return uss.addUser(user);
	}
	
	@GetMapping("/allusers")
	public List<Users> getAllUsers(){
		return uss.getAllUsers();
	}
}
