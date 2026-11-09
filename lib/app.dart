import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/user_database.dart';

class GandaberundaApp extends StatelessWidget {
  const GandaberundaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const royalBlue = Color(0xFF1257A6);
    const skyBlue = Color(0xFF58A6FF);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gandaberunda',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: royalBlue,
          primary: royalBlue,
          secondary: skyBlue,
          surface: const Color(0xFFF1F7FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFEAF3FF),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE6D9C8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE6D9C8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: royalBlue, width: 1.6),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF073B78), Color(0xFF1976D2)],
          ),
        ),
        child: const SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GandaberundaLogo(size: 170),
              SizedBox(height: 28),
              Text(
                'GANDABERUNDA',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Strength • Courage • Heritage',
                style: TextStyle(
                  color: Color(0xFFD8EBFF),
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  color: Color(0xFF8CC8FF),
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              const Spacer(),
              const GandaberundaLogo(size: 145, darkBackground: false),
              const SizedBox(height: 26),
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF073B78),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Discover a powerful experience inspired by Karnataka’s '
                'timeless symbol of strength.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 16,
                  color: Color(0xFF725E62),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text('Create account'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(color: Color(0xFF1257A6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text('I already have an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await UserDatabase.instance.register(
        fullName: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(name: user.username)),
        (_) => false,
      );
    } on DuplicateUserException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not create your account')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: 'Create account',
      subtitle: 'Join the Gandaberunda community',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _usernameController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Example: sriharsha',
                prefixIcon: Icon(Icons.alternate_email),
              ),
              validator: (value) {
                final username = value?.trim() ?? '';
                if (username.length < 3) {
                  return 'Username must have at least 3 characters';
                }
                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
                  return 'Use only letters, numbers and underscore';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: _emailValidator,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                  icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (value) =>
                  (value?.length ?? 0) < 6 ? 'Use at least 6 characters' : null,
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Register'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text('Already registered? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await UserDatabase.instance.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect email or password')),
        );
        return;
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(name: user.username)),
        (_) => false,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not log in. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Log in to continue your journey',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: _emailValidator,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                  icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (value) => (value?.isEmpty ?? true)
                  ? 'Please enter your password'
                  : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset link requested'),
                  ),
                ),
                child: const Text('Forgot password?'),
              ),
            ),
            FilledButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Log in'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              child: const Text('New here? Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}

String? _emailValidator(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
    return 'Please enter a valid email';
  }
  return null;
}

class _AuthScaffold extends StatelessWidget {
  const _AuthScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: GandaberundaLogo(size: 92, darkBackground: false),
              ),
              const SizedBox(height: 22),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF073B78),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF806B70), fontSize: 15),
              ),
              const SizedBox(height: 26),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.name});

  final String name;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late String _profileName;

  @override
  void initState() {
    super.initState();
    _profileName = widget.name.trim().isEmpty ? 'Friend' : widget.name;
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['GANDABERUNDA', 'EXPLORE', 'MY PROFILE'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              tooltip: 'Notifications',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You have no new notifications')),
              ),
              icon: const Icon(Icons.notifications_none),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeTab(name: _profileName),
          const _ExploreTab(),
          _ProfileTab(name: _profileName),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final cards = <({IconData icon, String title, String detail})>[
      (icon: Icons.explore_outlined, title: 'Explore', detail: 'Discover more'),
      (
        icon: Icons.auto_stories_outlined,
        title: 'Heritage',
        detail: 'Our story',
      ),
      (
        icon: Icons.groups_outlined,
        title: 'Community',
        detail: 'Connect today',
      ),
      (icon: Icons.event_outlined, title: 'Events', detail: 'What is coming'),
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF073B78), Color(0xFF1976D2)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x241257A6),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const GandaberundaLogo(size: 82),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Namaskara, $name!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your journey begins here.',
                      style: TextStyle(color: Color(0xFFD8EBFF)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Quick access',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.18,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFF0E5D6)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(card.icon, color: const Color(0xFF1976D2), size: 30),
                    const Spacer(),
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      card.detail,
                      style: const TextStyle(color: Color(0xFF806B70)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ExploreTab extends StatelessWidget {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search heritage, events and stories',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tune),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Discover Karnataka',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        ...[
          (Icons.temple_hindu_outlined, 'Royal heritage', 'Stories of Mysuru'),
          (
            Icons.festival_outlined,
            'Culture & festivals',
            'Celebrate together',
          ),
          (Icons.landscape_outlined, 'Places to visit', 'Explore Karnataka'),
        ].map(
          (item) => Card(
            elevation: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFDCEEFF),
                child: Icon(item.$1, color: const Color(0xFF1257A6)),
              ),
              title: Text(
                item.$2,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(item.$3),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatefulWidget {
  const _ProfileTab({required this.name});

  final String name;

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  late String _name;
  String _email = 'member@gandaberunda.in';
  String _phone = '+91 98765 43210';
  String _bio = 'Exploring the culture and heritage of Karnataka.';

  @override
  void initState() {
    super.initState();
    _name = widget.name.trim().isEmpty ? 'Friend' : widget.name;
  }

  Future<void> _editProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => EditProfileScreen(
          name: _name,
          email: _email,
          phone: _phone,
          bio: _bio,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _name = result['name']!;
        _email = result['email']!;
        _phone = result['phone']!;
        _bio = result['bio']!;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Center(
          child: Column(
            children: [
              const AnimatedProfileAvatar(),
              const SizedBox(height: 18),
              Text(
                _name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF073B78),
                ),
              ),
              const SizedBox(height: 4),
              Text(_email, style: const TextStyle(color: Color(0xFF806B70))),
              const SizedBox(height: 8),
              Text(
                _bio,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF526579), height: 1.4),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit profile'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF073B78),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ProfileStat(value: '12', label: 'Stories'),
              _StatDivider(),
              _ProfileStat(value: '08', label: 'Events'),
              _StatDivider(),
              _ProfileStat(value: '24', label: 'Saved'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        _ProfileOption(
          icon: Icons.person_outline,
          title: 'Personal information',
          subtitle: _phone,
          onTap: _editProfile,
        ),
        _ProfileOption(
          icon: Icons.bookmark_border,
          title: 'Saved items',
          onTap: () {},
        ),
        _ProfileOption(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {},
        ),
        _ProfileOption(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () {},
        ),
        const SizedBox(height: 10),
        _ProfileOption(
          icon: Icons.logout,
          title: 'Log out',
          isDestructive: true,
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (_) => false,
          ),
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
  });

  final String name;
  final String email;
  final String phone;
  final String bio;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _bioController = TextEditingController(text: widget.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EDIT PROFILE',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2),
        ),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Center(child: AnimatedProfileAvatar()),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Photo selection can be connected here'),
                  ),
                ),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Change profile photo'),
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: _emailValidator,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) => (value?.trim().length ?? 0) < 8
                  ? 'Please enter a valid phone number'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _bioController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              maxLength: 120,
              decoration: const InputDecoration(
                labelText: 'About me',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedProfileAvatar extends StatefulWidget {
  const AnimatedProfileAvatar({super.key});

  @override
  State<AnimatedProfileAvatar> createState() => _AnimatedProfileAvatarState();
}

class _AnimatedProfileAvatarState extends State<AnimatedProfileAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: .96,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 132,
            height: 132,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF8CC8FF), Color(0xFF1976D2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1976D2).withValues(alpha: .32),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEAF3FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 82,
                color: Color(0xFF073B78),
              ),
            ),
          ),
          Positioned(
            right: 3,
            bottom: 5,
            child: Container(
              width: 29,
              height: 29,
              decoration: BoxDecoration(
                color: const Color(0xFF2E9B62),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF8CC8FF),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(label, style: const TextStyle(color: Color(0xFFD8EBFF))),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 35, color: const Color(0x55FFFFFF));
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFB3261E)
        : const Color(0xFF073B78);
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: Icon(Icons.chevron_right, color: color),
      ),
    );
  }
}

