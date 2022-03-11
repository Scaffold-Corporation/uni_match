import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'registration_store.g.dart';

class RegistrationStore = _RegistrationStore with _$RegistrationStore;

abstract class _RegistrationStore with Store {
  //Crontroller Registro Nome
  final nameController = TextEditingController();
  //Crontroller Registro Email
  final emailController = TextEditingController();
  //Crontroller Registro Insta
  final instaController = TextEditingController();
  //Crontroller Registro Universidade
  @observable
  String universidadeController = '';
  //Crontrollers Registro Curso
  final cursoController = TextEditingController();
  @observable
  String course = '';
  @observable
  String cursoGraduacao = '';
  //Crontrollers Registro Tipo de Graduacao
  @observable
  String tipoGraduacao = '';
  @observable
  bool isGraduate = true;
  //Crontroller Registro Ano de inicio
  final anoiController = TextEditingController();
  //Crontroller Registro Ano de saida
  final anofController = TextEditingController();
  //Crontroller Registro Codigo da Atletica
  final codigoAtleticaController = TextEditingController();


  @action
  setUniversidade(String universidade) => universidadeController = universidade;

  @action
  setCurso(String curso) => cursoGraduacao = curso;

  @action
  setTipoGraducao(String tipoGraducao) => tipoGraduacao = tipoGraducao;

  @action
  changeCourse(bool value){
    if(value==true){
      course = cursoGraduacao;
    }else{
      course = cursoController.text;
    }
  }

  @action
  void changeIsGraduate (bool value){
    isGraduate = value;
  }


  //Controle de dados Resgistro
  @observable
  bool dados = false;

  @action
  dateRegistrationpage1() {
    if (nameController.text != '' &&
        emailController.text != '' &&
        instaController.text != '') {
      dados = true;
    } else
      dados = false;
  }


  @observable
  List<String> typeGraduacao = [
   'Graduação',
   'Pós Graduação',
   'Mestrado',
   'Doutorado',
   'Pós Doutorado',

  ];

