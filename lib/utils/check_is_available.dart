bool isAvailable(availableTill) {
  var now = DateTime.now();
  var availableTillDate = DateTime.parse(availableTill);
  return now.isBefore(availableTillDate);
}