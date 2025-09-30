import 'package:gsheets/gsheets.dart';

class ExcelApi {
  static const _sheetId = "YOUR_GOOGLE_SHEETS_ID_HERE";
  
  // TODO: Replace with your own Google Cloud Service Account credentials
  // Store credentials securely in environment variables or config files
  // Never commit real credentials to version control
  static const _credential = r'''{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "your-private-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n",
  "client_email": "your-service-account@your-project.iam.gserviceaccount.com",
  "client_id": "your-client-id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-service-account%40your-project.iam.gserviceaccount.com"
}''';

  static Worksheet? _sheet;

  // Create custom function init to initialization
  static Future init() async {
    try {
      final gsheets = GSheets(_credential);
      final spreadsheet = await gsheets.spreadsheet(_sheetId);
      _sheet = await _getWorkSheet(spreadsheet, title: "UserInputModel");

      final firstRow = ['Names', 'Email']; // Using the correct field names
      _sheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Error initializing ExcelApi: $e');
      // For now, we'll just print the error and continue
      // In production, you might want to handle this differently
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    try {
      if (_sheet == null) {
        print('ExcelApi not initialized. Please call ExcelApi.init() first.');
        return;
      }

      await _sheet!.values.map.appendRows(rowList);
      print('Successfully inserted ${rowList.length} rows to Excel sheet');
    } catch (e) {
      print('Error inserting data to Excel: $e');
      // For now, we'll just print the error
      // In production, you might want to handle this differently
    }
  }
}

// Example model class (replace with your actual model)
class UserInputModel {
  final String? name;
  final String? email;

  UserInputModel({this.name, this.email});

  static List<String> getFields() => ['Name', 'Email'];

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Email': email,
      };
}
