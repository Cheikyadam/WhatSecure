import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Url {
  static var adding = Uri.parse('http://$ip:8080/newuser');
  static Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': ''
  };

  static var fetching = Uri.parse('http://$ip:8080/allusers');
}

const ip = "100.100.48.220";
const webSocketUrl = 'http://$ip:8080/ws';
bool loaded = false;
const color1 = Color(0xFFC5B8CE);
const color2 = Color(0xFF880fd8);
late List<CameraDescription> cameras;
