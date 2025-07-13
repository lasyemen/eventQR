import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../core/contacts_service.dart';
import '../core/constants.dart';

class ContactsPicker extends StatefulWidget {
  final Function(List<Contact>) onContactsSelected;
  final List<Contact>? initialSelectedContacts;
  final bool allowMultiple;

  const ContactsPicker({
    Key? key,
    required this.onContactsSelected,
    this.initialSelectedContacts,
    this.allowMultiple = true,
  }) : super(key: key);

  @override
  State<ContactsPicker> createState() => _ContactsPickerState();
}

class _ContactsPickerState extends State<ContactsPicker> {
  List<Contact> _contacts = [];
  List<Contact> _selectedContacts = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedContacts = widget.initialSelectedContacts ?? [];
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);

    try {
      final contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تحميل جهات الاتصال: $e')));
    }
  }

  List<Contact> get _filteredContacts {
    if (_searchQuery.isEmpty) return _contacts;

    return _contacts.where((contact) {
      final name = contact.displayName.toLowerCase();
      final phones = contact.phones
          .map((p) => p.number)
          .join(' ')
          .toLowerCase();
      final emails = contact.emails
          .map((e) => e.address)
          .join(' ')
          .toLowerCase();

      return name.contains(_searchQuery.toLowerCase()) ||
          phones.contains(_searchQuery.toLowerCase()) ||
          emails.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _toggleContactSelection(Contact contact) {
    setState(() {
      if (_selectedContacts.contains(contact)) {
        _selectedContacts.remove(contact);
      } else {
        if (widget.allowMultiple) {
          _selectedContacts.add(contact);
        } else {
          _selectedContacts = [contact];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر جهات الاتصال'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          if (_selectedContacts.isNotEmpty)
            TextButton(
              onPressed: () {
                widget.onContactsSelected(_selectedContacts);
                Navigator.pop(context);
              },
              child: Text(
                'تم (${_selectedContacts.length})',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'ابحث في جهات الاتصال...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Contacts list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredContacts.isEmpty
                ? const Center(child: Text('لا توجد جهات اتصال'))
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      final isSelected = _selectedContacts.contains(contact);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : Colors.grey[300],
                          child: contact.photo != null
                              ? ClipOval(
                                  child: Image.memory(
                                    contact.photo!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  contact.displayName.isNotEmpty
                                      ? contact.displayName[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        title: Text(
                          contact.displayName,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: contact.phones.isNotEmpty
                            ? Text(contact.phones.first.number)
                            : contact.emails.isNotEmpty
                            ? Text(contact.emails.first.address)
                            : null,
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                              )
                            : null,
                        onTap: () => _toggleContactSelection(contact),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
