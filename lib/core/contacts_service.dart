import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsService {
  static Future<bool> requestContactsPermission() async {
    if (await FlutterContacts.requestPermission()) {
      return true;
    }
    return false;
  }

  static Future<bool> hasContactsPermission() async {
    return await FlutterContacts.requestPermission();
  }

  static Future<List<Contact>> getContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      return [];
    }

    return await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );
  }

  static Future<List<Contact>> searchContacts(String query) async {
    if (!await FlutterContacts.requestPermission()) {
      return [];
    }

    return await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    ).then((contacts) {
      return contacts.where((contact) {
        final name = contact.displayName.toLowerCase();
        final phones = contact.phones
            .map((p) => p.number)
            .join(' ')
            .toLowerCase();
        final emails = contact.emails
            .map((e) => e.address)
            .join(' ')
            .toLowerCase();

        return name.contains(query.toLowerCase()) ||
            phones.contains(query.toLowerCase()) ||
            emails.contains(query.toLowerCase());
      }).toList();
    });
  }

  static Future<Contact?> getContactById(String id) async {
    if (!await FlutterContacts.requestPermission()) {
      return null;
    }

    return await FlutterContacts.getContact(id);
  }

  static Future<List<Contact>> getContactsWithPhones() async {
    if (!await FlutterContacts.requestPermission()) {
      return [];
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );

    return contacts.where((contact) => contact.phones.isNotEmpty).toList();
  }

  static Future<List<Contact>> getContactsWithEmails() async {
    if (!await FlutterContacts.requestPermission()) {
      return [];
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );

    return contacts.where((contact) => contact.emails.isNotEmpty).toList();
  }
}
