import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CertificationTrackerItem {
  final String id;
  final String title;
  final String issuer;
  final DateTime issueDate;
  final DateTime expiryDate;
  final String credentialId;
  final String credentialUrl;
  final String renewalStatus;
  final String notes;

  CertificationTrackerItem({
    required this.id,
    required this.title,
    required this.issuer,
    required this.issueDate,
    required this.expiryDate,
    required this.credentialId,
    required this.credentialUrl,
    required this.renewalStatus,
    required this.notes,
  });
}

class CertificationNotifier
    extends StateNotifier<List<CertificationTrackerItem>> {
  CertificationNotifier()
      : super([
          CertificationTrackerItem(
            id: '1',
            title: 'AWS Solutions Architect Associate',
            issuer: 'AWS',
            issueDate: DateTime(2024, 1, 15),
            expiryDate: DateTime(2027, 1, 15),
            credentialId: 'AWS-ASA-123456',
            credentialUrl: '',
            renewalStatus: 'Active',
            notes: '',
          ),
          CertificationTrackerItem(
            id: '2',
            title: 'Google Cloud Professional Cloud Developer',
            issuer: 'Google Cloud',
            issueDate: DateTime(2024, 3, 10),
            expiryDate: DateTime(2026, 3, 10),
            credentialId: 'GCP-123456',
            credentialUrl: '',
            renewalStatus: 'Expiring Soon',
            notes: '',
          ),
          CertificationTrackerItem(
            id: '3',
            title: 'Azure Administrator Associate',
            issuer: 'Microsoft',
            issueDate: DateTime(2024, 2, 5),
            expiryDate: DateTime(2027, 2, 5),
            credentialId: 'AZ-104-123456',
            credentialUrl: '',
            renewalStatus: 'Active',
            notes: '',
          ),
          CertificationTrackerItem(
            id: '4',
            title: 'Google Data Analytics Professional Certificate',
            issuer: 'Google',
            issueDate: DateTime(2024, 5, 20),
            expiryDate: DateTime(2026, 5, 20),
            credentialId: 'GDA-789456',
            credentialUrl: '',
            renewalStatus: 'Active',
            notes: '',
          ),
        ]);

  void addCertification(CertificationTrackerItem certification) {
    state = [...state, certification];
  }
}

final certificationProvider = StateNotifierProvider<CertificationNotifier,
    List<CertificationTrackerItem>>(
  (ref) => CertificationNotifier(),
);

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certifications = ref.watch(certificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CertVault',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CertificationSearchDelegate(certifications),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter options coming soon.'),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1200&q=80',
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
                Colors.white.withValues(alpha: 0.88),
                Colors.blue.withValues(alpha: 0.15),
              ],
            ),
          ),
          child: certifications.isEmpty
              ? const Center(
                  child: Text(
                    'No certifications added yet.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  itemCount: certifications.length,
                  itemBuilder: (context, index) {
                    final certification = certifications[index];

                    return CertificationCard(
                      certification: certification,
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('About CertVault'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Name: Parth Sahani'),
                      Text('Roll Number: 150096724135'),
                      Text('Cohort: Elon Musk'),
                      SizedBox(height: 15),
                      Text(
                        'CertVault helps you manage and track '
                        'your professional certifications.',
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CertificationCard extends StatelessWidget {
  final CertificationTrackerItem certification;

  const CertificationCard({
    super.key,
    required this.certification,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          context.go('/details/${certification.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IssuerLogo(issuer: certification.issuer),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certification.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      certification.issuer,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Expires: ${formatDate(certification.expiryDate)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                status: certification.renewalStatus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IssuerLogo extends StatelessWidget {
  final String issuer;

  const IssuerLogo({
    super.key,
    required this.issuer,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.workspace_premium;

    if (issuer == 'AWS') {
      icon = Icons.cloud;
    } else if (issuer == 'Google Cloud') {
      icon = Icons.cloud_queue;
    } else if (issuer == 'Microsoft') {
      icon = Icons.window;
    } else if (issuer == 'Google') {
      icon = Icons.language;
    }

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        icon,
        color: Colors.blue,
        size: 30,
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: status == 'Active'
            ? Colors.green.withValues(alpha: 0.15)
            : status == 'Expiring Soon'
                ? Colors.orange.withValues(alpha: 0.18)
                : Colors.red.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: status == 'Active'
              ? Colors.green.shade700
              : status == 'Expiring Soon'
                  ? Colors.orange.shade800
                  : Colors.red.shade700,
        ),
      ),
    );
  }
}

class CertificationSearchDelegate
    extends SearchDelegate<CertificationTrackerItem?> {
  final List<CertificationTrackerItem> certifications;

  CertificationSearchDelegate(this.certifications);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = certifications.where((certification) {
      return certification.title
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('No certification found.'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final certification = results[index];

        return ListTile(
          leading: const Icon(Icons.workspace_premium),
          title: Text(certification.title),
          subtitle: Text(certification.issuer),
          onTap: () {
            close(context, certification);
            context.go('/details/${certification.id}');
          },
        );
      },
    );
  }
}
