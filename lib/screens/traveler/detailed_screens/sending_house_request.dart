import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  title: 'Your Homestay',
                  content: Column(
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dates',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'KastelovAxiforma',
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Click here to pick the dates',
                                style: TextStyle(
                                  color: Color(0xff001939),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'KastelovAxiforma',
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          Text(
                            'Edit',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 14,
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
                              onCapacityChanged: (v) {})
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
                      const Row(
                        children: [
                          Text(
                            '1500DZD x 5 nights',
                            style: TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 13,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '7500DZD',
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
                      const Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Color(0xff001939),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'KastelovAxiforma',
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '7700DZD',
                            style: TextStyle(
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
                MaterialButtonAuth(onPressed: () {}, label: 'Request to book')
              ]),
            )));
  }
}
