import 'dart:math';
import 'package:flutter/material.dart';

// ============ CONFIG ============
// Cole aqui a URL base da API de autenticação REAL do jogo.
// Enquanto estiver vazia, o app mostra "API não configurada".
const String apiBaseUrl = '';

final langN = ValueNotifier<String>('pt');
const gold = Color(0xFFE8C26A);
const panel = Color(0xE6140E1C);

const _t = <String, Map<String, String>>{
  'pt': {
    'region': 'Selecione a Região', 'servers': 'Selecione o Servidor',
    'confirm': 'Confirmar', 'user': 'Usuário', 'pass': 'Senha',
    'pass2': 'Confirmar senha', 'email': 'E-mail', 'enter': 'Entrar',
    'create': 'Criar conta', 'recover': 'Recuperar senha',
    'send': 'Enviar link', 'support': 'Suporte', 'lang': 'Idioma',
    'online': 'Online', 'busy': 'Lotado', 'maint': 'Manutenção',
    'noapi': 'API de autenticação não configurada.',
    'back': 'Voltar', 'fill': 'Preencha todos os campos.',
    'match': 'As senhas não conferem.',
    'supporttxt': 'Configure aqui o contato oficial de suporte.',
  },
  'en': {
    'region': 'Select Region', 'servers': 'Select Server',
    'confirm': 'Confirm', 'user': 'Username', 'pass': 'Password',
    'pass2': 'Confirm password', 'email': 'E-mail', 'enter': 'Sign in',
    'create': 'Create account', 'recover': 'Recover password',
    'send': 'Send link', 'support': 'Support', 'lang': 'Language',
    'online': 'Online', 'busy': 'Full', 'maint': 'Maintenance',
    'noapi': 'Authentication API not configured.',
    'back': 'Back', 'fill': 'Fill in all fields.',
    'match': 'Passwords do not match.',
    'supporttxt': 'Set the official support contact here.',
  },
  'es': {
    'region': 'Selecciona la Región', 'servers': 'Selecciona el Servidor',
    'confirm': 'Confirmar', 'user': 'Usuario', 'pass': 'Contraseña',
    'pass2': 'Confirmar contraseña', 'email': 'Correo', 'enter': 'Entrar',
    'create': 'Crear cuenta', 'recover': 'Recuperar contraseña',
    'send': 'Enviar enlace', 'support': 'Soporte', 'lang': 'Idioma',
    'online': 'En línea', 'busy': 'Lleno', 'maint': 'Mantenimiento',
    'noapi': 'API de autenticación no configurada.',
    'back': 'Volver', 'fill': 'Completa todos los campos.',
    'match': 'Las contraseñas no coinciden.',
    'supporttxt': 'Configura aquí el contacto oficial de soporte.',
  },
};
String tr(String k) => _t[langN.value]?[k] ?? _t['pt']![k] ?? k;

// ============ API (integração futura) ============
class AuthApi {
  Future<void> login(String u, String p) async => _need();
  Future<void> register(String u, String p, String e) async => _need();
  Future<void> recover(String e) async => _need();
  // TODO: implementar as chamadas HTTP com os endpoints reais do jogo.
  void _need() {
    if (apiBaseUrl.isEmpty) throw tr('noapi');
    throw UnimplementedError('Implemente a chamada em AuthApi');
  }
}

// Servidores: DADOS DE EXEMPLO. Troque por uma chamada à API real.
class Srv {
  final String name;
  final int status; // 0 online, 1 lotado, 2 manutenção
  const Srv(this.name, this.status);
}

const regions = {
  'Américas': [Srv('Aurora', 0), Srv('Hércules', 1), Srv('Valkyria', 0)],
  'Europa': [Srv('Avalon', 0), Srv('Camelot', 2)],
  'Ásia-Pacífico': [Srv('Dragonspire', 0), Srv('Jade', 1)],
};

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext c) => ValueListenableBuilder<String>(
        valueListenable: langN,
        builder: (_, __, ___) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Forja Mistyc',
          theme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: gold, brightness: Brightness.dark)),
          home: const RegionPage(),
        ),
      );
}

