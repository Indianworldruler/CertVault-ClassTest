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
  static const Color navy = Color(0xFF101A36);
  static const Color blue = Color(0xFF2878F0);
  static const Color cyan = Color(0xFF39C6E8);
  static const Color purple = Color(0xFF7357E8);

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

  Future<void> _selectDate({
    required bool isIssueDate,
  }) async {
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
      prefixIcon: Icon(
        icon,
        color: blue,
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.96),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: cyan,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
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
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=1600&q=85',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: navy,
                );
              },
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    navy.withValues(alpha: 0.88),
                    blue.withValues(alpha: 0.58),
                    purple.withValues(alpha: 0.56),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      25,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 45,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _sectionHeading(
                              'Certification Information',
                              Icons.workspace_premium_rounded,
                            ),

                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _titleController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: _inputDecoration(
                                label: 'Certification Title',
                                hint: 'Enter certification name',
                                icon: Icons.workspace_premium_rounded,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Please enter the certification title.';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            DropdownButtonFormField<String>(
                              initialValue: _selectedIssuer,
                              decoration: _inputDecoration(
                                label: 'Issuing Body',
                                icon: Icons.business_rounded,
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
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _otherIssuerController,
                                decoration: _inputDecoration(
                                  label: 'Issuing Body Name',
                                  hint: 'Enter issuing body',
                                  icon: Icons.business_center_rounded,
                                ),
                              ),
                            ],

                            const SizedBox(height: 22),

                            _sectionHeading(
                              'Certification Dates',
                              Icons.calendar_month_rounded,
                            ),

                            const SizedBox(height: 14),

                            _dateField(
                              label: 'Issue Date',
                              date: _issueDate,
                              icon: Icons.calendar_today_rounded,
                              onTap: () =>
                                  _selectDate(isIssueDate: true),
                            ),

                            const SizedBox(height: 14),

                            _dateField(
                              label: 'Expiry Date',
                              date: _expiryDate,
                              icon: Icons.event_busy_rounded,
                              onTap: () =>
                                  _selectDate(isIssueDate: false),
                            ),

                            const SizedBox(height: 22),

                            _sectionHeading(
                              'Credential Details',
                              Icons.verified_rounded,
                            ),

                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _credentialIdController,
                              decoration: _inputDecoration(
                                label: 'Credential ID',
                                hint: 'Enter credential ID',
                                icon: Icons.badge_rounded,
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _credentialUrlController,
                              keyboardType: TextInputType.url,
                              decoration: _inputDecoration(
                                label: 'Credential URL',
                                hint: 'Enter credential URL',
                                icon: Icons.link_rounded,
                              ),
                            ),

                            const SizedBox(height: 14),

                            DropdownButtonFormField<String>(
                              initialValue: _renewalStatus,
                              decoration: _inputDecoration(
                                label: 'Renewal Status',
                                icon: Icons.autorenew_rounded,
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

                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: _inputDecoration(
                                label: 'Notes',
                                hint: 'Add any additional information',
                                icon: Icons.notes_rounded,
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              height: 58,
                              child: ElevatedButton.icon(
                                onPressed: _saveCertification,
                                icon: const Icon(
                                  Icons.save_rounded,
                                  size: 23,
                                ),
                                label: const Text(
                                  'Save Certification',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cyan,
                                  foregroundColor: navy,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cyan.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: InputDecorator(
        decoration: _inputDecoration(
          label: label,
          icon: icon,
        ),
        child: Text(
          _formatDate(date),
          style: TextStyle(
            color: date == null
                ? Colors.grey.shade600
                : Colors.black87,
            fontSize: 16,
            fontWeight: date == null
                ? FontWeight.normal
                : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
