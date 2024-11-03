import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:liveasy_internship/Screens/OTPScreen.dart';

class ValidateUser extends StatefulWidget {
  const ValidateUser({super.key});

  @override
  State<ValidateUser> createState() => _ValidateUserState();
}

class _ValidateUserState extends State<ValidateUser> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  Future<void> _verifyPhoneNumber() async {
    print('numbern ======================='+number.phoneNumber.toString());
    await _auth.verifyPhoneNumber(
      phoneNumber: number.phoneNumber.toString(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("User signed in automatically: ${_auth.currentUser}");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              phoneNo: controller.text,
              verificationID: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Code auto-retrieval timeout: $verificationId");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.clear)),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Please enter your mobile number',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: -5,
                      children: [
                        Text(
                          'You\'ll receive a 6 digit code',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          'to verify next.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber num) {

                                print('num========================='+num.phoneNumber.toString());
                                print('con========================='+controller.text.toString());
                                print('old number========================='+number.phoneNumber.toString());

                                //setState(() {
                                  number = num;
                                  print('new number========================='+number.phoneNumber.toString());
                                //});

                              },
                              onInputValidated: (bool value) {
                                print(value);
                              },
                              selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                useBottomSheetSafeArea: true,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: number,
                              textFieldController: controller,
                              formatInput: true,
                              keyboardType: TextInputType.number,
                              inputBorder: OutlineInputBorder(),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter mobile number';
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  _verifyPhoneNumber();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xff0A2472),
                                ),
                                child: Center(
                                  child: Text(
                                    'CONTINUE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ])));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

// @override
// Widget build(BuildContext context) {
//   var mobileNo = TextEditingController();
//   GlobalKey<FormState> userKey = GlobalKey();
//
//   return Scaffold(
//     body: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           IconButton(onPressed: () {}, icon: Icon(Icons.clear)),
//           SizedBox(
//             height: 20,
//           ),
//           Form(
//             key: userKey,
//             child:
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Please enter your mobile number',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                   Wrap(
//                     direction: Axis.vertical,
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     spacing: -5,
//                     children: [
//                       Text(
//                         'You\'ll receive a 6 digit code',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       Text(
//                         'to verify next.',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextFormField(
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Enter mobile number";
//                       }
//                     },
//                     controller: mobileNo!,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 1.2),
//                           borderRadius: BorderRadius.circular(0.5)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 1.2),
//                           borderRadius: BorderRadius.circular(0.5)),
//                       errorBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1.2, color: Colors.red),
//                           borderRadius: BorderRadius.circular(0.3)),
//                       focusedErrorBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1.2, color: Colors.red),
//                           borderRadius: BorderRadius.circular(0.3)),
//                       labelText: 'Mobile number',
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w400, fontSize: 15),
//                     ),
//                   ),
//                   OutlinedButton(
//                     onPressed: () {},
//                     child: Text(
//                       'CONTINUE',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ButtonStyle(
//                       backgroundColor:
//                           WidgetStatePropertyAll(Colors.deepPurple),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
