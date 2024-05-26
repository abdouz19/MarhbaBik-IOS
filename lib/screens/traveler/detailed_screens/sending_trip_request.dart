import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marhba_bik/components/capacity_selector.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/white_container_field.dart';
import 'package:marhba_bik/models/trip.dart';

class SendingTripRequestScreen extends StatefulWidget {
  const SendingTripRequestScreen({super.key, required this.trip});

  final Trip trip;

  @override
  State<SendingTripRequestScreen> createState() =>
      _SendingTripRequestScreenState();
}

class _SendingTripRequestScreenState extends State<SendingTripRequestScreen> {
  String? _paymentMethod;
  int selectedCapacity = 1;
  late int totalPrice;

  @override
  void initState() {
    super.initState();
    totalPrice = int.parse(widget.trip.price) + 200;
  }

  void _updateTotalPrice() {
    setState(() {
      totalPrice = calculateTotalPrice();
    });
  }

  int getPeople() {
    return selectedCapacity;
  }

  int calculateTotalPrice() {
    int pricePerPerson = int.parse(widget.trip.price);
    int people = getPeople();
    int totalPrice = (pricePerPerson * people) + 200;
    return totalPrice;
  }

  void presentDialog(bool requestSent) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(requestSent ? 'Request Sent' : 'Error'),
          content: Text(
            requestSent
                ? 'Your booking request has been sent successfully.'
                : 'Please select a payment method before sending the request.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _requestToBook() {
    if (_paymentMethod == null) {
      presentDialog(false); // Payment method not selected
      return;
    }
    int people = getPeople();
    String paymentMethod = _paymentMethod ?? 'Not selected';

    print('People: $people');
    print('Total Price: ${totalPrice}DZD');
    print('Payment Method: $paymentMethod');

    presentDialog(true); // Request sent successfully
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = widget.trip.startDate.toDate();
    DateTime endDate = widget.trip.endDate.toDate();

    // Format the dates
    String formattedStartDate = DateFormat('d MMM').format(startDate);
    String formattedEndDate = DateFormat('d MMM').format(endDate);

    // Combined date range string
    String dateRange = '$formattedStartDate - $formattedEndDate';
    int people = getPeople();
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              centerTitle: true,
              title: const Text(
                'Request to book',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xff001939),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'KastelovAxiforma',
                  fontSize: 22,
                ),
              ),
            )),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(children: [
                CustomContainer(
                  content: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                            imageUrl: widget.trip.images[0],
                            fit: BoxFit.cover,
                            width: 130,
                            height: 100,
                          ),
                        ),
                        const SizedBox(
                            width:
                                12), // Add some spacing between the image and the text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateRange,
                                style: const TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                widget.trip.title,
                                style: const TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              Text(
                                widget.trip.wilaya,
                                style: const TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomContainer(
                  title: 'Your Trip',
                  content: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Dates',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'KastelovAxiforma',
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                dateRange,
                                style: const TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'KastelovAxiforma',
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'People',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CapacitySelector(
                            space: 13,
                            paddingNumber: 1,
                            initialCapacity: 1,
                            onCapacityChanged: (v) {
                              setState(() {
                                selectedCapacity = v;
                                _updateTotalPrice();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomContainer(
                  title: 'Price details',
                  content: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.trip.price}DZD x $people people',
                            style: const TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${int.parse(widget.trip.price) * people}DZD',
                            style: const TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Tax',
                            style: TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 13,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '200DZD',
                            style: TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: const Color(0xff001939).withOpacity(0.1),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${totalPrice}DZD',
                            style: const TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomContainer(
                  title: 'Pay with',
                  content: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.credit_card),
                        title: const Text(
                          'Credit card',
                          style: TextStyle(
                            color: Color(0xff001939),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'KastelovAxiforma',
                            fontSize: 14,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: 'credit_card',
                          groupValue: _paymentMethod,
                          onChanged: (String? value) {
                            setState(() {
                              _paymentMethod = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _paymentMethod = 'credit_card';
                          });
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.money_rounded),
                        title: const Text(
                          'Hand to hand',
                          style: TextStyle(
                            color: Color(0xff001939),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'KastelovAxiforma',
                            fontSize: 14,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: 'hand_to_hand',
                          groupValue: _paymentMethod,
                          onChanged: (String? value) {
                            setState(() {
                              _paymentMethod = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _paymentMethod = 'hand_to_hand';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Your reservation wont\' be confirmed until the host accepts your request (within 24 hours).',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff001939),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'KastelovAxiforma',
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButtonAuth(
                    onPressed: _requestToBook, label: 'Request to book')
              ]),
            )));
  }
}