// ============ CENÁRIO MÁGICO ============
class Backdrop extends StatefulWidget {
  final Widget child;
  final bool back;
  const Backdrop({super.key, required this.child, this.back = false});
  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController ac =
      AnimationController(vsync: this, duration: const Duration(seconds: 20))
        ..repeat();
  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(fit: StackFit.expand, children: [
          AnimatedBuilder(
              animation: ac,
              builder: (_, __) => CustomPaint(painter: ScenePainter(ac.value))),
          SafeArea(
            child: Stack(children: [
              Center(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16), child: widget.child)),
              Positioned(
                top: 4, right: 4,
                child: Row(children: [
                  IconButton(
                      icon: const Icon(Icons.language, color: gold),
                      onPressed: () => langSheet(c)),
                  IconButton(
                      icon: const Icon(Icons.support_agent, color: gold),
                      onPressed: () => supportDialog(c)),
                ]),
              ),
              if (widget.back)
                Positioned(
                    top: 4, left: 4,
                    child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: gold),
                        onPressed: () => Navigator.pop(c))),
            ]),
          ),
        ]),
      );
}

void langSheet(BuildContext c) => showModalBottomSheet(
    context: c,
    backgroundColor: panel,
    builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      for (final e in {'pt': 'Português', 'en': 'English', 'es': 'Español'}.entries)
        ListTile(
            title: Text(e.value),
            trailing: langN.value == e.key
                ? const Icon(Icons.check, color: gold)
                : null,
            onTap: () {
              langN.value = e.key;
              Navigator.pop(c);
            })
    ])));

void supportDialog(BuildContext c) => showDialog(
    context: c,
    builder: (_) => AlertDialog(
        backgroundColor: panel,
        title: Text(tr('support')),
        content: Text(tr('supporttxt')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: const Text('OK'))
        ]));

