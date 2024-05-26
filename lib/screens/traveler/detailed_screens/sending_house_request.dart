import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marhba_bik/components/capacity_selector.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/white_container_field.dart';
import 'package:marhba_bik/models/house.dart';

class SendingHouseRequestScreen extends StatefulWidget {
  const SendingHouseRequestScreen({super.key, required this.house});

  final House house;

  @override
  State<SendingHouseRequestScreen> createState() =>
      _SendingHouseRequestScreenState();
}

class _SendingHouseRequestScreenState extends State<SendingHouseRequestScreen> {
  String? _paymentMethod;
  int selectedCapacity = 1;
  DateTimeRange? dates;

  void _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dates = picked;
      });
    }
  }

  String getFormattedDateRange() {
    if (dates == null) {
      return 'Click here to pick the dates';
    } else {
      final DateFormat formatter = DateFormat('d MMM');
      final String start = formatter.format(dates!.start);
      final String end = formatter.format(dates!.end);
      final int nights = dates!.duration.inDays;
      return '$start to $end ($nights nights)';
    }
  }

  int getNights() {
    return dates?.duration.inDays ?? 0;
  }

  int calculateTotalPrice() {
    int pricePerNight = int.parse(widget.house.price);
    int nights = getNights();
    int totalPrice = (pricePerNight * nights) + 200;
    return totalPrice;
  }

  void presentDialog(bool requestSent, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(requestSent ? 'Request Sent' : 'Error'),
          content: Text(message),
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
      presentDialog(false,
          'Please select a payment method before sending the request.'); // Payment method not selected
      return;
    }
    // ignore: unnecessary_null_comparison
    if (dates == null ||
        dates!.duration.inDays == 0) {
      presentDialog(false, 'Please select valid dates for your booking.');
      return;
    }

    String startDate = dates?.start != null
        ? DateFormat('yyyy-MM-dd').format(dates!.start)
        : 'Not selected';
    String endDate = dates?.end != null
        ? DateFormat('yyyy-MM-dd').format(dates!.end)
        : 'Not selected';
    int nights = getNights();
    int totalPrice = calculateTotalPrice();
    String paymentMethod = _paymentMethod ?? 'Not selected';
    int guests = selectedCapacity; // Added line for number of guests

    print('Start Date: $startDate');
    print('End Date: $endDate');
    print('Nights: $nights');
    print('Guests: $guests'); // Included guests
    print('Total Price: ${totalPrice}DZD');
    print('Payment Method: $paymentMethod');
    presentDialog(true,'Your booking request has been sent successfully.'); // Request sent successfully
  }

  @override
  Widget build(BuildContext context) {
    String price = widget.house.price;
    int nights = getNights();
    int totalPrice = calculateTotalPrice();

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
                            imageUrl: widget.house.images[0],
                            fit: BoxFit.cover,
                            width: 130,
                            height: 100,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.house.placeType,
                                style: const TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                widget.house.title,
                                style: const TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              Text(
                                '${widget.house.address}, ${widget.house.wilaya}',
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
                  title: 'Your Homestay',
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
                              InkWell(
                                onTap: _pickDateRange,
                                child: Text(
                                  getFormattedDateRange(),
                                  style: const TextStyle(
                                    color: Color(0xff001939),
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'KastelovAxiforma',
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: _pickDateRange,
                            child: const Text(
                              'Edit',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff001939),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'KastelovAxiforma',
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Guests',
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
                              });
                            },
                          )
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
                            '${price}DZD x $nights nights',
                            style: const TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${int.parse(price) * nights}DZD',
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
