import '../../domain/entities/asset.dart';

class AssetMockDataSource {
  static List<Asset> getAssets() {
    return [
      const Asset(
        id: 1,
        assetId: "V001",
        name: "Volvo FH16",
        registrationNumber: "T 123 ABC",
        status: "Moving",
        latitude: -6.7924,
        longitude: 39.2083,
        speed: 65,
        heading: 180,
        address: "Bagamoyo Rd, Dar es Salaam",
        lastTransmit: "2024-03-24T10:30:00Z",
        ignition: true,
      ),
      const Asset(
        id: 2,
        assetId: "V002",
        name: "Scania R500",
        registrationNumber: "T 456 DEF",
        status: "Stopped",
        latitude: -6.8235,
        longitude: 39.2678,
        speed: 0,
        heading: 45,
        address: "Kariakoo, Dar es Salaam",
        lastTransmit: "2024-03-24T10:28:00Z",
        ignition: false,
      ),
    ];
  }
}