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
  int selectedLegCount = 0;


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
                        child: airlinesListScreen(provider.flights.itineraries,provider.flights.legs),
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

  Widget filterSection(FlightsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of Legs',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Convertir el valor ingresado a un número entero
                      selectedLegCount = int.tryParse(value) ?? 0;
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


  Widget airlinesListScreen(List<Itinerary> itineraries, List<Leg> legs) {
    final colorScheme = Theme.of(context).colorScheme;

    final airlineLegCounts = <String, int>{};

    for (final itinerary in itineraries) {
      final airline = itinerary.agent;
      final legCount = itinerary.legs.length;

      airlineLegCounts[airline] = (airlineLegCounts[airline] ?? 0) + legCount;
    }

    final filteredAirlines = airlineLegCounts.entries.where((entry) {
      return selectedLegCount == 0 || entry.value == selectedLegCount;
    }).toList();

    return ListView.builder(
      itemCount: filteredAirlines.length,
      itemBuilder: (context, index) {
        final airline = filteredAirlines[index];

        return Card(
          color: colorScheme.surface,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              airline.key,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${airline.value} Legs',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }



}