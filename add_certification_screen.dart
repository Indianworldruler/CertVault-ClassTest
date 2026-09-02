import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';

class AddCertificationScreen extends ConsumerStatefulWidget {
  const AddCertificationScreen({super.key});

  @override
  ConsumerState<AddCertificationScreen> createState() =>
      _AddCertificationScreenState();
}

class _AddCertificationScreenState
    extends ConsumerState<AddCertificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _credentialController = TextEditingController();

  String? _issuer;
  String _renewalStatus = 'Not Renewed';

  DateTime? _issueDate;
  DateTime? _expiryDate;

  Future<void> _selectDate({
    required bool isIssueDate,
  }) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;

    setState(() {
      if (isIssueDate) {
        _issueDate = selectedDate;
      } else {
        _expiryDate = selectedDate;
      }
    });
  }

  void _saveCertification() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_issueDate == null || _expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select issue and expiry dates'),
        ),
      );
      return;
    }

    ref.read(certificationProvider.notifier).addCertification(
          CertificationTrackerItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text,
            issuer: _issuer ?? 'Unknown',
            issueDate: _issueDate!,
            expiryDate: _expiryDate!,
            credentialUrl: _credentialController.text.isEmpty
                ? null
                : _credentialController.text,
            renewalStatus: _renewalStatus,
          ),
        );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _credentialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff45a64d),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Certification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveCertification,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Certification Title *'),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration(
                  'Enter certification title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Certification title is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 13),

              _fieldLabel('Issuing Body *'),
              DropdownButtonFormField<String>(
                value: _issuer,
                decoration: _inputDecoration(
                  'Enter issuing body (e.g. AWS, Google)',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Amazon Web Services',
                    child: Text('Amazon Web Services'),
                  ),
                  DropdownMenuItem(
                    value: 'Google Cloud',
                    child: Text('Google Cloud'),
                  ),
                  DropdownMenuItem(
                    value: 'Microsoft',
                    child: Text('Microsoft'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _issuer = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Issuing body is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 13),

              _fieldLabel('Issue Date *'),
              _DateField(
                date: _issueDate,
                hint: 'dd/mm/yyyy',
                onTap: () => _selectDate(isIssueDate: true),
              ),

              const SizedBox(height: 13),

              _fieldLabel('Expiry Date *'),
              _DateField(
                date: _expiryDate,
                hint: 'dd/mm/yyyy',
                onTap: () => _selectDate(isIssueDate: false),
              ),

              const SizedBox(height: 13),

              _fieldLabel('Credential ID / URL'),
              TextFormField(
                controller: _credentialController,
                decoration: _inputDecoration(
                  'Enter credential ID or URL',
                ),
              ),

              const SizedBox(height: 13),

              _fieldLabel('Renewal Status'),
              DropdownButtonFormField<String>(
                value: _renewalStatus,
                decoration: _inputDecoration(''),
                items: const [
                  DropdownMenuItem(
                    value: 'Not Renewed',
                    child: Text('Not Renewed'),
                  ),
                  DropdownMenuItem(
                    value: 'Active',
                    child: Text('Active'),
                  ),
                  DropdownMenuItem(
                    value: 'Expiring Soon',
                    child: Text('Expiring Soon'),
                  ),
                  DropdownMenuItem(
                    value: 'Expired',
                    child: Text('Expired'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _renewalStatus = value ?? 'Not Renewed';
                  });
                },
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff45a64d),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _saveCertification,
                  child: const Text(
                    'Save Certification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 10,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Color(0xffcccccc),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Color(0xffcccccc),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? date;
  final String hint;
  final VoidCallback onTap;

  const _DateField({
    required this.date,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          suffixIcon: const Icon(
            Icons.calendar_month,
            size: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Color(0xffcccccc),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Color(0xffcccccc),
            ),
          ),
        ),
        child: Text(
          date == null ? hint : formatDate(date!),
          style: TextStyle(
            fontSize: 10,
            color: date == null ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }
}