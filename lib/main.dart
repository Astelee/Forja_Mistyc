import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

// ============ CONFIG ============
// URL base da API de autenticação REAL. Vazia = "API não configurada".
const String apiBaseUrl = '';
const String version = '1.0.0';
const bgRegiao = 'assets/bg_regiao.jpg';
const bgLogin = 'assets/bg_login.jpg';
// Música de fundo (stream da internet). Troque a URL quando quiser.
const musicUrl = 'https://incompetech.com/music/royalty-free/mp3-royaltyfree/Heroic%20Age.mp3';
const musicCredit = 'Heroic Age — Kevin MacLeod (incompetech.com), CC BY 4.0';
// Links do "Siga-nos". Vazio = "Link não configurado".
const linkSite = '', linkFacebook = '', linkDiscord = '', linkTwitter = '', linkYoutube = '';

const gold = Color(0xFFF0C968);
const goldDk = Color(0xFF9A6B1F);
const emerald = Color(0xFF39E07A);
final langN = ValueNotifier<String>('pt');
late SharedPreferences prefs;

const _t = <String, Map<String, String>>{
  'pt': {
    'region': 'Selecione a Região', 'server': 'Selecione o Servidor',
    'confirm': 'Confirmar', 'user': 'Usuário (3 a 16 letras, números, _)',
    'pass': 'Senha (mínimo 6 caracteres)', 'pass2': 'Confirmar senha',
    'email': 'E-mail', 'remember': 'Lembrar login neste aparelho',
    'lang': 'Idioma', 'enter': 'Entrar', 'create': 'Criar Conta',
    'recover': 'Recuperar Conta', 'support': 'Suporte', 'send': 'Enviar',
    'terms': 'Li e aceito os Termos de Uso', 'ok': 'OK',
    'online': 'Online', 'busy': 'Lotado', 'maint': 'Manutenção',
    'noapi': 'API de autenticação não configurada.',
    'fill': 'Preencha todos os campos.', 'match': 'As senhas não conferem.',
    'acceptTerms': 'Aceite os Termos de Uso.',
    'supporttxt': 'Configure aqui o contato oficial de suporte.',
    'welcome': 'Bem-vindo ao Forja Mistyc!',
    'events': 'Eventos', 'ranking': 'Ranking', 'news': 'Novidades', 'config': 'Config.',
    'tagline': 'Forja Mistyc — Sua lenda começa aqui!', 'ver': 'Versão',
    'latest': 'Últimas Atualizações', 'announcements': 'Anúncios', 'settings': 'Configurações', 'languages': 'Idiomas',
    'audio': 'Áudio', 'account': 'Conta', 'follow': 'Siga-nos', 'music': 'Música', 'effects': 'Efeitos',
    'changeAcc': 'Mudar de conta', 'changeReg': 'Mudar de região', 'site': 'Site Oficial', 'like': 'Curtir',
    'linkoff': 'Link não configurado.', 'close': 'Fechar', 'all': 'Todas', 'updates': 'atualizações',
    'details': 'Ver detalhes', 'less': 'Ocultar', 't0': 'Atualização', 't1': 'Novo conteúdo', 't2': 'Evento',
    't3': 'Correção', 't4': 'Manutenção', 't5': 'Aviso', 'example': 'EXEMPLO',
    'welcome2': 'Conquiste novos reinos, fortaleça seu castelo e faça parte dessa jornada épica!',
  },
  'en': {
    'region': 'Select Region', 'server': 'Select Server',
    'confirm': 'Confirm', 'user': 'Username (3-16 letters, numbers, _)',
    'pass': 'Password (min. 6 characters)', 'pass2': 'Confirm password',
    'email': 'E-mail', 'remember': 'Remember login on this device',
    'lang': 'Language', 'enter': 'Sign in', 'create': 'Create Account',
    'recover': 'Recover Account', 'support': 'Support', 'send': 'Send',
    'terms': 'I have read and accept the Terms of Use', 'ok': 'OK',
    'online': 'Online', 'busy': 'Full', 'maint': 'Maintenance',
    'noapi': 'Authentication API not configured.',
    'fill': 'Fill in all fields.', 'match': 'Passwords do not match.',
    'acceptTerms': 'Accept the Terms of Use.',
    'supporttxt': 'Set the official support contact here.',
    'welcome': 'Welcome to Forja Mistyc!',
    'events': 'Events', 'ranking': 'Ranking', 'news': 'News', 'config': 'Settings',
    'tagline': 'Forja Mistyc — Your legend begins here!', 'ver': 'Version',
    'latest': 'Latest Updates', 'announcements': 'Announcements', 'settings': 'Settings', 'languages': 'Languages',
    'audio': 'Audio', 'account': 'Account', 'follow': 'Follow us', 'music': 'Music', 'effects': 'Effects',
    'changeAcc': 'Switch account', 'changeReg': 'Change region', 'site': 'Website', 'like': 'Like',
    'linkoff': 'Link not configured.', 'close': 'Close', 'all': 'All', 'updates': 'updates',
    'details': 'View details', 'less': 'Hide', 't0': 'Update', 't1': 'New content', 't2': 'Event',
    't3': 'Fix', 't4': 'Maintenance', 't5': 'Notice', 'example': 'EXAMPLE',
    'welcome2': 'Conquer new realms, strengthen your castle and join this epic journey!',
  },
  'es': {
    'region': 'Selecciona la Región', 'server': 'Selecciona el Servidor',
    'confirm': 'Confirmar', 'user': 'Usuario (3 a 16 letras, números, _)',
    'pass': 'Contraseña (mínimo 6 caracteres)', 'pass2': 'Confirmar contraseña',
    'email': 'Correo', 'remember': 'Recordar login en este dispositivo',
    'lang': 'Idioma', 'enter': 'Entrar', 'create': 'Crear Cuenta',
    'recover': 'Recuperar Cuenta', 'support': 'Soporte', 'send': 'Enviar',
    'terms': 'He leído y acepto los Términos de Uso', 'ok': 'OK',
    'online': 'En línea', 'busy': 'Lleno', 'maint': 'Mantenimiento',
    'noapi': 'API de autenticación no configurada.',
    'fill': 'Completa todos los campos.', 'match': 'Las contraseñas no coinciden.',
    'acceptTerms': 'Acepta los Términos de Uso.',
    'supporttxt': 'Configura aquí el contacto oficial de soporte.',
    'welcome': '¡Bienvenido a Forja Mistyc!',
    'events': 'Eventos', 'ranking': 'Ranking', 'news': 'Novedades', 'config': 'Config.',
    'tagline': 'Forja Mistyc — ¡Tu leyenda comienza aquí!', 'ver': 'Versión',
    'latest': 'Últimas Actualizaciones', 'announcements': 'Anuncios', 'settings': 'Configuración', 'languages': 'Idiomas',
    'audio': 'Audio', 'account': 'Cuenta', 'follow': 'Síguenos', 'music': 'Música', 'effects': 'Efectos',
    'changeAcc': 'Cambiar de cuenta', 'changeReg': 'Cambiar de región', 'site': 'Sitio Oficial', 'like': 'Me gusta',
    'linkoff': 'Enlace no configurado.', 'close': 'Cerrar', 'all': 'Todas', 'updates': 'actualizaciones',
    'details': 'Ver detalles', 'less': 'Ocultar', 't0': 'Actualización', 't1': 'Nuevo contenido', 't2': 'Evento',
    't3': 'Corrección', 't4': 'Mantenimiento', 't5': 'Aviso', 'example': 'EJEMPLO',
    'welcome2': '¡Conquista nuevos reinos, fortalece tu castillo y únete a esta épica aventura!',
  },
};
String tr(String k) => _t[langN.value]?[k] ?? _t['en']![k] ?? k;

