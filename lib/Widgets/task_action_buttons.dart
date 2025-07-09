import 'package:flutter/material.dart';
class TaskActionButtons extends StatelessWidget {
  final VoidCallback onNewTask;
  final VoidCallback onRefresh;

  const TaskActionButtons({
    Key? key,
    required this.onNewTask,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // "New Task" button
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: onNewTask, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFECB3),
              foregroundColor: Colors.grey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4), 
                ),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 40), 
            ),
            child: const Text(
              'New Task',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),

        const SizedBox(width: 1), // Small space between buttons

        // "Refresh" button
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: onRefresh, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFECB3), 
              foregroundColor: Colors.grey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4), 
                ),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 40),
            ),
            child: const Text(
              'Refresh',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
