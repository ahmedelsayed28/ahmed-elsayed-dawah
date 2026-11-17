import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AhmedElsayedApp());
}

class DawahVideo {
  final String id;
  final String cat;
  final String titleAr;
  final String titleEn;

  const DawahVideo({
    required this.id,
    required this.cat,
    required this.titleAr,
    required this.titleEn,
  });

  String get thumbUrl => 'https://i.ytimg.com/vi/$id/hqdefault.jpg';
  String get watchUrl => 'https://www.youtube.com/watch?v=$id';
  String get embedUrl => 'https://www.youtube.com/embed/$id?autoplay=1&rel=0';
}

const _channelId = 'UCIo3f71IVat32Y_yJCxQy3g';
const _channelUrl = 'https://www.youtube.com/channel/$_channelId';

const _curatedVideos = <DawahVideo>[
  DawahVideo(
    id: '5udlE4Xl7Ck',
    cat: 'quran',
    titleAr: 'فجريات هادئة - تلاوات من صلاة الفجر',
    titleEn: 'Calm Fajr Recitations',
  ),
  DawahVideo(
    id: 'BS9_xwKnH4s',
    cat: 'quran',
    titleAr: 'آيات من سورة يونس - من صلاة التهجد - رمضان 1444',
    titleEn: 'Surah Yunus - Tahajjud Prayer',
  ),
  DawahVideo(
    id: 'rZ1MwKDhEvo',
    cat: 'quran',
    titleAr: 'ما تيسر من سورة البقرة',
    titleEn: 'Selected Verses from Surah Al-Baqarah',
  ),
  DawahVideo(
    id: 'gUInzldjHPY',
    cat: 'quran',
    titleAr: 'ما تيسر من سورة غافر - قصة مؤمن آل فرعون',
    titleEn: 'Surah Ghafir - Story of the Believer',
  ),
  DawahVideo(
    id: 'P2JPRdF4ZF4',
    cat: 'tadabbur',
    titleAr: 'تدبر و تفكر في الجنة و ما فيها من نعيم من خلال سورة الإنسان',
    titleEn: 'Reflecting on Paradise in Surah Al-Insan',
  ),
  DawahVideo(
    id: 'EugF4Y3y9SM',
    cat: 'shorts',
    titleAr: 'و كم لله من لطف خفى',
    titleEn: "Allah's Hidden Kindness (Short)",
  ),
  DawahVideo(
    id: 'hql-3qO-dIg',
    cat: 'reminders',
    titleAr: 'اصبر',
    titleEn: 'Be Patient',
  ),
  DawahVideo(
    id: 'Ujt0XROo8Bw',
    cat: 'reminders',
    titleAr: 'اغتنم حياتك',
    titleEn: 'Seize Your Life',
  ),
  DawahVideo(
    id: '1RulEmD4lSg',
    cat: 'lessons',
    titleAr: 'موقف من حياة عمر بن الخطاب رضى الله عنه',
    titleEn: 'A Lesson from Umar ibn Al-Khattab',
  ),
  DawahVideo(
    id: 'VvbbLh6mLA4',
    cat: 'lessons',
    titleAr: 'الأزمة الاقتصادية و حرمة الربا و فوائد البنوك الربوية',
    titleEn: 'Islamic Guidance on Riba & Economy',
  ),
  DawahVideo(
    id: '5Ll00Ub2vMY',
    cat: 'lessons',
    titleAr: 'الأزمة الاقتصادية (آثار - أسباب - علاج)',
    titleEn: 'Economic Crisis: Causes & Cure',
  ),
  DawahVideo(
    id: 'khDYqp-EMr0',
    cat: 'reminders',
    titleAr: 'بحر الحياة',
    titleEn: 'The Sea of Life',
  ),
  DawahVideo(
    id: 'ZuPZ6coOHOg',
    cat: 'reminders',
    titleAr: 'حديث الليل',
    titleEn: 'Night Reflections',
  ),
  DawahVideo(
    id: 'fEUCNl1glF8',
    cat: 'reminders',
    titleAr: 'رباط القلب',
    titleEn: 'Steadfastness of the Heart',
  ),
  DawahVideo(
    id: 'SjKsGtLSGks',
    cat: 'reminders',
    titleAr: 'وجهة نظر',
    titleEn: 'A Faith Perspective',
  ),
];

const _dawahCards = <Map<String, String>>[
  {
    'text': '﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾ — اجعل لك ورداً يومياً من القرآن ولو صفحة واحدة.',
    'ref': 'سورة الرعد: 28',
  },
  {
    'text': '«أحبُّ الأعمال إلى الله أدومُها وإن قلَّ» — الاستمرار على الطاعة القليلة يفتح أبواب التوفيق.',
    'ref': 'متفق عليه',
  },
  {
    'text': 'من لزم الاستغفار جعل الله له من كل همٍّ فرجاً ومن كل ضيقٍ مخرجاً.',
    'ref': 'تذكير إيماني',
  },
  {
    'text': 'اصبر وما صبرك إلا بالله؛ فإن مع العسر يسراً.',
    'ref': 'سورة النحل / الشرح',
  },
];