// ============ API (integração futura) ============
class AuthApi {
  Future<void> login(String u, String p) async => _need();
  Future<void> register(String u, String p, String e) async => _need();
  Future<void> recover(String e) async => _need();
  // TODO: implementar com os endpoints reais do jogo (não inventados aqui).
  void _need() {
    if (apiBaseUrl.isEmpty) throw tr('noapi');
    throw UnimplementedError('Implemente a chamada em AuthApi');
  }
}

// Servidores: DADOS DE EXEMPLO. Troque por chamada à API real.
class Srv {
  final String name;
  final int status, signal; // status 0 online,1 lotado,2 manutenção; signal 1-4
  const Srv(this.name, this.status, this.signal);
}

const regions = <String, List<Srv>>{
  'Américas': [Srv('S1 - Terra de Eldória', 0, 4), Srv('S2 - Hércules', 1, 3), Srv('S3 - Valkyria', 0, 4)],
  'Europa': [Srv('S1 - Avalon', 0, 4), Srv('S2 - Camelot', 2, 0)],
  'Ásia-Pacífico': [Srv('S1 - Dragonspire', 0, 3), Srv('S2 - Jade', 1, 2)],
};
const statusCol = [Color(0xFF3DDC4A), Color(0xFFFFA726), Color(0xFFEF5350)];
const statusKey = ['online', 'busy', 'maint'];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  prefs = await SharedPreferences.getInstance();
  langN.value = prefs.getString('lang') ?? 'pt';
  musicOn.value = prefs.getBool('musicOn') ?? true;
  musicVol.value = prefs.getDouble('musicVol') ?? .5;
  fxOn.value = prefs.getBool('fxOn') ?? true;
  fxVol.value = prefs.getDouble('fxVol') ?? .5;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext c) => ValueListenableBuilder<String>(
      valueListenable: langN,
      builder: (_, __, ___) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Forja Mistyc',
            theme: ThemeData.dark(useMaterial3: true),
            home: const RegionPage(),
          ));
}

// ============ CENÁRIO (imagem + brilhos mágicos) ============
class Stage extends StatefulWidget {
  final String bg;
  final Widget child;
  const Stage({super.key, required this.bg, required this.child});
  @override
  State<Stage> createState() => _StageState();
}

class _StageState extends State<Stage> with SingleTickerProviderStateMixin {
  late final ac = AnimationController(vsync: this, duration: const Duration(seconds: 24))..repeat();
  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        backgroundColor: const Color(0xFF06140E),
        body: Stack(fit: StackFit.expand, children: [
          AnimatedBuilder(
              animation: ac,
              builder: (_, __) => Transform.scale(
                  scale: 1.03 + 0.03 * sin(ac.value * 2 * pi),
                  child: Image.asset(widget.bg, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Color(0xFF06140E), Color(0xFF1F5A3A), Color(0xFFE8C26A)])))))),
          IgnorePointer(child: AnimatedBuilder(
              animation: ac, builder: (_, __) => CustomPaint(painter: Sparkles(ac.value)))),
          SafeArea(child: widget.child),
        ]),
      );
}

