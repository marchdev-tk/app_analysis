// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

// TODO: move into separate package

extension HttpClientRequestExtension on HttpClientRequest {
  HttpClientRequestExtended toExtended() => HttpClientRequestExtended(this);
}

extension HttpClientResponseExtension on HttpClientResponse {
  HttpClientResponseExtended toExtended() => HttpClientResponseExtended(this);
}

class HttpHeadersExtended implements HttpHeaders {
  HttpHeadersExtended(this.raw);

  final HttpHeaders raw;

  @override
  int get contentLength {
    var contentLength = 0;
    raw.forEach((name, values) {
      for (var value in values) {
        /// `2` for `: ` and `2` for `CRLF (\r\n)`
        contentLength +=
            utf8.encode(name).length + utf8.encode(value).length + 4;
      }
    });

    return contentLength;
  }

  // !
  // ! Wrappers
  // !

  @override
  set contentLength(int contentLength) => raw.contentLength = contentLength;
  @override
  bool get chunkedTransferEncoding => raw.chunkedTransferEncoding;
  @override
  set chunkedTransferEncoding(bool chunkedTransferEncoding) =>
      raw.chunkedTransferEncoding = chunkedTransferEncoding;
  @override
  ContentType? get contentType => raw.contentType;
  @override
  set contentType(ContentType? contentType) => raw.contentType = contentType;
  @override
  DateTime? get date => raw.date;
  @override
  set date(DateTime? date) => raw.date = date;
  @override
  DateTime? get expires => raw.expires;
  @override
  set expires(DateTime? expires) => raw.expires = expires;
  @override
  String? get host => raw.host;
  @override
  set host(String? host) => raw.host = host;
  @override
  DateTime? get ifModifiedSince => raw.ifModifiedSince;
  @override
  set ifModifiedSince(DateTime? ifModifiedSince) =>
      raw.ifModifiedSince = ifModifiedSince;
  @override
  bool get persistentConnection => raw.persistentConnection;
  @override
  set persistentConnection(bool persistentConnection) =>
      raw.persistentConnection = persistentConnection;
  @override
  int? get port => raw.port;
  @override
  set port(int? port) => raw.port = port;

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) =>
      raw.add(name, value, preserveHeaderCase: preserveHeaderCase);
  @override
  void clear() => raw.clear();
  @override
  void forEach(void Function(String name, List<String> values) action) =>
      raw.forEach(action);
  @override
  void noFolding(String name) => raw.noFolding(name);
  @override
  void remove(String name, Object value) => raw.remove(name, value);
  @override
  void removeAll(String name) => raw.removeAll(name);
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) =>
      raw.set(name, value, preserveHeaderCase: preserveHeaderCase);
  @override
  String? value(String name) => raw.value(name);

  @override
  List<String>? operator [](String name) => raw[name];
}

class HttpClientRequestExtended implements HttpClientRequest {
  HttpClientRequestExtended(this.raw);

  final HttpClientRequest raw;
  final _buffer = StringBuffer();

  String? _body;
  String get body => _body ?? _buffer.toString();

  @override
  HttpHeadersExtended get headers => HttpHeadersExtended(raw.headers);

  int get uriContentLength {
    final relativeUri = uri.toString().replaceFirst(uri.origin, '');
    final requestLine = '$method $relativeUri HTTP/1.1\r\n';

    return utf8.encode(requestLine).length;
  }

  int get cookiesContentLength {
    var contentLength = 0;
    if (cookies.isNotEmpty) {
      var cookieHeader = cookies.map((c) => '${c.name}=${c.value}').join('; ');
      contentLength = utf8.encode('Cookie: $cookieHeader\r\n').length;
    }

    return contentLength;
  }

  int get bodyContentLength => contentLength;

  int get totalContentLength =>
      uriContentLength +
      headers.contentLength +
      cookiesContentLength +
      contentLength;

  @override
  int get contentLength {
    if (raw.contentLength != -1) {
      return raw.contentLength;
    }

    return utf8.encode(body).length;
  }

  @override
  void write(Object? object) {
    raw.write(object);
    _buffer.write(object);
  }

  @override
  void writeAll(Iterable objects, [String separator = '']) {
    raw.writeAll(objects, separator);
    _buffer.writeAll(objects, separator);
  }

