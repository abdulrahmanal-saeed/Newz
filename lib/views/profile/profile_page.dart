import 'package:flutter/material.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/views/profile/change_password_page.dart';
import 'package:newz/views/profile/edit_profile_page.dart';
import 'package:newz/views/profile/notification_settings_page.dart';
import 'package:newz/views/profile/privacy_settings_page.dart';
import 'package:newz/views/profile/saved_articles_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'Profile',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "AbrilFatface"),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // الانتقال إلى صفحة تعديل الملف الشخصي
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // الصورة الشخصية
            const CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage('https://example.com/profile_picture.jpg'),
            ),
            const SizedBox(height: 20),
            // الاسم والبريد الإلكتروني
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'john.doe@example.com',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // زر تغيير كلمة المرور
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                // الانتقال إلى صفحة تغيير كلمة المرور
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                );
              },
            ),
            // الأخبار المحفوظة
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Saved Articles'),
              onTap: () {
                // الانتقال إلى صفحة الأخبار المحفوظة
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SavedArticlesPage()),
                );
              },
            ),
            // إعدادات الإشعارات
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications Settings'),
              onTap: () {
                // الانتقال إلى صفحة إعدادات الإشعارات
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationSettingsPage()),
                );
              },
            ),
            // إعدادات الخصوصية والأمان
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy & Security'),
              onTap: () {
                // الانتقال إلى صفحة الخصوصية والأمان
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacySettingsPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            // زر تسجيل الخروج
            ElevatedButton(
              onPressed: () {
                // تأكيد تسجيل الخروج
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // تنفيذ تسجيل الخروج
                            Navigator.of(context).pop();
                            // log out logic
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
