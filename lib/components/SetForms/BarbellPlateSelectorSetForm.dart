import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:provider/provider.dart';

class BarbellPlateSelectorSetForm extends StatefulWidget {
  final int initalWeight;
  final int initialReps;
  final void Function(int) onWeightChanged;
  final void Function(int) onRepsChanged;
  const BarbellPlateSelectorSetForm(
      {Key key,
      this.initalWeight,
      this.initialReps,
      this.onRepsChanged,
      this.onWeightChanged})
      : super(key: key);

  @override
  _BarbellPlateSelectorSetFormState createState() =>
      _BarbellPlateSelectorSetFormState();
}

class BarbellWeightNotifier extends ChangeNotifier {
  int weight;
  List<String> _weights = ['45', '35', '25', '10', '5', '2.5'];
  Map<String, int> plateAmounts = {
    '45': 0,
    '35': 0,
    '25': 0,
    '10': 0,
    '5': 0,
    '2.5': 0,
  };
  List<String> allPlatesList = [];
  List<String> quantizedPlatesList = [];

  BarbellWeightNotifier({this.weight}) {
    _calculatePlateAmounts();
    _generateLists();
  }

  void setWeight(int weight) {
    this.weight = weight;
    _calculatePlateAmounts();
    _generateLists();
    notifyListeners();
  }

  void addPlate(String weight) {
    plateAmounts[weight] += 1;
    _generateLists();
    _calculateWeight();
    notifyListeners();
  }

  void clear() {
    _weights.forEach((weight) {
      plateAmounts[weight] = 0;
    });
    _generateLists();
    _calculateWeight();
    notifyListeners();
  }

  void _calculatePlateAmounts() {
    if (weight < 45) weight = 45;
    int plateWeight = weight - 45;
    double persideWeight = plateWeight.toDouble() / 2.0;
    int fourtyFivesCount = persideWeight ~/ 45;
    persideWeight -= (fourtyFivesCount * 45);
    int thirtyFivesCount = persideWeight ~/ 35;
    persideWeight -= (thirtyFivesCount * 35);
    int twentyFivesCount = persideWeight ~/ 25;
    persideWeight -= (twentyFivesCount * 25);
    int tensCount = persideWeight ~/ 10;
    persideWeight -= (tensCount * 10);
    int fivesCount = persideWeight ~/ 5;
    persideWeight -= (fivesCount * 5);
    int twoPointFivesCount = persideWeight ~/ 2.5;

    plateAmounts['45'] = fourtyFivesCount;
    plateAmounts['35'] = thirtyFivesCount;
    plateAmounts['25'] = twentyFivesCount;
    plateAmounts['10'] = tensCount;
    plateAmounts['5'] = fivesCount;
    plateAmounts['2.5'] = twoPointFivesCount;
  }

  void _calculateWeight() {
    weight = 45;
    for (String weightString in _weights) {
      int quantity = plateAmounts[weightString] * 2;
      weight += (quantity * double.parse(weightString)).toInt();
    }
  }

  void _generateLists() {
    allPlatesList.clear();
    quantizedPlatesList.clear();
    _weights.forEach((weight) {
      allPlatesList
          .addAll(List.generate(plateAmounts[weight], (index) => weight));
      int quantity = plateAmounts[weight];
      if (quantity > 0) {
        quantizedPlatesList.add('$quantity x $weight');
      }
    });
  }
}