  @override
  void writeCharCode(int charCode) {
    raw.writeCharCode(charCode);
    _buffer.writeCharCode(charCode);
  }

  @override
  void writeln([Object? object = '']) {
    raw.writeln(object);
    _buffer.writeln(object);
  }

  @override
  Future<HttpClientResponse> get done {
    _body = _buffer.toString();
    _buffer.clear();
    return raw.done;
  }

  @override
  Future<HttpClientResponse> close() {
    _body = _buffer.toString();
    _buffer.clear();
    return raw.close();
  }

  // !
  // ! Wrappers
  // !

  @override
  String get method => raw.method;
  @override
  Uri get uri => raw.uri;
  @override
  HttpConnectionInfo? get connectionInfo => raw.connectionInfo;
  @override
  List<Cookie> get cookies => raw.cookies;
  @override
  Encoding get encoding => raw.encoding;
  @override
  set encoding(Encoding encoding) => raw.encoding = encoding;
  @override
  bool get bufferOutput => raw.bufferOutput;
  @override
  set bufferOutput(bool value) => raw.bufferOutput = value;
  @override
  set contentLength(int value) => raw.contentLength = value;
  @override
  bool get followRedirects => raw.followRedirects;
  @override
  set followRedirects(bool value) => raw.followRedirects = value;
  @override
  int get maxRedirects => raw.maxRedirects;
  @override
  set maxRedirects(int value) => raw.maxRedirects = value;
  @override
  bool get persistentConnection => raw.persistentConnection;
  @override
  set persistentConnection(bool value) => raw.persistentConnection = value;
  @override
  void add(List<int> data) => raw.add(data);
  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      raw.addError(error, stackTrace);
  @override
  Future addStream(Stream<List<int>> stream) => raw.addStream(stream);
  @override
  void abort([Object? exception, StackTrace? stackTrace]) =>
      raw.abort(exception, stackTrace);
  @override
  Future flush() => raw.flush();
}

class HttpClientResponseExtended implements HttpClientResponse {
  HttpClientResponseExtended(this.raw);

  final HttpClientResponse raw;

  var _bodyBytes = Uint8List(0);
  FutureOr<Uint8List> get bodyBytes async {
    if (_bodyBytes.isNotEmpty) {
      return _bodyBytes;
    }

    final bytes = await raw
        .fold<List<int>>(<int>[], (value, prevValue) => value + prevValue);
    return _bodyBytes = Uint8List.fromList(bytes);
  }

  FutureOr<String> get body async =>
      _encodingForHeaders().decode(await bodyBytes);

  Encoding _encodingForHeaders() =>
      _encodingForCharset(_contentTypeForHeaders().parameters['charset']);

  Encoding _encodingForCharset(String? charset, [Encoding fallback = utf8]) {
    if (charset == null) return fallback;
    return Encoding.getByName(charset) ?? fallback;
  }

  MediaType _contentTypeForHeaders() {
    final contentType = headers.value(HttpHeaders.contentTypeHeader);
    if (contentType != null) return MediaType.parse(contentType);
    return MediaType('application', 'octet-stream');
  }

  @override
  HttpHeadersExtended get headers => HttpHeadersExtended(raw.headers);

  var _bodyContentLength = -1;
  Future<int> get bodyContentLength async {
    if (raw.contentLength != -1) {
      return raw.contentLength;
    }

    var contentLength = 0;
    await for (var chunk in raw) {
      contentLength += chunk.length;
    }

    return _bodyContentLength = contentLength;
  }

  Future<int> get totalContentLength async =>
      headers.contentLength + await bodyContentLength;

  /// Be advised that this method does not guarantee that true content length
  /// will be retrieved, consider using async getter [bodyContentLength].
  @override
  int get contentLength =>
      _bodyContentLength != -1 ? _bodyContentLength : raw.contentLength;

