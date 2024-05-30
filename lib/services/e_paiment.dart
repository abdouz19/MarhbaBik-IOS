import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl =
      'https://devapi.slick-pay.com/api/v2/users/transfers/commission';
  static const String _authToken =
      '48|e38u499dLrh94cPipLkranYXjHdUjWGsbEb9o2ud';

  Future<Map<String, dynamic>> calculateCommission(int amount) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'amount': amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == 1) {
          return {
            'success': true,
            'amount': data['amount'],
            'commission': data['commission'],
          };
        } else {
          throw Exception('Failed to calculate commission: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to calculate commission: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to calculate commission: $e');
    }
  }
}
