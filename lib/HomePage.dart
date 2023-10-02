import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'EventPage.dart';
import 'SearchPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl =
      'https://sde-007.api.assignment.theinternetfolks.works/v1/event';

  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data is Map<String, dynamic> &&
            data.containsKey('content') &&
            data['content'] is Map<String, dynamic> &&
            data['content'].containsKey('data') &&
            data['content']['data'] is List<dynamic>) {
          return data['content']['data'];
        } else {
          print('Invalid data format');
          return [];
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              size: 30.0,
            ),
            onPressed: () {
              // Reload data when pressing the more_vert icon
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(
              child: Text('No events available'),
            );
          } else {
            List<dynamic> eventDataList = snapshot.data as List;

            return SingleChildScrollView(
              child: Column(
                children: eventDataList
                    .map((event) => buildEventCard(context, event))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildEventCard(BuildContext context, dynamic event) {
    final organiserIcon = event['organiser_icon'];
    final dateTime = event['date_time'];
    final formattedDateTime =
        DateFormat('EEE, MMM dd • hh:mm a').format(DateTime.parse(dateTime));
    final title = event['title'];
    final venueName = event['venue_name'];
    final venueCity = event['venue_city'];
    final venueCountry = event['venue_country'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (organiserIcon.isNotEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  height: MediaQuery.of(context).size.width * 0.18,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      organiserIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 2.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        formattedDateTime,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                      const SizedBox(height: 4.1),
                      Text(
                        '$title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                      const SizedBox(height: 9.8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.place_rounded,
                            color: Colors.grey,
                            size: 16.0,
                          ),
                          const SizedBox(width: 6.0),
                          Flexible(
                            child: Text(
                              '$venueName • $venueCity, $venueCountry',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 140, 134, 134),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.031,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
