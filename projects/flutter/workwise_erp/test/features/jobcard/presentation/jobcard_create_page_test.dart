import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise_erp/features/jobcard/presentation/pages/jobcard_create_page.dart';
import 'package:workwise_erp/core/provider/dio_provider.dart';

class _FakePicker extends FilePickerPlatform {
  final List<PlatformFile>? filesToReturn;
  _FakePicker(this.filesToReturn);

  @override
  Future<FilePickerResult?> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    int? dialogTitle,
  }) async {
    if (filesToReturn == null) return null;
    return FilePickerResult(filesToReturn!);
  }
}

void main() {
  setUp(() {
    // reset platform to default before each test
    FilePicker.platform = MethodChannelFilePicker();
  });

  testWidgets('Save draft stores draft to SharedPreferences', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(Response(requestOptions: options, data: []));
        },
      ),
    );

    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: JobcardCreatePage()),
      ),
    );
    await tester.pumpAndSettle();

    // verify dropdown styling propagation by inspecting Related To input decorator
    final decoratorFinder = find.byWidgetPredicate(
      (w) => w is InputDecorator && w.decoration?.labelText == 'Related To',
    );
    expect(decoratorFinder, findsOneWidget);
    final decorator = tester.widget<InputDecorator>(decoratorFinder.first);
    expect(decorator.decoration?.fillColor, isNotNull);

    final subjectField = find.byWidgetPredicate(
      (w) => w is TextField && (w.decoration?.labelText ?? '') == 'Subject',
    );
    expect(subjectField, findsOneWidget);
    await tester.enterText(subjectField, 'Draft subject');
    await tester.pumpAndSettle();

    final saveIcon = find.byTooltip('Save draft');
    expect(saveIcon, findsOneWidget);
    await tester.tap(saveIcon);
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('jobcard_create_draft_v1');
    expect(s, isNotNull);
    expect(s!, contains('Draft subject'));
  });

  testWidgets('Picking item file (<=5MB) shows file in UI', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(Response(requestOptions: options, data: []));
        },
      ),
    );
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );

    // Fake picker returns one small file
    FilePicker.platform = _FakePicker([
      PlatformFile(name: 'small.png', size: 1024 * 100, path: '/tmp/small.png'),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: JobcardCreatePage()),
      ),
    );
    await tester.pumpAndSettle();

    // Tap the item attachments attach icon
    final itemAttach = find.byIcon(Icons.attach_file_outlined);
    expect(itemAttach, findsOneWidget);
    await tester.tap(itemAttach);
    await tester.pumpAndSettle();

    // The file name should appear in the Item attachments tile subtitle
    expect(find.textContaining('small.png'), findsWidgets);
  });

  testWidgets(
    'Picking oversized item file (>5MB) shows snackbar and does not add file',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(Response(requestOptions: options, data: []));
          },
        ),
      );
      final container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      // Fake picker returns one large file (6MB)
      FilePicker.platform = _FakePicker([
        PlatformFile(
          name: 'big.mov',
          size: 6 * 1024 * 1024,
          path: '/tmp/big.mov',
        ),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: JobcardCreatePage()),
        ),
      );
      await tester.pumpAndSettle();

      final itemAttach = find.byIcon(Icons.attach_file_outlined);
      expect(itemAttach, findsOneWidget);
      await tester.tap(itemAttach);
      await tester.pumpAndSettle();

      // Oversize message shown via SnackBar
      expect(find.textContaining('exceeds 5MB limit'), findsOneWidget);

      // File should NOT appear in the UI
      expect(find.textContaining('big.mov'), findsNothing);
    },
  );
}
