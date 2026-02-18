List<String> uniqueOptions(List<String> options) {
  final seen = <String>{};
  final result = <String>[];
  for (final o in options) {
    if (seen.add(o)) result.add(o);
  }
  return result;
}
