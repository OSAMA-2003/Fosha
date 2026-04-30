import 'package:flutter_test/flutter_test.dart';

import 'package:fosha_shared/fosha_shared.dart';

void main() {
  test('ArabicIndic.digits converts ASCII digits', () {
    expect(ArabicIndic.digits('0123456789'), '٠١٢٣٤٥٦٧٨٩');
    expect(ArabicIndic.digits('سعر 10 ج.م'), 'سعر ١٠ ج.م');
  });
}
