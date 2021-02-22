/// Appends [value] to a copy of [list] if [value] is not `null` or empty and
/// returns it.
///
/// Returns the [list] if [value] is `null` or empty.
List<String> appendToList(List<String> list, String value) {
  if (value != null && value.isNotEmpty) {
    return List<String>.of(list ?? <String>[])..add(value);
  } else {
    return list;
  }
}

/// Removes the [index] from the [list] and returns it.
///
/// Returns the [list] if [index] is is out of bounds of the [list] or if the
/// [list] is `null`.
List<String> removeFromList(List<String> list, int index) {
  final List<String> updatedList = List<String>.of(list ?? <String>[]);

  if (index >= 0 && index < updatedList.length) {
    return updatedList..removeAt(index);
  } else {
    return list;
  }
}
