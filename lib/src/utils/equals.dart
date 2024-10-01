// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO: move into separate package

class MdEquals {
  const MdEquals._();

  static bool map<T, U>(Map<T, U>? a, Map<T, U>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (final T key in a.keys) {
      final av = a[key];
      final bv = b[key];
      if (!b.containsKey(key)) {
        return false;
      }
      if (bv.runtimeType != av.runtimeType) {
        return false;
      }
      if (av is Map && bv is Map) {
        return map(av, bv);
      }
      if (av is List && bv is List) {
        return list(av, bv);
      }
      if (av is Set && bv is Set) {
        return set(av, bv);
      }
    }
    return true;
  }

  static bool list<T>(List<T>? a, List<T>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (int index = 0; index < a.length; index += 1) {
      final av = a[index];
      final bv = b[index];
      if (bv.runtimeType != av.runtimeType) {
        return false;
      }
      if (av is Map && bv is Map) {
        return map(av, bv);
      }
      if (av is List && bv is List) {
        return list(av, bv);
      }
      if (av is Set && bv is Set) {
        return set(av, bv);
      }
      if (av != bv) {
        return false;
      }
    }
    return true;
  }

  static bool set<T>(Set<T>? a, Set<T>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (final T av in a) {
      if (!b.contains(av)) {
        return false;
      }
    }
    return true;
  }
}

class MdHash {
  const MdHash._();

  static int _hash<T>(T item) {
    int hash = item.hashCode;

    if (item is Map) {
      hash = map(item);
    }
    if (item is List) {
      hash = list(item);
    }
    if (item is Set) {
      hash = set(item);
    }

    return hash;
  }

  static int map<T, U>(Map<T, U>? m) {
    if (m == null || m.isEmpty) {
      return 0;
    }

    int hash = 0;
    for (final key in m.keys) {
      final value = m[key];
      hash ^= _hash(key) ^ _hash(value);
    }

    return hash;
  }

  static int list<T>(List<T>? l) {
    if (l == null || l.isEmpty) {
      return 0;
    }

    int hash = 0;
    for (final value in l) {
      hash ^= _hash(value);
    }

    return hash;
  }

  static int set<T>(Set<T>? s) {
    if (s == null || s.isEmpty) {
      return 0;
    }

    int hash = 0;
    for (final value in s) {
      hash ^= _hash(value);
    }

    return hash;
  }
}