class _BarbellPlateSelectorSetFormState
    extends State<BarbellPlateSelectorSetForm> {
  List<String> weights = ['45', '35', '25', '10', '5', '2.5'];
  Map<String, int> plateAmounts = {};
  List<String> plateCountStrings = [];
  TextEditingController barweightTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BarbellWeightNotifier(weight: widget.initalWeight),
      child: Consumer<BarbellWeightNotifier>(
          builder: (context, barbellWeight, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            weightAndReps(barbellWeight, barweightTextController),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: button(
                                    text: 'Clear Weight',
                                    onPressed: () {
                                      barbellWeight.clear();
                                      barweightTextController.text =
                                          '${barbellWeight.weight}';
                                      widget.onWeightChanged(barbellWeight.weight);
                                    }),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: ListView(
                                      physics: ClampingScrollPhysics(),
                                      children: [
                                            text('Each side',
                                                textAlign: TextAlign.center),
                                            SizedBox(height: 10)
                                          ] +
                                          ((barbellWeight.quantizedPlatesList
                                                      .length ==
                                                  0)
                                              ? [
                                                  text('No plates added',
                                                      textAlign:
                                                          TextAlign.center)
                                                ]
                                              : barbellWeight
                                                  .quantizedPlatesList
                                                  .map((item) => text(item,
                                                      textAlign:
                                                          TextAlign.center))
                                                  .toList())),
                                ),
                              ),
                            )
                          ],
                        ),
                        height: constraints.maxHeight / 2),
                    Container(
                      height: constraints.maxHeight / 2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: weights.map((weight) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: text(weight),
                                  width: constraints.maxHeight / 4,
                                  height: constraints.maxHeight / 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade600.withAlpha(50),
                                    border:
                                        Border.all(color: Colors.grey.shade600),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          constraints.maxHeight / 8),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  barbellWeight.addPlate(weight);
                                  barweightTextController.text =
                                      '${barbellWeight.weight}';
                                  widget.onWeightChanged(barbellWeight.weight);
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                );
              }),
            )
          ],
        );
      }),
    );
  }

  Widget barbell() {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;
      return Container(
        //color: Colors.red,
        height: height,
        width: width,
        child: Consumer<BarbellWeightNotifier>(
            builder: (context, barbellWeight, child) {
          List<String> plateStrings =
              getBarbellPlateAmounts(barbellWeight.weight);
          double start = 70;
          double plateWidth = 30;
          double fullPlateHeight = 200;
          double fiveHeight = 100;
          double twoPointFiveHeight = 50;
          List<Positioned> plates = [];
          for (var i = 0; i < plateStrings.length; i++) {
            double plateHeight;
            Color plateColor;
            switch (plateStrings[i]) {
              case '45':
                plateHeight = fullPlateHeight;
                plateColor = Colors.blue;
                break;
              case '25':
                plateHeight = fullPlateHeight;
                plateColor = Colors.green;
                break;
              case '10':
                plateHeight = fullPlateHeight;
                plateColor = Colors.grey.shade800;
                break;
              case '5':
                plateHeight = fiveHeight;
                plateColor = Colors.black;
                break;
              case '2.5':
                plateHeight = twoPointFiveHeight;
                plateColor = Colors.black;
                break;
              default:
            }
            plates.add(
              Positioned(
                right: start + plateWidth * i,
                top: height / 2 - plateHeight / 2,
                child: Container(
                  height: plateHeight,
                  width: plateWidth,
                  decoration: BoxDecoration(
                    color: plateColor,
                    border: Border.all(color: Colors.white, width: 0.5),
                  ),
                ),
              ),
            );
          }
          return Stack(
            children: [
                  Positioned(
                    right: 0,
                    top: height / 2 - 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      height: 20,
                      width: 50,
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: height / 2 - 25,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      height: 50,
                      width: 20,
                    ),
                  ),
                  Positioned(
                    right: 70,
                    top: height / 2 - 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      height: 30,
                      width: 250,
                    ),
                  ),
                ] +
                plates,
          );
        }),
      );
    });
  }

  Widget weightAndReps(BarbellWeightNotifier barbellWieght,
      TextEditingController barWeightTextController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: ScrollableValuePicker(
            value: barbellWieght.weight,
            textController: barWeightTextController,
            increment: 5,
            onValueChanged: (value) {
              barbellWieght.setWeight(value);
              widget.onWeightChanged(barbellWieght.weight);
            },
          ),
        ),
        Container(
          width: 40,
          child: text('x', textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 1,
          child: ScrollableValuePicker(
            value: widget.initialReps,
            increment: 1,
            onValueChanged: widget.onRepsChanged,
          ),
        ),
      ],
    );
  }

  List<String> getBarbellPlateAmounts(int value) {
    if (value <= 45) return [];
    print(value);
    int plateWeight = value - 45;
    double persideWeight = plateWeight.toDouble() / 2.0;
    int fourtyFivesCount = persideWeight ~/ 45;
    persideWeight -= (fourtyFivesCount * 45);
    int twentyFivesCount = persideWeight ~/ 25;
    persideWeight -= (twentyFivesCount * 25);
    int tensCount = persideWeight ~/ 10;
    persideWeight -= (tensCount * 10);
    int fivesCount = persideWeight ~/ 5;
    persideWeight -= (fivesCount * 5);
    int twoPointFivesCount = persideWeight ~/ 2.5;

    List<String> plates = [];
    plates.addAll(List.generate(fourtyFivesCount, (index) => '45'));
    plates.addAll(List.generate(twentyFivesCount, (index) => '25'));
    plates.addAll(List.generate(tensCount, (index) => '10'));
    plates.addAll(List.generate(fivesCount, (index) => '5'));
    plates.addAll(List.generate(twoPointFivesCount, (index) => '2.5'));

    return plates;
  }
}

class WeightSelector extends StatelessWidget {
  final int initialWeight;
  final Function(int) onValueChanged;
  const WeightSelector({Key key, this.initialWeight, this.onValueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableValuePicker(
      value: initialWeight,
      increment: 5,
      onValueChanged: (value) {
        onValueChanged(value);
        Provider.of<BarbellWeightNotifier>(context, listen: false)
            .setWeight(value);
      },
    );
  }
}
