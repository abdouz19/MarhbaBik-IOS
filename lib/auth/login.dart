import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/api/user_services.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void onPushScreen(String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  void presentDialog(String title, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xff3F75BB),
          ),
          Positioned.fill(
            top: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'MarhbaBik!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xff001939),
                            letterSpacing: .5,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomizedTextFormField(
                        label: 'Email',
                        hintText: 'Ex: exemple@email.com',
                        icon: Icons.email,
                        textEditingController: emailController,
                        validator: (v) {
                          if (v == "") {
                            return "Oops! Don't leave this field empty!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomizedTextFormField(
                        label: 'Password',
                        hintText: '**********',
                        icon: Icons.lock,
                        textEditingController: passwordController,
                        isPassword: true,
                        validator: (v) {
                          if (v == "") {
                            return "Oops! Don't leave this field empty!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () async {
                          if (emailController.text == "") {
                            presentDialog(
                                'Oops! Looks like you forgot something...',
                                'Please enter your email address before proceeding to reset your password.');
                            return;
                          }
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: emailController.text);
                            presentDialog('Password Reset Email Sent!',
                                'We\'ve sent you an email with a link to reset your password. Please check your inbox and follow the instructions provided.');
                          } catch (e) {
                            presentDialog('Invalid Email',
                                'Please make sure the entered email address is correct and try again.');
                          }
                        },
                        child: Text(
                          'Forgot password?',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.poppins(
                            color: const Color(0xff3F75BB),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      MaterialButtonAuth(
                          label: 'Login',
                          onPressed: () async {
                            // Show circular progress indicator
                            showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // Prevent dismissing the dialog by tapping outside
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            if (formState.currentState!.validate()) {
                              try {
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                if (credential.user!.emailVerified) {
                                  // Get user data from Firestore
                                  final userData = await firestore
                                      .collection('users')
                                      .doc(credential.user!.uid)
                                      .get();
                                  final userRole = userData['role'];
                                  final personalDataProvided =
                                      userData['personalDataProvided'] ?? false;

                                  await _userService.storeUserToken();

                                  // Check if personal data is provided
                                  if (personalDataProvided) {
                                    // Check if subscription is paid
                                    final isSubscriptionPaid =
                                        await FirestoreService()
                                            .checkSubscriptionPayment(
                                                credential.user!.uid);

                                    // Navigate based on user role and subscription payment
                                    if (isSubscriptionPaid) {
                                      switch (userRole) {
                                        case 'traveler':
                                          onPushScreen('/traveler_home');
                                          break;
                                        case 'home owner':
                                          onPushScreen('/home_owner_home');
                                          break;
                                        case 'car owner':
                                          onPushScreen('/car_owner_home');
                                          break;
                                        case 'travelling agency':
                                          onPushScreen(
                                              '/travelling_agency_home');
                                          break;
                                        default:
                                          presentDialog('Unknown User Role',
                                              'User role not recognized.');
                                      }
                                    } else {
                                      // Redirect to SubscriptionScreen
                                      onPushScreen('/subscription_screen');
                                    }
                                  } else {
                                    // Redirect to info form based on user role
                                    switch (userRole) {
                                      case 'traveler':
                                        onPushScreen('/traveler_info_form');
                                        break;
                                      case 'home owner':
                                        onPushScreen('/home_owner_info_form');
                                        break;
                                      case 'car owner':
                                        onPushScreen('/car_owner_info_form');
                                        break;
                                      case 'travelling agency':
                                        onPushScreen(
                                            '/travelling_agency_info_form');
                                        break;
                                      default:
                                        presentDialog('Unknown User Role',
                                            'User role not recognized.');
                                    }
                                  }
                                } else {
                                  presentDialog('Account Verification Required',
                                      'Please check your email and click on the provided link to verify your account. Once verified, your account will be activated.');
                                }
                              } on FirebaseAuthException catch (e) {
                                String errorMessage = '';
                                if (e.code == 'user-not-found') {
                                  errorMessage =
                                      'Sorry, we couldn\'t find an account associated with that email address.';
                                } else if (e.code == 'wrong-password') {
                                  errorMessage =
                                      'The password you entered is incorrect. Please try again.';
                                } else {
                                  errorMessage =
                                      'An error occurred: ${e.message}';
                                }
                                // Close the circular progress indicator dialog
                                Navigator.pop(context);
                                presentDialog(
                                    'Authentication Error', errorMessage);
                              }
                            } else {
                              // Close the circular progress indicator dialog
                              Navigator.pop(context);
                            }
                          }),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          onPushScreen('/signup');
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account?",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff888888),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: " Signup",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff3F75BB),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