class Sparkles extends CustomPainter {
  final double t;
  Sparkles(this.t);
  @override
  void paint(Canvas cv, Size s) {
    final rnd = Random(11);
    for (var i = 0; i < 45; i++) {
      final x = rnd.nextDouble() * s.width;
      final sp = .3 + rnd.nextDouble() * .5;
      final y = (rnd.nextDouble() - t * sp * 2) % 1 * s.height;
      final tw = .5 + .5 * sin(t * 2 * pi * (3 + i % 4) + i);
      cv.drawCircle(Offset(x, y), (1 + rnd.nextDouble() * 2.2) * (.6 + tw * .4),
          Paint()..color = Color.fromRGBO(255, 233, 168, .25 + .6 * tw));
    }
  }

  @override
  bool shouldRepaint(Sparkles o) => true;
}

// ============ COMPONENTES ============
class GoldBox extends StatelessWidget {
  final Widget child;
  final double? width;
  final bool crest;
  const GoldBox({super.key, required this.child, this.width, this.crest = false});
  @override
  Widget build(BuildContext c) {
    final box = CustomPaint(
        foregroundPainter: crest ? CornerPainter() : null,
        child: Container(
          width: width,
          padding: EdgeInsets.fromLTRB(18, crest ? 24 : 14, 18, 14),
          decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xF01C4A2B), Color(0xF40B2415)]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD9AE45), width: 2),
              boxShadow: const [BoxShadow(color: Color(0xFF1F6B3A), spreadRadius: 3), BoxShadow(color: Color(0x6639E07A), spreadRadius: 3, blurRadius: 22)]),
          child: child,
        ));
    if (!crest) return box;
    return Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [
      Padding(padding: const EdgeInsets.only(top: 16), child: box),
      CustomPaint(size: const Size(150, 32), painter: CrestPainter()),
    ]);
  }
}

// Cantos dourados do painel
class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas cv, Size s) {
    final p = Paint()..color = gold..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    void c(double x, double y, double dx, double dy) {
      cv.drawLine(Offset(x, y), Offset(x + dx * 20, y), p);
      cv.drawLine(Offset(x, y), Offset(x, y + dy * 20), p);
      cv.drawCircle(Offset(x + dx * 6, y + dy * 6), 2.4, Paint()..color = gold);
    }
    c(-3, -3, 1, 1); c(s.width + 3, -3, -1, 1);
    c(-3, s.height + 3, 1, -1); c(s.width + 3, s.height + 3, -1, -1);
  }
  @override
  bool shouldRepaint(CornerPainter o) => false;
}

// Brasão: asas douradas + gema esmeralda (usado no painel e no logo)
class CrestPainter extends CustomPainter {
  final double gap, span;
  final bool dual;
  CrestPainter({this.gap = 14, this.span = 56, this.dual = false});
  void _gem(Canvas cv, Offset o, double z) {
    final g = Path()..moveTo(o.dx, o.dy - z)..lineTo(o.dx + z * .7, o.dy)..lineTo(o.dx, o.dy + z)..lineTo(o.dx - z * .7, o.dy)..close();
    cv.drawCircle(o, z * 1.4, Paint()..color = const Color(0x6639E07A)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    cv.drawPath(g, Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFFB8FFD0), Color(0xFF138A4A)]).createShader(Rect.fromCenter(center: o, width: z * 1.4, height: z * 2)));
    cv.drawPath(g, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.8..color = gold);
  }

  @override
  void paint(Canvas cv, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final gp = Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF2B0), Color(0xFFB8801F)]).createShader(Offset.zero & s);
    for (final d in [-1.0, 1.0]) {
      for (var i = 0; i < 3; i++) {
        final len = span - i * 11.0, y = cy + i * 5.0 - 6;
        cv.drawPath(
            Path()
              ..moveTo(cx + d * gap, cy)
              ..quadraticBezierTo(cx + d * (gap + len * .5), y - 12, cx + d * (gap + len), y - 2)
              ..quadraticBezierTo(cx + d * (gap + len * .5), y + 3, cx + d * gap, cy + 3),
            gp);
      }
    }
    if (dual) {
      _gem(cv, Offset(cx, 9), 8);
      _gem(cv, Offset(cx, s.height - 9), 8);
    } else {
      _gem(cv, Offset(cx, cy), 12);
    }
  }

  @override
  bool shouldRepaint(CrestPainter o) => false;
}

