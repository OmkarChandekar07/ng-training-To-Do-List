import 'package:flutter/material.dart';

/// A reusable search bar widget for filtering tasks based on user input.
/// Accepts a TextEditingController and a callback for value changes.
class TaskSearchBar extends StatelessWidget {
  final TextEditingController controller; // Controller to manage input text
  final ValueChanged<String> onChanged;   // Callback when the input text changes

  const TaskSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,  // Fixed width for the search bar
      height: 36,  // Fixed height for compact appearance
      child: TextField(
        controller: controller,  
        onChanged: onChanged,    
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search, color: Colors.grey.shade600),

          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),

          // Border when no focus
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4), 
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),
      ),
    );
  }
}
