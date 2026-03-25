import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/core/constants/api_constant.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';

void main() {
  test(
    'imageProviderFromUrl normalizes /profile/... to /storage/... and prefixes base URL',
    () {
      final provider = imageProviderFromUrl(
        '/profile/profile/3ENg0jq2M5Z42oQriWfb1lHvo2bHsoSfwgMjLL8F.jpg',
      );

      expect(provider, isNotNull);
      expect(provider, isA<NetworkImage>());

      final networkImage = provider as NetworkImage;
      expect(
        networkImage.url,
        '${ApiConstant.baseUrl.replaceFirst(RegExp(r'/api/?$'), '')}/storage/profile/3ENg0jq2M5Z42oQriWfb1lHvo2bHsoSfwgMjLL8F.jpg',
      );
    },
  );

  test('imageProviderFromUrl leaves /storage/... path intact', () {
    final provider = imageProviderFromUrl('/storage/profile/abc.jpg');
    expect(provider, isA<NetworkImage>());
    final networkImage = provider as NetworkImage;
    expect(
      networkImage.url,
      '${ApiConstant.baseUrl.replaceFirst(RegExp(r'/api/?$'), '')}/storage/profile/abc.jpg',
    );
  });
}
