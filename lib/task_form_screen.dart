import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_to_list_app/Model/task_model.dart';

/// Screen to create or edit a task
class TaskFormScreen extends StatefulWidget {
  final Task? task; // If editing, pass the task

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field variables
  String? assignedTo;
  String? status = 'Not Started';
  DateTime? dueDate = DateTime.now();
  String? priority = 'Normal';
  String? description;

  // Dropdown options
  final users = ['User 1', 'User 2', 'User 3', 'User 4'];
  final statusOptions = ['Not Started', 'In Progress', 'Completed'];
  final priorityOptions = ['Low', 'Normal', 'High'];

  @override
  void initState() {
    super.initState();
    // Populate form fields if editing existing task
    if (widget.task != null) {
      assignedTo = widget.task!.assignedTo;
      status = widget.task!.status;
      dueDate = widget.task!.dueDate;
      priority = widget.task!.priority;
      description = widget.task!.description;
    }
  }

  /// Save the task to Firestore (add new or update existing)
  void saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Construct task data to save
      final taskData = {
        'assignedTo': assignedTo,
        'status': status,
        'dueDate': dueDate!.toIso8601String(),
        'priority': priority,
        'description': description ?? '',
      };

      final taskCollection = FirebaseFirestore.instance.collection('tasks');

      if (widget.task == null) {
        // Add new task
        taskCollection.add(taskData);
      } else {
        // Update existing task
        taskCollection.doc(widget.task!.id).update(taskData);
      }

      // Close the form
      Navigator.pop(context);
    }
  }

  /// Show date picker to select due date
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  /// Helper to display a red asterisk for required fields
  Widget buildRequiredLabel(String label) {
    return RichText(
      text: TextSpan(
        text: '* ',
        style: TextStyle(color: Colors.red),
        children: [
          TextSpan(
            text: label,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  /// Dropdown for "Assigned To"
  Widget _buildAssignedToField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRequiredLabel('Assigned To'),
          SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: assignedTo,
            decoration: InputDecoration(border: OutlineInputBorder()),
            items: users.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
            onChanged: (v) => setState(() => assignedTo = v),
            validator: (v) => v == null ? 'Please select user' : null,
          ),
        ],
      );

  /// Dropdown for "Status"
  Widget _buildStatusField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRequiredLabel('Status'),
          SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: status,
            decoration: InputDecoration(border: OutlineInputBorder()),
            items: statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => status = v),
            validator: (v) => v == null ? 'Please select status' : null,
          ),
        ],
      );

  /// Date picker field for "Due Date"
  Widget _buildDueDateField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRequiredLabel('Due Date'),
          SizedBox(height: 4),
          InkWell(
            onTap: pickDate,
            child: InputDecorator(
              decoration: InputDecoration(border: OutlineInputBorder()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${dueDate!.day.toString().padLeft(2, '0')} ${_monthName(dueDate!.month)} ${dueDate!.year}'),
                  Icon(Icons.calendar_today, size: 18),
                ],
              ),
            ),
          ),
        ],
      );

  /// Dropdown for "Priority"
  Widget _buildPriorityField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRequiredLabel('Priority'),
          SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: priority,
            decoration: InputDecoration(border: OutlineInputBorder()),
            items: priorityOptions.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (v) => setState(() => priority = v),
            validator: (v) => v == null ? 'Please select priority' : null,
          ),
        ],
      );

  /// Multiline text field for "Description"
  Widget _buildDescriptionField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description'),
          SizedBox(height: 4),
          TextFormField(
            initialValue: description,
            decoration: InputDecoration(border: OutlineInputBorder()),
            maxLines: 5,
            onSaved: (v) => description = v,
          ),
        ],
      );

  /// Main UI of the form screen
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600; // Responsive layout

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Scrollable form content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // AssignedTo + Status
                      isWide
                          ? Row(
                              children: [
                                Expanded(child: _buildAssignedToField()),
                                SizedBox(width: 16),
                                Expanded(child: _buildStatusField()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildAssignedToField(),
                                SizedBox(height: 16),
                                _buildStatusField(),
                              ],
                            ),
                      SizedBox(height: 16),
                      // DueDate + Priority
                      isWide
                          ? Row(
                              children: [
                                Expanded(child: _buildDueDateField()),
                                SizedBox(width: 16),
                                Expanded(child: _buildPriorityField()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildDueDateField(),
                                SizedBox(height: 16),
                                _buildPriorityField(),
                              ],
                            ),
                      SizedBox(height: 16),
                      _buildDescriptionField(),
                    ],
                  ),
                ),
              ),
              // Cancel and Save buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[100],
                      foregroundColor: Colors.green[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      elevation: 0,
                    ),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      elevation: 0,
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper to convert month number to short name
  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}
