import 'package:flutter/material.dart';

class SimpleVoteWidget extends StatefulWidget {
  const SimpleVoteWidget({super.key});

  @override
  State<SimpleVoteWidget> createState() => _SimpleVoteWidgetState();
}

class _SimpleVoteWidgetState extends State<SimpleVoteWidget> {
  bool _isArrowDown = true;
  bool _showOptions = false;
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_showOptions)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildOptionButton('Да'),
                      const SizedBox(width: 12),
                      _buildOptionButton('Нет'),
                      const SizedBox(width: 12),
                      _buildOptionButton('Воздержаться'),
                    ],
                  ),
                ),
              IconButton(
                icon: Icon(
                  _isArrowDown ? Icons.arrow_back : Icons.arrow_forward,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _isArrowDown = !_isArrowDown;
                    _showOptions = !_showOptions;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              _selectedOption == option ? Colors.green.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          option,
          style: TextStyle(
            color: Colors.black,
            fontWeight:
                _selectedOption == option ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
