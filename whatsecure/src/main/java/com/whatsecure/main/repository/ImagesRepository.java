package com.whatsecure.main.repository;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.whatsecure.main.models.ProfileImage;

public interface ImagesRepository extends MongoRepository<ProfileImage, String> {
	 Optional<ProfileImage> findByName(String fileName);

}
