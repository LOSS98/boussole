/// Static information about the app and its publisher.
abstract final class AppInfo {
  static const name = 'Boussole';
  static const version = '1.0.0';
  static const developer = 'Khalil MZOUGHI';
  static const school = 'INSA Hauts-de-France';
  static const programme =
      'Engineering degree in Computer Science and Cybersecurity';
  static const schoolContext =
      'Boussole is a school project, carried out in the final year of the '
      '$programme at $school.';
  static const authorNotice =
      'This app reflects what its developer understood. It is based on his '
      'personal experience and research, and may contain simplifications or '
      'mistakes. Please keep this in mind when using it.';

  static const copyright = '© 2026 Khalil MZOUGHI. All rights reserved.';

  /// Contact address shown in the legal documents. Fill it in before
  /// publishing the app; the contact line is hidden while it is empty.
  static const contactEmail = '';
}
