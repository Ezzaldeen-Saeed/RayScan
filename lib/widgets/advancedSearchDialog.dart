import 'package:flutter/material.dart';

class AdvancedSearchDialog extends StatelessWidget {
  final String? selectedGender;
  final String? selectedDisease;
  final RangeValues ageRange;
  final void Function(String? gender, String? disease, RangeValues range)
      onApply;
  final VoidCallback onReset;

  const AdvancedSearchDialog({
    super.key,
    required this.selectedGender,
    required this.selectedDisease,
    required this.ageRange,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    String? localGender = selectedGender;
    String? localDisease = selectedDisease;
    RangeValues localAgeRange = ageRange;

    return AlertDialog(
      title: Text('Advanced Search'),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  isExpanded: true,
                  value: localGender,
                  hint: Text('Select Gender'),
                  items: ['Male', 'Female']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      localGender = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  isExpanded: true,
                  value: localDisease,
                  hint: Text('Select Disease'),
                  items: [
                    'Fibrosis',
                    'Hernia',
                    'Effusion',
                    'Cardiomegaly',
                    'Atelectasis'
                  ]
                      .map((disease) => DropdownMenuItem(
                            value: disease,
                            child: Text(disease),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      localDisease = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                Text('Select Age Range:'),
                RangeSlider(
                  values: localAgeRange,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  labels: RangeLabels('${localAgeRange.start.round()}',
                      '${localAgeRange.end.round()}'),
                  onChanged: (values) {
                    setDialogState(() {
                      localAgeRange = values;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            onApply(localGender, localDisease, localAgeRange);
            Navigator.of(context).pop();
          },
          child: Text('Apply'),
        ),
        TextButton(
          onPressed: () {
            onReset();
            Navigator.of(context).pop();
          },
          child: Text('Reset'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
