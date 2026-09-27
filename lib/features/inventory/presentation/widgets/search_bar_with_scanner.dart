import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBarWithScanner extends ConsumerStatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onScanPressed;

  const SearchBarWithScanner({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onScanPressed,
  });

  @override
  ConsumerState<SearchBarWithScanner> createState() => _SearchBarWithScannerState();
}

class _SearchBarWithScannerState extends ConsumerState<SearchBarWithScanner> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _showClear = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_showClear)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _onSearchChanged('');
              },
            ),
          const VerticalDivider(width: 1, indent: 8, endIndent: 8),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: widget.onScanPressed,
            tooltip: 'Pindai Barcode',
          ),
        ],
      ),
    );
  }
}
