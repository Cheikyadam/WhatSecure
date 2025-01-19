package com.whatsecure.main.models;

import java.util.Date;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
@Builder
@AllArgsConstructor

public class ChatMessage {
	 	//private String chatId;
	    private String senderId;
	    private String recipientId;
	    private String content;
	    private Date sentAt;
	    private Map<String, String> fileInfos;
	    private MessageType messageType;
}

enum MessageType{
	image,
	text,
	doc,
	}