class GandaberundaLogo extends StatelessWidget {
  const GandaberundaLogo({
    super.key,
    required this.size,
    this.darkBackground = true,
  });

  final double size;
  final bool darkBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: darkBackground
            ? const Color(0x19FFFFFF)
            : const Color(0xFFF7E9C8),
        border: Border.all(color: const Color(0xFFD6A63B), width: 2),
      ),
      child: CustomPaint(painter: _GandaberundaPainter()),
    );
  }
}

class _GandaberundaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gold = Paint()
      ..color = const Color(0xFFD6A63B)
      ..style = PaintingStyle.fill;
    final dark = Paint()
      ..color = const Color(0xFF5A1020)
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    final bird = Path()
      ..moveTo(w * .50, h * .78)
      ..cubicTo(w * .42, h * .63, w * .39, h * .51, w * .40, h * .39)
      ..cubicTo(w * .30, h * .27, w * .20, h * .23, w * .08, h * .30)
      ..cubicTo(w * .15, h * .14, w * .33, h * .08, w * .47, h * .23)
      ..lineTo(w * .50, h * .17)
      ..lineTo(w * .53, h * .23)
      ..cubicTo(w * .67, h * .08, w * .85, h * .14, w * .92, h * .30)
      ..cubicTo(w * .80, h * .23, w * .70, h * .27, w * .60, h * .39)
      ..cubicTo(w * .61, h * .51, w * .58, h * .63, w * .50, h * .78)
      ..close();
    canvas.drawPath(bird, gold);

    final leftWing = Path()
      ..moveTo(w * .39, h * .40)
      ..lineTo(w * .05, h * .45)
      ..lineTo(w * .32, h * .53)
      ..lineTo(w * .08, h * .64)
      ..lineTo(w * .40, h * .62)
      ..close();
    final rightWing = Path()
      ..moveTo(w * .61, h * .40)
      ..lineTo(w * .95, h * .45)
      ..lineTo(w * .68, h * .53)
      ..lineTo(w * .92, h * .64)
      ..lineTo(w * .60, h * .62)
      ..close();
    canvas.drawPath(leftWing, gold);
    canvas.drawPath(rightWing, gold);

    canvas.drawCircle(Offset(w * .30, h * .24), w * .025, dark);
    canvas.drawCircle(Offset(w * .70, h * .24), w * .025, dark);
    canvas.drawCircle(Offset(w * .50, h * .46), w * .07, dark);

    final tail = Path()
      ..moveTo(w * .43, h * .68)
      ..lineTo(w * .35, h * .91)
      ..lineTo(w * .50, h * .80)
      ..lineTo(w * .65, h * .91)
      ..lineTo(w * .57, h * .68)
      ..close();
    canvas.drawPath(tail, gold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
