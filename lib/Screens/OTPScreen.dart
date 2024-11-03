import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liveasy_internship/Screens/HomePage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({required this.phoneNo, required this.verificationID, super.key});
  final String phoneNo;
  final String verificationID;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String otpNo;

  Future<void> _signInWithOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationID,
      smsCode: otpNo,
    );

    try {
      await _auth.signInWithCredential(credential).then((value){
        print("User signed in: ${_auth.currentUser}");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(),));
      });
    } catch (e) {
      print("Failed to sign in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Verify phone',
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Code is sent to ${widget.phoneNo}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,  // Number of digits
                      onChanged: (value) {
                        setState(() {
                          print(value);
                          otpNo = value;
                        });

                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.red,
                      ),
                      onCompleted: (value) {
                        print("Completed: $value");
                      },
                    ),
                        SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          children: [Text(
                            'Did\'t receive the code? ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                            Text(
                              'Request again',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ]
                        ),SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            _signInWithOTP();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xff0A2472),
                            ),
                            child: Center(
                              child: Text('VERIFY AND CONTINUE',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }
}