class ScenePainter extends CustomPainter {
  final double t;
  ScenePainter(this.t);
  @override
  void paint(Canvas cv, Size s) {
    final r = Offset.zero & s;
    cv.drawRect(
        r,
        Paint()
          ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B1038), Color(0xFF3B3A8C), Color(0xFFF2A65A)])
              .createShader(r));
    // sol
    cv.drawCircle(Offset(s.width * .22, s.height * .62), s.shortestSide * .3,
        Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xAAFFE9A8),
            const Color(0x00FFE9A8)
          ]).createShader(Rect.fromCircle(
              center: Offset(s.width * .22, s.height * .62),
              radius: s.shortestSide * .3)));
    // ilhas flutuantes + castelo
    _island(cv, s, .72, .52, .42, 1, true);
    _island(cv, s, .25, .40, .22, .6, false);
    _island(cv, s, .50, .72, .16, .5, false);
    // nuvens
    final cl = Paint()..color = const Color(0x22FFFFFF);
    for (var i = 0; i < 6; i++) {
      final x = ((i * .21 + t * (.3 + i * .05)) % 1.3 - .15) * s.width;
      cv.drawOval(
          Rect.fromCenter(
              center: Offset(x, s.height * (.2 + i * .12)),
              width: s.width * .35,
              height: s.height * .06),
          cl);
    }
    // dragão
    final dx = (t * 1.4 % 1.4 - .2) * s.width;
    final dy = s.height * .18 + sin(t * 2 * pi * 3) * 10;
    final flap = sin(t * 2 * pi * 40) * 12;
    final u = s.shortestSide / 400;
    final d = Path()
      ..moveTo(dx, dy)
      ..quadraticBezierTo(dx - 30 * u, dy - 40 * u - flap, dx - 70 * u, dy - 20 * u)
      ..quadraticBezierTo(dx - 40 * u, dy - 5 * u, dx, dy + 12 * u)
      ..quadraticBezierTo(dx + 40 * u, dy - 5 * u, dx + 70 * u, dy - 20 * u)
      ..quadraticBezierTo(dx + 30 * u, dy - 40 * u - flap, dx, dy)
      ..moveTo(dx, dy + 6 * u)
      ..lineTo(dx + 8 * u, dy + 30 * u)
      ..lineTo(dx - 4 * u, dy + 8 * u);
    cv.drawPath(d, Paint()..color = const Color(0xFF1A1030));
    // brilhos mágicos
    final p = Paint()..color = const Color(0xCCFFE9A8);
    final rnd = Random(7);
    for (var i = 0; i < 40; i++) {
      final x = rnd.nextDouble() * s.width;
      final y = (rnd.nextDouble() - t * (.2 + rnd.nextDouble() * .3)) % 1 * s.height;
      cv.drawCircle(Offset(x, y), 1 + rnd.nextDouble() * 2, p);
    }
  }

  void _island(Canvas cv, Size s, double cx, double cy, double w, double k, bool castle) {
    final x = cx * s.width, y = cy * s.height + sin(t * 2 * pi * 2 + cx * 9) * 6;
    final hw = w * s.width / 2, h = w * s.width * .5;
    cv.drawPath(
        Path()
          ..moveTo(x - hw, y)
          ..lineTo(x + hw, y)
          ..lineTo(x + hw * .3, y + h)
          ..lineTo(x, y + h * 1.3)
          ..lineTo(x - hw * .4, y + h * .8)
          ..close(),
        Paint()..color = const Color(0xFF2A2447));
    cv.drawRect(Rect.fromLTRB(x - hw, y - 5, x + hw, y + 3),
        Paint()..color = const Color(0xFF3F7A4A));
    cv.drawRect(Rect.fromLTRB(x - 2, y + 3, x + 3, y + h * .9),
        Paint()..color = const Color(0x6690D8FF)); // cachoeira
    if (castle) {
      final wall = Paint()..color = const Color(0xFFD9D4EC);
      final roof = Paint()..color = const Color(0xFF3A5BD9);
      for (var i = -3; i <= 3; i++) {
        final bx = x + i * hw / 4.5;
        final bh = (60 + (4 - i.abs()) * 22) * k * s.shortestSide / 400;
        final bw = 14 * k * s.shortestSide / 400;
        cv.drawRect(Rect.fromLTWH(bx - bw / 2, y - bh, bw, bh), wall);
        cv.drawPath(
            Path()
              ..moveTo(bx - bw / 1.4, y - bh)
              ..lineTo(bx, y - bh - bw * 2.2)
              ..lineTo(bx + bw / 1.4, y - bh)
              ..close(),
            roof);
      }
    }
  }

  @override
  bool shouldRepaint(ScenePainter o) => true;
}

// ============ COMPONENTES ============
class GoldPanel extends StatelessWidget {
  final String? title;
  final Widget child;
  const GoldPanel({super.key, this.title, required this.child});
  @override
  Widget build(BuildContext c) => Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: gold, width: 1.6),
            boxShadow: const [BoxShadow(color: Color(0x66E8C26A), blurRadius: 24)]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (title != null) ...[
            Text(title!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: gold,
                    letterSpacing: 1.5)),
            const Divider(color: gold, height: 24),
          ],
          child,
        ]),
      );
}

class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool outline;
  const GoldButton(this.text, this.onTap, {super.key, this.outline = false});
  @override
  Widget build(BuildContext c) => SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: outline ? Colors.transparent : const Color(0xFF7A1F1F),
              foregroundColor: gold,
              side: const BorderSide(color: gold, width: 1.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: Text(text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
}

Widget field(String label, TextEditingController ctl, {bool obscure = false}) =>
    Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
            controller: ctl,
            obscureText: obscure,
            decoration: InputDecoration(
                labelText: label,
                filled: true,
                fillColor: Colors.black38,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0x88E8C26A))))));

// ============ TELAS ============
class RegionPage extends StatefulWidget {
  const RegionPage({super.key});
  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  String sel = regions.keys.first;
  @override
  Widget build(BuildContext c) => Backdrop(
          child: GoldPanel(title: tr('region'), child: Column(children: [
        for (final r in regions.keys)
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GoldButton(r, () => setState(() => sel = r),
                  outline: sel != r)),
        const SizedBox(height: 8),
        GoldButton(tr('confirm'), () => Navigator.push(c,
            MaterialPageRoute(builder: (_) => ServerPage(region: sel)))),
      ])));
}

