import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CertificationTrackerItem {
  final String id;
  final String title;
  final String issuer;
  final DateTime issueDate;
  final DateTime expiryDate;
  final String? credentialUrl;
  final String renewalStatus;

  CertificationTrackerItem({
    required this.id,
    required this.title,
    required this.issuer,
    required this.issueDate,
    required this.expiryDate,
    this.credentialUrl,
    this.renewalStatus = 'Not Renewed',
  });
}

class CertificationNotifier
    extends StateNotifier<List<CertificationTrackerItem>> {
  CertificationNotifier()
      : super([
          CertificationTrackerItem(
            id: 'aws-1',
            title: 'AWS Solutions Architect\nAssociate',
            issuer: 'Amazon Web Services',
            issueDate: DateTime(2024, 1, 15),
            expiryDate: DateTime(2027, 1, 15),
            credentialUrl: 'AWS-ASA-123456',
            renewalStatus: 'Active',
          ),
          CertificationTrackerItem(
            id: 'google-1',
            title: 'Google Cloud Professional\nCloud Developer',
            issuer: 'Google Cloud',
            issueDate: DateTime(2024, 3, 10),
            expiryDate: DateTime(2026, 3, 10),
            credentialUrl: 'GCP-123456',
            renewalStatus: 'Expiring Soon',
          ),
          CertificationTrackerItem(
            id: 'azure-1',
            title: 'Azure Administrator\nAssociate',
            issuer: 'Microsoft',
            issueDate: DateTime(2023, 2, 5),
            expiryDate: DateTime(2025, 2, 5),
            credentialUrl: 'AZ-104-123456',
            renewalStatus: 'Expired',
          ),
        ]);

  void addCertification(CertificationTrackerItem item) {
    state = [...state, item];
  }
}

final certificationProvider = StateNotifierProvider<CertificationNotifier,
    List<CertificationTrackerItem>>(
  (ref) => CertificationNotifier(),
);

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')} '
      '${_month(date.month)} ${date.year}';
}

String _month(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  return months[month - 1];
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certifications = ref.watch(certificationProvider);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff2864d7),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CertVault',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 90),
        itemCount: certifications.length,
        itemBuilder: (context, index) {
          final item = certifications[index];

          return _CertificationCard(
            item: item,
            onTap: () {
              Navigator.of(context).pushNamed(
                '/details/${item.id}',
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff2864d7),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xff2864d7),
        unselectedItemColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

class _CertificationCard extends StatelessWidget {
  final CertificationTrackerItem item;
  final VoidCallback onTap;

  const _CertificationCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IssuerLogo(issuer: item.issuer),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.issuer,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Issued: ${formatDate(item.issueDate)}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.event_outlined,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Expires: ${formatDate(item.expiryDate)}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              _StatusChip(status: item.renewalStatus),
            ],
          ),
        ),
      ),
    );
  }
}

class _IssuerLogo extends StatelessWidget {
  final String issuer;

  const _IssuerLogo({required this.issuer});

  @override
  Widget build(BuildContext context) {
    if (issuer.contains('Amazon')) {
      return Container(
        width: 56,
        height: 46,
        decoration: const BoxDecoration(
          color: Color(0xff2864d7),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            'AWS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    if (issuer.contains('Google')) {
      return SizedBox(
        width: 56,
        height: 46,
        child: Center(
          child: Icon(
            Icons.cloud,
            size: 42,
            color: Colors.blue,
          ),
        ),
      );
    }

    return SizedBox(
      width: 56,
      height: 46,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        padding: const EdgeInsets.all(7),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ColoredBox(color: Color(0xfff25022)),
          ColoredBox(color: Color(0xff7fba00)),
          ColoredBox(color: Color(0xff00a4ef)),
          ColoredBox(color: Color(0xffffb900)),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color background;
    Color foreground;

    switch (status) {
      case 'Active':
        background = const Color(0xffdff5df);
        foreground = const Color(0xff25852b);
        break;
      case 'Expiring Soon':
        background = const Color(0xffffedc8);
        foreground = const Color(0xffb66b00);
        break;
      default:
        background = const Color(0xffffdddd);
        foreground = const Color(0xffc53b3b);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: foreground.withOpacity(.25),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: foreground,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}