import 'package:flutter/material.dart';

class FootprintCalculator extends StatefulWidget {
  const FootprintCalculator({Key? key}) : super(key: key);

  @override
  _FootprintCalculatorState createState() => _FootprintCalculatorState();
}

class _FootprintCalculatorState extends State<FootprintCalculator> {
  // Define options for each dropdown
  List<String> transportationOptions = [
    "Car",
    "Bicycle",
    "Public Transportation"
  ];
  List<String> foodConsumptionOptions = ["Omnivorous", "Vegetarian", "Vegan"];
  List<String> energyUsageOptions = [
    "Electricity",
    "Natural Gas",
    "Renewable Energy"
  ];
  List<String> wasteProducedOptions = ["Low", "Medium", "High"];
  List<String> travelLeisureOptions = ["Rarely", "Occasionally", "Frequently"];

  // Selected values from dropdowns
  String selectedTransportation = "";
  String selectedFoodConsumption = "";
  String selectedEnergyUsage = "";
  String selectedWasteProduced = "";
  String selectedTravelLeisure = "";
  double distanceTraveled = 0.0;

  // Result of the carbon footprint calculation
  double carbonFootprintResult = 0.0;

  // Function to calculate the carbon footprint
  double calculateCarbonFootprint({
    required double transportationInput,
    required double foodConsumptionInput,
    required double energyUsageInput,
    required double wasteProducedInput,
    required double travelLeisureInput,
  }) {
    double transportationFactor = getTransportationEmissionFactor(
        selectedTransportation, distanceTraveled);
    double foodConsumptionFactor = getFoodEmissionFactor(foodConsumptionInput);
    double energyUsageFactor = getEnergyEmissionFactor(energyUsageInput);
    double wasteProducedFactor = getWasteEmissionFactor(wasteProducedInput);
    double travelLeisureFactor =
    getTravelLeisureEmissionFactor(travelLeisureInput);

    // Calculate carbon footprint for each category
    double transportationFootprint =
        transportationInput * transportationFactor;
    double foodConsumptionFootprint =
        foodConsumptionInput * foodConsumptionFactor;
    double energyUsageFootprint = energyUsageInput * energyUsageFactor;
    double wasteProducedFootprint = wasteProducedInput * wasteProducedFactor;
    double travelLeisureFootprint = travelLeisureInput * travelLeisureFactor;

    // Calculate total carbon footprint
    double totalCarbonFootprint = transportationFootprint +
        foodConsumptionFootprint +
        energyUsageFootprint +
        wasteProducedFootprint +
        travelLeisureFootprint;

    return totalCarbonFootprint;
  }

  double getTransportationEmissionFactor(
      String selectedTransportation, double distanceTraveled) {
    switch (selectedTransportation) {
      case "Car":
        return 226 * distanceTraveled; // Car (g CO2e/km)
      case "Bicycle":
        return 16 * distanceTraveled; // Bicycle (g CO2e/km)
      case "Public Transportation":
        return 51 * distanceTraveled; // Public Transportation (g CO2e/km)
      default:
        return 0.0;
    }
  }

  double getFoodEmissionFactor(double foodConsumptionInput) {
    switch (foodConsumptionInput.toInt()) {
      case 1:
        return 5.3; // Omnivorous (kg CO2e/day)
      case 2:
        return 3.8; // Vegetarian (kg CO2e/day)
      case 3:
        return 2.9; // Vegan (kg CO2e/day)
      default:
        return 0.0;
    }
  }

  double getEnergyEmissionFactor(double energyUsageInput) {
    switch (energyUsageInput.toInt()) {
      case 1:
        return 0.3; // Electricity (g CO2e/kWh)
      case 2:
        return 0.2; // Natural Gas (g CO2e/kWh)
      case 3:
        return 0.0; // Renewable Energy (g CO2e/kWh) - Assume zero emissions for simplicity
      default:
        return 0.0;
    }
  }

  double getWasteEmissionFactor(double wasteProducedInput) {
    switch (wasteProducedInput.toInt()) {
      case 1:
        return 0.15; // Low (kg CO2e/day)
      case 2:
        return 0.1; // Medium (kg CO2e/day)
      case 3:
        return 0.05; // High (kg CO2e/day)
      default:
        return 0.0;
    }
  }

  double getTravelLeisureEmissionFactor(double travelLeisureInput) {
    switch (travelLeisureInput.toInt()) {
      case 1:
        return 0.25; // Rarely (kg CO2e/day)
      case 2:
        return 0.15; // Occasionally (kg CO2e/day)
      case 3:
        return 0.1; // Frequently (kg CO2e/day)
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Footprints Calculator",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdowns for each category
              buildDropdown(
                "Transportation",
                transportationOptions,
                selectedTransportation,
              ),
              buildDistanceInput(),
        
              buildDropdown(
                "Food Consumption",
                foodConsumptionOptions,
                selectedFoodConsumption,
              ),
              buildDropdown(
                "Energy Usage",
                energyUsageOptions,
                selectedEnergyUsage,
              ),
              buildDropdown(
                "Waste Produced",
                wasteProducedOptions,
                selectedWasteProduced,
              ),
              buildDropdown(
                "Travel and Leisure",
                travelLeisureOptions,
                selectedTravelLeisure,
              ),
        
              SizedBox(height: 20),
        
              // Calculate button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    carbonFootprintResult = calculateCarbonFootprint(
                      transportationInput: transportationOptions.indexOf(
                          selectedTransportation) +
                          1.0,
                      foodConsumptionInput: foodConsumptionOptions.indexOf(
                          selectedFoodConsumption) +
                          1.0,
                      energyUsageInput: energyUsageOptions.indexOf(
                          selectedEnergyUsage) +
                          1.0,
                      wasteProducedInput: wasteProducedOptions.indexOf(
                          selectedWasteProduced) +
                          1.0,
                      travelLeisureInput: travelLeisureOptions.indexOf(
                          selectedTravelLeisure) +
                          1.0,
                    );
                  });
                },
                child: Text("Calculate Carbon Footprint"),
              ),
        
              SizedBox(height: 20),
        
              // Display the result
              SizedBox(height: 10),
              Text(
                "Total Emission: ${carbonFootprintResult.toStringAsFixed(
                    2)} MT CO2e",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build dropdowns
  Widget buildDropdown(String label, List<String> options, String selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        DropdownButton<String>(
          value: selectedValue.isEmpty ? null : selectedValue,
          onChanged: (value) {
            setState(() {
              switch (label) {
                case "Transportation":
                  selectedTransportation = value!;
                  break;
                case "Food Consumption":
                  selectedFoodConsumption = value!;
                  break;
                case "Energy Usage":
                  selectedEnergyUsage = value!;
                  break;
                case "Waste Produced":
                  selectedWasteProduced = value!;
                  break;
                case "Travel and Leisure":
                  selectedTravelLeisure = value!;
                  break;
              }
            });
          },
          items: [
            DropdownMenuItem<String>(
              value: "",
              child:
              Text("Select an option"), // Add this line for initial hint
            ),
            ...options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Helper method to build distance input field
  Widget buildDistanceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Distance Traveled (km)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              distanceTraveled = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