class Title extends StatelessWidget {
  final String text;
  const Title(this.text, {super.key});
  @override
  Widget build(BuildContext c) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        const Expanded(child: Divider(color: goldDk)),
        const Text(' ◆ ', style: TextStyle(color: gold, fontSize: 11)),
        Text(text, style: const TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'serif')),
        const Text(' ◆ ', style: TextStyle(color: gold, fontSize: 11)),
        const Expanded(child: Divider(color: goldDk)),
      ]));
}

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool small;
  const Btn(this.text, this.onTap, {super.key, this.small = false});
  Widget _d(double z) => Transform.rotate(
      angle: pi / 4,
      child: Container(
          width: z, height: z,
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFF2B0), Color(0xFFB8801F)]),
              border: Border.all(color: const Color(0xFF5A3A0A)))));
  @override
  Widget build(BuildContext c) {
    final on = onTap != null;
    return GestureDetector(
        onTap: onTap,
        child: SizedBox(
            height: small ? 44 : 56,
            child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 9, vertical: small ? 3 : 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: on ? const [Color(0xFF3F9A5A), Color(0xFF14522E)] : [Colors.grey.shade700, Colors.grey.shade900]),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: gold, width: 2),
                      boxShadow: const [BoxShadow(color: Color(0x8839E07A), blurRadius: 14)]),
                  child: Text(text, style: TextStyle(color: gold, fontFamily: 'serif', fontWeight: FontWeight.w900,
                      fontSize: small ? 16 : 25, shadows: const [Shadow(color: Colors.black, blurRadius: 4)]))),
              Positioned(left: 2, child: _d(small ? 11 : 14)),
              Positioned(right: 2, child: _d(small ? 11 : 14)),
              Positioned(top: 0, child: _d(9)),
            ])));
  }
}

// Botões do topo (sem função por enquanto)
class TopBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const TopBtn(this.icon, this.label, {super.key, this.onTap});
  @override
  Widget build(BuildContext c) => Padding(
      padding: const EdgeInsets.only(left: 10),
      child: InkWell(
          onTap: onTap ?? () {}, // sem função por enquanto quando onTap é nulo
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Color(0xFF2E7A4E), Color(0xFF0C2A1C)]),
                    border: Border.all(color: gold, width: 1.8),
                    boxShadow: const [BoxShadow(color: Color(0x6639E07A), blurRadius: 8)]),
                child: Icon(icon, color: gold, size: 22)),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
          ])));
}

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  Widget build(BuildContext c) {
    const st = TextStyle(fontSize: 34, height: .95, fontFamily: 'serif', fontWeight: FontWeight.w900);
    return SizedBox(
        width: 250, height: 92,
        child: Stack(alignment: Alignment.center, children: [
          CustomPaint(size: const Size(250, 92), painter: CrestPainter(gap: 74, span: 48, dual: true)),
          Text('FORJA\nMISTYC', textAlign: TextAlign.center,
              style: st.copyWith(foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 5..color = const Color(0xFF0C3A22))),
          ShaderMask(
              shaderCallback: (r) => const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF2B0), Color(0xFFD9A030), Color(0xFF8A5A14)]).createShader(r),
              child: Text('FORJA\nMISTYC', textAlign: TextAlign.center, style: st.copyWith(color: Colors.white))),
        ]));
  }
}

class Fld extends StatefulWidget {
  final String hint;
  final TextEditingController ctl;
  final IconData icon;
  final bool secret;
  const Fld(this.hint, this.ctl, this.icon, {super.key, this.secret = false});
  @override
  State<Fld> createState() => _FldState();
}

class _FldState extends State<Fld> {
  late bool hide = widget.secret;
  @override
  Widget build(BuildContext c) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
          controller: widget.ctl,
          obscureText: hide,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
              prefixIcon: Icon(widget.icon, color: gold, size: 20),
              suffixIcon: widget.secret
                  ? IconButton(icon: Icon(hide ? Icons.visibility_off : Icons.visibility, color: Colors.white60, size: 20),
                      onPressed: () => setState(() => hide = !hide))
                  : null,
              filled: true,
              fillColor: Colors.black54,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0x55F0C968))))));
}

void snack(BuildContext c, String m) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));

Future<void> boxDialog(BuildContext c, String title, List<Widget> body) => showDialog(
    context: c,
    builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: GoldBox(child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [Title(title), ...body]))))));

// ============ ÁUDIO ============
final musicOn = ValueNotifier<bool>(true), fxOn = ValueNotifier<bool>(true);
final musicVol = ValueNotifier<double>(.5), fxVol = ValueNotifier<double>(.5);

class Bgm {
  static final _p = AudioPlayer();
  static bool _started = false;
  static Future<void> start() async {
    try {
      await _p.setReleaseMode(ReleaseMode.loop);
      await _p.setVolume(musicVol.value);
      if (musicOn.value) {
        await _p.play(UrlSource(musicUrl));
        _started = true;
      }
    } catch (_) {}
  }

  static Future<void> apply() async {
    try {
      await _p.setVolume(musicVol.value);
      if (!musicOn.value) {
        await _p.pause();
      } else if (_started) {
        await _p.resume();
      } else {
        await start();
      }
    } catch (_) {}
  }

  static Future<void> pause() async {
    try {
      await _p.pause();
    } catch (_) {}
  }

  static Future<void> resume() async {
    if (!musicOn.value || !_started) return;
    try {
      await _p.resume();
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _p.stop();
      _started = false;
    } catch (_) {}
  }
}

const langs = <String, String>{
  'zh': '中文繁體', 'en': 'English', 'es': 'Español',
  'pt': 'Português', 'tr': 'Türkçe', 'fr': 'Français',
  'de': 'Deutsch', 'ru': 'Русский', 'id': 'Bahasa Indonesia',
  'th': 'ภาษาไทย', 'pl': 'Polski', 'nl': 'Nederlands',
};

