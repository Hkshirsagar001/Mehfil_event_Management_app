import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  final String apiKey = 'tMeIvUfmI19Rr0mcH2ERFn8NPvDzRNce'; // Replace with your actual API key

  Future<List<Map<String, String>>> fetchEvents(String location) async {
    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json?city=$location&apikey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final events = data['_embedded']['events'] as List;
      return events.map((event) {
        return {
          'name': event['name'] as String,
          'date': event['dates']['start']['localDate'] as String,
          'location': event['_embedded']['venues'][0]['name'] as String,
          'image': event['images'][0]['url'] as String,
        };
      }).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
