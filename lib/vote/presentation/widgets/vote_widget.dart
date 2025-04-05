import 'package:flutter/material.dart';

class VoteSelectionWidget extends StatefulWidget {
  final Function(String)? onVoteSelected;

  const VoteSelectionWidget({super.key, this.onVoteSelected});

  @override
  State<VoteSelectionWidget> createState() => _VoteSelectionWidgetState();
}

class _VoteSelectionWidgetState extends State<VoteSelectionWidget> {
  bool _isExpanded = false;
  String? _selectedOption;

  final List<String> _options = ['Да', 'Нет', 'Воздержаться'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(
            _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _options.map((option) {
                  return ListTile(
                    leading: Radio<String>(
                      value: option,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                        widget.onVoteSelected?.call(value!);
                      },
                    ),
                    title: Text(option),
                    onTap: () {
                      setState(() {
                        _selectedOption = option;
                      });
                      widget.onVoteSelected?.call(option);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