  @observable
  List<String> cursos = [
    'Administração',
    'Agrimensura',
    'Agroecologia',
    'Agroindústria',
    'Agronomia (ou Engenharia Agronômica)',
    'Análise e Desenvolvimento de Sistemas',
    'Antropologia',
    'Aquacultura',
    'Arqueologia',
    'Arquitetura',
    'Arquivística',
    'Artes Cênicas',
    'Artes Visuais',
    'Astronomia',
    'Automação Industrial',
    'Biblioteconomia',
    'Biocombustíveis',
    'Bioengenharia',
    'Biofísica',
    'Biologia',
    'Biologia Marinha',
    'Biomedicina',
    'Biotecnologia',
    'Botânica',
    'Cafeicultura',
    'Ciência da Computação',
    'Ciência dos Alimentos',
    'Ciência dos Materiais',
    'Ciência e Tecnologia',
    'Ciência Política (ou Ciências do Estado)',
    'Ciências Aeronáuticas',
    'Ciências Agrárias',
    'Ciências Ambientais',
    'Ciências Atuariais',
    'Ciências Biológicas',
    'Ciências Biomoleculares',
    'Ciências Contábeis',
    'Ciências da Saúde',
    'Ciências do Meio Aquático',
    'Ciências Humanas (licenciatura)',
    'Ciências Matemáticas da Terra',
    'Ciências Naturais (licenciatura)',
    'Ciências Náuticas',
    'Ciências Sociais',
    'Cinema',
    'Comércio Exterior',
    'Comunicação social',
    'Construção de Edifícios',
    'Construção de Estradas',
    'Construção Naval',
    'Cooperativismo',
    'Cosmetologia',
    'Dança',
    'Defesa e Gestão Estratégica Internacional',
    'Desenho Industrial',
    'Design de Interiores',
    'Design de Jogos Digitais',
    'Design de Moda',
    'Design de Produto',
    'Design Gráfico',
    'Direito',
    'Drenagem e Irrigação',
    'Ecologia',
    'Economia',
    'Economia Doméstica',
    'Editoração',
    'Educação Artística (licenciatura)',
    'Educação do Campo (licenciatura)',
    'Educação física',
    'Energias Renováveis',
    'Enfermagem',
    'Engenharia Aeroespacial',
    'Engenharia Aeronáutica',
    'Engenharia Agrícola',
    'Engenharia Ambiental',
    'Engenharia Biomédica',
    'Engenharia Cartográfica (ou Engenharia Geográfica)',
    'Engenharia Civil',
    'Engenharia de Alimentos',
    'Engenharia de Computação',
    'Engenharia de Controle e Automação',
    'Engenharia de Manufatura',
    'Engenharia de Materiais',
    'Engenharia de Minas',
    'Engenharia de Pesca',
    'Engenharia de Petróleo',
    'Engenharia de Produção',
    'Engenharia de Sistemas Eletrônicos',
    'Engenharia de Software',
    'Engenharia de Tecidos',
    'Engenharia de Telecomunicações',
    'Engenharia Elétrica (ou Engenharia de Energia)',
    'Engenharia Física',
    'Engenharia Florestal',
    'Engenharia Geológica',
    'Engenharia Industrial Madeireira',
    'Engenharia Mecânica',
    'Engenharia Mecatrônica',
    'Engenharia Metalúrgica',
    'Engenharia Militar',
    'Engenharia Naval e Oceânica',
    'Engenharia Nuclear',
    'Engenharia Química',
    'Engenharia Sanitária',
    'Engenharia Têxtil',
    'Enologia',
    'Escultura',
    'Esporte e Lazer',
    'Estatística',
    'Eventos',
    'Farmácia (ou Bioquímica)',
    'Filosofia',
    'Física',
    'Física Computacional',
    'Física Médica',
    'Fisioterapia',
    'Fonoaudiologia',
    'Fotografia',
    'Fruticultura',
    'Gastronomia',
    'Geofísica',
    'Geografia',
    'Geologia',
    'Geoprocessamento e Sensoriamento Remoto',
    'Gerontologia',
    'Gestão Ambiental',
    'Gestão Comercial',
    'Gestão da Qualidade',
    'Gestão da Tecnologia da Informação',
    'Gestão de Petróleo e Gás',
    'Gestão de Recursos Hídricos',
    'Gestão de Segurança Privada',
    'Gestão do Agronegócio',
    'Gestão em Serviços Jurídicos e Notariais',
    'Gestão Financeira',
    'Gestão Hospitalar',
    'Gestão Portuária',
    'Gestão Pública',
    'Gravurismo',
    'História',
    'História da Arte',
    'Horticultura',
    'Hotelaria',
    'Informática',
    'Informática Biomédica',
    'Jornalismo',
    'Letras',
    'Linguística',
    'Logística',
    'Manutenção Industrial',
    'Matemática',
    'Matemática Aplicada',
    'Matemática Computacional',
    'Mecatrônica e Mecânica de Precisão',
    'Medicina',
    'Medicina Veterinária',
    'Meliponicultura',
    'Mercadologia',
    'Meteorologia',
    'Microbiologia e Imunologia',
    'Mineração',
    'Museologia',
    'Música',
    'Nanotecnologia',
    'Naturologia',
    'Negócios Imobiliários',
    'Neurociência',
    'Nutrição',
    'Oceanografia',
    'Odontologia',
    'Oftálmica',
    'Ordenamento do Território',
    'Paisagismo',
    'Pedagogia',
    'Pintura',
    'Processamento de Dados',
    'Processos Escolares',
    'Processos Metalúrgicos',
    'Produção Audiovisual (Rádio e TV ou Radialismo)',
    'Produção Cultural',
    'Produção de Aguardente',
    'Produção de Laticínios',
    'Produção de Materiais Plásticos',
    'Produção Fonográfica',
    'Produção Sucroalcooleira',
    'Produção Têxtil',
    'Projetos de Estruturas Aeronáuticas',
    'Psicologia',
    'Publicidade e Propaganda',
    'Química',
    'Química Ambiental',
    'Química Industrial',
    'Quiropraxia',
    'Radiologia',
    'Recursos Humanos',
    'Redes de Computadores',
    'Redes de Telecomunicações',
    'Relações Internacionais',
    'Relações Públicas',
    'Saneamento Ambiental',
    'Saúde Coletiva',
    'Secretariado',
    'Segurança da Informação',
    'Segurança no Trabalho',
    'Segurança Pública',
    'Serviço Social',
    'Silvicultura',
    'Sistemas Biomédicos',
    'Sistemas de Informação',
    'Sistemas de Navegação Fluvial',
    'Sistemas Elétricos',
    'Sistemas Embarcados',
    'Sistemas para Internet',
    'Sociologia',
    'Teatro',
    'Telemática',
    'Teologia',
    'Terapia ocupacional',
    'Transporte Aéreo',
    'Transporte Terrestre',
    'Turismologia',
    'Urbanismo',
    'Zootecnia',
  ];

}
