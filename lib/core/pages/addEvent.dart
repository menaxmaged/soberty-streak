import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soberty_streak/core/utils/helper.dart';

class AddEventModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onEventAdded;

  const AddEventModal({super.key, required this.onEventAdded});

  @override
  State<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends State<AddEventModal> {
  final TextEditingController nameController = TextEditingController();
  DateTime _startDate = DateTime.now();
  Color _selectedColor = const Color(0xFFFF4500); // Default orange color

  void _addEvent(BuildContext context) {
    if (nameController.text.trim().isEmpty) {
      // Show a simple error message if the name is empty
      showCupertinoDialog(
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Event Name Required'),
              content: const Text('Please enter a name for your event.'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
      );
      return;
    }
    final newEvent = {
      "name": nameController.text.trim(),
      "dateString": DateFormat('yyyy-MM-dd').format(_startDate),
      "color": _selectedColor.value,
    };
    widget.onEventAdded(newEvent);
    Navigator.pop(context); // Close the modal after adding the event
  }

  Future<void> _showSelectDate(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                initialDateTime: _startDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _startDate = newDate;
                  });
                },
              ),
            ),
          ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 250, // Adjust as needed
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: CupertinoTheme(
              data: CupertinoThemeData(brightness: Brightness.dark),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Pick an Event Color',
                      style:
                          CupertinoTheme.of(
                            context,
                          ).textTheme.navTitleTextStyle,
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: _availableColors.length,
                      itemBuilder: (context, index) {
                        final color = _availableColors[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                            Navigator.pop(context); // Close the color picker
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: CupertinoColors.white,
                                width: _selectedColor == color ? 2 : 0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the color picker
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  final List<Color> _availableColors = [
    const Color(0xFFFF4500), // Orange
    const Color(0xFF007AFF), // Blue
    const Color(0xFF4CD964), // Green
    const Color(0xFFFFD600), // Yellow
    const Color(0xFF5856D6), // Purple
    const Color(0xFFFF2D55), // Red
    const Color(0xFF34AADC), // Light Blue
    const Color(0xFF5AC8FA), // Another Light Blue
    const Color(0xFF0CDCFE), // Cyan
    const Color(0xFF30D158), // Another Green
    const Color(0xFF8E8E93), // Gray
    const Color(0xFFC7C7CC), // Light Gray
    const Color(0xFFD1D1D6), // Another Light Gray
    const Color(0xFFFF9F0A), // Amber
    const Color(0xFFFA87C0), // Pink
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black, // Dark background
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: CupertinoColors.systemGrey),
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _addEvent(context),
          child: const Text(
            'Done',
            style: TextStyle(color: CupertinoColors.activeBlue),
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [BoxShadow(blurRadius: 8.0, offset: Offset(0, 4))],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CupertinoTextField(
                  controller: nameController,
                  placeholder: "Event Name",
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  style: const TextStyle(color: CupertinoColors.white),
                  placeholderStyle: const TextStyle(
                    color: CupertinoColors.systemGrey,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: CupertinoColors.systemGrey.withOpacity(0.4),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => _showSelectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: CupertinoColors.systemGrey.withOpacity(0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Date',
                          style: TextStyle(color: CupertinoColors.systemGrey),
                        ),
                        Text(
                          DateFormat('d MMM yyyy').format(_startDate),
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => _showColorPicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: CupertinoColors.systemGrey.withOpacity(0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pick a color',
                          style: TextStyle(color: CupertinoColors.systemGrey),
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: CupertinoColors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedColor.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget myWidgetFunction(
  String name,
  String startDateFormatted,
  int daysRemaining,
) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.isEmpty ? '-' : name,
          style: const TextStyle(
            color: Color(0xFF32CD32),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '$daysRemaining ',
              style: const TextStyle(
                color: Color(0xFF32CD32),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Days',
              style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Started on $startDateFormatted',
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(
            8,
            (index) => Container(
              width: 30,
              height: 15,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color:
                    index < (daysRemaining / 60 * 8).floor()
                        ? const Color(0xFF32CD32)
                        : CupertinoColors.darkBackgroundGray,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
