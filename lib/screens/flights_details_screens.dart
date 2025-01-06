import 'package:flutter_assessment/models/flights.dart';
import 'package:flutter/material.dart';

class FlightDetails extends StatelessWidget {
  final Itinerary itinerary;
  final List<Leg> legs;

  const FlightDetails({
    required this.itinerary,
    required this.legs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flight Details ${itinerary.id}',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price: ${itinerary.price}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            AgentInfoRow(itinerary: itinerary),
            const SizedBox(height: 16),
            const Text(
              'Legs:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: legs.length,
                itemBuilder: (context, index) {
                  final leg = legs[index];
                  return Card(
                    color: colorScheme.surface,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: ListTile(
                      title: Text(
                        '${leg.departureAirport} -> ${leg.arrivalAirport}',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration: ${leg.durationMins} mins',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Stops: ${leg.stops}',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Airline: ${leg.airlineName}',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Departure: ${leg.departureTime}',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Arrival: ${leg.arrivalTime}',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
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

class AgentInfoRow extends StatelessWidget {
  const AgentInfoRow({
    super.key,
    required this.itinerary,
  });

  final Itinerary itinerary;



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          itinerary.agent,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 8),
        Card(
          color: Colors.green[50],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '${itinerary.agentRating}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }
}