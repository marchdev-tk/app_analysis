// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import '../traffic_consumption.collector.dart';

class HttpClientRequestResponse {
  const HttpClientRequestResponse(this.request, this.response);

  final HttpClientRequest request;
  final HttpClientResponse response;

  int get totalLength =>
      request.headers.contentLength +
      request.contentLength +
      response.headers.contentLength +
      response.contentLength;
}

class HttpClientTrafficConsumptionAdapter
    implements TrafficConsumptionAdapter<HttpClientRequestResponse> {
  const HttpClientTrafficConsumptionAdapter(this.value);

  @override
  final HttpClientRequestResponse value;

  @override
  int get contentLength => value.totalLength;
}
