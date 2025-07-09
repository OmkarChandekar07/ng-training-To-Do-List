class Task {
  String id;
  String assignedTo;
  String status;
  DateTime dueDate;
  String priority;
  String description;
  String comments;
   String title;/// Constructor to create a Task instance
  Task({
    required this.id,
    required this.assignedTo,
    required this.status,
    required this.dueDate,
    required this.priority,
    required this.description,
    required this.comments,
    required this.title,
  });

  /// Converts the Task object to a Map<String, dynamic> for saving to Firestore
  Map<String, dynamic> toMap() => {
        'assignedTo': assignedTo,
        'status': status,
        'dueDate': dueDate.toIso8601String(), 
        'priority': priority,
        'description': description,
        'comments': comments,
        'title': title,
      };

  /// Factory constructor to create a Task object from a Firestore document
  factory Task.fromMap(String id, Map<String, dynamic> data) => Task(
        id: id,
        assignedTo: data['assignedTo'],
        status: data['status'],
        dueDate: DateTime.parse(data['dueDate']),
        priority: data['priority'],
        description: data['description'],
        comments: data['comments'] ?? '', 
        title: data['title'] ?? 'Untitled Task', 
      );
}