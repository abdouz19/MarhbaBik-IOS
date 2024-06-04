import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marhba_bik/api/e_paiment.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/white_container_field.dart';
import 'package:marhba_bik/launchers/url_launcher.dart';
import 'package:marhba_bik/screens/shared/subscription_card.dart';
import 'package:marhba_bik/screens/shared/subscription_header.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  const SubscriptionDetailsScreen(
      {super.key,
      required this.imagePath,
      required this.valueColor1,
      required this.planName,
      required this.price,
      required this.texts,
      required this.textColor,
      required this.valueColor2});

  final String imagePath;
  final int valueColor1;
  final int valueColor2;
  final String planName;
  final int price;
  final List<String> texts;
  final int textColor;

  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  double commission = 0;
  bool isLoading = false;
  double totalPrice = 0;

  ApiService apiService = ApiService();

  Future<void> calculateTotalPrice() async {
    setState(() {
      isLoading = true;
    });
    try {
      final commissionData = await apiService.calculateCommission(widget.price);
      setState(() {
        commission = commissionData['commission'];
        totalPrice = widget.price + commission;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        commission = 0;
        totalPrice = widget.price as double;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleProceed() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      isLoading = true;
    });
    try {
      final result = await apiService.createTransfer(
          totalPrice, uid, 'https://www.google.com/');
      print(result);
      if (result['success']) {
        final String url = result['url'];
        bool launched = await UrlHandler.open(url);
        if (!launched) {
          throw 'Could not launch $url';
        }
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    calculateTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SubscriptionHeader(
                  planName: widget.planName,
                  price: widget.price,
                  valueColor1: widget.valueColor1,
                  valueColor2: widget.valueColor2,
                ),
                const SizedBox(
                  height: 40,
                ),
                SubscriptionCard(
                  imagePath: widget.imagePath,
                  textColor: widget.textColor,
                  texts: widget.texts,
                  valueColor1: widget.valueColor1,
                  valueColor2: widget.valueColor2,
                  planName: widget.planName,
                  price: widget.price,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomContainer(
                    title: 'Subscription details',
                    content: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Plan price',
                              style: TextStyle(
                                color: Color(0xff001939),
                                fontWeight: FontWeight.w300,
                                fontFamily: 'KastelovAxiforma',
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${widget.price} DZD',
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
                        Row(
                          children: [
                            const Text(
                              'Commission fee',
                              style: TextStyle(
                                color: Color(0xff001939),
                                fontWeight: FontWeight.w300,
                                fontFamily: 'KastelovAxiforma',
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    '$commission DZD',
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
                              'Total amount',
                              style: TextStyle(
                                color: Color(0xff001939),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'KastelovAxiforma',
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              isLoading ? 'Loading...' : '$totalPrice DZD',
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
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: MaterialButtonAuth(
                        onPressed: handleProceed, label: 'Proceed'))
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
