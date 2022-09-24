void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

String prettify(String itemName) {
  String prettyName = itemName.split('-').join(' ');
  return prettyName[0].toUpperCase() + prettyName.substring(1);
}

String cutZeros(num x) {
  if (x == 0) return '0';
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  return x.toStringAsFixed(2).replaceAll(regex, '');
}
