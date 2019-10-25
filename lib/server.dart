import 'dart:io';

class Server {
  HttpServer _server;
  bool isOn = false;

  void start(String ssid, String pw, Function callback) async {
    _server = await HttpServer.bind('192.168.43.1', 8080);
    print('Server running at: ${_server.address.address}:${_server.port}');
    isOn = true;
    callback();

    await for (HttpRequest req in _server) {
      print('requested ${req.uri.toString()} from ${req.connectionInfo.remoteAddress.address}');
      _serveRequest(ssid, pw, req);
    }
  }

  void _serveRequest(String ssid, String pw, HttpRequest req) async {
    switch (req.uri.toString()) {
      case '/ssid':
        req.response.write(ssid);
        print('responsed $ssid');
        break;
      case '/password':
        req.response.write(pw);
        print('responsed $pw');
        break;
      default:
        req.response.write('Not found');
        print('responsed Not found');
    }
    req.response.close();
  }

  void close(Function callback) async {
    await _server.close();
    print('Server closed');
    isOn = false;
    callback();
  }
}
