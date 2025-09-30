import 'package:Kootumb/models/excel_entry_model.dart';

class UserInput {
  final String? name;
  final String? email;

  const UserInput({this.name, this.email});

  Map<String, dynamic> toJson() => {
        Entries.name: name,
        Entries.email: email,
      };

  // Keep the old method for backward compatibility
  Map<String, dynamic> tojson() => toJson();
}
