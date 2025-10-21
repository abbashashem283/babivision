class Ustring {
  static String initials(String name) {
    if (name.isEmpty) return '';

    // Split the name by spaces
    final words = name.trim().split(" ");

    // Take the first character of each word and uppercase it
    final initials = words.map((word) => word[0].toUpperCase()).join();

    return initials;
  }
}
