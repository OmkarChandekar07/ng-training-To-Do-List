import 'package:flutter/material.dart';

/// A custom dialog widget to confirm deletion of a task
class TaskDeleteDialog extends StatelessWidget {
  final String taskName; // Name of the task to be deleted
  final VoidCallback onConfirm; // Callback when user confirms deletion
  final VoidCallback onCancel;  // Callback when user cancels deletion

  const TaskDeleteDialog({
    Key? key,
    required this.taskName,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          // Dialog header with title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.red[700], 
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Dialog content - confirmation message
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Do you want to delete task $taskName?', // Dynamic task name
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Action buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button (No)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200], 
                    foregroundColor: const Color(0xFFFFECB3), 
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: onCancel, // Trigger cancel callback
                  child: const Text('No', style: TextStyle(fontSize: 14)),
                ),

                const SizedBox(width: 12),

                // Confirm button (Yes)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFECB3), 
                    foregroundColor: Colors.green[200], 
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: onConfirm,
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