Future<void> openLink(BuildContext c, String url) async {
  if (url.isEmpty) {
    snack(c, tr('linkoff'));
    return;
  }
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {
    if (c.mounted) snack(c, tr('linkoff'));
  }
}

// ============ CONFIGURAÇÕES (Idiomas, Áudio, Conta, Siga-nos) ============
void openSettings(BuildContext c, {int tab = 0, VoidCallback? onChangeAccount, VoidCallback? onChangeRegion}) =>
    showDialog(
        context: c,
        builder: (_) => SettingsDialog(tab: tab, onChangeAccount: onChangeAccount, onChangeRegion: onChangeRegion));

class SettingsDialog extends StatefulWidget {
  final int tab;
  final VoidCallback? onChangeAccount, onChangeRegion;
  const SettingsDialog({super.key, this.tab = 0, this.onChangeAccount, this.onChangeRegion});
  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late int tab = widget.tab;

  Widget tabBtn(int i, String t) {
    final on = tab == i;
    return GestureDetector(
        onTap: () => setState(() => tab = i),
        child: Container(
            height: 38,
            margin: const EdgeInsets.only(bottom: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: on ? const [Color(0xFFF3D27A), Color(0xFF9A6B1F)] : const [Color(0xFF2E7A4E), Color(0xFF14522E)]),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: on ? const Color(0xFFFFF2B0) : goldDk, width: 1.4)),
            child: Text(t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: on ? const Color(0xFF2A1A04) : gold))));
  }

  Widget langBtn(String code, String label) {
    final on = langN.value == code;
    return SizedBox(
        width: 118,
        child: GestureDetector(
            onTap: () {
              langN.value = code;
              prefs.setString('lang', code);
              setState(() {});
            },
            child: Container(
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: on ? const Color(0x55F0C968) : Colors.black38,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: on ? gold : goldDk, width: on ? 2 : 1)),
                child: Text(label, style: TextStyle(fontSize: 13, fontWeight: on ? FontWeight.bold : FontWeight.normal)))));
  }

  Widget audioRow(String label, ValueNotifier<bool> on, ValueNotifier<double> vol, String kOn, String kVol, VoidCallback apply) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Checkbox(
                value: on.value,
                activeColor: const Color(0xFF2E9E5B),
                onChanged: (v) {
                  on.value = v ?? true;
                  prefs.setBool(kOn, on.value);
                  apply();
                  setState(() {});
                }),
            SizedBox(width: 62, child: Text(label, style: const TextStyle(color: gold, fontSize: 13))),
            Expanded(
                child: Slider(
                    value: vol.value,
                    activeColor: const Color(0xFF3DDC4A),
                    inactiveColor: Colors.black54,
                    thumbColor: gold,
                    onChanged: (v) {
                      vol.value = v;
                      setState(() {});
                      apply();
                    },
                    onChangeEnd: (v) => prefs.setDouble(kVol, v))),
            SizedBox(width: 40, child: Text('${(vol.value * 100).round()}%', style: const TextStyle(fontSize: 12))),
          ]));

  Widget social(Widget icon, String label, String url) => InkWell(
      onTap: () => openLink(context, url),
      child: SizedBox(
          width: 84,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 54, height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Color(0xFF2E7A4E), Color(0xFF0C2A1C)]),
                    border: Border.all(color: gold, width: 2)),
                child: icon),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ])));

  @override
  Widget build(BuildContext c) {
    final m = MediaQuery.of(c);
    final labels = [tr('languages'), tr('audio'), tr('account'), tr('follow')];
    final pages = <Widget>[
      Wrap(spacing: 8, runSpacing: 8, children: [for (final e in langs.entries) langBtn(e.key, e.value)]),
      Column(children: [
        audioRow(tr('music'), musicOn, musicVol, 'musicOn', 'musicVol', Bgm.apply),
        audioRow(tr('effects'), fxOn, fxVol, 'fxOn', 'fxVol', () {}),
        if (musicCredit.isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 10), child: Text('♪ $musicCredit', style: const TextStyle(fontSize: 10, color: Colors.white54))),
      ]),
      Column(children: [
        const SizedBox(height: 16),
        SizedBox(width: 260, child: Btn(tr('changeAcc'), () {
          Navigator.pop(c);
          widget.onChangeAccount?.call();
        }, small: true)),
        const SizedBox(height: 14),
        SizedBox(width: 260, child: Btn(tr('changeReg'), () {
          Navigator.pop(c);
          widget.onChangeRegion?.call();
        }, small: true)),
      ]),
      Wrap(spacing: 8, runSpacing: 12, children: [
        social(const Icon(Icons.language, color: gold, size: 28), tr('site'), linkSite),
        social(const Icon(Icons.facebook, color: gold, size: 28), tr('like'), linkFacebook),
        social(const Icon(Icons.forum, color: gold, size: 26), 'Discord', linkDiscord),
        social(const Text('X', style: TextStyle(color: gold, fontSize: 24, fontWeight: FontWeight.w900)), 'Twitter', linkTwitter),
        social(const Icon(Icons.play_circle_fill, color: gold, size: 28), 'YouTube', linkYoutube),
      ]),
    ];
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: SizedBox(
            width: min(m.size.width * .92, 660),
            height: min(m.size.height * .9, 340),
            child: GoldBox(
                child: Column(children: [
              Row(children: [
                Expanded(child: Title(tr('settings'))),
                InkWell(
                    onTap: () => Navigator.pop(c),
                    child: Container(
                        width: 30, height: 30,
                        margin: const EdgeInsets.only(bottom: 10, left: 6),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(colors: [Color(0xFFF3D27A), Color(0xFF9A6B1F)]),
                            border: Border.all(color: const Color(0xFFFFF2B0))),
                        child: const Icon(Icons.close, size: 18, color: Color(0xFF2A1A04)))),
              ]),
              Expanded(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 108, child: Column(children: [for (var i = 0; i < 4; i++) tabBtn(i, labels[i])])),
                const SizedBox(width: 12),
                Expanded(
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(child: pages[tab]))),
              ])),
            ]))));
  }
}

