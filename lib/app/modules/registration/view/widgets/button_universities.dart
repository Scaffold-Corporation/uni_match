import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universities/universities.dart';
import 'package:uni_match/app/modules/registration/store/registration_store.dart';


class ButtonUniversities extends StatefulWidget {
  final String hintText;
  final RegistrationStore controller;



  const ButtonUniversities(
      {Key? key,
        required this.hintText, required this.controller,
      })
      : super(key: key);

  @override
  State<ButtonUniversities> createState() => _ButtonUniversitiesState();
}

class _ButtonUniversitiesState extends State<ButtonUniversities> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: TextFormField(
        enabled: false,
        style: GoogleFonts.nunito(
          color: Colors.grey[700],
          fontSize: 17,
        ),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey[700]),
          hintText: widget.hintText,
          filled: true,
          fillColor: Colors.white.withOpacity(0.6),
          alignLabelWithHint: true,
          contentPadding:EdgeInsets.fromLTRB(20, 18, 20, 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(
              width: 1.18,
              color: Color(0xff1a1919),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(
              width: 1.2,
              color: Colors.white,
            ), //Color(0xff1a1919)
          ),
        ),
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectUniversity(
              backButton: true,
              infoButton: true,
              labelText: "Universidades",
              hintText: "Insira o nome de sua universidade",
              errorText: "Universidade não encontrada!",

              textFormFieldColor: Colors.blue,
              iconBackColor: Colors.deepPurpleAccent,
              iconCollegeColor: Colors.indigoAccent,
              iconInfoColor: Colors.deepPurpleAccent,

              borderRadius: 10.0,

              onSelect: (Map response){
                widget.controller.setUniversidade(response['full_name']);
                Navigator.pop(context);
                debugPrint(response.toString());
              },
            ),
          ),
        );
      },
    );

  }
}
