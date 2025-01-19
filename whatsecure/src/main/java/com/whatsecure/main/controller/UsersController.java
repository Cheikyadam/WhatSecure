package com.whatsecure.main.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
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
	
	@DeleteMapping("/users/{userId}")
	public String deleteUser(@PathVariable String userId) {
		return uss.deleteUser(userId);
	}
	
	@PutMapping("/name/{userId}")
	public String updateUserName(@PathVariable String userId, @RequestBody Map<String, String> body) {
		
		String name = (String) body.get("name");
		System.err.println("name: "+ name);
		return uss.updateUserName(userId, name);
	}
	
	@PutMapping("/phone/{userId}")
	public String updateUserPhone(@PathVariable String userId, @RequestBody Map<String, String> body) {
		
		String phone = (String) body.get("phone");
		System.err.println("phone: "+phone);
		return uss.updateUserPhone(userId, phone);
	}
	
	
}
