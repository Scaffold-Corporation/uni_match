// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RegistrationStore on _RegistrationStore, Store {
  final _$universidadeControllerAtom =
      Atom(name: '_RegistrationStore.universidadeController');

  @override
  String get universidadeController {
    _$universidadeControllerAtom.reportRead();
    return super.universidadeController;
  }

  @override
  set universidadeController(String value) {
    _$universidadeControllerAtom
        .reportWrite(value, super.universidadeController, () {
      super.universidadeController = value;
    });
  }

  final _$courseAtom = Atom(name: '_RegistrationStore.course');

  @override
  String get course {
    _$courseAtom.reportRead();
    return super.course;
  }

  @override
  set course(String value) {
    _$courseAtom.reportWrite(value, super.course, () {
      super.course = value;
    });
  }

  final _$cursoGraduacaoAtom = Atom(name: '_RegistrationStore.cursoGraduacao');

  @override
  String get cursoGraduacao {
    _$cursoGraduacaoAtom.reportRead();
    return super.cursoGraduacao;
  }

  @override
  set cursoGraduacao(String value) {
    _$cursoGraduacaoAtom.reportWrite(value, super.cursoGraduacao, () {
      super.cursoGraduacao = value;
    });
  }

  final _$tipoGraduacaoAtom = Atom(name: '_RegistrationStore.tipoGraduacao');

  @override
  String get tipoGraduacao {
    _$tipoGraduacaoAtom.reportRead();
    return super.tipoGraduacao;
  }

  @override
  set tipoGraduacao(String value) {
    _$tipoGraduacaoAtom.reportWrite(value, super.tipoGraduacao, () {
      super.tipoGraduacao = value;
    });
  }

  final _$isGraduateAtom = Atom(name: '_RegistrationStore.isGraduate');

  @override
  bool get isGraduate {
    _$isGraduateAtom.reportRead();
    return super.isGraduate;
  }

  @override
  set isGraduate(bool value) {
    _$isGraduateAtom.reportWrite(value, super.isGraduate, () {
      super.isGraduate = value;
    });
  }

  final _$dadosAtom = Atom(name: '_RegistrationStore.dados');

  @override
  bool get dados {
    _$dadosAtom.reportRead();
    return super.dados;
  }

  @override
  set dados(bool value) {
    _$dadosAtom.reportWrite(value, super.dados, () {
      super.dados = value;
    });
  }

  final _$typeGraduacaoAtom = Atom(name: '_RegistrationStore.typeGraduacao');

  @override
  List<String> get typeGraduacao {
    _$typeGraduacaoAtom.reportRead();
    return super.typeGraduacao;
  }

  @override
  set typeGraduacao(List<String> value) {
    _$typeGraduacaoAtom.reportWrite(value, super.typeGraduacao, () {
      super.typeGraduacao = value;
    });
  }

  final _$cursosAtom = Atom(name: '_RegistrationStore.cursos');

  @override
  List<String> get cursos {
    _$cursosAtom.reportRead();
    return super.cursos;
  }

  @override
  set cursos(List<String> value) {
    _$cursosAtom.reportWrite(value, super.cursos, () {
      super.cursos = value;
    });
  }

  final _$_RegistrationStoreActionController =
      ActionController(name: '_RegistrationStore');

  @override
  dynamic setUniversidade(String universidade) {
    final _$actionInfo = _$_RegistrationStoreActionController.startAction(
        name: '_RegistrationStore.setUniversidade');
    try {
      return super.setUniversidade(universidade);
    } finally {
      _$_RegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurso(String curso) {
    final _$actionInfo = _$_RegistrationStoreActionController.startAction(
        name: '_RegistrationStore.setCurso');
    try {
      return super.setCurso(curso);
    } finally {
      _$_RegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTipoGraducao(String tipoGraducao) {
    final _$actionInfo = _$_RegistrationStoreActionController.startAction(
        name: '_RegistrationStore.setTipoGraducao');
    try {
      return super.setTipoGraducao(tipoGraducao);
    } finally {
      _$_RegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeCourse(bool value) {
    final _$actionInfo = _$_RegistrationStoreActionController.startAction(
        name: '_RegistrationStore.changeCourse');
    try {
      return super.changeCourse(value);
    } finally {
      _$_RegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeIsGraduate(bool value) {
    final _$actionInfo = _$_RegistrationStoreActionController.startAction(
        name: '_RegistrationStore.changeIsGraduate');
    try {
      return super.changeIsGraduate(value);
    } finally {
      _$_RegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic dateRegistrationpage1() {
    final _$actionInfo = _$_RegistrationStoreActionController.startAction(
        name: '_RegistrationStore.dateRegistrationpage1');
    try {
      return super.dateRegistrationpage1();
    } finally {
      _$_RegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
universidadeController: ${universidadeController},
course: ${course},
cursoGraduacao: ${cursoGraduacao},
tipoGraduacao: ${tipoGraduacao},
isGraduate: ${isGraduate},
dados: ${dados},
typeGraduacao: ${typeGraduacao},
cursos: ${cursos}
    ''';
  }
}
