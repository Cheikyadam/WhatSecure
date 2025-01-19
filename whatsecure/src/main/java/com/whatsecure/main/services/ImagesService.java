package com.whatsecure.main.services;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;


import com.whatsecure.main.models.ProfileImage;
import com.whatsecure.main.repository.ImagesRepository;

@Service
public class ImagesService {
	
	@Autowired
	ImagesRepository imgRepository;
	
	private final String FOLDER_PATH="C:\\Users\\Adam\\Desktop\\PFC_IMAGES\\";
	
	
	
	public String uploadImageToFileSystem(MultipartFile file) throws IOException {
		String fileName = file.getOriginalFilename();
        String filePath=FOLDER_PATH+fileName;
        String id = fileName.split("\\.")[0];
        Optional<ProfileImage> fileData = imgRepository.findById(id); 
        
        if(fileData.isPresent()) {
        	Files.deleteIfExists(new File(filePath).toPath());
        }
        
        imgRepository.save(ProfileImage.builder()
        		.userId(id)
                .name(file.getOriginalFilename())
                .type(file.getContentType())
                .filePath(filePath).build());     	

        file.transferTo(new File(filePath));

        return "file uploaded successfully : " + filePath;
        
        
    }

    public byte[] downloadImageFromFileSystem(String fileId) throws IOException {
        Optional<ProfileImage> fileData = imgRepository.findById(fileId);
        if(! fileData.isPresent()) {
        	System.err.println("nothing");
        	return null;
        }
        String filePath= fileData.get().getFilePath();
        byte[] images = Files.readAllBytes(new File(filePath).toPath());
        return images;
    }

    public String getImageType(String fileId) {
	
    	Optional<ProfileImage> fileData = imgRepository.findById(fileId);
    	return fileData.get().getType();
     
    }

    
    public void deleteImageFromFileSystem(String fileId) throws IOException{
    	Optional<ProfileImage> fileData = imgRepository.findById(fileId);
    	if( fileData.isPresent()) {
    		String filePath= fileData.get().getFilePath();
    		Files.deleteIfExists(new File(filePath).toPath());
    		imgRepository.deleteById(fileId);
    	}
    	
    	
    }
}
