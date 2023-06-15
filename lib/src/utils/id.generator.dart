// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

String generateRandomId() {
  const length = 32;
  const dictionary = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final buffer = StringBuffer();

  for (var i = 0; i < length; i++) {
    buffer.write(String.fromCharCode(
      dictionary.codeUnitAt(Random().nextInt(dictionary.length)),
    ));
  }

  return buffer.toString();
}