class ServerPage extends StatefulWidget {
  final String region;
  const ServerPage({super.key, required this.region});
  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  int sel = 0;
  @override
  Widget build(BuildContext c) {
    final list = regions[widget.region]!;
    const cols = [Colors.greenAccent, Colors.orangeAccent, Colors.redAccent];
    const keys = ['online', 'busy', 'maint'];
    return Backdrop(
        back: true,
        child: GoldPanel(
            title: '${tr('servers')}\n${widget.region}',
            child: Column(children: [
              for (var i = 0; i < list.length; i++)
                Card(
                    color: sel == i ? const Color(0x55E8C26A) : Colors.black26,
                    child: ListTile(
                        leading: Icon(Icons.circle, size: 14, color: cols[list[i].status]),
                        title: Text(list[i].name),
                        trailing: Text(tr(keys[list[i].status]),
                            style: TextStyle(color: cols[list[i].status])),
                        onTap: list[i].status == 2
                            ? null
                            : () => setState(() => sel = i))),
              const SizedBox(height: 8),
              GoldButton(tr('confirm'), () => Navigator.push(c,
                  MaterialPageRoute(builder: (_) => LoginPage(server: list[sel])))),
            ])));
  }
}

class LoginPage extends StatefulWidget {
  final Srv server;
  const LoginPage({super.key, required this.server});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final u = TextEditingController(), p = TextEditingController();
  final api = AuthApi();
  bool busy = false;

  void msg(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> go() async {
    if (u.text.isEmpty || p.text.isEmpty) return msg(tr('fill'));
    setState(() => busy = true);
    try {
      await api.login(u.text.trim(), p.text);
    } catch (e) {
      msg('$e');
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext c) => Backdrop(
      back: true,
      child: GoldPanel(
          title: 'FORJA MISTYC',
          child: Column(children: [
            Text(widget.server.name, style: const TextStyle(color: gold)),
            const SizedBox(height: 12),
            field(tr('user'), u),
            field(tr('pass'), p, obscure: true),
            GoldButton(busy ? '...' : tr('enter'), busy ? null : go),
            const SizedBox(height: 10),
            GoldButton(tr('create'), () => Navigator.push(c,
                MaterialPageRoute(builder: (_) => const RegisterPage())),
                outline: true),
            TextButton(
                onPressed: () => Navigator.push(c,
                    MaterialPageRoute(builder: (_) => const RecoverPage())),
                child: Text(tr('recover'), style: const TextStyle(color: gold))),
          ])));
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final u = TextEditingController(), p = TextEditingController(),
      p2 = TextEditingController(), e = TextEditingController();
  void msg(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  Future<void> go() async {
    if ([u, p, p2, e].any((x) => x.text.isEmpty)) return msg(tr('fill'));
    if (p.text != p2.text) return msg(tr('match'));
    try {
      await AuthApi().register(u.text.trim(), p.text, e.text.trim());
    } catch (x) {
      msg('$x');
    }
  }

  @override
  Widget build(BuildContext c) => Backdrop(
      back: true,
      child: GoldPanel(
          title: tr('create'),
          child: Column(children: [
            field(tr('user'), u),
            field(tr('pass'), p, obscure: true),
            field(tr('pass2'), p2, obscure: true),
            field(tr('email'), e),
            GoldButton(tr('create'), go),
          ])));
}

class RecoverPage extends StatefulWidget {
  const RecoverPage({super.key});
  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  final e = TextEditingController();
  Future<void> go() async {
    try {
      await AuthApi().recover(e.text.trim());
    } catch (x) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$x')));
    }
  }

  @override
  Widget build(BuildContext c) => Backdrop(
      back: true,
      child: GoldPanel(
          title: tr('recover'),
          child: Column(children: [
            field(tr('email'), e),
            GoldButton(tr('send'), go),
          ])));
}