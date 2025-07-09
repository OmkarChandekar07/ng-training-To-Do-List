import 'package:flutter/material.dart';
import '../Model/task_model.dart';

/// A stateless widget that displays a list of tasks in a paginated table format.
/// Allows selecting tasks individually or in bulk, and supports actions like edit/delete.
class TaskTable extends StatelessWidget {
  final List<Task> tasks; // List of tasks to display
  final Set<String> selectedTaskIds; // Set of selected task IDs
  final ValueChanged<String> onSelectTask; // Callback when an individual task is selected
  final ValueChanged<bool> onSelectAll; // Callback when the select-all checkbox is toggled
  final void Function(Task, String) onAction; // Callback for actions ('edit' or 'delete') on a task

  const TaskTable({
    Key? key,
    required this.tasks,
    required this.selectedTaskIds,
    required this.onSelectTask,
    required this.onSelectAll,
    required this.onAction,
  }) : super(key: key);

  /// Checks if all tasks are selected
  bool _areAllSelected() =>
      tasks.isNotEmpty && tasks.every((t) => selectedTaskIds.contains(t.id));

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20,       
      dataRowHeight: 48,      
      headingRowHeight: 56,   

      columns: [
        // Select All checkbox in the header
        DataColumn(
          label: Checkbox(
            value: _areAllSelected(),
            onChanged: (value) => onSelectAll(value ?? false),
          ),
        ),

        // Column headers with bold styling
        const DataColumn(label: Text('Assigned To', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('Priority', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('Comments', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('')),
      ],

      // Generate a row for each task
      rows: tasks.map((task) => DataRow(
        cells: [
          // Checkbox for selecting individual task
          DataCell(
            Checkbox(
              value: selectedTaskIds.contains(task.id),
              onChanged: (value) => onSelectTask(task.id),
            ),
          ),

          // Assigned To cell with blue accent color
          DataCell(Text(task.assignedTo, style: const TextStyle(color: Colors.blueAccent))),
          DataCell(Text(task.status)),
          DataCell(Text(task.dueDate.toLocal().toString().split(' ')[0])),
          DataCell(Text(task.priority)),
          DataCell(Text(task.description)),
          DataCell(_buildPopupMenu(context, task)),
        ],
      )).toList(),
    );
  }

  /// Builds a popup menu button for each task row with "Edit" and "Delete" actions
  Widget _buildPopupMenu(BuildContext context, Task task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) => onAction(task, value),
        itemBuilder: (context) => [
          // Edit action
          PopupMenuItem(
            value: 'edit',
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Edit',
              style: TextStyle(
                color: Colors.brown.shade300,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Delete action
          PopupMenuItem(
            value: 'delete',
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.brown.shade300,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],

        icon: const Icon(Icons.arrow_drop_down, size: 18), 
        color: const Color(0xFFFFF4CC), 
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
