package com.whatsecure.main.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor

@Document(collection = "users")
public class Users {
	
	@Id
	
	private String id;
	private String name;
	private String picture;
	private String createdAt;
	private String updatedAt;
	private String publicKey;
}
