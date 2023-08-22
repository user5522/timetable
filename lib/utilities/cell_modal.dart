import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CellModalData extends ChangeNotifier {
  var isDelete = false;

  void setIsDelete(bool newIsDelete) {
    isDelete = newIsDelete;
    notifyListeners();
  }
}

class AddCellModal extends StatefulWidget {
  final String time;
  final String day;

  final ScrollController scrollController;

  final String? existingCellLabel;
  final String? existingCellSubLabel;
  final Color? existingCellColor;

  final void Function(
    String newCellLabel,
    String newCellLocation,
    Color newCellColor,
  )? onCellSaved;

  const AddCellModal({
    Key? key,
    required this.time,
    required this.day,
    required this.scrollController,
    this.existingCellLabel,
    this.existingCellSubLabel,
    this.existingCellColor,
    this.onCellSaved,
  }) : super(key: key);

  @override
  AddCellModalState createState() => AddCellModalState();
}

class AddCellModalState extends State<AddCellModal> {
  final _formKey = GlobalKey<FormState>();

  String newCellLabel = '';
  String newCellLocation = '';
  Color newCellColor = Colors.black;

  @override
  void initState() {
    super.initState();
    newCellLabel = widget.existingCellLabel ?? '';
    newCellLocation = widget.existingCellSubLabel ?? '';
    newCellColor = widget.existingCellColor ?? Colors.black;
  }

  @override
  void didUpdateWidget(AddCellModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.existingCellLabel != widget.existingCellLabel ||
        oldWidget.existingCellSubLabel != widget.existingCellSubLabel ||
        oldWidget.existingCellColor != widget.existingCellColor) {
      setState(() {
        newCellLabel = widget.existingCellLabel ?? '';
        newCellLocation = widget.existingCellSubLabel ?? '';
        newCellColor = widget.existingCellColor ?? Colors.black;
      });
    }
  }

  ColorLabel findColorLabelFromColor(Color color) {
    final matchingColorLabel = ColorLabel.values.firstWhere(
      (colorLabel) => colorLabel.color == color,
      orElse: () {
        return ColorLabel.black;
      },
    );
    return matchingColorLabel;
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<ColorLabel>> colorEntries =
        <DropdownMenuEntry<ColorLabel>>[];
    for (final ColorLabel color in ColorLabel.values) {
      colorEntries.add(
        DropdownMenuEntry<ColorLabel>(value: color, label: color.label),
      );
    }
    final cellModalData = Provider.of<CellModalData>(context, listen: false);

     return SingleChildScrollView(
        controller: widget.scrollController,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: newCellLabel,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Subject*',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a Subject.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      newCellLabel = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: newCellLocation,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      newCellLocation = value;
                    });
                  },
                ),
                const SizedBox(height: 32.0),
                Row(
                  children: [
                    const Text('Color: '),
                    const Spacer(),
                    Row(
                      children: [
                        DropdownMenu<ColorLabel>(
                          width: 120,
                          label: const Text('Color'),
                          initialSelection:
                              findColorLabelFromColor(newCellColor),
                          dropdownMenuEntries: colorEntries,
                          onSelected: (value) {
                            setState(() {
                              newCellColor = value!.color;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Row(
                      children: [
                        if (widget.existingCellLabel != null)
                          TextButton(
                            onPressed: () {
                              cellModalData.isDelete = true;
                              Navigator.pop(context, null);
                            },
                            child: const Text('Delete'),
                          ),
                        if (widget.existingCellLabel != null)
                          const SizedBox(width: 10.0)
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        cellModalData.isDelete = false;
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final label = newCellLabel;
                          final location = newCellLocation;
                          final color = newCellColor;
                          widget.onCellSaved?.call(label, location, color);
                          Navigator.pop(context, label);
                        }
                      },
                      child: Text(
                        widget.existingCellLabel != null ? 'Save' : 'Create',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}

enum ColorLabel {
  white('White', Color(0xFFFFFFFF)),
  yellow('Yellow', Color(0xFFFFEB3B)),
  pink('Pink', Color(0xFFE91E63)),
  green('Green', Color(0xFF4CAF50)),
  blue('Blue', Color(0xFF2196f3)),
  purple('Purple', Color(0xFF673AB7)),
  grey('Grey', Color(0xFF9E9E9E)),
  brown('Brown', Color(0xFF795548)),
  orange('Orange', Color(0xFFFF5722)),
  red('Red', Color(0xF4FF3636)),
  black('Black', Color(0xFF000000));

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}
