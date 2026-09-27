import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/add_medicine/providers/add_medicine_provider.dart';

class QuantityStepper extends ConsumerStatefulWidget {
  const QuantityStepper({Key? key}) : super(key: key);

  @override
  ConsumerState<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends ConsumerState<QuantityStepper> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(addMedicineFormProvider);
    final formNotifier = ref.read(addMedicineFormProvider.notifier);
    
    // Sync controller if state changes from outside
    if (_controller.text != formState.quantity.toString()) {
      _controller.text = formState.quantity.toString();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          icon: Icons.remove,
          color: const Color(0xFFFFEBEE),
          iconColor: const Color(0xFFE74C3C),
          onTap: () {
            if (formState.quantity > 0) {
              formNotifier.setField(quantity: formState.quantity - 1);
            }
          },
        ),
        Container(
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (val) {
              final intVal = int.tryParse(val) ?? 0;
              formNotifier.setField(quantity: intVal);
            },
          ),
        ),
        _buildButton(
          icon: Icons.add,
          color: const Color(0xFFD8F3DC),
          iconColor: const Color(0xFF27AE60),
          onTap: () {
            formNotifier.setField(quantity: formState.quantity + 1);
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 32),
      ),
    );
  }
}
