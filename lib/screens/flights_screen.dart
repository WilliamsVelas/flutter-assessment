import 'package:flutter/material.dart';
import 'package:flutter_assessment/models/flights.dart';
import 'package:flutter_assessment/providers/flights_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Flights extends StatefulWidget {
  @override
  State<Flights> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
  String selectedAirline = 'All';
  double? maxPrice;

  @override
  void initState() {
    final provider = Provider.of<FlightsProvider>(context, listen: false);
    provider.getDataFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlightsProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Flights',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          backgroundColor: colorScheme.primary,
          iconTheme: IconThemeData(color: colorScheme.onPrimary),
        ),
        body: provider.isLoading
            ? loadingScreen()
            : provider.error.isNotEmpty
                ? errorScreen(provider.error)
                : Column(
                    children: [
                      filterSection(provider),
                      Expanded(
                          child: flightsListScreen(provider.flights.itineraries,
                              provider.flights.legs))
                    ],
                  ));
  }

  Widget loadingScreen() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          const Text('Loading...', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget errorScreen(String error) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }

  Widget filterSection(FlightsProvider provider) {
    final airlines = [
      'All',
      ...provider.flights.itineraries
          .map((itinerary) => itinerary.agent)
          .toSet()
    ];

    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedAirline,
                  onChanged: (value) {
                    setState(() {
                      selectedAirline = value!;
                    });
                  },
                  items: airlines
                      .map((airline) => DropdownMenuItem(
                            value: airline,
                            child: Text(airline),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      maxPrice = double.tryParse(value);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget flightsListScreen(List<Itinerary> itineraries, List<Leg> legs) {
    final colorScheme = Theme.of(context).colorScheme;

    final filteredItineraries = itineraries.where((itinerary) {
      final isPriceValid = maxPrice == null ||
          double.parse(itinerary.price.replaceAll('£', '')) <= maxPrice!;
      final isAirlineValid =
          selectedAirline == 'All' || itinerary.agent == selectedAirline;
      return isPriceValid && isAirlineValid;
    }).toList();

    return ListView.builder(
      itemCount: filteredItineraries.length,
      itemBuilder: (context, index) {
        final itinerary = filteredItineraries[index];
        final itineraryLegs =
            legs.where((leg) => itinerary.legs.contains(leg.id)).toList();

        return Card(
          color: colorScheme.surface,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              'Flight ${itinerary.id}',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Price: ${itinerary.price} - Agent: ${itinerary.agent}',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
