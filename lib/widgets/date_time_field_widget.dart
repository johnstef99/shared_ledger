import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateTimeField extends StatelessWidget {
  const DateTimeField({
    super.key,
    required this.label,
    required this.dateTime,
    this.onDateTimeSelected,
  });

  final String label;
  final ValueNotifier<DateTime> dateTime;
  final void Function(DateTime)? onDateTimeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: dateTime,
          builder: (BuildContext context, DateTime dateTime, Widget? child) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      key: ValueKey(dateTime.millisecondsSinceEpoch),
                      initialValue: DateFormat('yyyy-MM-dd').format(dateTime),
                      onTap: () async {
                        final newDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(3000),
                          initialDate: dateTime,
                        );
                        if (newDate == null) return;
                        onDateTimeSelected?.call(DateTime(
                          newDate.year,
                          newDate.month,
                          newDate.day,
                          dateTime.hour,
                          dateTime.minute,
                        ));
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      key: ValueKey(dateTime.microsecondsSinceEpoch),
                      initialValue: DateFormat('HH:mm').format(dateTime),
                      onTap: () async {
                        final newTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(dateTime),
                        );
                        if (newTime == null) return;
                        onDateTimeSelected?.call(DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          newTime.hour,
                          newTime.minute,
                        ));
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.access_time_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
