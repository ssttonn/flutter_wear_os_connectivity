extension ListExtension<T> on List<T> {
  List<T> addBetweenItems(T item) {
    var items = <T>[];
    asMap().forEach((index, value) {
      if (index == length - 1) {
        items.add(value);
      } else {
        items.addAll([value, item]);
      }
    });
    return items;
  }
}
