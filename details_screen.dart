import 'package:flutter/material.dart';
import 'home_screen.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  const DetailsScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final certifications =
        CertificationNotifier().state;

    CertificationTrackerItem item = certifications.first;

    for (final certification in certifications) {
      if (certification.id == id) {
        item = certification;
        break;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff7650c7),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Certification Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const SizedBox(height: 10),

            _AwsLogo(),

            const SizedBox(height: 14),

            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              item.issuer,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      title: 'Issue Date',
                      value: formatDate(item.issueDate),
                    ),
                    const SizedBox(height: 14),
                    _DetailRow(
                      title: 'Expiry Date',
                      value: formatDate(item.expiryDate),
                    ),
                    const SizedBox(height: 14),
                    _DetailRow(
                      title: 'Credential ID / URL',
                      value: item.credentialUrl ?? 'Not provided',
                      valueColor: const Color(0xff2864d7),
                    ),
                    const SizedBox(height: 14),
                    _DetailStatusRow(
                      status: item.renewalStatus,
                    ),
                    const SizedBox(height: 14),
                    const _DetailRow(
                      title: 'Notes',
                      value: 'Valid for 3 years from\nissue date.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff2864d7),
                  side: const BorderSide(
                    color: Color(0xff2864d7),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.language,
                  size: 17,
                ),
                label: const Text(
                  'Open Credential',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AwsLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 58,
      decoration: const BoxDecoration(
        color: Color(0xff2864d7),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'AWS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11,
              color: valueColor ?? Colors.black87,
              fontWeight: valueColor != null
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailStatusRow extends StatelessWidget {
  final String status;

  const _DetailStatusRow({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Renewal Status',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffdff5df),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xff8aca8a),
            ),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Color(0xff25852b),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}