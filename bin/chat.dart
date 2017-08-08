part of server;

// Create a broadcast channel to share messages
StreamController channel = new StreamController.broadcast();

class Chat extends Vane {
  @Route("/ws")
  Future main() {
    // Start listening to websocket connection
    StreamSubscription conn = ws.listen(null);

    // Set ping interval to prevent disconnection from peers
    ws.pingInterval = new Duration(seconds: 5);

    // Add all incomming message to the chatStream
    conn.onData((msg) {
      log.info(msg);
      channel.sink.add(msg);
    });

    // On error, log warning
    conn.onError((e) => log.warning(e));

    // Close connection if websocket closes
    conn.onDone(() => close());

    // Add message to chat stream
    channel.stream.listen((msg) {
      log.info(msg);
      ws.add(msg);
    });

    return end;
  }
}

