// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ashirah`
  String get appTitle {
    return Intl.message(
      'Ashirah',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Don't leave the field blank`
  String get validatorField {
    return Intl.message(
      'Don\'t leave the field blank',
      name: 'validatorField',
      desc: '',
      args: [],
    );
  }

  /// `Don't leave the field blank or leave your gender selection`
  String get validatorFieldAndGender {
    return Intl.message(
      'Don\'t leave the field blank or leave your gender selection',
      name: 'validatorFieldAndGender',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Not a member?`
  String get notMember {
    return Intl.message(
      'Not a member?',
      name: 'notMember',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account`
  String get createNewAccount {
    return Intl.message(
      'Create a new account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get lastname {
    return Intl.message(
      'Last name',
      name: 'lastname',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get birthdate {
    return Intl.message(
      'Date of birth',
      name: 'birthdate',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Password again`
  String get confirmPassword {
    return Intl.message(
      'Password again',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `have an account?`
  String get haveAccount {
    return Intl.message(
      'have an account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Password doesn't match`
  String get passwordNotMatch {
    return Intl.message(
      'Password doesn\'t match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Enter the email you registered with to change your password`
  String get changePassword {
    return Intl.message(
      'Enter the email you registered with to change your password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Verify Email`
  String get verifyEmail {
    return Intl.message(
      'Verify Email',
      name: 'verifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get errorOccurred {
    return Intl.message(
      'An error occurred',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get userNotFound {
    return Intl.message(
      'User not found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get wrongPassword {
    return Intl.message(
      'Wrong password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `There is a problem while registering with this email`
  String get userDisabled {
    return Intl.message(
      'There is a problem while registering with this email',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `This email address is already registered`
  String get emailAlreadyInUse {
    return Intl.message(
      'This email address is already registered',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `The password is not strong`
  String get weakPassword {
    return Intl.message(
      'The password is not strong',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `We have sent you a link to change your password, check your email`
  String get changePasswordMessage {
    return Intl.message(
      'We have sent you a link to change your password, check your email',
      name: 'changePasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `Restore Account`
  String get accountRecovery {
    return Intl.message(
      'Restore Account',
      name: 'accountRecovery',
      desc: '',
      args: [],
    );
  }

  /// `You have recently disabled your account`
  String get accountDisable {
    return Intl.message(
      'You have recently disabled your account',
      name: 'accountDisable',
      desc: '',
      args: [],
    );
  }

  /// `If you want to recover your account, click on Restore Account`
  String get restoreAccount {
    return Intl.message(
      'If you want to recover your account, click on Restore Account',
      name: 'restoreAccount',
      desc: '',
      args: [],
    );
  }

  /// `Signout`
  String get signout {
    return Intl.message(
      'Signout',
      name: 'signout',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message(
      'Messages',
      name: 'messages',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to signout?`
  String get wantSignout {
    return Intl.message(
      'Do you want to signout?',
      name: 'wantSignout',
      desc: '',
      args: [],
    );
  }

  /// `No network connection`
  String get noNetwork {
    return Intl.message(
      'No network connection',
      name: 'noNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Check your network connection, then refresh the page`
  String get checkNetwork {
    return Intl.message(
      'Check your network connection, then refresh the page',
      name: 'checkNetwork',
      desc: '',
      args: [],
    );
  }

  /// `There is no bio..`
  String get noBio {
    return Intl.message(
      'There is no bio..',
      name: 'noBio',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message(
      'Photos',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Account settings`
  String get accountSettings {
    return Intl.message(
      'Account settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `My posts`
  String get myPosts {
    return Intl.message(
      'My posts',
      name: 'myPosts',
      desc: '',
      args: [],
    );
  }

  /// `Channels`
  String get channels {
    return Intl.message(
      'Channels',
      name: 'channels',
      desc: '',
      args: [],
    );
  }

  /// `Pages`
  String get pages {
    return Intl.message(
      'Pages',
      name: 'pages',
      desc: '',
      args: [],
    );
  }

  /// `Groups`
  String get groups {
    return Intl.message(
      'Groups',
      name: 'groups',
      desc: '',
      args: [],
    );
  }

  /// `Market`
  String get market {
    return Intl.message(
      'Market',
      name: 'market',
      desc: '',
      args: [],
    );
  }

  /// `Sciences`
  String get sciences {
    return Intl.message(
      'Sciences',
      name: 'sciences',
      desc: '',
      args: [],
    );
  }

  /// `Jobs`
  String get jobs {
    return Intl.message(
      'Jobs',
      name: 'jobs',
      desc: '',
      args: [],
    );
  }

  /// `Advertisements`
  String get ads {
    return Intl.message(
      'Advertisements',
      name: 'ads',
      desc: '',
      args: [],
    );
  }

  /// `Videos`
  String get videos {
    return Intl.message(
      'Videos',
      name: 'videos',
      desc: '',
      args: [],
    );
  }

  /// `Saved items`
  String get savedItems {
    return Intl.message(
      'Saved items',
      name: 'savedItems',
      desc: '',
      args: [],
    );
  }

  /// `View your account`
  String get viewAccount {
    return Intl.message(
      'View your account',
      name: 'viewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Change Personal Image`
  String get changePersonalImage {
    return Intl.message(
      'Change Personal Image',
      name: 'changePersonalImage',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `There are no posts`
  String get noPosts {
    return Intl.message(
      'There are no posts',
      name: 'noPosts',
      desc: '',
      args: [],
    );
  }

  /// `Modifications are being made`
  String get loadingModifications {
    return Intl.message(
      'Modifications are being made',
      name: 'loadingModifications',
      desc: '',
      args: [],
    );
  }

  /// `The modifications have been saved`
  String get saveModifications {
    return Intl.message(
      'The modifications have been saved',
      name: 'saveModifications',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Personal Data`
  String get personalData {
    return Intl.message(
      'Personal Data',
      name: 'personalData',
      desc: '',
      args: [],
    );
  }

  /// `E.G.`
  String get forExpample {
    return Intl.message(
      'E.G.',
      name: 'forExpample',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get nickName {
    return Intl.message(
      'Nickname',
      name: 'nickName',
      desc: '',
      args: [],
    );
  }

  /// `What do you like people to call you`
  String get callYou {
    return Intl.message(
      'What do you like people to call you',
      name: 'callYou',
      desc: '',
      args: [],
    );
  }

  /// `?`
  String get question {
    return Intl.message(
      '?',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `,`
  String get comma {
    return Intl.message(
      ',',
      name: 'comma',
      desc: '',
      args: [],
    );
  }

  /// `Tell your visitors about yourself`
  String get aboutYourself {
    return Intl.message(
      'Tell your visitors about yourself',
      name: 'aboutYourself',
      desc: '',
      args: [],
    );
  }

  /// `Marital Status`
  String get maritalStatus {
    return Intl.message(
      'Marital Status',
      name: 'maritalStatus',
      desc: '',
      args: [],
    );
  }

  /// `Single`
  String get single {
    return Intl.message(
      'Single',
      name: 'single',
      desc: '',
      args: [],
    );
  }

  /// `Engaged`
  String get engaged {
    return Intl.message(
      'Engaged',
      name: 'engaged',
      desc: '',
      args: [],
    );
  }

  /// `Married`
  String get married {
    return Intl.message(
      'Married',
      name: 'married',
      desc: '',
      args: [],
    );
  }

  /// `Absolute`
  String get absolute {
    return Intl.message(
      'Absolute',
      name: 'absolute',
      desc: '',
      args: [],
    );
  }

  /// `Widower`
  String get widower {
    return Intl.message(
      'Widower',
      name: 'widower',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePasswordButton {
    return Intl.message(
      'Change password',
      name: 'changePasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `Account Verification`
  String get accountVerification {
    return Intl.message(
      'Account Verification',
      name: 'accountVerification',
      desc: '',
      args: [],
    );
  }

  /// `Cancel account verification`
  String get cancelAccountVerification {
    return Intl.message(
      'Cancel account verification',
      name: 'cancelAccountVerification',
      desc: '',
      args: [],
    );
  }

  /// `Disable account`
  String get disableAccount {
    return Intl.message(
      'Disable account',
      name: 'disableAccount',
      desc: '',
      args: [],
    );
  }

  /// `The account has been disabled.`
  String get disableAccountDone {
    return Intl.message(
      'The account has been disabled.',
      name: 'disableAccountDone',
      desc: '',
      args: [],
    );
  }

  /// `Note: After 60 days, the account will be permanently deleted`
  String get after60Days {
    return Intl.message(
      'Note: After 60 days, the account will be permanently deleted',
      name: 'after60Days',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get dateJoin {
    return Intl.message(
      'Join',
      name: 'dateJoin',
      desc: '',
      args: [],
    );
  }

  /// `There are no photos`
  String get noPhotos {
    return Intl.message(
      'There are no photos',
      name: 'noPhotos',
      desc: '',
      args: [],
    );
  }

  /// `New post`
  String get newPost {
    return Intl.message(
      'New post',
      name: 'newPost',
      desc: '',
      args: [],
    );
  }

  /// `Adding post`
  String get loadingPost {
    return Intl.message(
      'Adding post',
      name: 'loadingPost',
      desc: '',
      args: [],
    );
  }

  /// `Published`
  String get sharePost {
    return Intl.message(
      'Published',
      name: 'sharePost',
      desc: '',
      args: [],
    );
  }

  /// `You cannot share an empty post`
  String get emptyPost {
    return Intl.message(
      'You cannot share an empty post',
      name: 'emptyPost',
      desc: '',
      args: [],
    );
  }

  /// `What's on your mind`
  String get yourMind {
    return Intl.message(
      'What\'s on your mind',
      name: 'yourMind',
      desc: '',
      args: [],
    );
  }

  /// `Add Image`
  String get addImage {
    return Intl.message(
      'Add Image',
      name: 'addImage',
      desc: '',
      args: [],
    );
  }

  /// `Show more`
  String get showMore {
    return Intl.message(
      'Show more',
      name: 'showMore',
      desc: '',
      args: [],
    );
  }

  /// `Write a comment...`
  String get writeComment {
    return Intl.message(
      'Write a comment...',
      name: 'writeComment',
      desc: '',
      args: [],
    );
  }

  /// `Choose a language`
  String get chooseLanguage {
    return Intl.message(
      'Choose a language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message(
      'Likes',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `There are no likes`
  String get noLikes {
    return Intl.message(
      'There are no likes',
      name: 'noLikes',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Shares`
  String get shares {
    return Intl.message(
      'Shares',
      name: 'shares',
      desc: '',
      args: [],
    );
  }

  /// `Modify`
  String get modify {
    return Intl.message(
      'Modify',
      name: 'modify',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Modify post`
  String get modifyPost {
    return Intl.message(
      'Modify post',
      name: 'modifyPost',
      desc: '',
      args: [],
    );
  }

  /// `Delete post`
  String get deletePost {
    return Intl.message(
      'Delete post',
      name: 'deletePost',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the post?`
  String get deletePostContent {
    return Intl.message(
      'Are you sure you want to delete the post?',
      name: 'deletePostContent',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get oldPassword {
    return Intl.message(
      'Old password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm new password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `The old password matches the new password.`
  String get newPasswordMatchOldPassword {
    return Intl.message(
      'The old password matches the new password.',
      name: 'newPasswordMatchOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please choose another password!`
  String get chooseAnotherPassword {
    return Intl.message(
      'Please choose another password!',
      name: 'chooseAnotherPassword',
      desc: '',
      args: [],
    );
  }

  /// `The new password does not match`
  String get newPasswordNotMatch {
    return Intl.message(
      'The new password does not match',
      name: 'newPasswordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to deactivate your account?`
  String get confirmDisableAccount {
    return Intl.message(
      'Are you sure you want to deactivate your account?',
      name: 'confirmDisableAccount',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get shareNow {
    return Intl.message(
      'Share',
      name: 'shareNow',
      desc: '',
      args: [],
    );
  }

  /// `Verified account`
  String get verified {
    return Intl.message(
      'Verified account',
      name: 'verified',
      desc: '',
      args: [],
    );
  }

  /// `Account ownership for this user has been verified through trusted personal documents.`
  String get verifiedAccount {
    return Intl.message(
      'Account ownership for this user has been verified through trusted personal documents.',
      name: 'verifiedAccount',
      desc: '',
      args: [],
    );
  }

  /// `Neglecting editing`
  String get neglectingEditing {
    return Intl.message(
      'Neglecting editing',
      name: 'neglectingEditing',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to leave and ignore the edit?`
  String get ignoreEdit {
    return Intl.message(
      'Are you sure you want to leave and ignore the edit?',
      name: 'ignoreEdit',
      desc: '',
      args: [],
    );
  }

  /// `Neglecting`
  String get neglecting {
    return Intl.message(
      'Neglecting',
      name: 'neglecting',
      desc: '',
      args: [],
    );
  }

  /// `There are no comments`
  String get noComments {
    return Intl.message(
      'There are no comments',
      name: 'noComments',
      desc: '',
      args: [],
    );
  }

  /// `Delete comment`
  String get deleteComment {
    return Intl.message(
      'Delete comment',
      name: 'deleteComment',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the comment?`
  String get confirmDeleteComment {
    return Intl.message(
      'Are you sure you want to delete the comment?',
      name: 'confirmDeleteComment',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `We sent you a verification link to the email you provided`
  String get verifyEmailAddress {
    return Intl.message(
      'We sent you a verification link to the email you provided',
      name: 'verifyEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `The password has been changed successfully`
  String get changedPassword {
    return Intl.message(
      'The password has been changed successfully',
      name: 'changedPassword',
      desc: '',
      args: [],
    );
  }

  /// `The current password is incorrect`
  String get incorrectPassword {
    return Intl.message(
      'The current password is incorrect',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while changing the password`
  String get errorChangePassword {
    return Intl.message(
      'An error occurred while changing the password',
      name: 'errorChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `We have not yet verified your email address`
  String get notVerifiedEmail {
    return Intl.message(
      'We have not yet verified your email address',
      name: 'notVerifiedEmail',
      desc: '',
      args: [],
    );
  }

  /// `If you have done this step before, ignore performing this procedure, as it takes some time for the confirmation process to complete`
  String get doneVerifyStep {
    return Intl.message(
      'If you have done this step before, ignore performing this procedure, as it takes some time for the confirmation process to complete',
      name: 'doneVerifyStep',
      desc: '',
      args: [],
    );
  }

  /// `It has been confirmed that you have this email`
  String get doneVerified {
    return Intl.message(
      'It has been confirmed that you have this email',
      name: 'doneVerified',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get like {
    return Intl.message(
      'Like',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `Dis like`
  String get disLike {
    return Intl.message(
      'Dis like',
      name: 'disLike',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Beta`
  String get beta {
    return Intl.message(
      'Beta',
      name: 'beta',
      desc: '',
      args: [],
    );
  }

  /// `Loading the image`
  String get loadingImage {
    return Intl.message(
      'Loading the image',
      name: 'loadingImage',
      desc: '',
      args: [],
    );
  }

  /// `There was a problem loading the image`
  String get errorLoadingImage {
    return Intl.message(
      'There was a problem loading the image',
      name: 'errorLoadingImage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
