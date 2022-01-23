import 'package:flutter/material.dart';

/// APP SETINGS INFO CONSTANTS - SECTION ///
///
const String APP_NAME = "Unimatch";
const Color APP_PRIMARY_COLOR = Colors.pink;
const Color APP_ACCENT_COLOR = Colors.pinkAccent;
const String APP_VERSION_NAME = "v1.0.2";
const int ANDROID_APP_VERSION_NUMBER = 1; // Google Play Version Number
const int IOS_APP_VERSION_NUMBER = 1; // App Store Version Number
//
// Add Google Maps - API KEY required for Passport feature
//
const String ANDROID_MAPS_API_KEY = "AIzaSyDQHbPVOqoBhcqhp6N5N_g7W5LmyjhW8pk"; //AIzaSyDQHbPVOqoBhcqhp6N5N_g7W5LmyjhW8pk
const String IOS_MAPS_API_KEY = "AIzaSyBlcVLVVlre07LtTyTeC_qv6OQt2k5ANUU";
//
// GOOGLE ADMOB INTERSTITIAL IDS
//
// For Android Platform
const String ANDROID_INTERSTITIAL_ID = "ca-app-pub-2162183208526463/1129939918"; //ca-app-pub-3940256099942544/1033173712
// For IOS Platform
const String IOS_INTERSTITIAL_ID = "ca-app-pub-2162183208526463~7799801108";

/// List of Supported Locales
/// Add your new supported Locale to the array list.
///
/// E.g: Locale('fr'), Locale('es'),
///
const List<Locale> SUPPORTED_LOCALES = [
  Locale('pt_br'),
];
///
/// END APP SETINGS - SECTION


///
/// DATABASE COLLECTIONS FIELD - SECTION
///
/// FIREBASE MESSAGING TOPIC
const NOTIFY_USERS = "NOTIFICAR_USUARIOS";

/// NOMES DE COLLECTION USADOS NO APP
///
const String C_APP_INFO = "AppInfo";
const String C_INTERESTED = "Interessados";
const String C_USERS = "Usuarios";
const String C_FLAGGED_USERS = "UsuariosSinalizados";
const String C_CONNECTIONS = "Conexoes";
const String C_MATCHES = "Matches";
const String C_CONVERSATIONS = "Conversas";
const String C_LIKES = "Likes";
const String C_VISITS = "Visitas";
const String C_DISLIKES = "Dislikes";
const String C_MESSAGES = "Mensagens";
const String C_NOTIFICATIONS = "Notificacoes";
const String C_PARTY = "Festas";
const String C_LIFESTYLE = "LifeStyle";
const String C_MOVIES = "Filmes";
const String C_ATHLETIC = "Atleticas";

/// NOME DE CAMPOS PARA AppInfo COLLECTION  ///
///
const String ANDROID_APP_CURRENT_VERSION = "android_app_current_version";
const String IOS_APP_CURRENT_VERSION = "ios_app_current_version";
const String ANDROID_PACKAGE_NAME = "android_package_name";
const String IOS_APP_ID = "ios_app_id";
const String APP_EMAIL = "app_email";
const String URL_FORM = "url_form";
const String PRIVACY_POLICY_URL = "privacy_policy_url";
const String TERMS_OF_SERVICE_URL = "terms_of_service_url";
const String FIREBASE_SERVER_KEY = "firebase_server_key";
const String STORE_SUBSCRIPTION_IDS = "store_subscription_ids";
const String FREE_ACCOUNT_MAX_DISTANCE = "free_account_max_distance";
const String FREE_ACCOUNT_SWIPES = "free_account_swipes";
const String VIP_ACCOUNT_MAX_DISTANCE = "vip_account_max_distance";
const String VIP_ACCOUNT_SWIPES = "vip_account_swipes";
const String PARTIES_MAX_DISTANCE = "parties_max_distance";
const String LIFESTYLE_MAX_DISTANCE = "lifestyle_max_distance";
// Admob variables
const String ADMOB_APP_ID = "admob_app_id";
const String ADMOB_INTERSTITIAL_AD_ID = "admob_interstitial_ad_id";

/// DATABASE FIELDS FOR Usuario COLLECTION  ///
///
const String USER_ID = "usuario_id";
const String USER_PROFILE_PHOTO = "usuario_foto_link";
const String USER_FULLNAME = "usuario_nome";
const String USER_GENDER = "usuario_genero";
const String USER_BIRTH_DAY = "usuario_dia_aniversario";
const String USER_BIRTH_MONTH = "usuario_mes_aniversario";
const String USER_BIRTH_YEAR = "usuario_ano_aniversario";
const String USER_SCHOOL = "usuario_universidade";
const String USER_ORIENTATION = "usuario_orientacao_sexual";
const String USER_INTERESTS = "usuario_interesses";
const String USER_BIO = "usuario_bio";
const String USER_PHONE_NUMBER = "usuario_numero_telefone";
const String USER_EMAIL = "usuario_email";
const String USER_GALLERY = "usuario_galeria";
const String USER_BADGES = "usuario_emblemas";
const String USER_COUNTRY = "usuario_pais";
const String USER_LOCALITY = "usuario_localidade";
const String USER_GEO_POINT = "usuario_geo_point";
const String USER_SETTINGS = "usuario_configuracoes";
const String USER_STATUS = "usuario_status";
const String USER_IS_VERIFIED = "usuario_verificado";
const String USER_LEVEL = "usuario_nivel";
const String USER_REG_DATE = "usuario_data_registro";
const String USER_LAST_LOGIN = "usuario_ultimo_login";
const String USER_LAST_SWIPES = "usuario_ultimo_tempo_swipe";
const String USER_DEVICE_TOKEN = "usuario_device_token";
const String USER_TOTAL_LIKES = "usuario_total_likes";
const String USER_TOTAL_VISITS = "usuario_total_visitas";
const String USER_TOTAL_DISLIKED = "usuario_total_disliked";
// User Univip map - fields
const String USER_UNIVIP = "usuario_univip";
const String USER_UNIVIP_DATE = "usuario_univip_data_compra";
const String USER_UNIVIP_TYPE = "usuario_univip_tipo";
const String USER_UNIVIP_INFO = "usuario_univip_info_compra";

