import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'EventPage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final String apiUrl =
      'https://sde-007.api.assignment.theinternetfolks.works/v1/event';

  List<dynamic> allEventDataList = [];
  List<dynamic> filteredEventDataList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data is Map<String, dynamic> &&
            data.containsKey('content') &&
            data['content'] is Map<String, dynamic> &&
            data['content'].containsKey('data') &&
            data['content']['data'] is List<dynamic>) {
          setState(() {
            allEventDataList = data['content']['data'];
            filteredEventDataList = List.from(allEventDataList);
          });
        } else {
          print('Invalid data format');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void filterData(String query) {
    setState(() {
      filteredEventDataList = allEventDataList
          .where((event) =>
              event['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.black),
                onChanged: filterData,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.search,
                    color: Colors.blue,
                    size: 37,
                  ),
                  hintText: 'Type Event Name',
                  hintStyle: TextStyle(color: Colors.black26),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (allEventDataList.isEmpty)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (filteredEventDataList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEventDataList.length,
                  itemBuilder: (context, index) {
                    final event = filteredEventDataList[index];

                    final organiserIcon = event['organiser_icon'];
                    final dateTime = event['date_time'];
                    String formattedDateTime =
                        DateFormat('dd MMM - EEE - hh:mm a z')
                            .format(DateTime.parse(dateTime));
                    final title = event['title'];

                    return InkWell(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  height:
                                      MediaQuery.of(context).size.width * 0.18,
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
                                  padding: const EdgeInsets.only(left: 1.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        formattedDateTime,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                      ),
                                      const SizedBox(height: 15.1),
                                      Text(
                                        '$title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.064,
                                        ),
                                      ),
                                      const SizedBox(height: 13.8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