// ============ ANÚNCIOS (últimas atualizações) ============
class Ann {
  final int kind;
  final String date, title, body, more;
  const Ann(this.kind, this.date, this.title, this.body, this.more);
}

// EXEMPLOS: troque por dados reais (ex.: vindos da API do jogo).
const announcements = <Ann>[
  Ann(0, '18/11/2026', 'Exemplo: título de uma atualização do jogo',
      'Resumo curto da atualização. Este é apenas um texto de exemplo para mostrar o layout.',
      'Aqui aparece o texto completo da atualização: lista de mudanças, ajustes de equilíbrio e melhorias gerais. (Texto de exemplo.)'),
  Ann(1, '16/11/2026', 'Exemplo: anúncio de novo conteúdo',
      'Espaço para apresentar novas áreas, itens ou masmorras. Texto de exemplo.',
      'Detalhes do novo conteúdo: como desbloquear, recompensas e requisitos. (Texto de exemplo.)'),
  Ann(2, '14/11/2026', 'Exemplo: evento de fim de semana',
      'Participe e ganhe recompensas especiais por tempo limitado. Texto de exemplo.',
      'Regras do evento, período e lista de prêmios. (Texto de exemplo.)'),
  Ann(3, '12/11/2026', 'Exemplo: correção de erros conhecidos',
      'Lista resumida de problemas corrigidos nesta versão. Texto de exemplo.',
      'Correções detalhadas por área do jogo. (Texto de exemplo.)'),
  Ann(4, '10/11/2026', 'Exemplo: manutenção programada',
      'Os servidores ficarão indisponíveis por um curto período. Texto de exemplo.',
      'Horário previsto, duração estimada e compensações. (Texto de exemplo.)'),
  Ann(5, '08/11/2026', 'Exemplo: aviso importante',
      'Comunicado geral para os jogadores. Texto de exemplo.',
      'Texto completo do aviso. (Texto de exemplo.)'),
];
const annColors = [Color(0xFF4DA3FF), Color(0xFF4CD37E), Color(0xFFF0C968), Color(0xFFB58CFF), Color(0xFFFF8A4C), Color(0xFFFFD84D)];
const annKeys = ['t0', 't1', 't2', 't3', 't4', 't5'];

void openAnnouncements(BuildContext c) => showDialog(context: c, builder: (_) => const AnnouncementsDialog());

class AnnouncementsDialog extends StatefulWidget {
  const AnnouncementsDialog({super.key});
  @override
  State<AnnouncementsDialog> createState() => _AnnouncementsDialogState();
}

class _AnnouncementsDialogState extends State<AnnouncementsDialog> {
  int f = -1;
  final open = <int>{};

  Widget chip(String t, int k) {
    final on = f == k;
    return GestureDetector(
        onTap: () => setState(() => f = k),
        child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: on ? gold : const Color(0xFF14522E), border: Border.all(color: on ? Colors.white70 : goldDk)),
            child: Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: on ? const Color(0xFF2A1A04) : gold))));
  }

  Widget tag(String t, Color col) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: col)),
      child: Text(t, style: TextStyle(fontSize: 10, color: col)));

  Widget card(int i) {
    final a = announcements[i];
    final col = annColors[a.kind];
    final op = open.contains(i);
    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        decoration: BoxDecoration(
            color: Colors.black38,
            border: Border(left: BorderSide(color: col, width: 4), top: const BorderSide(color: goldDk),
                right: const BorderSide(color: goldDk), bottom: const BorderSide(color: goldDk))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            tag(tr(annKeys[a.kind]), col),
            const SizedBox(width: 6),
            tag(tr('example'), gold),
            const SizedBox(width: 8),
            Text(a.date, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ]),
          const SizedBox(height: 4),
          Text(a.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(a.body, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          if (op) Padding(padding: const EdgeInsets.only(top: 6), child: Text(a.more, style: const TextStyle(fontSize: 12, color: Color(0xFFCFE8D5)))),
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () => setState(() => op ? open.remove(i) : open.add(i)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(op ? tr('less') : tr('details'),
                          style: const TextStyle(color: Color(0xFF6FC3FF), fontSize: 12, decoration: TextDecoration.underline))))),
        ]));
  }

  @override
  Widget build(BuildContext c) {
    final m = MediaQuery.of(c);
    final list = [for (var i = 0; i < announcements.length; i++) if (f < 0 || announcements[i].kind == f) i];
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: SizedBox(
            width: min(m.size.width * .92, 620),
            height: min(m.size.height * .92, 360),
            child: GoldBox(
                child: Column(children: [
              Row(children: [
                Expanded(child: Title(tr('latest'))),
                InkWell(
                    onTap: () => Navigator.pop(c),
                    child: Container(
                        width: 30, height: 30,
                        margin: const EdgeInsets.only(bottom: 10, left: 6),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(colors: [Color(0xFFF3D27A), Color(0xFF9A6B1F)]),
                            border: Border.all(color: const Color(0xFFFFF2B0))),
                        child: const Icon(Icons.close, size: 18, color: Color(0xFF2A1A04)))),
              ]),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [chip(tr('all'), -1), for (var k = 0; k < 6; k++) chip(tr(annKeys[k]), k)])),
              const SizedBox(height: 6),
              Align(alignment: Alignment.centerLeft, child: Text('${list.length} ${tr('updates')}', style: const TextStyle(fontSize: 12, color: Colors.white70))),
              const SizedBox(height: 4),
              Expanded(child: ListView(children: [for (final i in list) card(i)])),
              const SizedBox(height: 6),
              Align(alignment: Alignment.centerRight, child: SizedBox(width: 130, child: Btn(tr('close').toUpperCase(), () => Navigator.pop(c), small: true))),
            ]))));
  }
}

