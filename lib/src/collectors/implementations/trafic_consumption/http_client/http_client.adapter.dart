// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';

class HttpClientRequestResponse {
  const HttpClientRequestResponse(this.request, this.response);

  final HttpClientRequestExtended request;
  final HttpClientResponseExtended response;

  FutureOr<int> get totalLength async =>
      request.totalContentLength + await response.totalContentLength;
}

class HttpClientTrafficConsumptionAdapter
    implements TrafficConsumptionAdapter<HttpClientRequestResponse> {
  const HttpClientTrafficConsumptionAdapter(this.value);

  @override
  final HttpClientRequestResponse value;

  @override
  FutureOr<int> get contentLength => value.totalLength;
}
