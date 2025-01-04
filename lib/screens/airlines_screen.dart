import 'package:flutter_assessment/models/flights.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/flights_provider.dart';

class Airlines extends StatefulWidget {
  @override
  State<Airlines> createState() => _AirlinesState();
}

class _AirlinesState extends State<Airlines> {
  String selectedAirline = 'All';

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
            'Airlines',
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
                        child: airlinesListScreen(provider.flights.legs),
                      )
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
          SizedBox(height: 16),
          Text('Loading...', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget errorScreen(String error) {
    return Center(
      child: Text(
        error,
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }

  Widget filterSection(FlightsProvider provider) {
    final airlines = [
      'All',
      ...provider.flights.legs.map((legs) => legs.airlineName).toSet()
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget airlinesListScreen(List<Leg> legs) {
    final colorScheme = Theme.of(context).colorScheme;

    final filteredAirlines = legs.where((legs) {
      final isAirlineValid =
          selectedAirline == 'All' || legs.airlineName == selectedAirline;
      return isAirlineValid;
    }).toList();

    return ListView.builder(
      itemCount: filteredAirlines.length,
      itemBuilder: (context, index) {
        final leg = filteredAirlines[index];

        return Card(
          color: colorScheme.surface,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              'Airline: ${leg.airlineName}',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Departure: ${leg.departureAirport}',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            trailing: Text('${leg.stops} Stops', style: TextStyle(
              color: colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),),
            onTap: () {},
          ),
        );
      },
    );
  }
}