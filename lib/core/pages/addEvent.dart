import 'package:flutter/rendering.dart';

import '/core/utils/helper.dart';

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

  late Event newEvent;

  @override
  void initState() {
    super.initState();
    newEvent = Event(
      name: "Event Name",
      dateString: DateFormat('yyyy-MM-dd').format(_startDate),
      color: _selectedColor.value,
    );
  }

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

    // Prepare the event
    newEvent = Event(
      name: nameController.text.trim(),
      dateString: DateFormat('yyyy-MM-dd').format(_startDate),
      color: _selectedColor.value,
    );

    widget.onEventAdded(newEvent.toJson()); // Pass the Event object as a Map

    Navigator.pop(context); // Close the modal after adding the event
  }

  Future<void> _showSelectDate(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 350,
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
                    // Update the event's date when the date is changed
                    newEvent.dateString = DateFormat(
                      'yyyy-MM-dd',
                    ).format(_startDate);
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
            height: 350, // Adjust as needed
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: CupertinoTheme(
              data: const CupertinoThemeData(brightness: Brightness.dark),
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
                              // Update the event's color when the color is changed
                              newEvent.color = _selectedColor.value;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double modalHeight = constraints.maxHeight * 0.99;

        return Container(
          height: modalHeight,
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.black,
            navigationBar: CupertinoNavigationBar(
              leading: CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: CupertinoColors.systemGrey),
                ),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () => _addEvent(context),
                child: const Text(
                  'Done',
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    widgetPreview(newEvent),
                    const SizedBox(height: 30),

                    CupertinoTextField(
                      onChanged: (value) {
                        setState(() {
                          newEvent.name = nameController.text.trim();
                        });
                      },
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
                              color: CupertinoColors.systemGrey.withOpacity(
                                0.1,
                              ),
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
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                              ),
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
                              color: CupertinoColors.systemGrey.withOpacity(
                                0.1,
                              ),
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
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                              ),
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
      },
    );
  }
}

Widget widgetPreview(Event event) {
  // Parse the event date from event.dateString
  DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event.dateString);

  // Calculate the difference between eventDate and the current date
  DateTime currentDate = DateTime.now();
  int daysSince = currentDate.difference(eventDate).inDays;

  // Handle negative daysSince (in case the event date is in the future)
  if (daysSince < 0) {
    daysSince = 0; // Or you can display something like "Event yet to happen"
  }

  // Convert the event color from int to Color
  Color eventColor = Color(event.color);

  // Calculate the number of months that have passed (up to 12)
  int monthsSince = (daysSince / 30).floor();
  if (monthsSince > 12) monthsSince = 12;

  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          event.name.isEmpty ? 'Event Name' : event.name,
          style: TextStyle(
            color: eventColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '$daysSince ',
              style: TextStyle(
                color: eventColor,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Days Since',
              style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Started on ${event.dateString}',
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (index) {
            bool isFilled = index < monthsSince;
            return Container(
              width: 30,
              height: 15,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color:
                    isFilled
                        ? eventColor
                        : CupertinoColors
                            .darkBackgroundGray, // Corrected this line
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (index) {
            bool isFilled = index + 6 < monthsSince;
            return Container(
              width: 30,
              height: 15,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color:
                    isFilled
                        ? eventColor
                        : CupertinoColors
                            .darkBackgroundGray, // Corrected this line
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    ),
  );
}