// ============ TELA 1: REGIÃO ============
class RegionPage extends StatefulWidget {
  const RegionPage({super.key});
  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  late String sel = prefs.getString('region') ?? regions.keys.first;
  void _r() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    langN.addListener(_r);
  }

  @override
  void dispose() {
    langN.removeListener(_r);
    super.dispose();
  }
  @override
  Widget build(BuildContext c) => Stage(
      bg: bgRegiao,
      child: Center(
          child: SingleChildScrollView(
              child: GoldBox(
                  width: 380,
                  crest: true,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Title(tr('region')),
                    for (final r in regions.keys)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                              onTap: () => setState(() => sel = r),
                              child: Container(
                                  height: 44,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: sel == r ? const Color(0xFFC9A04A) : Colors.black45,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: sel == r ? gold : goldDk)),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    if (sel == r) const Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.check_circle, size: 18, color: Colors.black87)),
                                    Text(r, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: sel == r ? Colors.black87 : gold)),
                                  ])))),
                    const SizedBox(height: 4),
                    Btn(tr('confirm'), () {
                      prefs.setString('region', sel);
                      Navigator.push(c, MaterialPageRoute(builder: (_) => LoginPage(region: sel)));
                    }, small: true),
                  ])))));
}

// ============ TELA 2: LOGIN (+ servidor, criar, recuperar, suporte) ============
class LoginPage extends StatefulWidget {
  final String region;
  const LoginPage({super.key, required this.region});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final u = TextEditingController(text: prefs.getString('user') ?? ''), p = TextEditingController();
  final api = AuthApi();
  late final list = regions[widget.region]!;
  int sel = 0;
  bool remember = prefs.getBool('remember') ?? true, busy = false;

