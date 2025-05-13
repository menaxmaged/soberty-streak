import 'package:soberty_streak/core/utils/helper.dart';
import 'package:intl/intl.dart'; // For formatting the date

class AddEventModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onEventAdded;

  AddEventModal({required this.onEventAdded});

  @override
  State<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends State<AddEventModal> {
  final TextEditingController nameController = TextEditingController();

  DateTime _startDate = DateTime.now();
  Color _selectedColor = const Color(0xFFFF4500); // Default color

  void _addEvent(BuildContext context) {
    final newEvent = {
      "name": nameController.text.trim(),
      "dateString": DateFormat(
        'yyyy-MM-dd',
      ).format(_startDate), // Format the date
      "color": _selectedColor.value,
    };
    widget.onEventAdded(newEvent);
    Navigator.pop(context); // Close the modal after adding the event
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          initialDateTime: _startDate,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              _startDate = newDate;
            });
          },
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  // Show Add Event
  Future<void> _showSelectDate(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: true,
              child: SingleChildScrollView(
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
          ),
    );
  }

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
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
            boxShadow: [BoxShadow(blurRadius: 8.0, offset: Offset(0, 4))],
          ),
          child: SingleChildScrollView(
            // Wrap content in a scrollable widget
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Event Name Input
                  CupertinoTextField(
                    controller: nameController,
                    placeholder: "Event Name",
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 16,
                    ), // Increased padding for a taller section
                  ),
                  SizedBox(height: 30), // Increased space between sections
                  // Date Picker
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
                            offset: Offset(0, 2),
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
                  const SizedBox(
                    height: 30,
                  ), // Increased space between sections
                  // Color Picker
                  GestureDetector(
                    onTap: () {
                      // Placeholder for color picker
                    },
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
                            offset: Offset(0, 2),
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
      ),
    );
  }
}
