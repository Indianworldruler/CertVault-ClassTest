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
            notes:
                'Validates knowledge of designing secure, scalable and reliable applications on AWS.',
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
            notes:
                'Demonstrates skills in developing, deploying and maintaining applications on Google Cloud.',
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
            notes:
                'Demonstrates knowledge of managing Azure resources, identities, storage and virtual networks.',
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
            notes:
                'Covers data cleaning, analysis, visualisation and practical data analytics techniques.',
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

  static const Color navy = Color(0xFF101A36);
  static const Color blue = Color(0xFF2878F0);
  static const Color cyan = Color(0xFF39C6E8);
  static const Color purple = Color(0xFF7357E8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certifications = ref.watch(certificationProvider);

    return Scaffold(
      backgroundColor: navy,

      appBar: AppBar(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CertVault',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(
              Icons.search_rounded,
              size: 29,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CertificationSearchDelegate(
                  certifications,
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Filter',
            icon: const Icon(
              Icons.tune_rounded,
              size: 27,
            ),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1600&q=85',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFF17233F),
                );
              },
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    navy.withValues(alpha: 0.55),
                    blue.withValues(alpha: 0.25),
                    navy.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header information
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'My Certifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${certifications.length} certifications in your vault',
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.85,
                                ),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.18,
                          ),
                          borderRadius:
                              BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              color: cyan,
                              size: 19,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${certifications.length} Active',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Certification cards
                Expanded(
                  child: certifications.isEmpty
                      ? const Center(
                          child: Text(
                            'No certifications added yet.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            18,
                            4,
                            18,
                            100,
                          ),
                          itemCount: certifications.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 14,
                              ),
                              child: CertificationCard(
                                certification:
                                    certifications[index],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: cyan,
        foregroundColor: navy,
        elevation: 8,
        onPressed: () {
          context.go('/add');
        },
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 72,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_rounded,
                        color: blue,
                        size: 25,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _showAboutDialog(context);
                  },
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.black54,
                        size: 25,
                      ),
                      SizedBox(height: 3),
                      Text(
                        'About',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.verified_rounded,
                color: cyan,
              ),
              SizedBox(width: 10),
              Text(
                'About CertVault',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Certification Tracker',
                style: TextStyle(
                  color: cyan,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Name: Parth Sahani\n'
                'Roll Number: 150096724135\n'
                'Cohort: Elon Musk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'CertVault helps you store and manage your professional certifications in one place.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: cyan,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Filter Certifications',
                style: TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                leading: const Icon(
                  Icons.all_inclusive_rounded,
                  color: blue,
                ),
                title: const Text('All Certifications'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                ),
                title: const Text('Active'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.warning_rounded,
                  color: Colors.orange,
                ),
                title: const Text('Expiring Soon'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class CertificationCard extends StatelessWidget {
  final CertificationTrackerItem certification;

  const CertificationCard({
    super.key,
    required this.certification,
  });

  String _description() {
    if (certification.title.contains('AWS')) {
      return 'Validates expertise in designing secure, scalable and reliable applications on AWS.';
    }

    if (certification.title.contains('Cloud Developer')) {
      return 'Demonstrates skills in developing, deploying and maintaining applications on Google Cloud.';
    }

    if (certification.title.contains('Azure')) {
      return 'Demonstrates knowledge of managing Azure resources, identities, storage and virtual networks.';
    }

    if (certification.title.contains('Data Analytics')) {
      return 'Covers data cleaning, analysis, visualisation and practical data analytics techniques.';
    }

    return 'Professional certification recorded in your CertVault.';
  }

  @override
  Widget build(BuildContext context) {
    final bool expiring =
        certification.renewalStatus == 'Expiring Soon';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          context.go(
            '/details/${certification.id}',
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.97),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              IssuerLogo(
                issuer: certification.issuer,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      certification.title,
                      style: const TextStyle(
                        color: HomeScreen.navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      certification.issuer,
                      style: const TextStyle(
                        color: HomeScreen.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _description(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 11),

                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 15,
                          color: HomeScreen.blue,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Issued ${formatDate(certification.issueDate)}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.event_rounded,
                          size: 15,
                          color: HomeScreen.purple,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Expires ${formatDate(certification.expiryDate)}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 9),

                    Row(
                      children: [
                        const Icon(
                          Icons.badge_rounded,
                          size: 15,
                          color: HomeScreen.purple,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            certification.credentialId.isEmpty
                                ? 'Credential ID not provided'
                                : 'ID: ${certification.credentialId}',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 11),

                    Row(
                      children: [
                        StatusChip(
                          status:
                              certification.renewalStatus,
                          expiring: expiring,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: HomeScreen.blue,
                          size: 19,
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          'View Details',
                          style: TextStyle(
                            color: HomeScreen.navy,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
    IconData icon = Icons.workspace_premium_rounded;

    if (issuer == 'AWS') {
      icon = Icons.cloud_rounded;
    } else if (issuer == 'Google Cloud') {
      icon = Icons.cloud_outlined;
    } else if (issuer == 'Microsoft') {
      icon = Icons.grid_view_rounded;
    } else if (issuer == 'Google') {
      icon = Icons.language_rounded;
    }

    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDCEBFF),
            Color(0xFFE9E2FF),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        color: HomeScreen.blue,
        size: 32,
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;
  final bool expiring;

  const StatusChip({
    super.key,
    required this.status,
    required this.expiring,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        expiring ? Colors.deepOrange : Colors.green.shade700;

    final Color backgroundColor =
        expiring ? const Color(0xFFFFE5D0) : const Color(0xFFDDF2E3);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            expiring
                ? Icons.warning_amber_rounded
                : Icons.check_circle_rounded,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults(context);
  }

  Widget _buildResults(BuildContext context) {
    final results = certifications.where(
      (certification) {
        return certification.title
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            certification.issuer
                .toLowerCase()
                .contains(query.toLowerCase());
      },
    ).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No certification found.',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final certification = results[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(
              Icons.workspace_premium_rounded,
              color: HomeScreen.blue,
              size: 32,
            ),
            title: Text(
              certification.title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              certification.issuer,
            ),
            trailing: const Icon(
              Icons.arrow_forward_rounded,
            ),
            onTap: () {
              close(context, certification);
              context.go(
                '/details/${certification.id}',
              );
            },
          ),
        );
      },
    );
  }
}
