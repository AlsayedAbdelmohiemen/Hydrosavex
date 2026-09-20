import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Organisation Daily Reports'**
  String get reports;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Organization Code'**
  String get code;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'All Organisation Accounts'**
  String get accounts;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Organization Profile'**
  String get profile;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Organisation Manager Account'**
  String get manager;

  /// No description provided for @lifeguard_account.
  ///
  /// In en, this message translates to:
  /// **'Lifeguard Account'**
  String get lifeguard_account;

  /// No description provided for @medic_account.
  ///
  /// In en, this message translates to:
  /// **'Medic Account'**
  String get medic_account;

  /// No description provided for @lifeguard_notifications.
  ///
  /// In en, this message translates to:
  /// **'Lifeguard Notifications'**
  String get lifeguard_notifications;

  /// No description provided for @lifeguard_profile.
  ///
  /// In en, this message translates to:
  /// **'Lifeguard Profile'**
  String get lifeguard_profile;

  /// No description provided for @medic_notifications.
  ///
  /// In en, this message translates to:
  /// **'Medic Notifications'**
  String get medic_notifications;

  /// No description provided for @medic_profile.
  ///
  /// In en, this message translates to:
  /// **'Medic Profile'**
  String get medic_profile;

  /// No description provided for @generated_code.
  ///
  /// In en, this message translates to:
  /// **'Generated Code Page'**
  String get generated_code;

  /// No description provided for @generated_cod.
  ///
  /// In en, this message translates to:
  /// **'Generated Code'**
  String get generated_cod;

  /// No description provided for @the_code.
  ///
  /// In en, this message translates to:
  /// **'The Code'**
  String get the_code;

  /// No description provided for @copied_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to Clipboard'**
  String get copied_to_clipboard;

  /// No description provided for @all_lifeguards_accounts.
  ///
  /// In en, this message translates to:
  /// **'All Lifeguards Accounts'**
  String get all_lifeguards_accounts;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yes;

  /// No description provided for @confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirm_delete;

  /// No description provided for @are_you_sure_want_to_proceed.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure Want To Proceed ?'**
  String get are_you_sure_want_to_proceed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @all_medic_accounts.
  ///
  /// In en, this message translates to:
  /// **'All Medic Accounts'**
  String get all_medic_accounts;

  /// No description provided for @lifeguards.
  ///
  /// In en, this message translates to:
  /// **'Lifeguards'**
  String get lifeguards;

  /// No description provided for @medics.
  ///
  /// In en, this message translates to:
  /// **'Medics'**
  String get medics;

  /// No description provided for @profile1.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile1;

  /// No description provided for @organization_name.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get organization_name;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @drowning_alert.
  ///
  /// In en, this message translates to:
  /// **'Drowning Alert'**
  String get drowning_alert;

  /// No description provided for @subscription_status_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Subscription status updated successfully'**
  String get subscription_status_updated_successfully;

  /// No description provided for @error_activating_notifications.
  ///
  /// In en, this message translates to:
  /// **'Error activating notifications'**
  String get error_activating_notifications;

  /// No description provided for @send_a_report.
  ///
  /// In en, this message translates to:
  /// **'Send A Report'**
  String get send_a_report;

  /// No description provided for @choose_the_drowning_status.
  ///
  /// In en, this message translates to:
  /// **'choose the drowning status alert'**
  String get choose_the_drowning_status;

  /// No description provided for @enter_your_comment.
  ///
  /// In en, this message translates to:
  /// **'Please enter Your Comment'**
  String get enter_your_comment;

  /// No description provided for @choose_a_type.
  ///
  /// In en, this message translates to:
  /// **'Please choose a type'**
  String get choose_a_type;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sent_at.
  ///
  /// In en, this message translates to:
  /// **'Sent At'**
  String get sent_at;

  /// No description provided for @notification_deleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted!'**
  String get notification_deleted;

  /// No description provided for @subscription_canceled.
  ///
  /// In en, this message translates to:
  /// **'Subscription Canceled'**
  String get subscription_canceled;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status: '**
  String get status;

  /// No description provided for @lifeguard_notes.
  ///
  /// In en, this message translates to:
  /// **'Lifeguard Notes : '**
  String get lifeguard_notes;

  /// No description provided for @medic_notes.
  ///
  /// In en, this message translates to:
  /// **'Medic Notes'**
  String get medic_notes;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @report_already_added_for_this_case.
  ///
  /// In en, this message translates to:
  /// **'Report already added for this case!'**
  String get report_already_added_for_this_case;

  /// No description provided for @report_deleted.
  ///
  /// In en, this message translates to:
  /// **'Report deleted!'**
  String get report_deleted;

  /// No description provided for @the_daily_reports.
  ///
  /// In en, this message translates to:
  /// **'The Daily Reports '**
  String get the_daily_reports;

  /// No description provided for @lifeguard_report.
  ///
  /// In en, this message translates to:
  /// **'Lifeguard Report'**
  String get lifeguard_report;

  /// No description provided for @medic_report.
  ///
  /// In en, this message translates to:
  /// **'Medic Report'**
  String get medic_report;

  /// No description provided for @organisation_manager.
  ///
  /// In en, this message translates to:
  /// **'Organisation Manager'**
  String get organisation_manager;

  /// No description provided for @lifeguard.
  ///
  /// In en, this message translates to:
  /// **'Lifeguard'**
  String get lifeguard;

  /// No description provided for @medical_team_member.
  ///
  /// In en, this message translates to:
  /// **'Medical Team member'**
  String get medical_team_member;

  /// No description provided for @pooleye.
  ///
  /// In en, this message translates to:
  /// **'HydroSaveX'**
  String get pooleye;

  /// No description provided for @please_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Email'**
  String get please_enter_email;

  /// No description provided for @email_too_long.
  ///
  /// In en, this message translates to:
  /// **'Email is too long'**
  String get email_too_long;

  /// No description provided for @email_too_short.
  ///
  /// In en, this message translates to:
  /// **'Email is too short'**
  String get email_too_short;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalid_email;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Password'**
  String get please_enter_password;

  /// No description provided for @password_too_long.
  ///
  /// In en, this message translates to:
  /// **'Password is too long'**
  String get password_too_long;

  /// No description provided for @password_too_short.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get password_too_short;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @please_enter_organisation_name.
  ///
  /// In en, this message translates to:
  /// **'Please Enter The Organisation Name'**
  String get please_enter_organisation_name;

  /// No description provided for @organisation_name_too_short.
  ///
  /// In en, this message translates to:
  /// **'Organisation Name is too short'**
  String get organisation_name_too_short;

  /// No description provided for @organisation_name_too_long.
  ///
  /// In en, this message translates to:
  /// **'Organisation Name is too long'**
  String get organisation_name_too_long;

  /// No description provided for @organisation_name.
  ///
  /// In en, this message translates to:
  /// **'Organisation Name'**
  String get organisation_name;

  /// No description provided for @please_enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Username'**
  String get please_enter_username;

  /// No description provided for @username_too_short.
  ///
  /// In en, this message translates to:
  /// **'Username is too short'**
  String get username_too_short;

  /// No description provided for @username_too_long.
  ///
  /// In en, this message translates to:
  /// **'Username is too long'**
  String get username_too_long;

  /// No description provided for @username_alphabets_only.
  ///
  /// In en, this message translates to:
  /// **'Username should be alphabets only'**
  String get username_alphabets_only;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @please_enter_organisation_id.
  ///
  /// In en, this message translates to:
  /// **'Please Enter The Organisation ID'**
  String get please_enter_organisation_id;

  /// No description provided for @organisation_id_too_short.
  ///
  /// In en, this message translates to:
  /// **'Organisation ID is too short'**
  String get organisation_id_too_short;

  /// No description provided for @organisation_id_too_long.
  ///
  /// In en, this message translates to:
  /// **'Organisation ID is too long'**
  String get organisation_id_too_long;

  /// No description provided for @organisation_id.
  ///
  /// In en, this message translates to:
  /// **'Organisation ID'**
  String get organisation_id;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @organisation_name_alphabets_only.
  ///
  /// In en, this message translates to:
  /// **'Organisation Name should be alphabets only'**
  String get organisation_name_alphabets_only;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @no_account_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Haven\'t an account? Sign Up Now'**
  String get no_account_sign_up;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forget_password;

  /// No description provided for @send_reset_link.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get send_reset_link;

  /// No description provided for @reset_link_sent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent'**
  String get reset_link_sent;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_occurred;

  /// No description provided for @error_deleting_report.
  ///
  /// In en, this message translates to:
  /// **'error deleting report'**
  String get error_deleting_report;

  /// No description provided for @no_reports_available.
  ///
  /// In en, this message translates to:
  /// **'no reports available'**
  String get no_reports_available;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @home_notifications.
  ///
  /// In en, this message translates to:
  /// **'Home Notifications'**
  String get home_notifications;

  /// No description provided for @first_aid.
  ///
  /// In en, this message translates to:
  /// **'First Aid'**
  String get first_aid;

  /// No description provided for @home_profile.
  ///
  /// In en, this message translates to:
  /// **'Home Profile'**
  String get home_profile;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get show_more;

  /// No description provided for @first_aid_for_drowning.
  ///
  /// In en, this message translates to:
  /// **'First Aid for Drowning'**
  String get first_aid_for_drowning;

  /// No description provided for @rescue_breathing_for_drowning_victims_title.
  ///
  /// In en, this message translates to:
  /// **'Rescue Breathing for Drowning Victims'**
  String get rescue_breathing_for_drowning_victims_title;

  /// No description provided for @rescue_breathing_for_drowning_victims_instruction.
  ///
  /// In en, this message translates to:
  /// **'Rescue breathing is critical in drowning incidents as it helps supply oxygen to a person who has stopped breathing. Steps:\n\n1. Ensure the airway is clear by tilting the head back and lifting the chin. \n2. Pinch the nose and give two full breaths into the victim\'s mouth, watching for chest rise. \n3. Continue with one breath every 5 seconds if the person doesn’t start breathing on their own. \n4. Check for pulse and signs of life.'**
  String get rescue_breathing_for_drowning_victims_instruction;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @read_more.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get read_more;

  /// No description provided for @show_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get show_less;

  /// No description provided for @chest_compressions_in_drowning_title.
  ///
  /// In en, this message translates to:
  /// **'Chest Compressions in Drowning'**
  String get chest_compressions_in_drowning_title;

  /// No description provided for @chest_compressions_in_drowning_instruction.
  ///
  /// In en, this message translates to:
  /// **'If the drowning victim has no pulse, chest compressions must be performed to help restore blood circulation. Steps:\n\n1. Place the heel of one hand on the center of the chest, and your other hand on top of it.\n2. Press down firmly and quickly, giving at least 30 compressions at a rate of 100 to 120 compressions per minute.\n3. If you are trained, give two breaths after every 30 compressions. \n4. Continue until medical help arrives or the person starts breathing.'**
  String get chest_compressions_in_drowning_instruction;

  /// No description provided for @emergency_response_for_drowning_victims_title.
  ///
  /// In en, this message translates to:
  /// **'Emergency Response for Drowning Victims'**
  String get emergency_response_for_drowning_victims_title;

  /// No description provided for @emergency_response_for_drowning_victims_instruction.
  ///
  /// In en, this message translates to:
  /// **'Time is crucial in an emergency drowning situation. Proper response can mean the difference between life and death. Steps:\n\n1. Immediately remove the victim from the water, ensuring your own safety first.\n2. Check for breathing and pulse. \n3. If the victim is not breathing, start rescue breaths followed by chest compressions.\n4. Call emergency services immediately and continue providing care until help arrives.\n5. If the victim regains consciousness, keep them warm and calm.'**
  String get emergency_response_for_drowning_victims_instruction;

  /// No description provided for @checking_for_breathing_and_pulse_title.
  ///
  /// In en, this message translates to:
  /// **'Checking for Breathing and Pulse'**
  String get checking_for_breathing_and_pulse_title;

  /// No description provided for @checking_for_breathing_and_pulse_instruction.
  ///
  /// In en, this message translates to:
  /// **'Quickly assessing breathing and pulse is vital when attending to a drowning victim. Steps:\n\n1. Check for breathing by looking for chest movement and listening for air movement near the victim’s mouth.\n2. Feel for a pulse by placing two fingers on the neck or wrist.\n3. If no pulse or breathing is detected, immediately begin CPR with rescue breaths and chest compressions.\n4. Continue to monitor the victim for any changes in breathing or heart rate while providing care.'**
  String get checking_for_breathing_and_pulse_instruction;

  /// No description provided for @dealing_with_secondary_drowning_title.
  ///
  /// In en, this message translates to:
  /// **'Dealing with Secondary Drowning'**
  String get dealing_with_secondary_drowning_title;

  /// No description provided for @dealing_with_secondary_drowning_instruction.
  ///
  /// In en, this message translates to:
  /// **'Secondary drowning occurs when water enters the lungs and causes delayed complications, even after the initial rescue. Watch for symptoms hours after the incident. Steps:\n\n1. Look for signs of difficulty breathing, coughing, or chest pain. \n2. If the victim shows symptoms of confusion, fatigue, or breathing difficulties, seek immediate medical attention. \n3. Avoid further strenuous activities and monitor the victim closely for worsening symptoms. \n4. Call emergency services immediately if the symptoms escalate.'**
  String get dealing_with_secondary_drowning_instruction;

  /// No description provided for @preventing_drowning_in_children_title.
  ///
  /// In en, this message translates to:
  /// **'Preventing Drowning in Children'**
  String get preventing_drowning_in_children_title;

  /// No description provided for @preventing_drowning_in_children_instruction.
  ///
  /// In en, this message translates to:
  /// **'Children are at high risk of drowning, and prevention is key to avoid incidents. Safety tips:\n\n1. Never leave children unattended near water, including pools, lakes, or bathtubs. \n2. Ensure children wear proper flotation devices when in or near water. \n3. Teach children to swim at an early age and educate them on water safety rules. \n4. Install proper barriers, such as pool fences, to prevent unsupervised access to water.\n5. Always have an adult trained in CPR nearby when children are swimming.'**
  String get preventing_drowning_in_children_instruction;

  /// No description provided for @water_safety_best_practices_title.
  ///
  /// In en, this message translates to:
  /// **'Water Safety Best Practices'**
  String get water_safety_best_practices_title;

  /// No description provided for @water_safety_best_practices_instruction.
  ///
  /// In en, this message translates to:
  /// **'Practicing water safety can significantly reduce the risk of drowning. Best practices:\n\n1. Always swim with a buddy and in areas supervised by lifeguards.\n2. Avoid alcohol when swimming or supervising others in water. \n3. Learn CPR and first aid to respond quickly in case of emergencies. \n4. Use life jackets in open water, even if you are a strong swimmer. \n5. Know your limits and avoid swimming in dangerous water conditions like strong currents or deep waters.'**
  String get water_safety_best_practices_instruction;

  /// No description provided for @home_account.
  ///
  /// In en, this message translates to:
  /// **'Home Account'**
  String get home_account;

  /// No description provided for @create_member.
  ///
  /// In en, this message translates to:
  /// **'Create Member'**
  String get create_member;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @choose_theme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get choose_theme;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @no_account.
  ///
  /// In en, this message translates to:
  /// **'Didn’t have an account ?  '**
  String get no_account;

  /// No description provided for @organisation_name_length.
  ///
  /// In en, this message translates to:
  /// **'Organisation name must be between 3 and 18 characters'**
  String get organisation_name_length;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @please_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get please_confirm_password;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @confirm_your_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Password'**
  String get confirm_your_password;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account ?  '**
  String get already_have_account;

  /// No description provided for @job.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get job;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @title_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to HydroSaveX !'**
  String get title_welcome;

  /// No description provided for @subtitle_welcome.
  ///
  /// In en, this message translates to:
  /// **'Your pool\'s ultimate companion.'**
  String get subtitle_welcome;

  /// No description provided for @title_safety.
  ///
  /// In en, this message translates to:
  /// **'Safety and Security'**
  String get title_safety;

  /// No description provided for @subtitle_safety.
  ///
  /// In en, this message translates to:
  /// **'HydroSaveX ensures a safe swimming environment for everyone.'**
  String get subtitle_safety;

  /// No description provided for @title_control.
  ///
  /// In en, this message translates to:
  /// **'Intuitive Control'**
  String get title_control;

  /// No description provided for @subtitle_control.
  ///
  /// In en, this message translates to:
  /// **'Manage your pool effortlessly with our user-friendly app.'**
  String get subtitle_control;

  /// No description provided for @forgot_password1.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password ?'**
  String get forgot_password1;

  /// No description provided for @enter_email_verification.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address to receive a verification code'**
  String get enter_email_verification;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @edit_image.
  ///
  /// In en, this message translates to:
  /// **'Edit Image'**
  String get edit_image;

  /// No description provided for @edit_name.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get edit_name;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @error_occurred2.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get error_occurred2;

  /// No description provided for @report_already_added.
  ///
  /// In en, this message translates to:
  /// **'Report already added for this case!'**
  String get report_already_added;

  /// No description provided for @error_deleting_notification.
  ///
  /// In en, this message translates to:
  /// **'Error deleting notification: '**
  String get error_deleting_notification;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
