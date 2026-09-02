import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'home_screen.dart';

class DetailsScreen extends ConsumerWidget {
  final String id;

  const DetailsScreen({
    super.key,
    required this.id,
  });

  static const Color navy = Color(0xFF101A36);
  static const Color blue = Color(0xFF2878F0);
  static const Color cyan = Color(0xFF39C6E8);
  static const Color purple = Color(0xFF7357E8);

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final certifications =
        ref.watch(certificationProvider);

    CertificationTrackerItem? foundCertification;

    for (final certification in certifications) {
      if (certification.id == id) {
        foundCertification = certification;
        break;
      }
    }

    if (foundCertification == null) {
      return Scaffold(
        backgroundColor: navy,
        appBar: AppBar(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          title: const Text(
            'Certification Details',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: const Center(
          child: Text(
            'Certification not found.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    // The null check above guarantees that this variable
    // contains a valid certification.
    final CertificationTrackerItem certification =
        foundCertification;

    return Scaffold(
      backgroundColor: navy,

      appBar: AppBar(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 28,
          ),
          onPressed: () {
            context.go('/');
          },
        ),

        title: const Text(
          'Certification Details',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit_rounded,
              size: 25,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Edit option selected.',
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 7),
        ],
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=1600&q=85',
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
                    navy.withValues(alpha: 0.82),
                    purple.withValues(alpha: 0.62),
                    blue.withValues(alpha: 0.60),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      18,
                      18,
                      30,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight - 48,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          // ------------------------------------------------
                          // Certification overview
                          // ------------------------------------------------
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: 0.97,
                              ),
                              borderRadius:
                                  BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 82,
                                  height: 82,
                                  decoration: BoxDecoration(
                                    gradient:
                                        const LinearGradient(
                                      colors: [
                                        blue,
                                        purple,
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      24,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons
                                        .workspace_premium_rounded,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  certification.title,
                                  textAlign:
                                      TextAlign.center,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 23,
                                    fontWeight:
                                        FontWeight.w900,
                                    height: 1.15,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: blue.withValues(
                                      alpha: 0.10,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      30,
                                    ),
                                  ),
                                  child: Text(
                                    certification.issuer,
                                    style: const TextStyle(
                                      color: blue,
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.w900,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(
                                    16,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    gradient:
                                        LinearGradient(
                                      colors: [
                                        blue.withValues(
                                          alpha: 0.08,
                                        ),
                                        purple.withValues(
                                          alpha: 0.08,
                                        ),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      17,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      const Text(
                                        'CERTIFICATION OVERVIEW',
                                        style: TextStyle(
                                          color: blue,
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.w900,
                                          letterSpacing: 0.7,
                                        ),
                                      ),

                                      const SizedBox(height: 7),

                                      Text(
                                        certification.notes.isEmpty
                                            ? 'This professional certification represents a verified achievement and demonstrates knowledge and practical skills in the relevant field.'
                                            : certification.notes,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          height: 1.45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ------------------------------------------------
                          // Dates
                          // ------------------------------------------------
                          _detailTile(
                            icon:
                                Icons.calendar_month_rounded,
                            title: 'Issue Date',
                            value: formatDate(
                              certification.issueDate,
                            ),
                            description:
                                'This is the date when the certification was originally awarded and added to your professional record.',
                          ),

                          _detailTile(
                            icon:
                                Icons.event_available_rounded,
                            title: 'Expiry Date',
                            value: formatDate(
                              certification.expiryDate,
                            ),
                            description:
                                'This is the date until which the certification remains valid according to the issuing organisation.',
                          ),

                          // ------------------------------------------------
                          // Credential ID
                          // ------------------------------------------------
                          _detailTile(
                            icon: Icons.badge_rounded,
                            title: 'Credential ID',
                            value: certification
                                    .credentialId
                                    .isEmpty
                                ? 'Not provided'
                                : certification.credentialId,
                            description:
                                'A unique identifier used to reference or verify this professional credential.',
                          ),

                          // ------------------------------------------------
                          // Renewal
                          // ------------------------------------------------
                          _detailTile(
                            icon:
                                Icons.autorenew_rounded,
                            title: 'Renewal Status',
                            value: certification
                                .renewalStatus,
                            description:
                                'Shows the current validity condition of this certification and whether renewal may be required.',
                          ),

                          // ------------------------------------------------
                          // Credential URL
                          // ------------------------------------------------
                          if (certification
                              .credentialUrl.isNotEmpty)
                            _detailTile(
                              icon: Icons.link_rounded,
                              title: 'Credential URL',
                              value: certification
                                  .credentialUrl,
                              description:
                                  'The online page where this credential can be viewed or verified.',
                            ),

                          // ------------------------------------------------
                          // Notes
                          // ------------------------------------------------
                          if (certification.notes
                              .isNotEmpty)
                            _detailTile(
                              icon: Icons.notes_rounded,
                              title: 'Notes',
                              value:
                                  certification.notes,
                              description:
                                  'Additional information saved for this certification.',
                            ),

                          const SizedBox(height: 3),

                          // ------------------------------------------------
                          // Open Credential
                          // ------------------------------------------------
                          SizedBox(
                            height: 58,
                            width: double.infinity,
                            child:
                                ElevatedButton.icon(
                              onPressed: () {
                                final searchText =
                                    Uri.encodeComponent(
                                  certification.title,
                                );

                                final googleUrl =
                                    'https://www.google.com/search?q=$searchText';

                                showDialog(
                                  context: context,
                                  builder:
                                      (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          navy,
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          22,
                                        ),
                                      ),
                                      title:
                                          const Text(
                                        'Search Credential',
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white,
                                          fontWeight:
                                              FontWeight
                                                  .w900,
                                        ),
                                      ),
                                      content:
                                          const Text(
                                        'Use the Google search below to find the online credential or certificate verification page.',
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white70,
                                          height: 1.4,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context);
                                          },
                                          child:
                                              const Text(
                                            'Close',
                                            style:
                                                TextStyle(
                                              color:
                                                  cyan,
                                              fontWeight:
                                                  FontWeight
                                                      .w800,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context);

                                            ScaffoldMessenger
                                                .of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text(
                                                  googleUrl,
                                                ),
                                                duration:
                                                    const Duration(
                                                  seconds:
                                                      5,
                                                ),
                                              ),
                                            );
                                          },
                                          style:
                                              ElevatedButton
                                                  .styleFrom(
                                            backgroundColor:
                                                cyan,
                                            foregroundColor:
                                                navy,
                                          ),
                                          child:
                                              const Text(
                                            'Google Search',
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.open_in_new_rounded,
                              ),
                              label: const Text(
                                'Open Credential',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w900,
                                ),
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor: cyan,
                                foregroundColor: navy,
                                elevation: 7,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),
                        ],
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

  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 11,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  blue,
                  purple,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: blue.withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                    border: Border.all(
                      color: blue.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
