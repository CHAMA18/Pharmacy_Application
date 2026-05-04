import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart'; // To access appThemeMode

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const ProfileScreen({super.key, this.onBackPressed});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerColor = colorScheme.outline.withValues(alpha: 0.2);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: widget.onBackPressed,
                  color: colorScheme.onSurface,
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 48), // Spacer to balance the back button
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 56,
                backgroundImage: AssetImage('assets/images/landscape_null_1776853579839.jpg'),
              ),
              const SizedBox(height: 16),
              Text(
                '[Random Name]',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'developer@thestackone.com',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Divider(color: dividerColor, thickness: 1, height: 1),
              _buildListTile(
                icon: Icons.add,
                title: 'Add Product',
                onTap: () {},
                colorScheme: colorScheme,
              ),
              Divider(color: dividerColor, thickness: 1, height: 1),
              _buildListTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {},
                colorScheme: colorScheme,
              ),
              Divider(color: dividerColor, thickness: 1, height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  children: [
                    Icon(Icons.dark_mode_outlined, color: colorScheme.onSurface, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Switch to Dark Mode',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<ThemeMode>(
                      valueListenable: appThemeMode,
                      builder: (context, themeMode, _) {
                        final isDark = themeMode == ThemeMode.dark ||
                            (themeMode == ThemeMode.system &&
                                MediaQuery.of(context).platformBrightness == Brightness.dark);
                        return Switch(
                          value: isDark,
                          onChanged: (value) {
                            appThemeMode.value = value ? ThemeMode.dark : ThemeMode.light;
                          },
                          activeColor: colorScheme.onPrimary,
                          activeTrackColor: colorScheme.primary,
                          inactiveThumbColor: colorScheme.onSurfaceVariant,
                          inactiveTrackColor: colorScheme.surfaceContainerHighest,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: dividerColor, thickness: 1, height: 1),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: colorScheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    ),
    ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onSurface, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
