import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/project/data/models/project_model.dart';

void main() {
  test('ProjectModel.fromJson uses name when present', () {
    final json = {'id': 1, 'name': 'Alpha'};
    final model = ProjectModel.fromJson(json);
    expect(model.name, 'Alpha');
  });

  test('ProjectModel.fromJson falls back to title', () {
    final json = {'id': 2, 'title': 'Beta Project'};
    final model = ProjectModel.fromJson(json);
    expect(model.name, 'Beta Project');
  });

  test('ProjectModel.fromJson accepts project_name', () {
    final json = {'id': 3, 'project_name': 'Gamma'};
    final model = ProjectModel.fromJson(json);
    expect(model.name, 'Gamma');
  });

  test('ProjectModel.fromJson normalizes numeric name to string', () {
    final json = {'id': 4, 'name': 123};
    final model = ProjectModel.fromJson(json);
    expect(model.name, '123');
  });
}
