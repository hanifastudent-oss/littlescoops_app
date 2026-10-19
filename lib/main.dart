himport 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ============================================================================
// 🍦 LITTLE SCOOPS - FOCUS & ALARM APP WITH WEEK 8 STATE & LIFECYCLE
// ============================================================================
void main() {
  runApp(const FocusAlarmApp());
}

class FocusAlarmApp extends StatefulWidget {
  const FocusAlarmApp({super.key});

  @override
  State<FocusAlarmApp> createState() => _FocusAlarmAppState();
}

class _FocusAlarmAppState extends State<FocusAlarmApp> {
  List<AlarmItem> alarms = [
    AlarmItem(
      time: '06:30 AM',
      label: 'Morning Study Routine',
      repeat: 'Mon, Tue, Wed, Thu, Fri',
      sound: 'Soft Chime & Waves',
      isEnabled: true,
      snoozeDuration: 5,
    ),
    AlarmItem(
      time: '04:30 PM',
      label: 'Focus Block & Review',
      repeat: 'Everyday',
      sound: 'Matcha Latte Bell',
      isEnabled: true,
      snoozeDuration: 10,
    ),
    AlarmItem(
      time: '09:30 PM',
      label: 'Night Wind Down',
      repeat: 'Off',
      sound: 'Bedtime Lullaby',
      isEnabled: false,
      snoozeDuration: 5,
    ),
  ];

  DateTime selectedDate = DateTime.now();
  Map<String, List<Map<String, String>>> calendarEvents = {
    _formatKey(DateTime.now()): [
      {'time': '08:00 AM', 'title': 'Math Exam Review', 'type': 'Study Block'},
      {'time': '02:00 PM', 'title': 'Biology Lab Notes', 'type': 'Revision'},
    ],
    _formatKey(DateTime.now().add(const Duration(days: 1))): [
      {'time': '10:00 AM', 'title': 'Chemistry Problem Set', 'type': 'Practice'},
    ],
  };