  // !
  // ! Wrappers of [HttpClientResponse] part
  // !
  @override
  X509Certificate? get certificate => raw.certificate;
  @override
  HttpClientResponseCompressionState get compressionState =>
      raw.compressionState;
  @override
  HttpConnectionInfo? get connectionInfo => raw.connectionInfo;
  @override
  List<Cookie> get cookies => raw.cookies;
  @override
  bool get isRedirect => raw.isRedirect;
  @override
  bool get persistentConnection => raw.persistentConnection;
  @override
  String get reasonPhrase => raw.reasonPhrase;
  @override
  List<RedirectInfo> get redirects => raw.redirects;
  @override
  int get statusCode => raw.statusCode;
  @override
  Future<HttpClientResponse> redirect([
    String? method,
    Uri? url,
    bool? followLoops,
  ]) =>
      raw.redirect(method, url, followLoops);
  @override
  Future<Socket> detachSocket() => raw.detachSocket();

  // !
  // ! Wrappers of [Stream] part
  // !
  @override
  Future<int> get length => raw.length;
  @override
  Future<bool> any(bool Function(List<int> element) test) => raw.any(test);
  @override
  Stream<List<int>> asBroadcastStream({
    void Function(StreamSubscription<List<int>> subscription)? onListen,
    void Function(StreamSubscription<List<int>> subscription)? onCancel,
  }) =>
      raw.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(List<int> event) convert) =>
      raw.asyncExpand<E>(convert);
  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(List<int> event) convert) =>
      raw.asyncMap<E>(convert);
  @override
  Stream<R> cast<R>() => raw.cast<R>();
  @override
  Future<bool> contains(Object? needle) => raw.contains(needle);
  @override
  Stream<List<int>> distinct([
    bool Function(List<int> previous, List<int> next)? equals,
  ]) =>
      raw.distinct(equals);
  @override
  Future<E> drain<E>([E? futureValue]) => raw.drain<E>(futureValue);
  @override
  Future<List<int>> elementAt(int index) => raw.elementAt(index);
  @override
  Future<bool> every(bool Function(List<int> element) test) => raw.every(test);
  @override
  Stream<S> expand<S>(Iterable<S> Function(List<int> element) convert) =>
      raw.expand<S>(convert);
  @override
  Future<List<int>> get first => raw.first;
  @override
  Future<List<int>> firstWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) =>
      raw.firstWhere(test, orElse: orElse);
  @override
  Future<S> fold<S>(
    S initialValue,
    S Function(S previous, List<int> element) combine,
  ) =>
      raw.fold<S>(initialValue, combine);
  @override
  Future forEach(void Function(List<int> element) action) =>
      raw.forEach(action);
  @override
  Stream<List<int>> handleError(
    Function onError, {
    bool Function(dynamic error)? test,
  }) =>
      raw.handleError(onError, test: test);
  @override
  bool get isBroadcast => raw.isBroadcast;
  @override
  Future<bool> get isEmpty => raw.isEmpty;
  @override
  Future<String> join([String separator = '']) => raw.join(separator);
  @override
  Future<List<int>> get last => raw.last;
  @override
  Future<List<int>> lastWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) =>
      raw.lastWhere(test, orElse: orElse);
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      raw.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
  @override
  Stream<S> map<S>(S Function(List<int> event) convert) => raw.map<S>(convert);
  @override
  Future pipe(StreamConsumer<List<int>> streamConsumer) =>
      raw.pipe(streamConsumer);
  @override
  Future<List<int>> reduce(
    List<int> Function(List<int> previous, List<int> element) combine,
  ) =>
      raw.reduce(combine);
  @override
  Future<List<int>> get single => raw.single;
  @override
  Future<List<int>> singleWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) =>
      raw.singleWhere(test, orElse: orElse);
  @override
  Stream<List<int>> skip(int count) => raw.skip(count);
  @override
  Stream<List<int>> skipWhile(bool Function(List<int> element) test) =>
      raw.skipWhile(test);
  @override
  Stream<List<int>> take(int count) => raw.take(count);
  @override
  Stream<List<int>> takeWhile(bool Function(List<int> element) test) =>
      raw.takeWhile(test);
  @override
  Stream<List<int>> timeout(
    Duration timeLimit, {
    void Function(EventSink<List<int>> sink)? onTimeout,
  }) =>
      raw.timeout(timeLimit, onTimeout: onTimeout);
  @override
  Future<List<List<int>>> toList() => raw.toList();
  @override
  Future<Set<List<int>>> toSet() => raw.toSet();
  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) =>
      raw.transform(streamTransformer);
  @override
  Stream<List<int>> where(bool Function(List<int> event) test) =>
      raw.where(test);
}
