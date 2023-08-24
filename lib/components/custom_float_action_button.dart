import 'package:flutter/material.dart';

import '../services/functions/notifications_helper.dart';

class CustomFloatActionButton extends StatelessWidget {
  const CustomFloatActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black87,
      child: const Icon(Icons.notifications_active),
      onPressed: () {
        DateTime selectedDateTime = DateTime.now();
        showDatePicker(
          context: context,
          initialDate: selectedDateTime,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        ).then(
          (pickedDate) {
            if (pickedDate != null) {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(selectedDateTime),
              ).then((pickedTime) {
                if (pickedTime != null) {
                  selectedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  NotificationHelper.scheduleNotification(
                    id: 0,
                    title: "Film İzleme Zamanı!",
                    body: "film izleme zamanı geldi. Hemen bir film seç",
                    payload: "Film İzleme Verileri",
                    scheduledDateTime: selectedDateTime,
                  );
                }
              });
            }
          },
        );
      },
    );
  }
}
