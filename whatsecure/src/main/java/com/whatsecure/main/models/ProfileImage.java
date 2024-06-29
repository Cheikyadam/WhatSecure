package com.whatsecure.main.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder

@Document(collection="images")
public class ProfileImage {

	@Id
	private String id;
	private String name;
	private String type;
	private String filePath;
}
