import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart'; // AppColors, AppFonts
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_button.dart';

class ContactSelectionProvider extends ChangeNotifier {
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  List<Contact> _selectedContacts = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _permissionDenied = false;

  List<Contact> get contacts => _filteredContacts;
  List<Contact> get selectedContacts => _selectedContacts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get permissionDenied => _permissionDenied;

  Future<void> loadContacts() async {
    _isLoading = true;
    _errorMessage = null;
    _permissionDenied = false;
    notifyListeners();

    try {
      if (!await FlutterContacts.requestPermission()) {
        _permissionDenied = true;
        _errorMessage = 'تم رفض الإذن للوصول إلى جهات الاتصال';
        _isLoading = false;
        notifyListeners();
        return;
      }
      _permissionDenied = false;
      _allContacts = await FlutterContacts.getContacts(withProperties: true);
      _filteredContacts = List.from(_allContacts);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تحميل جهات الاتصال';
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchContacts(String query) {
    if (query.isEmpty) {
      _filteredContacts = List.from(_allContacts);
    } else {
      _filteredContacts = _allContacts.where((contact) {
        final name = contact.displayName.toLowerCase();
        final phone = contact.phones.isNotEmpty
            ? contact.phones.first.number
            : '';
        return name.contains(query.toLowerCase()) || phone.contains(query);
      }).toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _filteredContacts = List.from(_allContacts);
    notifyListeners();
  }

  void toggleContactSelection(Contact contact) {
    if (_selectedContacts.contains(contact)) {
      _selectedContacts.remove(contact);
    } else {
      _selectedContacts.add(contact);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedContacts.clear();
    notifyListeners();
  }
}

class SelectAttendeesScreen extends StatelessWidget {
  const SelectAttendeesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactSelectionProvider()..loadContacts(),
      child: const _SelectAttendeesContent(),
    );
  }
}

class _SelectAttendeesContent extends StatelessWidget {
  const _SelectAttendeesContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          ),
          elevation: 0,
          title: Text(
            'اختيار الحضور',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: AppFonts.header,
              shadows: [Shadow(color: Colors.black26, blurRadius: 6)],
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Consumer<ContactSelectionProvider>(
              builder: (context, provider, child) {
                if (provider.selectedContacts.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Text(
                        '${provider.selectedContacts.length} مختار',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: const _BodyContent(),
        floatingActionButton: Consumer<ContactSelectionProvider>(
          builder: (context, provider, _) {
            if (provider.selectedContacts.isEmpty)
              return const SizedBox.shrink();
            return FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pop(context, provider.selectedContacts),
              backgroundColor: AppColors.primary,
              label: const Text(
                "تأكيد الاختيار",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.check),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _BodyContent extends StatefulWidget {
  const _BodyContent({Key? key}) : super(key: key);

  @override
  State<_BodyContent> createState() => _BodyContentState();
}

class _BodyContentState extends State<_BodyContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactSelectionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingState();
        } else if (provider.errorMessage != null) {
          return _buildError(provider, context);
        } else if (provider.contacts.isEmpty) {
          return _buildEmpty(provider);
        }
        return _buildContactList(provider, context);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: ShimmerWidget.circle(width: 48, height: 48),
            title: ShimmerWidget.rect(width: 120, height: 16),
            subtitle: ShimmerWidget.rect(width: 100, height: 12),
          ),
        );
      },
    );
  }

  Widget _buildError(ContactSelectionProvider provider, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 56,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              provider.errorMessage!,
              style: const TextStyle(
                fontSize: 17,
                color: AppColors.text,
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            CustomButton(
              label: provider.permissionDenied
                  ? 'فتح الإعدادات'
                  : 'إعادة المحاولة',
              icon: provider.permissionDenied ? Icons.settings : Icons.refresh,
              onPressed: () {
                if (provider.permissionDenied) {
                  openAppSettings();
                } else {
                  provider.loadContacts();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(ContactSelectionProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.contact_page_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لم يتم العثور على جهات اتصال',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: AppFonts.header,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'يرجى إضافة جهات اتصال في هاتفك أو منح التطبيق الإذن للوصول إليها.',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
                fontFamily: AppFonts.body,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            CustomButton(
              label: 'إعادة المحاولة',
              icon: Icons.refresh,
              onPressed: provider.loadContacts,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactList(
    ContactSelectionProvider provider,
    BuildContext context,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: CustomTextField(
            hint: "ابحث بالاسم أو الرقم...",
            controller: _searchController,
            prefixIcon: Icons.search,
            onChanged: provider.searchContacts,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: provider.contacts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final contact = provider.contacts[index];
              final isSelected = provider.selectedContacts.contains(contact);

              return AnimatedScale(
                scale: isSelected ? 1.03 : 1.0,
                duration: const Duration(milliseconds: 170),
                curve: Curves.easeInOut,
                child: Material(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  elevation: isSelected ? 3 : 1,
                  shadowColor: Colors.black.withOpacity(0.06),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.avatarBg,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: contact.photoOrThumbnail != null
                          ? ClipOval(
                              child: Image.memory(
                                contact.photoOrThumbnail!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                contact.displayName.isNotEmpty
                                    ? contact.displayName[0]
                                    : '?',
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.text,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: AppFonts.header,
                                ),
                              ),
                            ),
                    ),
                    title: Text(
                      contact.displayName.isNotEmpty
                          ? contact.displayName
                          : 'لا يوجد اسم',
                      style: TextStyle(
                        fontFamily: AppFonts.header,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    subtitle: Text(
                      contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : 'لا يوجد رقم',
                      style: TextStyle(
                        fontFamily: AppFonts.body,
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () => provider.toggleContactSelection(contact),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    onTap: () => provider.toggleContactSelection(contact),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Consumer<ContactSelectionProvider>(
          builder: (context, provider, _) {
            if (provider.selectedContacts.isEmpty)
              return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 90.0),
              child: CustomButton(
                label: "إلغاء تحديد الكل",
                icon: Icons.clear_all,
                onPressed: provider.clearSelection,
              ),
            );
          },
        ),
      ],
    );
  }
}

// Simple shimmer effect for loading skeleton
class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;
  const ShimmerWidget.rect({
    required this.width,
    required this.height,
    Key? key,
  }) : isCircle = false,
       super(key: key);

  const ShimmerWidget.circle({
    required double width,
    required double height,
    Key? key,
  }) : width = width,
       height = height,
       isCircle = true,
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(8),
      ),
    );
  }
}
