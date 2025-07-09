import 'package:flutter/material.dart';

/// A stateless widget for paginating task lists with task count control.
/// Includes buttons for navigating between pages and adjusting tasks per page.
class TaskPagination extends StatelessWidget {
  final int currentPage; // The index of the current page (0-based)
  final int totalPages; // Total number of available pages
  final int tasksPerPage; // Number of tasks to show per page
  final ValueChanged<int> onPageChanged; // Callback for page change
  final ValueChanged<int> onTasksPerPageChanged; // Callback for tasksPerPage change

  const TaskPagination({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.tasksPerPage,
    required this.onPageChanged,
    required this.onTasksPerPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        // Top border to visually separate the pagination from the list
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Align pagination controls to the end (right side)
        children: [
          // Controls to increase/decrease tasks per page
          Row(
            children: [
              Text('$tasksPerPage'), // Display current tasks per page
              const SizedBox(width: 4),
              Column(
                children: [
                  // Increase tasks per page by 10 (max 50)
                  GestureDetector(
                    onTap: () => onTasksPerPageChanged(
                      (tasksPerPage + 10).clamp(10, 50),
                    ),
                    child: const Icon(Icons.arrow_drop_up, size: 20),
                  ),
                  // Decrease tasks per page by 10 (min 10)
                  GestureDetector(
                    onTap: () => onTasksPerPageChanged(
                      (tasksPerPage - 10).clamp(10, 50),
                    ),
                    child: const Icon(Icons.arrow_drop_down, size: 20),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(), // Space between per-page control and pagination buttons

          // "First" button – go to first page
          TextButton(
            onPressed: currentPage > 0 ? () => onPageChanged(0) : null,
            child: Text(
              '⤒ First',
              style: TextStyle(color: currentPage > 0 ? Colors.blue : Colors.grey),
            ),
          ),

          // "Prev" button – go to previous page
          TextButton(
            onPressed: currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
            child: Text(
              '< Prev',
              style: TextStyle(color: currentPage > 0 ? Colors.blue : Colors.grey),
            ),
          ),

          // Display the current page number (1-based for user friendliness)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${currentPage + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // "Next" button – go to next page
          TextButton(
            onPressed: currentPage < totalPages - 1
                ? () => onPageChanged(currentPage + 1)
                : null,
            child: Text(
              'Next >',
              style: TextStyle(
                color: currentPage < totalPages - 1 ? Colors.blue : Colors.grey,
              ),
            ),
          ),

          // "Last" button – go to last page
          TextButton(
            onPressed: currentPage < totalPages - 1
                ? () => onPageChanged(totalPages - 1)
                : null,
            child: Text(
              'Last ⤓',
              style: TextStyle(
                color: currentPage < totalPages - 1 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
