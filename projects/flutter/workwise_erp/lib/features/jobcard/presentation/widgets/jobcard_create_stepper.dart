import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobcardCreateStepper extends ConsumerStatefulWidget {
  final int currentStep;
  final Function(int) onStepTapped;
  final VoidCallback onStepContinue;
  final VoidCallback onStepCancel;
  final List<Step> steps;

  const JobcardCreateStepper({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
    required this.onStepContinue,
    required this.onStepCancel,
    required this.steps,
  });

  @override
  ConsumerState<JobcardCreateStepper> createState() => _JobcardCreateStepperState();
}

class _JobcardCreateStepperState extends ConsumerState<JobcardCreateStepper> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Stepper(
      physics: const ClampingScrollPhysics(),
      type: isWide ? StepperType.horizontal : StepperType.vertical,
      currentStep: widget.currentStep,
      onStepTapped: widget.onStepTapped,
      onStepContinue: widget.onStepContinue,
      onStepCancel: widget.onStepCancel,
      steps: widget.steps,
      elevation: 0,
      connectorThickness: 2,
      connectorColor: WidgetStateProperty.resolveWith((states) {
        return isDark ? Colors.white24 : Colors.grey.shade300;
      }),
    );
  }
}