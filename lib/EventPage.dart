import 'package:assignment_project/BookEvent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  EventDetailScreen(this.event);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    // Extracting event details
    final bannerImage = widget.event['banner_image'] ?? '';
    final date_time = widget.event['date_time'] ?? '';
    final DateTime eventDateTime = DateTime.parse(date_time);

    String formattedDateTime =
        DateFormat('dd MMMM, yyyy').format(eventDateTime);
    String dayOfWeek = DateFormat('EEEE').format(eventDateTime);
    String startTime = DateFormat('h:mma').format(eventDateTime);
    String endTime =
        DateFormat('h:mma').format(eventDateTime.add(const Duration(hours: 5)));
    String finalFormattedDateTime = '$dayOfWeek $startTime - $endTime';

    final title = widget.event['title'] ?? '';
    final organiser_name = widget.event['organiser_name'] ?? '';
    final description = widget.event['description'] ?? '';
    final venue_name = widget.event['venue_name'] ?? '';
    final venue_city = widget.event['venue_city'] ?? '';
    final venue_country = widget.event['venue_country'] ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width * 0.52,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Image.network(
                    bannerImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            toolbarHeight: 150,
            titleSpacing: 0.10,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text(
              'Event Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '$title',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 11),
                      Center(
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 15)),
                            const Icon(
                              Icons.density_medium_outlined,
                              size: 40,
                            ),
                            const SizedBox(width: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$organiser_name',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                                const Text(
                                  "organiser",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 23),
                      Row(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.calendar_month,
                                color: Colors.blue,
                                size: MediaQuery.of(context).size.width * 0.06,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDateTime,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.041,
                                ),
                              ),
                              const SizedBox(height: 13),
                              Text(
                                finalFormattedDateTime,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.040,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 17),
                      Row(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.place_rounded,
                                color: Colors.blue,
                                size: MediaQuery.of(context).size.width * 0.06,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$venue_name',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.041,
                                ),
                              ),
                              const SizedBox(height: 13),
                              Text(
                                '$venue_city, $venue_country',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.040,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About Event',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showFullDescription = !showFullDescription;
                              });
                            },
                            child: Text(
                              showFullDescription
                                  ? '$description'
                                  : '${description.substring(0, 30)}....Read more',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          if (description.length > 75)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showFullDescription = !showFullDescription;
                                });
                              },
                              child: Text(
                                showFullDescription ? 'Read less' : "",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BookedPageScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 106, 101, 245),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20),
                            Center(
                              child: Text(
                                'BOOK NOW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Color.fromARGB(255, 71, 66, 203),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
