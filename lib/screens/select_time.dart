// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TimeSettings with ChangeNotifier {
//   TimeOfDay _defaultStartTime = const TimeOfDay(hour: 8, minute: 0);
//   TimeOfDay _defaultEndTime = const TimeOfDay(hour: 18, minute: 0);

//   TimeOfDay get defaultStartTime => _defaultStartTime;

//   set defaultStartTime(TimeOfDay startTime) {
//     _defaultStartTime = startTime;
//     notifyListeners();
//   }

//   TimeOfDay get defaultEndTime => _defaultEndTime;

//   set defaultEndTime(TimeOfDay endTime) {
//     _defaultEndTime = endTime;
//     notifyListeners();
//   }
// }

// class CustomTimeSelectionPage extends StatefulWidget {
//   final TimeOfDay initialStartTime;
//   final TimeOfDay initialEndTime;
//   final TimeOfDay defaultStartTime;
//   final TimeOfDay defaultEndTime;
//   final bool isCustomTimeEnabled;

//   const CustomTimeSelectionPage({
//     Key? key,
//     required this.initialStartTime,
//     required this.initialEndTime,
//     required this.defaultStartTime,
//     required this.defaultEndTime,
//     required this.isCustomTimeEnabled,
//   }) : super(key: key);

//   factory CustomTimeSelectionPage.withDefaults(bool isCustomTimeEnabled,
//       TimeOfDay defaultStartTime, TimeOfDay defaultEndTime) {
//     TimeOfDay startTime = isCustomTimeEnabled
//         ? defaultStartTime
//         : const TimeOfDay(hour: 8, minute: 0);

//     TimeOfDay endTime = isCustomTimeEnabled
//         ? defaultEndTime
//         : const TimeOfDay(hour: 18, minute: 0);

//     return CustomTimeSelectionPage(
//       initialStartTime: startTime,
//       initialEndTime: endTime,
//       defaultStartTime: defaultStartTime,
//       defaultEndTime: defaultEndTime,
//       isCustomTimeEnabled: isCustomTimeEnabled,
//     );
//   }

//   @override
//   CustomTimeSelectionPageState createState() => CustomTimeSelectionPageState();
// }

// class CustomTimeSelectionPageState extends State<CustomTimeSelectionPage> {
//   late TimeOfDay selectedStartTime;
//   late TimeOfDay selectedEndTime;

//   @override
//   void initState() {
//     super.initState();
//     selectedStartTime = widget.initialStartTime;
//     selectedEndTime = widget.initialEndTime;
//     if (!widget.isCustomTimeEnabled) {
//       selectedStartTime = widget.defaultStartTime;
//       selectedEndTime = widget.defaultEndTime;
//     }
//     loadSelectedTimes();
//   }

//   void loadSelectedTimes() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? startHour = prefs.getInt('selectedStartTimeHour');
//     int? startMinute = prefs.getInt('selectedStartTimeMinute');
//     int? endHour = prefs.getInt('selectedEndTimeHour');
//     int? endMinute = prefs.getInt('selectedEndTimeMinute');

//     if (startHour != null && startMinute != null) {
//       setState(() {
//         selectedStartTime = TimeOfDay(hour: startHour, minute: startMinute);
//       });
//     }

//     if (endHour != null && endMinute != null) {
//       setState(() {
//         selectedEndTime = TimeOfDay(hour: endHour, minute: endMinute);
//       });
//     }
//   }

//   Future<void> saveSelectedTimes() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('selectedStartTimeHour', selectedStartTime.hour);
//     await prefs.setInt('selectedStartTimeMinute', selectedStartTime.minute);
//     await prefs.setInt('selectedEndTimeHour', selectedEndTime.hour);
//     await prefs.setInt('selectedEndTimeMinute', selectedEndTime.minute);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Customize Time Period'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             title: const Text('Choose the starting time'),
//             subtitle: Text(
//                 "${selectedStartTime.format(context)} | Only Hours are supposed to be chosen!"),
//             onTap: () {
//               _selectStartTime();
//             },
//           ),
//           ListTile(
//             title: const Text('Choose the ending time'),
//             subtitle: Text(
//                 "${selectedEndTime.format(context)} | Only Hours are supposed to be chosen!"),
//             onTap: () {
//               _selectEndTime(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectStartTime() async {
//     final TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(
//         hour: widget.initialStartTime.hour,
//         minute: widget.initialStartTime.minute,
//       ),
//     );

//     if (selectedTime != null) {
//       if (_isBefore(selectedTime, selectedEndTime)) {
//         setState(() {
//           selectedStartTime = selectedTime;
//           saveSelectedTimes();
//         });

//         final timeSettings = Provider.of<TimeSettings>(context, listen: false);
//         timeSettings.defaultStartTime = selectedTime;
//       } else {
//         _showInvalidStartTimeDialog();
//       }
//     }
//   }

//   void _showInvalidStartTimeDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Invalid Start Time'),
//         content: const Text('The start time must be before the end time.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectEndTime(BuildContext context) async {
//     final TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(
//         hour: selectedEndTime.hour,
//         minute: selectedEndTime.minute,
//       ),
//     );

//     if (selectedTime != null) {
//       if (_isAfter(selectedTime, selectedStartTime)) {
//         setState(() {
//           selectedEndTime = selectedTime;
//           saveSelectedTimes();
//         });

//         final timeSettings = Provider.of<TimeSettings>(context, listen: false);
//         timeSettings.defaultEndTime = selectedTime;
//       } else {
//         _showInvalidEndTimeDialog();
//       }
//     }
//   }

//   void _showInvalidEndTimeDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Invalid End Time'),
//         content: const Text('The end time must be after the start time.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   bool _isBefore(TimeOfDay time1, TimeOfDay time2) {
//     return time1.hour < time2.hour ||
//         (time1.hour == time2.hour && time1.minute < time2.minute);
//   }

//   bool _isAfter(TimeOfDay time1, TimeOfDay time2) {
//     return time1.hour > time2.hour ||
//         (time1.hour == time2.hour && time1.minute > time2.minute);
//   }
// }
