import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:portail_tn/constants/named_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCandidatesScreenRecruter extends StatefulWidget {
  @override
  _MyCandidatesScreenRecruterState createState() => _MyCandidatesScreenRecruterState();
}

class _MyCandidatesScreenRecruterState extends State<MyCandidatesScreenRecruter> {
  List<dynamic> offers = [];

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          enableFeedback: true,
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 43, 57, 82),
          unselectedItemColor: Colors.grey,
          currentIndex: 1,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Vos candidats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Get.toNamed(NamedRoutes.homeScreenRecruter);
            } else if (index == 1) {
              Get.toNamed(NamedRoutes.appliedJobList);
            } else {
              Get.toNamed(NamedRoutes.profileScreenRecruter);
            }
          },
        ),

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Mes Offres', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      ),
      body: offers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return _OfferCard(
                  offerTitle: offer['title'] as String,
                  publishedDate: offer['created_at'] as String,
                  onTap: () => _navigateToOfferCandidates(offer['id'] as int),
                );
              },
            ),
    );
  }

  Future<void> _fetchOffers() async {
    final prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getInt('companyId') ?? 0;
    final response = await http.get(Uri.parse('http://localhost:8000/api/offre/societe/$companyId'));

    if (response.statusCode == 200) {
      setState(() {
        offers = json.decode(response.body) as List<dynamic>;
      });
    } else {
      throw Exception('Erreur de chargement');
    }
  }

  void _navigateToOfferCandidates(int offerId) {
    Get.to(() => OfferCandidatesScreen(offerId: offerId));
  }
}

class _OfferCard extends StatelessWidget {
  final String offerTitle;
  final String publishedDate;
  final VoidCallback onTap;

  const _OfferCard({
    required this.offerTitle,
    required this.publishedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        
        title: Text(offerTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Pubilée le : ${publishedDate.substring(0, 10)}'),
        onTap: onTap,
      ),
    );
  }
}

// Candidates screen
class OfferCandidatesScreen extends StatelessWidget {
  final int offerId;

  const OfferCandidatesScreen({required this.offerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vos candidats')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchCandidates(offerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching candidates!'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun candidats pour le moment!'));
          }

          final candidates = snapshot.data!;
          return ListView.builder(
            itemCount: candidates.length,
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              final user = candidate['user'];
              final profil = user['profil'];

              return _CandidateCard(
                name: '${user['firstname']} ${user['lastname']}',
                bio: profil['bio'] as String ?? '--',
                city: '${profil['city']}, ${profil['country']}',
                appliedDate: candidate['created_at'] as String,
                profilePictureUrl: 'http://localhost:8000/api/profil/image/${profil['id']}',
                postulationId: candidate['id'] as int, // Pass the postulation ID here
              );
            },
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchCandidates(int offerId) async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/postulation/offre/$offerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load candidates');
    }
  }
}

class _CandidateCard extends StatelessWidget {
  final String name;
  final String bio;
  final String city;
  final String appliedDate;
  final String profilePictureUrl;
  final int postulationId; // Add the postulation ID to identify the candidate

  const _CandidateCard({
    required this.name,
    required this.bio,
    required this.city,
    required this.appliedDate,
    required this.profilePictureUrl,
    required this.postulationId, // Accept the postulation ID
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(profilePictureUrl)),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Ville: $city'),
                const SizedBox(height: 4),
                Text('Postulé le: ${appliedDate.substring(0, 10)}'),
              ],
            ),
            onLongPress: () {
              _showAcceptRejectDialog(context);
            },
          ),
        ),
        
      ],
    );
  }

  void _showAcceptRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Center(child: Text('Candidature de $name', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
          content: const Text('Voulez-vous accepter \n ou rejeter ce candidat?', textAlign: TextAlign.center),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleCandidateAction(context, 'accept'); // Handle accept action
              },
              child: const Text('Accepter'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleCandidateAction(context, 'reject'); // Handle reject action
              },
              child: const Text('Rejeter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCandidateAction(BuildContext context, String action) async {
    final String apiUrl = action == 'accept'
        ? 'http://localhost:8000/api/accept/$postulationId'
        : 'http://localhost:8000/api/reject/$postulationId';

    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        action == 'accept' ? 'Candidature accepté' : 'Candidature rejeté',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Erreur lors de la mise à jour de la candidature',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
