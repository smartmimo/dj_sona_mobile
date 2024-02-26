extension DateTimeExtensions on DateTime {
  bool isBeforeOrSame(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  bool isAfterOrSame(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }

  bool isWithin(DateTime? earlierDate, DateTime? laterDate) {
    if (earlierDate == null && laterDate == null) return true;
    if (earlierDate == null) return isBeforeOrSame(laterDate!);
    if (laterDate == null) return isAfterOrSame(earlierDate);
    return isAfterOrSame(earlierDate) && isBeforeOrSame(laterDate);
  }
}
