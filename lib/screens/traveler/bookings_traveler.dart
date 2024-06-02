import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marhba_bik/services/firestore_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelerBookingsScreen extends StatefulWidget {
  const TravelerBookingsScreen({super.key, required this.travelerID});
  final String travelerID;

  @override
  State<TravelerBookingsScreen> createState() => _TravelerBookingsScreenState();
}

class _TravelerBookingsScreenState extends State<TravelerBookingsScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    FirestoreService firestoreService = FirestoreService();
    List<Map<String, dynamic>> carBookings =
        await firestoreService.fetchCarBookingsByTravelerID(widget.travelerID);
    List<Map<String, dynamic>> houseBookings = await firestoreService
        .fetchHouseBookingsByTravelerID(widget.travelerID);
    List<Map<String, dynamic>> tripBookings =
        await firestoreService.fetchTripBookingsByTravelerID(widget.travelerID);
    print('------------- $tripBookings.isEmpty');
    setState(() {
      _bookings = carBookings + houseBookings + tripBookings;
      _loading = false;
    });
  }

  Future<Map<String, dynamic>?> _getTargetData(
      String collection, String id) async {
    FirestoreService firestoreService = FirestoreService();
    switch (collection) {
      case 'cars':
        return await firestoreService.getCarById(id);
      case 'houses':
        return await firestoreService.getHouseById(id);
      case 'trips':
        return await firestoreService.getTripById(id);
      default:
        return null;
    }
  }

  Future<Map<String, dynamic>?> _getTrip(String tripID) async {
    FirestoreService firestoreService = FirestoreService();
    return await firestoreService.getTripById(tripID);
  }

  String _formatDate(String? date) {
    if (date == null) {
      return 'N/A';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat.MMMd().format(dateTime);
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A';
    }
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat.MMMd().format(dateTime);
    return formattedDate;
  }

  String _formatPaymentMethod(String paymentMethod) {
    return paymentMethod
        .split('_')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _bookings.isEmpty
                ? _buildNoBookingsWidget()
                : RefreshIndicator(
                    onRefresh: _fetchBookings,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      itemCount: _bookings.length,
                      itemBuilder: (context, index) {
                        final booking = _bookings[index];
                        final targetType = booking['targetType'];
                        return FutureBuilder(
                          future: _getTargetData(
                              booking['targetType'], booking['id']),
                          builder: (context,
                              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildLoadingSkeleton();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              Map<String, dynamic>? targetData = snapshot.data;

                              String formattedPickupDate =
                                  _formatDate(booking['pickupDate']);
                              String formattedReturnDate =
                                  _formatDate(booking['returnDate']);
                              String formattedPaymentMethod =
                                  _formatPaymentMethod(
                                      booking['paymentMethod']);
                              String formattedStartDate =
                                  _formatDate(booking['startDate']);
                              String formattedEndDate =
                                  _formatDate(booking['endDate']);

                              

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                targetData?['images']?[0] ?? '',
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
                                              if (targetType == 'cars') ...[
                                                Text(
                                                  '${targetData?['brand'] ?? targetData?['name']} ${targetData?['model'] ?? ''}',
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
                                                  targetData?['title'] ?? '',
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
                                                  targetData?['wilaya'] ?? '',
                                                  style: const TextStyle(
                                                    color: Color(0xff001939),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ] else if (targetType ==
                                                  'houses') ...[
                                                Text(
                                                  targetData?['placeType'] ??
                                                      '',
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
                                                  targetData?['title'] ?? '',
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
                                                  targetData?['address'] ?? '',
                                                  style: const TextStyle(
                                                    color: Color(0xff001939),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ] else if (targetType ==
                                                  'trips') ...[
                                                Text(
                                                  '$formattedStartDate - $formattedEndDate',
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
                                                  targetData?['title'] ?? '',
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
                                                  targetData?['wilaya'] ?? '',
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
                                          'Booking Status : ',
                                          style: TextStyle(
                                            color: Color(0xff001939),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          booking['bookingStatus'],
                                          style: TextStyle(
                                            color: booking['bookingStatus'] ==
                                                    'accepted'
                                                ? Colors.green
                                                : booking['bookingStatus'] ==
                                                        'declined'
                                                    ? Colors.red
                                                    : Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (targetType == 'cars') ...[
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
                                            '$formattedPickupDate to $formattedReturnDate (${booking['days']} days)',
                                            style: const TextStyle(
                                              color: Color(0xff989898),
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ] else if (targetType == 'houses') ...[
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
                                            '$formattedPickupDate to $formattedReturnDate (${booking['nights']} nights)',
                                            style: const TextStyle(
                                              color: Color(0xff989898),
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ] else if (targetType == 'trips') ...[
                                      Row(
                                        children: [
                                          const Text(
                                            'People : ',
                                            style: TextStyle(
                                              color: Color(0xff001939),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '${booking['people']} people',
                                            style: const TextStyle(
                                              color: Color(0xff989898),
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Text(
                                          'Total Money : ',
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
                                          'Payment method : ',
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
                                    MaterialButton(
                                      onPressed: () async {
                                        var status =
                                            await Permission.phone.request();
                                        if (status.isGranted) {
                                          String targetID = booking['targetID'];
                                          Map<String, dynamic>? userData =
                                              await FirestoreService()
                                                  .getUserDataById(targetID);
                                          String? phoneNumber =
                                              userData?['phoneNumber'];

                                          if (phoneNumber != null &&
                                              phoneNumber.isNotEmpty) {
                                            String url = 'tel:$phoneNumber';

                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              print(
                                                  'Could not launch phone call');
                                            }
                                          } else {
                                            print('Phone number not available');
                                          }
                                        } else {
                                          await Permission.phone.request();
                                        }
                                      },
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.phone),
                                          SizedBox(width: 8),
                                          Text(
                                            'Call',
                                            style: TextStyle(
                                              fontFamily: 'KastelovAxiforma',
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            "No booking requests yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
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
}
