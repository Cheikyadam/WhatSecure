package com.whatsecure.main.controller;

import java.util.logging.*;


//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;

//import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
//import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;


import com.whatsecure.main.models.ChatMessage;


//import lombok.extern.slf4j.Slf4j;

//import org.springframework.messaging.handler.annotation.MessageMapping;
//import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
//import org.springframework.stereotype.Controller;

//import com.whatsecure.main.models.ChatMessage;

import lombok.RequiredArgsConstructor;
@Controller
@RequiredArgsConstructor
public class ChatController {
	private final SimpMessagingTemplate messagingTemplate;
	private static final Logger logger = Logger.getLogger(ChatController.class.getName());
	
	@MessageMapping("/chat")
    public void processMessage(@Payload ChatMessage chatMessage) {
        
		
		
		String sendTo = "/topic/" +chatMessage.getRecipientId() +  "/queue/messages";
        messagingTemplate.convertAndSend(
                sendTo,
                chatMessage
               /* new ChatNotification(chatMessage.getContent(), 
                		chatMessage.getSenderId(),
                		chatMessage.getRecipientId()
                		)*/
                        
                
        );
        
        logger.info(chatMessage.getContent());
        System.out.println("MESSAGE RECEIVED AND SEND TO "+ sendTo);
    }
}
/*
@Slf4j
@Controller
public class ChatController {

 private final Map<String, List<ChatMessage>> chats = new HashMap<>();

 @MessageMapping("/chat/{chatId}")
 @SendTo("/topic/chat/{chatId}")
 public List<ChatMessage> sendMessageWithWebsocket(@DestinationVariable String chatId,
   @Payload ChatMessage message) {
  log.info("new message arrived in chat with id {}", chatId);
  List<ChatMessage> messages = this.chats.getOrDefault(chatId, new ArrayList<ChatMessage>());
  messages.add(message);
  chats.put(chatId, messages);
  return messages;
 }
}*/
