import 'package:flutter_assessment/models/flights.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'flights.db');

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE itineraries (
            id TEXT PRIMARY KEY,
            price TEXT,
            agent TEXT,
            agentRating REAL
          );
        ''');

        await db.execute('''
  CREATE TABLE legs (
    id TEXT PRIMARY KEY,
    itineraryId TEXT,
    departureAirport TEXT,
    arrivalAirport TEXT,
    departureTime TEXT,
    arrivalTime TEXT,
    stops INTEGER,
    airlineName TEXT,
    airlineId TEXT,
    durationMins INTEGER
  );
''');
      },
    );
    return database;
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('legs');
    await db.delete('itineraries');
  }

  Future<void> insertItinerariesAndLegs(Flights flights) async {
    final db = await instance.database;

    for (var leg in flights.legs) {
      await db.insert(
        'legs',
        {
          'id': leg.id,
          'departureAirport': leg.departureAirport,
          'arrivalAirport': leg.arrivalAirport,
          'departureTime': leg.departureTime,
          'arrivalTime': leg.arrivalTime,
          'stops': leg.stops,
          'airlineName': leg.airlineName,
          'airlineId': leg.airlineId,
          'durationMins': leg.durationMins,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var itinerary in flights.itineraries) {
      await db.insert(
        'itineraries',
        {
          'id': itinerary.id,
          'price': itinerary.price,
          'agent': itinerary.agent,
          'agentRating': itinerary.agentRating,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Flights> fetchItinerariesWithLegs() async {
    final db = await instance.database;

    final itineraries = await db.query('itineraries');

    final legs = await db.query('legs');

    final itineraryList = itineraries.map((itinerary) {
      final itineraryLegs = legs
          .where((leg) => leg['itineraryId'] == itinerary['id'])
          .map((leg) => leg['id'] as String)
          .toList();

      return Itinerary(
        id: (itinerary['id'] ?? '') as String,
        legs: itineraryLegs,
        price: (itinerary['price'] ?? 'N/A') as String,
        agent: (itinerary['agent'] ?? 'Unknown') as String,
        agentRating: (itinerary['agentRating'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();

    final legList = legs.map((leg) => Leg.fromJson(leg)).toList();

    return Flights(
      itineraries: itineraryList,
      legs: legList,
    );
  }
}