const _reminders = <Map<String, String>>[
  {'title': 'أذكار الصباح والمساء', 'desc': 'حافظ على حصنك اليومي في بداية اليوم ونهايته.'},
  {'title': 'سنة الضحى', 'desc': 'ركعتان تجزئان عن صدقة كل مفصل في جسدك.'},
  {'title': 'الورد القرآني اليومي', 'desc': 'لا يمر يومك دون أن تفتح كتاب الله وتقرأ وتتدبر.'},
];

class AhmedElsayedApp extends StatefulWidget {
  const AhmedElsayedApp({super.key});

  @override
  State<AhmedElsayedApp> createState() => _AhmedElsayedAppState();
}

class _AhmedElsayedAppState extends State<AhmedElsayedApp> {
  bool _isArabic = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _isArabic ? 'أحمد السيد' : 'Ahmed Elsayed',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBF8F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F4C45),
          primary: const Color(0xFF0F4C45),
          secondary: const Color(0xFFC89B3C),
          surface: Colors.white,
        ),
      ),
      home: Directionality(
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: HomeShell(
          isArabic: _isArabic,
          onToggleLang: () => setState(() => _isArabic = !_isArabic),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onToggleLang;
  const HomeShell({super.key, required this.isArabic, required this.onToggleLang});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  String _cat = 'all';
  String _query = '';
  List<DawahVideo> _videos = List.of(_curatedVideos);
  Set<String> _favs = {};

  static const _teal = Color(0xFF0F4C45);
  static const _gold = Color(0xFFC89B3C);

  @override
  void initState() {
    super.initState();
    _loadFavs();
    _syncYouTubeFeed();
  }

  Future<void> _loadFavs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('ahmed_favs') ?? [];
    if (mounted) setState(() => _favs = saved.toSet());
  }

  Future<void> _toggleFav(String id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favs.contains(id)) {
        _favs.remove(id);
      } else {
        _favs.add(id);
      }
    });
    await prefs.setStringList('ahmed_favs', _favs.toList());
  }

  bool _isReligiousVideo(String title) {
    final lower = title.toLowerCase();
    const blocked = [
      'الذكاء الاصطناعي',
      'لوحة المفاتيح',
      'برمجة',
      'flutter',
      'python',
      'coding',
      'ai ',
      'فرص عمل',
      'تطبيقات عملية',
    ];
    return !blocked.any((b) => lower.contains(b));
  }

  Future<void> _syncYouTubeFeed() async {
    try {
      final res = await http
          .get(Uri.parse('https://www.youtube.com/feeds/videos.xml?channel_id=$_channelId'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return;

      final entryRegex = RegExp(r'<entry>([\s\S]*?)</entry>');
      final idRegex = RegExp(r'<yt:videoId>([^<]+)</yt:videoId>');
      final titleRegex = RegExp(r'<title>([^<]+)</title>');

      final existingIds = _videos.map((v) => v.id).toSet();
      final extras = <DawahVideo>[];
      for (final m in entryRegex.allMatches(res.body)) {
        final block = m.group(1) ?? '';
        final vid = idRegex.firstMatch(block)?.group(1)?.trim() ?? '';
        final title = titleRegex.firstMatch(block)?.group(1)?.trim() ?? '';
        if (vid.isNotEmpty &&
            title.isNotEmpty &&
            !existingIds.contains(vid) &&
            _isReligiousVideo(title)) {
          extras.add(DawahVideo(id: vid, cat: 'reminders', titleAr: title, titleEn: title));
        }
      }
      if (extras.isNotEmpty && mounted) {
        setState(() => _videos = [...extras, ..._videos]);
      }
    } catch (_) {
      // Offline mode continues seamlessly with bundled curated videos.
    }
  }

  String _tr(String ar, String en) => widget.isArabic ? ar : en;

  Map<String, String> get _cats => widget.isArabic
      ? {
          'all': 'الكل',
          'quran': 'تلاوات قرآنية',
          'tadabbur': 'تدبر القرآن',
          'lessons': 'دروس ومواعظ',
          'reminders': 'خواطر إيمانية',
          'shorts': 'مقاطع قصيرة',
        }
      : {
          'all': 'All',
          'quran': 'Quran',
          'tadabbur': 'Reflection',
          'lessons': 'Lessons',
          'reminders': 'Reminders',
          'shorts': 'Shorts',
        };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: _gold,
              child: Text(
                widget.isArabic ? 'أ' : 'A',
                style: const TextStyle(color: Color(0xFF092E2A), fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _tr('أحمد السيد', 'Ahmed Elsayed'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: widget.onToggleLang,
            child: Text(
              widget.isArabic ? 'EN' : 'عربي',
              style: const TextStyle(color: Color(0xFFF3D27A), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          _buildVideosTab(),
          _buildCardsTab(),
          _buildFavsTab(),
          _buildAboutTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: Colors.white,
        indicatorColor: _teal.withValues(alpha: 0.14),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.play_circle_outline),
            selectedIcon: const Icon(Icons.play_circle, color: _teal),
            label: _tr('المرئيات', 'Videos'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: const Icon(Icons.auto_awesome, color: _teal),
            label: _tr('بطاقات', 'Cards'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite, color: _teal),
            label: _tr('المفضلة', 'Saved'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: _teal),
            label: _tr('نبذة', 'About'),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosTab() {
    final q = _query.trim().toLowerCase();
    final list = _videos.where((v) {
      final catOk = _cat == 'all' || v.cat == _cat;
      final qOk = q.isEmpty ||
          v.titleAr.toLowerCase().contains(q) ||
          v.titleEn.toLowerCase().contains(q);
      return catOk && qOk;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF092E2A), _teal]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _gold.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _tr('تلاوات ودروس دعوية — بدون تسجيل دخول', 'Quran & Da\'wah — No Login Required'),
                style: const TextStyle(color: Color(0xFFF3D27A), fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                _tr('أحمد السيد', 'Ahmed Elsayed'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                _tr(
                  'مختارات قرآنية ودروس إيمانية من القناة الرسمية على يوتيوب.',
                  'Selected Quran recitations & Islamic reminders.',
                ),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: _tr('ابحث في التلاوات والدروس...', 'Search recitations & lessons...'),
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _teal.withValues(alpha: 0.15)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _cats.entries.map((e) {
              final selected = _cat == e.key;
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 4),
                child: ChoiceChip(
                  label: Text(e.value),
                  selected: selected,
                  selectedColor: _teal,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : _teal,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) => setState(() => _cat = e.key),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        ...list.map(_buildVideoCard),
      ],
    );
  }

  Widget _buildVideoCard(DawahVideo v) {
    final title = widget.isArabic ? v.titleAr : v.titleEn;
    final isFav = _favs.contains(v.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: v, title: title)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    v.thumbUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: const Color(0xFF0D2220)),
                  ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Color(0xFF092E2A), size: 32),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : _teal,
                    ),
                    onPressed: () => _toggleFav(v.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: _teal),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: v.watchUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_tr('تم نسخ رابط الفيديو', 'Video link copied'))),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _dawahCards.length,
      itemBuilder: (context, i) {
        final c = _dawahCards[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.white, Color(0xFFF5EBD4)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _gold.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c['text']!,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.6),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(c['ref']!, style: const TextStyle(color: Color(0xFF5D726E), fontWeight: FontWeight.w600)),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: c['text']!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_tr('تم نسخ البطاقة', 'Card copied'))),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text(_tr('نسخ', 'Copy')),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavsTab() {
    final saved = _videos.where((v) => _favs.contains(v.id)).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          _tr('تذكيرات يومية', 'Daily Reminders'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _teal),
        ),
        const SizedBox(height: 10),
        ..._reminders.map(
          (r) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.notifications_active_outlined, color: _gold),
              title: Text(r['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(r['desc']!),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _tr('المفضلة المحفوظة', 'Saved Favorites'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _teal),
        ),
        const SizedBox(height: 10),
        if (saved.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text(_tr('لا توجد فيديوهات في المفضلة بعد.', 'No favorite videos yet.'))),
          )
        else
          ...saved.map(_buildVideoCard),
      ],
    );
  }

  Widget _buildAboutTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _gold.withValues(alpha: 0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _tr('أحمد السيد', 'Ahmed Elsayed'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _teal),
              ),
              const SizedBox(height: 10),
              Text(
                _tr(
                  'تطبيق خفيف ومجاني يجمع التلاوات القرآنية والخواطر الإيمانية والدروس الدعوية لأحمد السيد من قناته الرسمية على يوتيوب، بدون الحاجة لتسجيل دخول.',
                  'A lightweight, login-free app gathering Quran recitations and Islamic reminders by Ahmed Elsayed from his official YouTube channel.',
                ),
                style: const TextStyle(fontSize: 15, height: 1.7),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () => launchUrl(Uri.parse(_channelUrl), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.ondemand_video),
                label: Text(_tr('زيارة القناة على يوتيوب', 'Visit YouTube Channel')),
                style: ElevatedButton.styleFrom(backgroundColor: _teal, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final DawahVideo video;
  final String title;
  const VideoPlayerScreen({super.key, required this.video, required this.title});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final embedUrl =
        'https://www.youtube.com/embed/${widget.video.id}?autoplay=1&playsinline=1&rel=0';
    final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
  <style>
    html, body { margin:0; padding:0; width:100%; height:100%; background:#000; overflow:hidden; }
    iframe { width:100%; height:100%; border:0; }
  </style>
</head>
<body>
  <iframe
    src="$embedUrl"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
  </iframe>
</body>
</html>
''';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadHtmlString(html, baseUrl: 'https://ahmed-elsayed-dawah.web.app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F4C45),
        foregroundColor: Colors.white,
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => launchUrl(Uri.parse(widget.video.watchUrl), mode: LaunchMode.externalApplication),
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFFC89B3C)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => launchUrl(Uri.parse(widget.video.watchUrl), mode: LaunchMode.externalApplication),
                  icon: const Icon(Icons.ondemand_video),
                  label: const Text('فتح في تطبيق يوتيوب / Open in YouTube'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
