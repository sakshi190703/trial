class Entries {
  static const String name = "Names";
  static const String email = "Email";

  static List<String> getFields() => [name, email];

  // Keep the old method for backward compatibility
  static List<String> getfiels() => getFields();
}