// User Setting map - fields
const String USER_MIN_AGE = "usuario_min_idade";
const String USER_MAX_AGE = "usuario_max_idade";
const String USER_MAX_DISTANCE = "usuario_max_distancia";
const String USER_SWIPES = "usuario_swipes";
const String USER_TIME_SWIPES = "usuario_tempo_swipes";
const String USER_SHOW_ME = "usuario_show_me";

/// DATABASE FIELDS FOR UsuariosSinalizados COLLECTION  ///
///
const String FLAGGED_USER_ID = "sinalizado_usuario_id";
const String FLAG_REASON = "motivo_sinalizado";
const String FLAGGED_BY_USER_ID = "sinalizado_por_usuario_id";

/// DATABASE FIELDS FOR Messages and Conversations COLLECTION ///
///
const String MESSAGE_TEXT = "mensagem_texto";
const String ID_DOC = "id_doc";
const String REPLY_TEXT = "resposta_mensagem";
const String USER_REPLY_TEXT = "name_user_resposta_mensagem";
const String MESSAGE_TYPE = "mensagem_tipo";
const String REPLY_TYPE = "tipo_resposta";
const String LIKE_MSG = "mensagem_curtida";
const String MESSAGE_IMG_LINK = "mensagem_img_link";
const String MESSAGE_READ = "mensagem_lida";
const String LAST_MESSAGE = "ultima_mensagem";

/// DATABASE FIELDS FOR Notifications COLLECTION ///
///
const N_SENDER_ID = "n_remetente_id";
const N_SENDER_FULLNAME = "n_remetente_nome";
const N_SENDER_PHOTO_LINK = "n_remetente_foto_link";
const N_RECEIVER_ID = "n_receptor_id";
const N_TYPE = "n_tipo";
const N_MESSAGE = "n_mensagem";
const N_READ = "n_lida";

/// DATABASE FIELDS FOR Likes COLLECTION
///
const String SUPER_LIKE= 'super_liked_usuario';
const String LIKED_USER_ID = 'liked_usuario_id';
const String LIKED_BY_USER_ID = 'liked_por_usuario_id';
const String LIKE_TYPE = 'like_tipo';

/// DATABASE FIELDS FOR Dislikes COLLECTION
///
const String DISLIKED_USER_ID = 'disliked_usuario_id';
const String DISLIKED_BY_USER_ID = 'disliked_por_usuario_id';

/// DATABASE FIELDS FOR Visits COLLECTION
///
const String VISITED_USER_ID = 'visitado_usuario_id';
const String VISITED_BY_USER_ID = 'visitado_por_usuario_id';

/// DATABASE FIELDS FOR LifeStyle COLLECTION
/// NUNCA NULL
const String NAME_LIFESTYLE = "nome_lifeStyle";
const String TYPE_LIFESTYLE = "tipo_lifeStyle";
const String LOCAL_LIFESTYLE = "localizacao_lifeStyle";
const String LIFESTYLE_GEO_POINT = "local_lifeStyle";
const String IMAGES_LIFESTYLE = "images_lifeStyle"; //nunca deixar chegar null
const String MENU_LIFESTYLE = "cardapio_lifeStyle";//nunca deixar chegar null
const String DESC_LIFESTYLE = "descricao_lifeStyle";
const String DATE_LIFESTYLE = "data_create_lifestyle";
const String PRICE_LIFESTYLE = "preco_medio_lifestyle";
const String OPEN_LIFESTYLE = "horario_abertos_lifeStyle";//nunca deixar chegar null

/// DATABASE FIELDS FOR Parties COLLECTION
/// NUNCA NULL
const String NAME_MOVIE = "nome_filme";
const String URL_MOVIE = "url_filme";
const String TYPE_MOVIE = "tipo_filme";
const String LOCAL_MOVIE= "local_filme";
const String DATE_MOVIE = "data_create_movie";

/// DATABASE FIELDS FOR Parties COLLECTION
///
const String ID_PARTY = "id_festa";
const String NAME_PARTY = "nome_festa";
const String DATE_PARTY = "data_festa";
const String TIME_PARTY = "hora_festa";
const String LOCAL_PARTY = "nome_local";
const String PARTY_GEO_POINT = "local_festa";
const String IMAGES_PARTY = "images_festa";
const String DESC_PARTY = "descricao_festa";
const String BUY_PARTY = "ingresso_festa";
const String COR_PARTY = "cor_festa";
const String QUANT_PARTY = "quantidade_visualizacao_festa";

/// DATABASE FIELDS FOR Atletica COLLECTION
///
const String NOME_ATHLETIC   = "nome_atletica";
const String SIGLA_ATHLETIC  = "sigla_atletica";
const String IMAGE_ATHLETIC  = "imagem_atletica";
const String CIDADE_ATHLETIC = "cidade_atletica";
const String UNIVER_ATHLETIC = "universidade_atletica";
const String CURSO_ATHLETIC  = "curso_atletica";

/// DATABASE SHARED FIELDS FOR COLLECTION
///
const String TIMESTAMP = "timestamp";
