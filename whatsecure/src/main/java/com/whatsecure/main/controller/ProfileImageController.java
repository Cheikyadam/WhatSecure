package com.whatsecure.main.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.whatsecure.main.services.ImagesService;

@RestController
@RequestMapping("/image")
public class ProfileImageController {

	@Autowired
	ImagesService service;
	
	
	@PostMapping
	public ResponseEntity<?> uploadImageToFIleSystem(@RequestParam("image")MultipartFile file) throws IOException {
		String uploadImage = service.uploadImageToFileSystem(file);
		return ResponseEntity.status(HttpStatus.OK)
				.body(uploadImage);
	}

	@GetMapping("/{fileId}")
	public ResponseEntity<?> downloadImageFromFileSystem(@PathVariable String fileId) throws IOException {
		if(service.downloadImageFromFileSystem(fileId) != null) {
			byte[] imageData=service.downloadImageFromFileSystem(fileId);
			return ResponseEntity.status(HttpStatus.OK)
				.contentType(MediaType.valueOf(service.getImageType(fileId)))
				.body(imageData);
		}
		return ResponseEntity.status(HttpStatus.OK).body("No photo here");
		

	}
	
	@DeleteMapping("/{fileId}")
	public  ResponseEntity<?> deleteImageFromFileSystem(@PathVariable String fileId) throws IOException{
		service.deleteImageFromFileSystem(fileId);
		return ResponseEntity.status(HttpStatus.OK).body("deleted");
	}
}
