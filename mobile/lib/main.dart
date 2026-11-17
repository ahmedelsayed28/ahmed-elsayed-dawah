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
}

class TelegramLesson {
  final int msgId;
  final String duration;
  final String type;
  final String title;

  const TelegramLesson({
    required this.msgId,
    required this.duration,
    required this.type,
    required this.title,
  });

  String get url => 'https://t.me/ahmedelsayedah/$msgId';
}

class LessonSeries {
  final String title;
  final List<TelegramLesson> lessons;

  const LessonSeries({required this.title, required this.lessons});
}

const _channelId = 'UCIo3f71IVat32Y_yJCxQy3g';
const _channelUrl = 'https://www.youtube.com/channel/$_channelId';
const _telegramUrl = 'https://t.me/ahmedelsayedah';

const _curatedVideos = <DawahVideo>[
  DawahVideo(
    id: '5udlE4Xl7Ck',
    cat: 'quran',
    titleAr: 'فجريات هادئة - تلاوات من صلاة الفجر',
    titleEn: 'Calm Fajr Recitations',
  ),
  DawahVideo(
    id: 'MMpUIXoaFrk',
    cat: 'quran',
    titleAr: 'سورة القمر من صلاة الفجر',
    titleEn: 'Surah Al-Qamar - Fajr Prayer',
  ),
  DawahVideo(
    id: 'w9mdX2t0l0Y',
    cat: 'quran',
    titleAr: 'ما تيسر من سورة هود - صلاة العشاء',
    titleEn: 'Surah Hud - Isha Prayer',
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
    id: 'bYJY2hKAQYg',
    cat: 'lessons',
    titleAr: 'و ما قوم لوط منكم ببعيد',
    titleEn: 'Lessons from the People of Lut',
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
    titleAr: 'بحر الحياة (الإخلاص سفينة النجاة)',
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

const _telegramSeries = <LessonSeries>[
  LessonSeries(
    title: 'سلسلة أصول الإيمان في ضوء الكتاب والسنة',
    lessons: [
      TelegramLesson(msgId: 210, duration: '30:06', type: 'صوت', title: 'المجلس الأول — أصول الإيمان في ضوء الكتاب والسنة'),
      TelegramLesson(msgId: 225, duration: '38:46', type: 'صوت', title: 'المجلس الثاني — أصول الإيمان في ضوء الكتاب والسنة'),
      TelegramLesson(msgId: 230, duration: '22:55', type: 'صوت', title: 'المجلس الثالث — في النهي عن أعمال تتعلق بالقبور'),
    ],
  ),
  LessonSeries(
    title: 'سلسلة الفقه الميسر في ضوء الكتاب والسنة',
    lessons: [
      TelegramLesson(msgId: 217, duration: '30:35', type: 'صوت', title: 'المجلس الأول — الفقه الميسر'),
      TelegramLesson(msgId: 222, duration: '27:39', type: 'صوت', title: 'المجلس الثاني (١) — الفقه الميسر'),
      TelegramLesson(msgId: 223, duration: '01:35', type: 'صوت', title: 'تكملة ١ — المجلس الثاني'),
      TelegramLesson(msgId: 224, duration: '00:58', type: 'صوت', title: 'تكملة ٢ — المجلس الثاني'),
      TelegramLesson(msgId: 228, duration: '26:36', type: 'صوت', title: 'المجلس الثالث — كتاب الآنية'),
      TelegramLesson(msgId: 232, duration: '24:12', type: 'صوت', title: 'المجلس الرابع — قضاء الحاجة وآدابها'),
    ],
  ),
  LessonSeries(
    title: 'سلسلة العقيدة والفقه — المرحلة الإعدادية',
    lessons: [
      TelegramLesson(msgId: 99, duration: '38:11', type: 'صوت', title: 'المحاضرة الأولى (صوتي)'),
      TelegramLesson(msgId: 107, duration: '38:59', type: 'فيديو', title: 'المحاضرة الأولى (مرئي)'),
      TelegramLesson(msgId: 113, duration: '51:09', type: 'صوت', title: 'المحاضرة الثانية في العقيدة والفقه'),
      TelegramLesson(msgId: 120, duration: '27:45', type: 'صوت', title: 'المحاضرة الثالثة في العقيدة والفقه'),
    ],
  ),
  LessonSeries(
    title: 'سلسلة التفسير والحديث — المرحلة الإعدادية',
    lessons: [
      TelegramLesson(msgId: 124, duration: '36:44', type: 'صوت', title: 'المحاضرة الأولى في التفسير والحديث'),
      TelegramLesson(msgId: 132, duration: '19:46', type: 'صوت', title: 'المحاضرة الثانية (صوتي)'),
      TelegramLesson(msgId: 133, duration: '19:46', type: 'فيديو', title: 'المحاضرة الثانية (مرئي)'),
      TelegramLesson(msgId: 137, duration: '13:28', type: 'فيديو', title: 'المحاضرة ٣ في التفسير والحديث'),
      TelegramLesson(msgId: 143, duration: '11:46', type: 'فيديو', title: 'المحاضرة الرابعة في التفسير والحديث'),
      TelegramLesson(msgId: 147, duration: '20:44', type: 'فيديو', title: 'المحاضرة الخامسة (الجزء الأول)'),
      TelegramLesson(msgId: 148, duration: '13:56', type: 'فيديو', title: 'المحاضرة الخامسة (الجزء الثاني)'),
      TelegramLesson(msgId: 154, duration: '18:04', type: 'فيديو', title: 'المحاضرة السادسة في التفسير'),
      TelegramLesson(msgId: 161, duration: '27:44', type: 'فيديو', title: 'المحاضرة الثامنة في التفسير'),
      TelegramLesson(msgId: 165, duration: '24:10', type: 'فيديو', title: 'المحاضرة التاسعة في التفسير'),
      TelegramLesson(msgId: 169, duration: '11:51', type: 'فيديو', title: 'مراجعة منهج التفسير'),
      TelegramLesson(msgId: 175, duration: '20:09', type: 'فيديو', title: 'الحديث — المرحلة الإعدادية'),
      TelegramLesson(msgId: 182, duration: '07:58', type: 'فيديو', title: 'الدرس الثامن — الحديث'),
    ],
  ),
  LessonSeries(
    title: 'سلسلة خطب (الداء والدواء)',
    lessons: [
      TelegramLesson(msgId: 236, duration: '28:27', type: 'صوت', title: 'الخطبة الأولى — لا تيأس فلكل داء دواء إلا الهرم'),
      TelegramLesson(msgId: 237, duration: '24:56', type: 'صوت', title: 'الخطبة الثانية — سلاح الدعاء'),
    ],
  ),
  LessonSeries(
    title: 'سلسلة تذكرة التراويح ولقاءات رمضان',
    lessons: [
      TelegramLesson(msgId: 83, duration: '08:19', type: 'صوت', title: 'تذكرة التراويح (٢) — الرزق مقسوم والحلال مبارك'),
      TelegramLesson(msgId: 85, duration: '08:56', type: 'صوت', title: 'تذكرة التراويح (٣) — ذكر الفطرة'),
      TelegramLesson(msgId: 86, duration: '08:04', type: 'صوت', title: 'تذكرة التراويح (٤) — اللهم أنت عضدي'),
      TelegramLesson(msgId: 201, duration: '09:29', type: 'صوت', title: 'أعظم مطلوب (رمضان)'),
      TelegramLesson(msgId: 204, duration: '09:52', type: 'صوت', title: 'الدعاء (اللقاء الأول - رمضان)'),
      TelegramLesson(msgId: 205, duration: '07:41', type: 'صوت', title: 'الدعاء (اللقاء الثاني - رمضان)'),
      TelegramLesson(msgId: 206, duration: '05:39', type: 'صوت', title: 'الدعاء (اللقاء الرابع - رمضان)'),
      TelegramLesson(msgId: 207, duration: '06:06', type: 'صوت', title: 'الدعاء (اللقاء الخامس - رمضان)'),
      TelegramLesson(msgId: 208, duration: '07:30', type: 'صوت', title: 'أولئك الأكياس'),
      TelegramLesson(msgId: 209, duration: '11:14', type: 'صوت', title: 'قد تبين الرشد من الغي'),
      TelegramLesson(msgId: 243, duration: '07:22', type: 'صوت', title: 'في السماء (الرزق والتدبير)'),
      TelegramLesson(msgId: 252, duration: '08:17', type: 'صوت', title: 'في السماء — حسن الخلق'),
    ],
  ),
  LessonSeries(
    title: 'التلاوات الصوتية وسورة الأنفال (تليجرام)',
    lessons: [
      TelegramLesson(msgId: 14, duration: '06:07', type: 'صوت', title: 'سورة الإنسان من صلاة فجر الجمعة'),
      TelegramLesson(msgId: 15, duration: '08:31', type: 'صوت', title: 'سورة السجدة من صلاة فجر الجمعة'),
      TelegramLesson(msgId: 30, duration: '04:05', type: 'صوت', title: 'سورة المزمل'),
      TelegramLesson(msgId: 32, duration: '04:22', type: 'صوت', title: 'آيات بينات من أدعية الأنبياء — سورة الأنبياء'),
      TelegramLesson(msgId: 39, duration: '06:14', type: 'صوت', title: 'الربع الأول من سورة البقرة'),
      TelegramLesson(msgId: 43, duration: '04:51', type: 'صوت', title: 'ما تيسر من سورة الزمر'),
      TelegramLesson(msgId: 44, duration: '04:47', type: 'صوت', title: 'تدبر نعيم أهل الجنة — سورة الصافات'),
      TelegramLesson(msgId: 244, duration: '03:56', type: 'صوت', title: 'تلاوة التراويح — سورة الأنفال (١–٨)'),
    ],
  ),
  LessonSeries(
    title: 'خطب ودروس متفرقة (تليجرام)',
    lessons: [
      TelegramLesson(msgId: 25, duration: '17:01', type: 'صوت', title: 'مرض الكبر وعلاجه — خطبة الجمعة'),
      TelegramLesson(msgId: 26, duration: '19:05', type: 'صوت', title: 'مرض الحسد وعلاجه — خطبة الجمعة'),
      TelegramLesson(msgId: 28, duration: '15:18', type: 'صوت', title: 'عقيدة المسلم — شرح متن نواقض الإسلام'),
      TelegramLesson(msgId: 29, duration: '14:50', type: 'صوت', title: 'التوبة من رياض الصالحين'),
      TelegramLesson(msgId: 33, duration: '19:06', type: 'صوت', title: 'الدعاء فضله وآدابه ودعاء يوم عرفة'),
      TelegramLesson(msgId: 35, duration: '18:02', type: 'صوت', title: 'فضل عشر ذي الحجة والعمل الصالح فيها'),
      TelegramLesson(msgId: 89, duration: '29:10', type: 'صوت', title: 'وأذن في الناس بالحج — خطبة الجمعة'),
      TelegramLesson(msgId: 233, duration: '39:44', type: 'صوت', title: 'خمس كلمات فيهن النجاة والفلاح'),
      TelegramLesson(msgId: 234, duration: '24:20', type: 'صوت', title: 'الإمارة واختيار الأصلح'),
    ],
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
  String _seriesQuery = '';
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
    } catch (_) {}
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
            ClipOval(
              child: Image.asset(
                'assets/logo.png',
                width: 34,
                height: 34,
                fit: BoxFit.cover,
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
          _buildSeriesTab(),
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
            icon: const Icon(Icons.library_music_outlined),
            selectedIcon: const Icon(Icons.library_music, color: _teal),
            label: _tr('السلاسل', 'Series'),
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
          child: Row(
            children: [
              ClipOval(
                child: Image.asset('assets/logo.png', width: 58, height: 58, fit: BoxFit.cover),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _tr('تلاوات ودروس دعوية — بدون تسجيل دخول', 'Quran & Da\'wah — No Login'),
                      style: const TextStyle(color: Color(0xFFF3D27A), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _tr('أحمد السيد', 'Ahmed Elsayed'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _tr('يوتيوب + قناة التليجرام الصوتية', 'YouTube + Telegram Audio'),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                    ),
                  ],
                ),
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

  Widget _buildSeriesTab() {
    final q = _seriesQuery.trim().toLowerCase();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton.icon(
          onPressed: () => launchUrl(Uri.parse(_telegramUrl), mode: LaunchMode.externalApplication),
          icon: const Icon(Icons.send_rounded),
          label: Text(_tr('فتح قناة أحمد السيد على تليجرام', 'Open Telegram Channel')),
          style: ElevatedButton.styleFrom(
            backgroundColor: _teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (v) => setState(() => _seriesQuery = v),
          decoration: InputDecoration(
            hintText: _tr('ابحث في السلاسل والدروس الصوتية...', 'Search audio series...'),
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
        ..._telegramSeries.map((series) {
          final filtered = series.lessons
              .where((l) => q.isEmpty || l.title.toLowerCase().contains(q) || series.title.toLowerCase().contains(q))
              .toList();
          if (filtered.isEmpty) return const SizedBox.shrink();
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              initiallyExpanded: q.isNotEmpty,
              title: Text(series.title, style: const TextStyle(fontWeight: FontWeight.bold, color: _teal)),
              subtitle: Text('${filtered.length} ${_tr('مادة', 'items')}'),
              children: filtered.map((l) {
                return ListTile(
                  leading: Icon(
                    l.type == 'فيديو' ? Icons.videocam_outlined : Icons.headphones_outlined,
                    color: _gold,
                  ),
                  title: Text(l.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('${l.type} • ${l.duration}'),
                  trailing: const Icon(Icons.open_in_new, size: 18, color: _teal),
                  onTap: () => launchUrl(Uri.parse(l.url), mode: LaunchMode.externalApplication),
                );
              }).toList(),
            ),
          );
        }),
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
                    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : _teal),
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
              Text(c['text']!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.6)),
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
        Text(_tr('تذكيرات يومية', 'Daily Reminders'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _teal)),
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
        Text(_tr('المفضلة المحفوظة', 'Saved Favorites'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _teal)),
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
              Row(
                children: [
                  ClipOval(child: Image.asset('assets/logo.png', width: 64, height: 64, fit: BoxFit.cover)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _tr('أحمد السيد', 'Ahmed Elsayed'),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _teal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                _tr(
                  'تطبيق خفيف ومجاني يجمع التلاوات القرآنية وسلاسل الدروس العلمية والخواطر الدعوية لأحمد السيد من قناته على يوتيوب وتليجرام، بدون الحاجة لتسجيل دخول.',
                  'A lightweight, login-free app gathering Quran recitations, Islamic audio series, and reminders by Ahmed Elsayed from YouTube and Telegram.',
                ),
                style: const TextStyle(fontSize: 15, height: 1.7),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => launchUrl(Uri.parse(_channelUrl), mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.ondemand_video),
                    label: Text(_tr('قناة يوتيوب', 'YouTube Channel')),
                    style: ElevatedButton.styleFrom(backgroundColor: _teal, foregroundColor: Colors.white),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => launchUrl(Uri.parse(_telegramUrl), mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.send_rounded),
                    label: Text(_tr('قناة تليجرام', 'Telegram Channel')),
                  ),
                ],
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
