class Url {
  static var adding = Uri.parse('http://100.100.56.13:8080/newuser');
  static Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': ''
  };

  static var fetching = Uri.parse('http://100.100.56.13:8080/allusers');
}
