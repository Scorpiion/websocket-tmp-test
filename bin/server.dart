library server;

import 'dart:io';
import 'dart:async';
import 'package:vane/vane_server.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

part 'chat.dart';

void main() => serve();

@Route("/")
Future shelfStatic(HttpRequest request) {
  io.handleRequest(request, createStaticHandler('build/web', defaultDocument: 'index.html'));
}

