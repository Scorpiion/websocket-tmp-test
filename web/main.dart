import 'dart:async';
import 'dart:html';
import 'dart:convert';

Future main() {
  WebSocket ws;
  DivElement chatBox = querySelector("#chat-box");
  DivElement messages = querySelector('#messages-box');
  InputElement user = querySelector('#user-input');
  InputElement message = querySelector('#message-input');
  ButtonElement send = querySelector('#send-btn');

  // Initialize Websocket connection (9090 for during development locally,
  // otherwise use standard port for production)
  Uri uri = Uri.parse(window.location.href);
  if(uri.scheme == "https") {
    ws = new WebSocket("wss://${uri.host}/ws");
  } else {
    ws = new WebSocket("ws://${uri.host}:9090/ws");
  }

  // Listen for Websocket events
  ws.onOpen.listen((e)    => print("Connected"));
  ws.onClose.listen((e)   => print("Disconnected"));
  ws.onError.listen((e)   => print("Error"));

  // Collect messages from the stream
  ws.onMessage.listen((e) {
    var message = new Message.fromJson(JSON.decode(e.data));

    messages.innerHtml = '''${messages.innerHtml}
<div class="pure-u-1-4 text-bold"><div class="pure-input-1">${message.user}</div></div>
<div class="pure-u-3-4"><div class="pure-input-1">${message.message}</div></div>''';

    chatBox.scrollTop = chatBox.scrollHeight;
  });

  // Send message on the channel
  send.onClick.listen((_) {
    if(user.value != "" && message.value != "") {
      ws.send(JSON.encode(new Message(user.value, message.value)));

      // Clear message input
      message.value = "";
    }
  });

  message.onKeyUp.listen((KeyboardEvent event) {
    if(event.keyCode == 13) {
      send.click();
    }
  });
}

class Message {
  String user, message;

  Message(this.user, this.message);

  Message.fromJson(Map data) {
    user    = data["user"];
    message = data["message"];
  }

  Map toJson() => {"user": user, "message": message};
}

