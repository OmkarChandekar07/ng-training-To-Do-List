import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_to_list_app/Model/task_model.dart';
import 'package:to_to_list_app/task_form_screen.dart';
import 'Widgets/task_search_bar.dart';
import 'Widgets/task_action_buttons.dart';
import 'Widgets/task_pagination.dart';
import 'Widgets/task_delete_dialog.dart';
import 'Widgets/task_table.dart';

/// Main screen that displays a searchable, paginated list of tasks from Firestore.
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final taskCollection = FirebaseFirestore.instance.collection('tasks');

  String _searchQuery = '';
  int _currentPage = 0;
  int _tasksPerPage = 20;

  List<Task> _allTasks = [];
  Set<String> _selectedTaskIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  /// Toggle select all for current page
  void _toggleSelectAll(List<Task> pageTasks, bool value) {
    setState(() {
      if (value) {
        _selectedTaskIds.addAll(pageTasks.map((t) => t.id));
      } else {
        _selectedTaskIds.removeAll(pageTasks.map((t) => t.id));
      }
    });
  }

  /// Show confirmation dialog to delete a task
  void _showDeleteDialog(String id, BuildContext context, String taskName) {
    showDialog(
      context: context,
      builder: (_) => TaskDeleteDialog(
        taskName: taskName,
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          taskCollection.doc(id).delete();
          setState(() {
            _selectedTaskIds.remove(id);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Returns true if the task matches the current search query
  bool _matchesSearch(Task task) {
    final query = _searchQuery.toLowerCase();
    return task.assignedTo.toLowerCase().contains(query) ||
        task.status.toLowerCase().contains(query) ||
        task.priority.toLowerCase().contains(query) ||
        task.comments.toLowerCase().contains(query) ||
        task.dueDate.toLocal().toString().split(' ')[0].contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: isWide ? 120 : 140,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 165, 0, 88),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.format_list_bulleted,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'All Tasks',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  if (isWide)
                    TaskActionButtons(
                      onNewTask: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TaskFormScreen()),
                        );
                      },
                      onRefresh: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                          _currentPage = 0;
                          _selectedTaskIds.clear();
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 8),
              isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: taskCollection.snapshots(),
                          builder: (_, snapshot) {
                            final count = snapshot.hasData
                                ? snapshot.data!.docs
                                    .where(
                                      (doc) => _matchesSearch(
                                        Task.fromMap(
                                          doc.id,
                                          doc.data() as Map<String, dynamic>,
                                        ),
                                      ),
                                    )
                                    .length
                                : 0;
                            return Text(
                              '$count records',
                              style: TextStyle(color: Colors.grey.shade700),
                            );
                          },
                        ),
                        TaskSearchBar(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _currentPage = 0;
                              _selectedTaskIds.clear();
                            });
                          },
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: taskCollection.snapshots(),
                          builder: (_, snapshot) {
                            final count = snapshot.hasData
                                ? snapshot.data!.docs
                                    .where(
                                      (doc) => _matchesSearch(
                                        Task.fromMap(
                                          doc.id,
                                          doc.data() as Map<String, dynamic>,
                                        ),
                                      ),
                                    )
                                    .length
                                : 0;
                            return Text(
                              '$count records',
                              style: TextStyle(color: Colors.grey.shade700),
                            );
                          },
                        ),
                        SizedBox(height: 8),
                        TaskSearchBar(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _currentPage = 0;
                              _selectedTaskIds.clear();
                            });
                          },
                        ),
                        SizedBox(height: 8),
                        TaskActionButtons(
                          onNewTask: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => TaskFormScreen()),
                            );
                          },
                          onRefresh: () {
                            setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                              _currentPage = 0;
                              _selectedTaskIds.clear();
                            });
                          },
                        ),
                      ],
                    ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),

      // Main body showing tasks in a paginated table
      body: StreamBuilder<QuerySnapshot>(
        stream: taskCollection.orderBy('dueDate').snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          _allTasks = snapshot.data!.docs
              .map((doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList();

          final filteredTasks = _allTasks.where(_matchesSearch).toList();
          final totalPages = (filteredTasks.length / _tasksPerPage).ceil();
          final startIndex = _currentPage * _tasksPerPage;
          final endIndex = (startIndex + _tasksPerPage).clamp(0, filteredTasks.length);
          final paginatedTasks = filteredTasks.sublist(startIndex, endIndex);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: TaskTable(
                      tasks: paginatedTasks,
                      selectedTaskIds: _selectedTaskIds,
                      onSelectTask: (taskId) {
                        setState(() {
                          if (_selectedTaskIds.contains(taskId)) {
                            _selectedTaskIds.remove(taskId);
                          } else {
                            _selectedTaskIds.add(taskId);
                          }
                        });
                      },
                      onSelectAll: (value) => _toggleSelectAll(paginatedTasks, value),
                      onAction: (task, action) {
                        if (action == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
                          );
                        } else if (action == 'delete') {
                          _showDeleteDialog(task.id, context, task.assignedTo);
                        }
                      },
                    ),
                  ),
                ),
              ),
              if (filteredTasks.isNotEmpty)
                TaskPagination(
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  tasksPerPage: _tasksPerPage,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  onTasksPerPageChanged: (newPerPage) {
                    setState(() {
                      _tasksPerPage = newPerPage;
                      _currentPage = 0;
                    });
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
