import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:medtech_project/components/apptextfield.dart';

class BusinessDateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const BusinessDateField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<BusinessDateField> createState() => _BusinessDateFieldState();
}

class _BusinessDateFieldState extends State<BusinessDateField> {
  Future<void> _selectDate() async {
    final DateTime today = DateTime.now();

    // User can select only future dates (from tomorrow)
    final DateTime firstAllowedDate = DateTime(
      today.year,
      today.month,
      today.day + 1,
    );

    final DateTime? selectedDate = await showDatePicker(
      context: context,

      // Start calendar from tomorrow
      initialDate: firstAllowedDate,

      // Past dates and today's date are disabled
      firstDate: firstAllowedDate,

      lastDate: DateTime(2100),

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) {
      return;
    }

    final String month = selectedDate.month.toString().padLeft(2, '0');

    final String day = selectedDate.day.toString().padLeft(2, '0');

    final String formattedDate = '${selectedDate.year}-$month-$day';

    setState(() {
      widget.controller.text = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,

      child: AbsorbPointer(
        child: AppTextField(
          controller: widget.controller,

          label: widget.label,

          hint: 'Select expiry date',

          suffixIcon: Icon(Icons.calendar_month_outlined, size: 20.sp),
        ),
      ),
    );
  }
}
