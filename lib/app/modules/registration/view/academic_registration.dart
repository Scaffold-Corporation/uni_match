import 'package:animate_do/animate_do.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_match/app/modules/registration/repository/registration_repository.dart';
import 'package:uni_match/app/modules/registration/store/registration_store.dart';
import 'package:uni_match/app/modules/registration/view/widgets/button_universities.dart';
import 'package:uni_match/app/modules/registration/view/widgets/registration_text_field.dart';

class AcademicRegistrationPage extends StatefulWidget {
  final RegistrationStore controller;

  const AcademicRegistrationPage({Key? key, required this.controller})
      : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<AcademicRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurpleAccent,
                Colors.purpleAccent,
                Colors.pinkAccent,
                Colors.pink,
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: const EdgeInsets.only(top: 5.0, left: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white70,
                                ))),
                      ),
                      Text(
                        "Pré Cadastro",
                        style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(40.0),
                                      topLeft: const Radius.circular(40.0),
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 25.0,
                                      color: Colors.pinkAccent,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLines: 3,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 45,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.school,
                                      size: 20.0,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Acadêmico",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: const Radius.circular(40.0),
                                      topRight: const Radius.circular(40.0),
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.description,
                                      size: 20.0,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Observer(
                        builder: (_) => Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Observer(
                                  builder: (_) => ButtonUniversities(
                                    hintText: widget.controller
                                            .universidadeController.isEmpty
                                        ? "Universidades"
                                        : widget
                                            .controller.universidadeController,
                                    controller: widget.controller,
                                  ),
                                )),
                            SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 17,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.6),
                                // alignLabelWithHint: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 18, 20, 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  borderSide: BorderSide(
                                    width: 1.18,
                                    color: Color(0xff1a1919),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  borderSide: BorderSide(
                                    width: 1.2,
                                    color: Colors.white,
                                  ), //Color(0xff1a1919)
                                ),
                              ),
                              items: widget.controller.typeGraduacao
                                  .map((typegraduacao) {
                                return new DropdownMenuItem(
                                    value: typegraduacao,
                                    child: Text(
                                      typegraduacao.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ));
                              }).toList(),
                              hint: Text("Tipo de Graduação"),
                              onChanged: (typegraduacao) {
                                widget.controller.setTipoGraducao(typegraduacao!);
                                if(typegraduacao == "Graduação"){
                                  widget.controller.changeIsGraduate(true);
                                }
                                else{
                                  widget.controller.changeIsGraduate(false);
                                }
                              },
                              onTap: () => FocusScope.of(context).unfocus(),
                            ),
                            SizedBox(height: 15),
                            widget.controller.isGraduate
                                ? DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 17,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.6),
                                      // alignLabelWithHint: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 18, 20, 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                        borderSide: BorderSide(
                                          width: 1.18,
                                          color: Color(0xff1a1919),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                        borderSide: BorderSide(
                                          width: 1.2,
                                          color: Colors.white,
                                        ), //Color(0xff1a1919)
                                      ),
                                    ),
                                    items:
                                        widget.controller.cursos.map((curso) {
                                      return new DropdownMenuItem(
                                          value: curso,
                                          child: Text(
                                            curso.toString(),
                                            overflow: TextOverflow.ellipsis,
                                          ));
                                    }).toList(),
                                    hint: Text("Curso"),
                                    onChanged: (curso) {
                                      widget.controller.setCurso(curso.toString());
                                    },
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                  )
                                : RegistrationTextField(
                                    hintText: "Curso",
                                    textInputType: TextInputType.text,
                                    controller: widget.controller.cursoController,
                                  ),
                            SizedBox(height: 15),
                            RegistrationTextField(
                              hintText: "Ingresso",
                              textInputType: TextInputType.number,
                              controller: widget.controller.anoiController,
                              textInputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                                DataInputFormatter(),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RegistrationTextField(
                              hintText: "Conclusão",
                              textInputType: TextInputType.number,
                              controller: widget.controller.anofController,
                              textInputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                                DataInputFormatter(),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RegistrationTextField(
                              hintText: "Código da atlética",
                              textInputType: TextInputType.text,
                              controller:
                                  widget.controller.codigoAtleticaController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      widget.controller.universidadeController.isNotEmpty &&
                              widget.controller.cursoController.text.isNotEmpty || widget.controller.cursoGraduacao.isNotEmpty &&
                              widget.controller.anoiController.text.isNotEmpty &&
                              widget.controller.anofController.text.isNotEmpty
                          ? FadeInDown(
                              delay: Duration(milliseconds: 200),
                              child: TextButton(
                                  child: Text(
                                    "Prosseguir",
                                    style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (widget.controller.universidadeController
                                            .isEmpty &&
                                        widget.controller.cursoController.text.isNotEmpty ||
                                        widget.controller.cursoGraduacao.isNotEmpty &&
                                        widget.controller.anoiController.text
                                            .isEmpty &&
                                        widget.controller.anofController.text
                                            .isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Preencha todos os campos!');
                                    } else {

                                      final dataI =
                                          widget.controller.anoiController.text;
                                      final diaI =
                                          int.parse(dataI.split('/')[0]) <= 31;
                                      final mesI =
                                          int.parse(dataI.split('/')[1]) <= 12;
                                      final anoI =
                                          int.parse(dataI.split('/')[2]) > 2000 &&
                                              int.parse(dataI.split('/')[2]) <
                                                  2100;

                                      final dataU =
                                          widget.controller.anofController.text;
                                      final diaU =
                                          int.parse(dataU.split('/')[0]) <= 31;
                                      final mesU =
                                          int.parse(dataU.split('/')[1]) <= 12;
                                      final anoU =
                                          int.parse(dataU.split('/')[2]) >=
                                                  DateTime.now().year &&
                                              int.parse(dataI.split('/')[2]) <
                                                  2100;

                                      final codAtletica = widget.controller
                                          .codigoAtleticaController.text;
                                      bool? response;
                                      if (codAtletica.isNotEmpty) {
                                        response = await RegistrationRepository()
                                            .verificarAtletica(codAtletica);
                                      }

                                      if (response == false) {
                                        Fluttertoast.showToast(
                                            msg: 'Código de atlética inválido!');
                                      } else if (diaI == false ||
                                          mesI == false ||
                                          anoI == false) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'A Data de ingeresso é inválida!');
                                      } else if (diaU == false ||
                                          mesU == false ||
                                          anoU == false) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'A Data de conclusão é inválida!');
                                      } else {
                                        FocusScope.of(context).unfocus();
                                        Modular.to.pushNamed(
                                            "/registration/registration3",
                                            arguments: widget.controller);
                                      }
                                      widget.controller.changeCourse(widget.controller.isGraduate);
                                    }
                                  },
                                ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