  static String _formatKey(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void _handleLogout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  void _addCalendarEvent(DateTime date, Map<String, String> event) {
    final key = _formatKey(date);
    setState(() {
      if (calendarEvents.containsKey(key)) {
        calendarEvents[key]!.add(event);
      } else {
        calendarEvents[key] = [event];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Scoops',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD9EFBD),
          surface: const Color(0xFFFFF9F2),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF9F2),
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? MainNavigationWrapper(
              alarms: alarms,
              calendarEvents: calendarEvents,
              selectedDate: selectedDate,
              onDateSelected: (dt) {
                setState(() {
                  selectedDate = dt;
                });
              },
              onAddEvent: _addCalendarEvent,
              onLogout: _handleLogout,
              onUpdateAlarms: () {
                setState(() {});
              },
            )
          : LoginScreen(onLogin: _handleLogin),
    );
  }
}

class AlarmItem {
  String time;
  String label;
  String repeat;
  String sound;
  bool isEnabled;
  bool snooze;
  int snoozeDuration;

  AlarmItem({
    required this.time,
    required this.label,
    required this.repeat,
    required this.sound,
    this.isEnabled = true,
    this.snooze = true,
    this.snoozeDuration = 5,
  });
}

class MainNavigationWrapper extends StatefulWidget {
  final List<AlarmItem> alarms;
  final Map<String, List<Map<String, String>>> calendarEvents;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(DateTime, Map<String, String>) onAddEvent;
  final VoidCallback onLogout;
  final VoidCallback onUpdateAlarms;

  const MainNavigationWrapper({
    super.key,
    required this.alarms,
    required this.calendarEvents,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onAddEvent,
    required this.onLogout,
    required this.onUpdateAlarms,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      FocusAlarmHomeScreen(
        alarms: widget.alarms,
        onLogout: widget.onLogout,
        onUpdateAlarms: widget.onUpdateAlarms,
      ),
      const FocusPlaceholderScreen(),
      CalendarTabScreen(
        selectedDate: widget.selectedDate,
        calendarEvents: widget.calendarEvents,
        onDateSelected: widget.onDateSelected,
        onAddEvent: widget.onAddEvent,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF450C3F),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 11,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: 'Scoop Alarm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9EFBD),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A450C3F),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.icecream_rounded,
                    size: 52,
                    color: Color(0xFF450C3F),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Little Scoops',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF450C3F),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'One scoop of focus at a time ✨',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Color(0xFF1E293B)),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: const TextStyle(color: Color(0xFF64748B)),
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF450C3F)),
                          filled: true,
                          fillColor: const Color(0xFFFFF9F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Color(0xFF1E293B)),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Color(0xFF64748B)),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF450C3F)),
                          filled: true,
                          fillColor: const Color(0xFFFFF9F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF450C3F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    onPressed: widget.onLogin,
                    child: const Text(
                      'Sign In to Scoops',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: widget.onLogin,
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(
                      color: Color(0xFFE8A07C),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FocusAlarmHomeScreen extends StatefulWidget {
  final List<AlarmItem> alarms;
  final VoidCallback onLogout;
  final VoidCallback onUpdateAlarms;

  const FocusAlarmHomeScreen({
    super.key,
    required this.alarms,
    required this.onLogout,
    required this.onUpdateAlarms,
  });

  @override
  State<FocusAlarmHomeScreen> createState() => _FocusAlarmHomeScreenState();
}

class _FocusAlarmHomeScreenState extends State<FocusAlarmHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _openEditScreen(AlarmItem alarm, {bool isNew = false}) async {
    final updatedAlarm = await Navigator.push<AlarmItem>(
      context,
      MaterialPageRoute(
        builder: (context) => EditAlarmScreen(alarm: alarm, isNew: isNew),
      ),
    );

    if (updatedAlarm != null) {
      if (isNew) {
        widget.alarms.add(updatedAlarm);
      }
      widget.onUpdateAlarms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Little Scoops',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF450C3F),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alarm),
            onPressed: () {
              _openEditScreen(
                AlarmItem(
                  time: '07:00 AM',
                  label: 'One Scoop at a Time',
                  repeat: 'Never',
                  sound: 'Morning Delight',
                ),
                isNew: true,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://i.pinimg.com/originals/00/ef/e4/00efe4d919ed6c33f858544c50cf9c4c.png',
              fit: BoxFit.cover,
              color: const Color(0xFFFFEED6),
              colorBlendMode: BlendMode.softLight,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFFFFEED6));
              },
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFE8A07C),
                            child: Text(
                              'HER',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hanifa Ellys Ranaya',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'Kelas 11 • AGS',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.alarms.where((a) => a.isEnabled).length} Active Scoops',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB9D175), Color(0xFFD9EFBD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4DB9D175),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD166),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'NEXT SCOOP ALARM',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A5A61),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.alarms.isNotEmpty ? widget.alarms[0].time : 'No Alarm',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF450C3F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.alarms.isNotEmpty
                            ? 'Rings in 7h 45m • ${widget.alarms[0].label}'
                            : 'Tap + to set a scoop',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF450C3F),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Scoops Routine',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Tap card to edit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF450C3F).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...widget.alarms.map((alarm) => _buildAlarmCard(context, alarm)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmCard(BuildContext context, AlarmItem alarm) {
    return GestureDetector(
      onTap: () => _openEditScreen(alarm),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alarm.time,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: alarm.isEnabled
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      alarm.label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: alarm.isEnabled,
                  onChanged: (val) {
                    alarm.isEnabled = val;
                    widget.onUpdateAlarms();
                  },
                  activeTrackColor: const Color(0xFFB9D175),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  alarm.repeat,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                Icon(
                  alarm.isEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  size: 16,
                  color: alarm.isEnabled
                      ? const Color(0xFFB9D175)
                      : const Color(0xFF94A3B8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditAlarmScreen extends StatefulWidget {
  final AlarmItem alarm;
  final bool isNew;
  const EditAlarmScreen({super.key, required this.alarm, this.isNew = false});

  @override
  State<EditAlarmScreen> createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {
  late TextEditingController _labelController;
  late String _repeat;
  late String _sound;
  late bool _snooze;
  late int _snoozeDuration;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 16);

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.alarm.label);
    _repeat = widget.alarm.repeat;
    _sound = widget.alarm.sound;
    _snooze = widget.alarm.snooze;
    _snoozeDuration = widget.alarm.snoozeDuration;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9F2),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Color(0xFF450C3F), size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isNew ? 'New Scoop Alarm' : 'Edit Scoop Alarm',
          style: const TextStyle(
            color: Color(0xFF450C3F),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF450C3F),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
            onPressed: () {
              widget.alarm.label = _labelController.text.isEmpty
                  ? 'Little Scoop'
                  : _labelController.text;
              widget.alarm.repeat = _repeat;
              widget.alarm.sound = _sound;
              widget.alarm.snooze = _snooze;
              widget.alarm.snoozeDuration = _snoozeDuration;
              widget.alarm.time = _formatTimeOfDay(_selectedTime);
              Navigator.pop(context, widget.alarm);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  brightness: Brightness.light,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Color(0xFF450C3F),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(2026, 1, 1, 7, 16),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedTime = TimeOfDay.fromDateTime(newDate);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Repeat',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _repeat,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _repeat = _repeat == 'Never' ? 'Everyday' : 'Never';
                      });
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Scoop Label',
                          style: TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: TextField(
                            controller: _labelController,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: Color(0xFFE8A07C),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Name your scoop',
                              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ListTile(
                    title: const Text(
                      'Chime Sound',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _sound,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  SwitchListTile(
                    title: const Text(
                      'Snooze Scoop',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: _snooze,
                    activeTrackColor: const Color(0xFFB9D175),
                    onChanged: (val) {
                      setState(() {
                        _snooze = val;
                      });
                    },
                  ),
                  if (_snooze) ...[
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    ListTile(
                      title: const Text(
                        'Snooze Duration',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        '$_snoozeDuration min',
                        style: const TextStyle(
                          color: Color(0xFFE8A07C),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _snoozeDuration = _snoozeDuration == 5 ? 10 : 5;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!widget.isNew)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete Scoop',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CalendarTabScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, List<Map<String, String>>> calendarEvents;
  final Function(DateTime) onDateSelected;
  final Function(DateTime, Map<String, String>) onAddEvent;

  const CalendarTabScreen({
    super.key,
    required this.selectedDate,
    required this.calendarEvents,
    required this.onDateSelected,
    required this.onAddEvent,
  });

  @override
  State<CalendarTabScreen> createState() => _CalendarTabScreenState();
}

class _CalendarTabScreenState extends State<CalendarTabScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatKey(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  void _showAddEventModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddEventModal(
          selectedDate: widget.selectedDate,
          onSave: (event) {
            widget.onAddEvent(widget.selectedDate, event);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = _formatKey(widget.selectedDate);
    final dayEvents = widget.calendarEvents[key] ?? [];
    final daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scoop Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF450C3F),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEventModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_monthName(widget.selectedDate.month)} ${widget.selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF450C3F),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9EFBD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Week 8 Focus',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF450C3F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: daysOfWeek
                        .map((day) => Text(
                              day,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final dayDate = widget.selectedDate
                          .add(Duration(days: index - widget.selectedDate.weekday + 1));
                      final isSelected = dayDate.day == widget.selectedDate.day &&
                          dayDate.month == widget.selectedDate.month;
                      final hasEvents =
                          widget.calendarEvents.containsKey(_formatKey(dayDate));

                      return GestureDetector(
                        onTap: () => widget.onDateSelected(dayDate),
                        child: Container(
                          width: 38,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF450C3F)
                                : const Color(0xFFFFF9F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF450C3F)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${dayDate.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: hasEvents
                                      ? (isSelected
                                          ? const Color(0xFFFFD166)
                                          : const Color(0xFFE8A07C))
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule (${widget.selectedDate.day} ${_monthName(widget.selectedDate.month)})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '${dayEvents.length} items',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (dayEvents.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.event_available, size: 36, color: Color(0xFFE8A07C)),
                    SizedBox(height: 8),
                    Text(
                      'No Focus Blocks Scheduled',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap + to schedule a study or focus session!',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              )
            else
              ...dayEvents.map((evt) => _buildEventCard(evt)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> evt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFD9EFBD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.stars, color: Color(0xFF450C3F), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evt['title'] ?? 'Scoop Task',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${evt['type']} • ${evt['time']}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class AddEventModal extends StatefulWidget {
  final DateTime selectedDate;
  final Function(Map<String, String>) onSave;

  const AddEventModal({
    super.key,
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends State<AddEventModal> {
  final _titleController = TextEditingController();
  final _typeController = TextEditingController(text: 'Study Block');
  final _timeController = TextEditingController(text: '03:00 PM');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Focus Event',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF450C3F),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Event Title',
              filled: true,
              fillColor: const Color(0xFFFFF9F2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _typeController,
                  decoration: InputDecoration(
                    labelText: 'Tag / Category',
                    filled: true,
                    fillColor: const Color(0xFFFFF9F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    filled: true,
                    fillColor: const Color(0xFFFFF9F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF450C3F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  widget.onSave({
                    'title': _titleController.text,
                    'type': _typeController.text,
                    'time': _timeController.text,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Event to Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FocusPlaceholderScreen extends StatelessWidget {
  const FocusPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF450C3F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFD9EFBD),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_florist, size: 52, color: Color(0xFF450C3F)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Focus Session Scoop',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Timer feature integrated in upcoming scoops!',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