  void _r() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    langN.addListener(_r);
    Bgm.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    langN.removeListener(_r);
    Bgm.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState st) {
    if (st == AppLifecycleState.resumed) {
      Bgm.resume();
    } else {
      Bgm.pause();
    }
  }

  Future<void> go() async {
    if (u.text.isEmpty || p.text.isEmpty) return snack(context, tr('fill'));
    setState(() => busy = true);
    try {
      await prefs.setBool('remember', remember);
      remember ? await prefs.setString('user', u.text.trim()) : await prefs.remove('user');
      await api.login(u.text.trim(), p.text);
    } catch (e) {
      if (mounted) snack(context, '$e');
    }
    if (mounted) setState(() => busy = false);
  }

  void pickServer() => boxDialog(context, tr('server'), [
        for (var i = 0; i < list.length; i++)
          ListTile(
              dense: true,
              enabled: list[i].status != 2,
              leading: Icon(Icons.circle, size: 14, color: statusCol[list[i].status]),
              title: Text(list[i].name),
              subtitle: Text(tr(statusKey[list[i].status]), style: TextStyle(color: statusCol[list[i].status], fontSize: 11)),
              trailing: _signal(list[i]),
              onTap: () {
                setState(() => sel = i);
                Navigator.pop(context);
              })
      ]);

  Widget _signal(Srv s) => Icon(Icons.signal_cellular_alt, size: 22,
      color: s.status == 2 ? Colors.grey : statusCol[s.signal >= 3 ? 0 : 1]);

  void showSettings([int tab = 0]) => openSettings(context,
      tab: tab,
      onChangeAccount: () {
        u.clear();
        p.clear();
        prefs.remove('user');
        setState(() {});
      },
      onChangeRegion: () => Navigator.popUntil(context, (r) => r.isFirst));

  void langMenu() => showSettings(0);

  void createDialog() {
    final cu = TextEditingController(), cp = TextEditingController(), cp2 = TextEditingController(), ce = TextEditingController();
    bool ok = false;
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (dc, set) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: GoldBox(
                        child: SingleChildScrollView(
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Title(tr('create')),
                      Fld(tr('user'), cu, Icons.person),
                      Fld(tr('pass'), cp, Icons.lock, secret: true),
                      Fld(tr('pass2'), cp2, Icons.lock_outline, secret: true),
                      Fld(tr('email'), ce, Icons.email),
                      CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(tr('terms'), style: const TextStyle(fontSize: 12)),
                          value: ok,
                          onChanged: (v) => set(() => ok = v ?? false)),
                      Btn(tr('create'), () async {
                        if ([cu, cp, cp2, ce].any((x) => x.text.isEmpty)) return snack(dc, tr('fill'));
                        if (cp.text != cp2.text) return snack(dc, tr('match'));
                        if (!ok) return snack(dc, tr('acceptTerms'));
                        try {
                          await api.register(cu.text.trim(), cp.text, ce.text.trim());
                        } catch (e) {
                          if (dc.mounted) snack(dc, '$e');
                        }
                      }, small: true),
                    ])))))));
  }

  void recoverDialog() {
    final e = TextEditingController();
    boxDialog(context, tr('recover'), [
      Fld(tr('email'), e, Icons.email),
      Builder(builder: (dc) => Btn(tr('send'), () async {
            if (e.text.isEmpty) return snack(dc, tr('fill'));
            try {
              await api.recover(e.text.trim());
            } catch (x) {
              if (dc.mounted) snack(dc, '$x');
            }
          }, small: true)),
    ]);
  }

  Widget action(IconData i, String t, VoidCallback f) => Expanded(
      child: InkWell(
          onTap: f,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: [
                Icon(i, color: gold, size: 24),
                Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ]))));

  @override
  Widget build(BuildContext c) {
    final m = MediaQuery.of(c);
    final w = m.size.width;
    final availH = max(120.0, m.size.height - m.padding.vertical - 64 - 34);
    final dw = (w * .38).clamp(310.0, 430.0);
    final s = list[sel];
    final panel = GoldBox(
        width: dw,
        crest: true,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Title(tr('server')),
          InkWell(
              onTap: pickServer,
              child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8), border: Border.all(color: gold)),
                  child: Row(children: [
                    Icon(Icons.circle, size: 14, color: statusCol[s.status]),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                    _signal(s),
                    const Icon(Icons.keyboard_arrow_down, color: gold),
                  ]))),
          Fld(tr('user'), u, Icons.person),
          Fld(tr('pass'), p, Icons.lock, secret: true),
          Row(children: [
            SizedBox(width: 28, height: 28, child: Checkbox(value: remember, activeColor: const Color(0xFF2E9E5B), onChanged: (v) => setState(() => remember = v ?? true))),
            const SizedBox(width: 6),
            Expanded(child: Text(tr('remember'), style: const TextStyle(fontSize: 11))),
            InkWell(onTap: langMenu, child: Text('${tr('lang')} ▾', style: const TextStyle(color: Color(0xFF6FC3FF), fontSize: 12, decoration: TextDecoration.underline))),
          ]),
          const SizedBox(height: 8),
          Btn(busy ? '...' : tr('enter'), busy || s.status == 2 ? null : go),
          const SizedBox(height: 6),
          Row(children: [
            action(Icons.person_add, tr('create'), createDialog),
            action(Icons.restart_alt, tr('recover'), recoverDialog),
            action(Icons.headset_mic, tr('support'), () => boxDialog(c, tr('support'), [
                  Text(tr('supporttxt'), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Builder(builder: (dc) => Btn(tr('ok'), () => Navigator.pop(dc), small: true)),
                ])),
          ]),
        ]));
    return Stage(
        bg: bgLogin,
        child: Stack(children: [
          Positioned(left: 50, top: 2, child: const Logo()),
          Positioned(left: 4, top: 4, child: IconButton(icon: const Icon(Icons.arrow_back, color: gold), onPressed: () => Navigator.pop(c))),
          Positioned(
              top: 6, right: 14,
              child: Row(children: [
                TopBtn(Icons.volume_up, tr('announcements'), onTap: () => openAnnouncements(c)),
                TopBtn(Icons.emoji_events, tr('ranking')),
                TopBtn(Icons.article, tr('news')),
                TopBtn(Icons.settings, tr('config'), onTap: () => showSettings()),
              ])),
          // painel 20% menor (escala 0.8), encolhe mais se a tela for baixa
          Positioned(
              top: 64, bottom: 34, right: 18,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                      child: SizedBox(width: dw * .8, height: availH, child: FittedBox(fit: BoxFit.scaleDown, child: panel))))),
          Positioned(
              left: 0, bottom: 28,
              child: Container(
                  width: w * .5,
                  padding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xDD000000), Color(0x00000000)])),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Row(children: [
                      const Icon(Icons.campaign, color: gold, size: 22),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tr('welcome'), style: const TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 13))),
                    ]),
                    Text(tr('welcome2'), style: const TextStyle(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ]))),
          Positioned(
              left: 0, right: 0, bottom: 0, height: 28,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: const BoxDecoration(color: Color(0xCC000000), border: Border(top: BorderSide(color: Color(0x88F0C968)))),
                  child: Row(children: [
                    Text('◆ ${tr('ver')} $version', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    const Spacer(),
                    Flexible(child: Text('◆ ${tr('tagline')} ◆', overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: gold, fontStyle: FontStyle.italic, fontFamily: 'serif'))),
                  ]))),
        ]));
  }
}