import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  final _credentialIdController = TextEditingController();
  final _credentialUrlController = TextEditingController();
  final _notesController = TextEditingController();
  final _otherIssuerController = TextEditingController();

  String _selectedIssuer = 'AWS';
  String _renewalStatus = 'Active';

  DateTime? _issueDate;
  DateTime? _expiryDate;

  final List<String> _issuers = [
    'AWS',
    'Google Cloud',
    'Microsoft',
    'Google',
    'Others',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _credentialIdController.dispose();
    _credentialUrlController.dispose();
    _notesController.dispose();
    _otherIssuerController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isIssueDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isIssueDate
          ? (_issueDate ?? DateTime.now())
          : (_expiryDate ?? _issueDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      if (isIssueDate) {
        _issueDate = pickedDate;

        if (_expiryDate != null &&
            _expiryDate!.isBefore(pickedDate)) {
          _expiryDate = null;
        }
      } else {
        _expiryDate = pickedDate;
      }
    });
  }

  void _saveCertification() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_issueDate == null) {
      _showMessage('Please select the issue date.');
      return;
    }

    if (_expiryDate == null) {
      _showMessage('Please select the expiry date.');
      return;
    }

    if (_expiryDate!.isBefore(_issueDate!)) {
      _showMessage('Expiry date cannot be before issue date.');
      return;
    }

    String issuer = _selectedIssuer;

    if (_selectedIssuer == 'Others') {
      issuer = _otherIssuerController.text.trim();

      if (issuer.isEmpty) {
        _showMessage('Please enter the issuing body.');
        return;
      }
    }

    final certification = CertificationTrackerItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      issuer: issuer,
      issueDate: _issueDate!,
      expiryDate: _expiryDate!,
      credentialId: _credentialIdController.text.trim(),
      credentialUrl: _credentialUrlController.text.trim(),
      renewalStatus: _renewalStatus,
      notes: _notesController.text.trim(),
    );

    ref
        .read(certificationProvider.notifier)
        .addCertification(certification);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certification added successfully.'),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.92),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.green,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Certification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=1200&q=80',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.90),
                Colors.green.withValues(alpha: 0.18),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration(
                        label: 'Certification Title',
                        hint: 'Enter certification name',
                        icon: Icons.workspace_premium,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the certification title.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedIssuer,
                      decoration: _inputDecoration(
                        label: 'Issuing Body',
                        icon: Icons.business,
                      ),
                      items: _issuers.map((issuer) {
                        return DropdownMenuItem<String>(
                          value: issuer,
                          child: Text(issuer),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          _selectedIssuer = value;
                        });
                      },
                    ),

                    if (_selectedIssuer == 'Others') ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _otherIssuerController,
                        decoration: _inputDecoration(
                          label: 'Issuing Body Name',
                          hint: 'Enter issuing body',
                          icon: Icons.business_center,
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () => _selectDate(isIssueDate: true),
                      borderRadius: BorderRadius.circular(14),
                      child: InputDecorator(
                        decoration: _inputDecoration(
                          label: 'Issue Date',
                          icon: Icons.calendar_today,
                        ),
                        child: Text(
                          _formatDate(_issueDate),
                          style: TextStyle(
                            color: _issueDate == null
                                ? Colors.grey.shade600
                                : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () => _selectDate(isIssueDate: false),
                      borderRadius: BorderRadius.circular(14),
                      child: InputDecorator(
                        decoration: _inputDecoration(
                          label: 'Expiry Date',
                          icon: Icons.event_busy,
                        ),
                        child: Text(
                          _formatDate(_expiryDate),
                          style: TextStyle(
                            color: _expiryDate == null
                                ? Colors.grey.shade600
                                : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _credentialIdController,
                      decoration: _inputDecoration(
                        label: 'Credential ID',
                        hint: 'Enter credential ID',
                        icon: Icons.badge,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _credentialUrlController,
                      keyboardType: TextInputType.url,
                      decoration: _inputDecoration(
                        label: 'Credential URL',
                        hint: 'Enter credential URL',
                        icon: Icons.link,
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: _renewalStatus,
                      decoration: _inputDecoration(
                        label: 'Renewal Status',
                        icon: Icons.autorenew,
                      ),
                      items: const [
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
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          _renewalStatus = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        label: 'Notes',
                        hint: 'Add any additional information',
                        icon: Icons.notes,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _saveCertification,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Save Certification',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
