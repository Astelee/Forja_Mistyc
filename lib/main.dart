import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============ CONFIG ============
// URL base da API de autenticação REAL. Vazia = "API não configurada".
const String apiBaseUrl = '';
const String version = '1.0.0';
const bgRegiao = 'assets/bg_regiao.jpg';
const bgLogin = 'assets/bg_login.jpg';

const gold = Color(0xFFF0C968);
const goldDk = Color(0xFF9A6B1F);
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
    'welcome2': '¡Conquista nuevos reinos, fortalece tu castillo y únete a esta épica aventura!',
  },
};
String tr(String k) => _t[langN.value]?[k] ?? _t['pt']![k] ?? k;

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
        backgroundColor: const Color(0xFF0B1038),
        body: Stack(fit: StackFit.expand, children: [
          AnimatedBuilder(
              animation: ac,
              builder: (_, __) => Transform.scale(
                  scale: 1.03 + 0.03 * sin(ac.value * 2 * pi),
                  child: Image.asset(widget.bg, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Color(0xFF0B1038), Color(0xFF3B3A8C), Color(0xFFF2A65A)])))))),
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
  const GoldBox({super.key, required this.child, this.width});
  @override
  Widget build(BuildContext c) => Container(
        width: width,
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xEE1B2650), Color(0xF00A1028)]),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: gold, width: 1.6),
            boxShadow: const [BoxShadow(color: Color(0x66F0C968), blurRadius: 22)]),
        child: child,
      );
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

class RedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool small;
  const RedButton(this.text, this.onTap, {super.key, this.small = false});
  @override
  Widget build(BuildContext c) => GestureDetector(
      onTap: onTap,
      child: Container(
        height: small ? 40 : 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: onTap == null
                    ? [Colors.grey.shade700, Colors.grey.shade900]
                    : const [Color(0xFFE53A1E), Color(0xFF8E0F0F)]),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: gold, width: 2),
            boxShadow: const [BoxShadow(color: Color(0x88FF5A2A), blurRadius: 14)]),
        child: Text(text, style: TextStyle(color: gold, fontFamily: 'serif', fontWeight: FontWeight.w900,
            fontSize: small ? 16 : 24, shadows: const [Shadow(color: Colors.black, blurRadius: 4)])),
      ));
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

// ============ TELA 1: REGIÃO ============
class RegionPage extends StatefulWidget {
  const RegionPage({super.key});
  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  late String sel = prefs.getString('region') ?? regions.keys.first;
  @override
  Widget build(BuildContext c) => Stage(
      bg: bgRegiao,
      child: Center(
          child: SingleChildScrollView(
              child: GoldBox(
                  width: 380,
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
                    RedButton(tr('confirm'), () {
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

class _LoginPageState extends State<LoginPage> {
  final u = TextEditingController(text: prefs.getString('user') ?? ''), p = TextEditingController();
  final api = AuthApi();
  late final list = regions[widget.region]!;
  int sel = 0;
  bool remember = prefs.getBool('remember') ?? true, busy = false;

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

  void langMenu() => boxDialog(context, tr('lang'), [
        for (final e in {'pt': 'Português', 'en': 'English', 'es': 'Español'}.entries)
          ListTile(
              dense: true,
              title: Text(e.value),
              trailing: langN.value == e.key ? const Icon(Icons.check, color: gold) : null,
              onTap: () {
                langN.value = e.key;
                prefs.setString('lang', e.key);
                Navigator.pop(context);
              })
      ]);

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
                      RedButton(tr('create'), () async {
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
      Builder(builder: (dc) => RedButton(tr('send'), () async {
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
    final w = MediaQuery.of(c).size.width;
    final s = list[sel];
    return Stage(
        bg: bgLogin,
        child: Stack(children: [
          // logo
          Positioned(
              left: 24, top: 8,
              child: Stack(children: [
                Text('FORJA\nMISTYC', style: TextStyle(fontSize: 46, height: .95, fontFamily: 'serif', fontWeight: FontWeight.w900,
                    foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 5..color = const Color(0xFF1B2A6B))),
                ShaderMask(
                    shaderCallback: (r) => const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFF2B0), Color(0xFFD9A030), Color(0xFF8A5A14)]).createShader(r),
                    child: const Text('FORJA\nMISTYC', style: TextStyle(fontSize: 46, height: .95, fontFamily: 'serif', fontWeight: FontWeight.w900, color: Colors.white))),
              ])),
          Positioned(left: 4, top: 4, child: IconButton(icon: const Icon(Icons.arrow_back, color: gold), onPressed: () => Navigator.pop(c))),
          // painel de login
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: SingleChildScrollView(
                      child: GoldBox(
                          width: (w * .38).clamp(310.0, 430.0),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Title(tr('server')),
                            InkWell(
                                onTap: pickServer,
                                child: Container(
                                    height: 42,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: gold)),
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
                              SizedBox(width: 28, height: 28, child: Checkbox(value: remember, onChanged: (v) => setState(() => remember = v ?? true))),
                              const SizedBox(width: 6),
                              Expanded(child: Text(tr('remember'), style: const TextStyle(fontSize: 11))),
                              InkWell(onTap: langMenu, child: Text('${tr('lang')} ▾', style: const TextStyle(color: Color(0xFF6FC3FF), fontSize: 12, decoration: TextDecoration.underline))),
                            ]),
                            const SizedBox(height: 8),
                            RedButton(busy ? '...' : tr('enter'), busy || s.status == 2 ? null : go),
                            const SizedBox(height: 6),
                            Row(children: [
                              action(Icons.person_add, tr('create'), createDialog),
                              action(Icons.restart_alt, tr('recover'), recoverDialog),
                              action(Icons.headset_mic, tr('support'), () => boxDialog(c, tr('support'), [
                                    Text(tr('supporttxt'), textAlign: TextAlign.center),
                                    const SizedBox(height: 10),
                                    Builder(builder: (dc) => RedButton(tr('ok'), () => Navigator.pop(dc), small: true)),
                                  ])),
                            ]),
                          ]))))),
          // boas-vindas + versão
          Positioned(
              left: 0, bottom: 0,
              child: Container(
                  width: w * .55,
                  padding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xDD000000), Color(0x00000000)])),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Row(children: [
                      const Icon(Icons.campaign, color: gold, size: 22),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tr('welcome'), style: const TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 13))),
                    ]),
                    Text(tr('welcome2'), style: const TextStyle(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text('Versão $version', style: const TextStyle(fontSize: 10, color: Colors.white60)),
                  ]))),
        ]));
  }
}