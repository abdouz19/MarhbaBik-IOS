import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/widgets/info_message.dart';
import 'package:shimmer/shimmer.dart';

class HousesOffersScreen extends StatefulWidget {
  const HousesOffersScreen({Key? key, required this.userID}) : super(key: key);
  final String userID;

  @override
  State<HousesOffersScreen> createState() => _HousesOffersScreenState();
}

class _HousesOffersScreenState extends State<HousesOffersScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _houseBookings = [];

  @override
  void initState() {
    super.initState();
    _fetchHouseBookings();
  }

  Future<void> _fetchHouseBookings() async {
    FirestoreService firestoreService = FirestoreService();
    List<Map<String, dynamic>> bookings =
        await firestoreService.fetchBookingHouses(widget.userID);
    setState(() {
      _houseBookings = bookings;
      _loading = false;
    });
  }

  Future<Map<String, dynamic>?> _getUserData(String userID) async {
    FirestoreService firestoreService = FirestoreService();
    return await firestoreService.getUserDataById(userID);
  }

  Future<Map<String, dynamic>?> _getHouse(String houseID) async {
    FirestoreService firestoreService = FirestoreService();
    return await firestoreService.getHouseById(houseID);
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat.MMMd().format(dateTime);
  }

  String _formatPaymentMethod(String paymentMethod) {
    return paymentMethod
        .split('_')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  Future<void> _updateBookingStatus(
      BuildContext context, String bookingID, String status, int index) async {
    FirestoreService firestoreService = FirestoreService();
    await firestoreService.updateBookingStatus(bookingID, status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: status == 'accepted'
            ? const Text('Réservation acceptée')
            : const Text('Réservation refusée'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Update UI
    setState(() {
      // Update the booking status in the local list
      _houseBookings[index]['bookingStatus'] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservations de maison'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _houseBookings.isEmpty
                ? _buildNoBookingsWidget()
                : RefreshIndicator(
                    onRefresh: _fetchHouseBookings,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      itemCount: _houseBookings.length,
                      itemBuilder: (context, index) {
                        final booking = _houseBookings[index];
                        return FutureBuilder(
                          future: Future.wait([
                            _getHouse(booking['id']),
                            _getUserData(booking['travelerID']),
                          ]),
                          builder:
                              (context, AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildLoadingSkeleton();
                            } else if (snapshot.hasError) {
                              return Text('Erreur: ${snapshot.error}');
                            } else {
                              final List<dynamic>? data = snapshot.data;
                              if (data != null && data.length == 2) {
                                Map<String, dynamic>? house =
                                    data[0] as Map<String, dynamic>?;
                                Map<String, dynamic>? user =
                                    data[1] as Map<String, dynamic>?;

                                String formattedPickupDate =
                                    _formatDate(booking['pickupDate']);
                                String formattedReturnDate =
                                    _formatDate(booking['returnDate']);
                                String formattedPaymentMethod =
                                    _formatPaymentMethod(
                                        booking['paymentMethod']);

                                // Check if the booking status is pending
                                if (booking['bookingStatus'] != 'pending') {
                                  // Skip rendering if the booking status is not pending
                                  return const SizedBox.shrink();
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff001939)
                                            .withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  house?['images']?[0] ?? '',
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 100,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${house?['placeType']}}',
                                                  style: const TextStyle(
                                                    color: Color(0xff001939),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  house?['title'] ?? '',
                                                  style: const TextStyle(
                                                    color: Color(0xff001939),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                                Text(
                                                  "${house?['address']}, ${house?['wilaya']}",
                                                  style: const TextStyle(
                                                    color: Color(0xff001939),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: const Color(0xff001939)
                                            .withOpacity(0.1),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          const Text(
                                            'Proposé par : ',
                                            style: TextStyle(
                                              color: Color(0xff001939),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '${user?['firstName']} ${user?['lastName'] ?? ''}',
                                            style: const TextStyle(
                                              color: Color(0xff989898),
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Text(
                                            'Date : ',
                                            style: TextStyle(
                                              color: Color(0xff001939),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '$formattedPickupDate to $formattedReturnDate (${booking['nights']} nuits)',
                                            style: const TextStyle(
                                              color: Color(0xff989898),
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Text(
                                            'Montant total : ',
                                            style: TextStyle(
                                              color: Color(0xff001939),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '${booking['price']}DZD',
                                            style: const TextStyle(
                                              color: Color(0xff989898),
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Text(
                                            'Méthode de paiement : ',
                                            style: TextStyle(
                                              color: Color(0xff001939),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            formattedPaymentMethod,
                                            style: const TextStyle(
                                              color: Color(0xff989898),
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await _updateBookingStatus(
                                                  context,
                                                  booking['bookingID'],
                                                  'declined',
                                                  index,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                elevation: 1,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.0),
                                                child: Text(
                                                  'Décliner',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'KastelovAxiforma',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await _updateBookingStatus(
                                                  context,
                                                  booking['bookingID'],
                                                  'accepted',
                                                  index,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                elevation: 1,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.0),
                                                child: Text(
                                                  'Accepter',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'KastelovAxiforma',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                );
                              } else {
                                // Handle null or empty data case
                                return const SizedBox();
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildNoBookingsWidget() {
    return const InfoMessageWidget(
        iconData: Icons.hourglass_empty,
        message: "Aucune demande de réservation pour le moment");
  }
}

Widget _buildLoadingSkeleton() {
  return SizedBox(
    height: 200,
    child: Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 48,
              height: 48,
              color: Colors.white,
            ),
            title: Container(
              width: double.infinity,
              height: 16,
              color: Colors.white,
            ),
            subtitle: Container(
              width: double.infinity,
              height: 16,
              color: Colors.white,
            ),
            trailing: Container(
              width: 48,
              height: 48,
              color: Colors.white,
            ),
          );
        },
      ),
    ),
  );
}
