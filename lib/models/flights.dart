// To parse this JSON data, do
//
//     final flights = flightsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Flights flightsFromJson(String str) => Flights.fromJson(json.decode(str));

String flightsToJson(Flights data) => json.encode(data.toJson());

class Flights {
  final List<Itinerary> itineraries;
  final List<Leg> legs;

  Flights({
    required this.itineraries,
    required this.legs,
  });

  factory Flights.fromJson(Map<String, dynamic> json) => Flights(
    itineraries: (json["itineraries"] as List<dynamic>?)
        ?.map((x) => Itinerary.fromJson(x))
        .toList() ??
        [],
    legs: (json["legs"] as List<dynamic>?)
        ?.map((x) => Leg.fromJson(x))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    "itineraries": itineraries.map((x) => x.toJson()).toList(),
    "legs": legs.map((x) => x.toJson()).toList(),
  };
}

class Itinerary {
  final String id;
  final List<String> legs;
  final String price;
  final String agent;
  final double agentRating;

  Itinerary({
    required this.id,
    required this.legs,
    required this.price,
    required this.agent,
    required this.agentRating,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    id: json["id"] ?? '',
    legs: (json["legs"] as List<dynamic>?)
        ?.map((x) => x as String)
        .toList() ??
        [],
    price: json["price"] ?? 'N/A',
    agent: json["agent"] ?? 'Unknown',
    agentRating: (json["agent_rating"] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "legs": legs,
    "price": price,
    "agent": agent,
    "agent_rating": agentRating,
  };
}

class Leg {
  final String id;
  final String departureAirport;
  final String arrivalAirport;
  final String departureTime;
  final String arrivalTime;
  final int stops;
  final String airlineName;
  final String airlineId;
  final int durationMins;

  Leg({
    required this.id,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.stops,
    required this.airlineName,
    required this.airlineId,
    required this.durationMins,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    id: json["id"] ?? '',
    departureAirport: json["departure_airport"] ?? 'Unknown',
    arrivalAirport: json["arrival_airport"] ?? 'Unknown',
    departureTime: json["departure_time"] ?? '',
    arrivalTime: json["arrival_time"] ?? '',
    stops: json["stops"] ?? 0,
    airlineName: json["airline_name"] ?? 'Unknown',
    airlineId: json["airline_id"] ?? '',
    durationMins: json["duration_mins"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "departure_airport": departureAirport,
    "arrival_airport": arrivalAirport,
    "departure_time": departureTime,
    "arrival_time": arrivalTime,
    "stops": stops,
    "airline_name": airlineName,
    "airline_id": airlineId,
    "duration_mins": durationMins,
  };
}