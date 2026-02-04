// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuestController)
final questControllerProvider = QuestControllerProvider._();

final class QuestControllerProvider
    extends $AsyncNotifierProvider<QuestController, List<Quest>> {
  QuestControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questControllerHash();

  @$internal
  @override
  QuestController create() => QuestController();
}

String _$questControllerHash() => r'325cf3a283d971ac04be1c8d1ca318a4ca8d18e1';

abstract class _$QuestController extends $AsyncNotifier<List<Quest>> {
  FutureOr<List<Quest>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Quest>>, List<Quest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Quest>>, List<Quest>>,
              AsyncValue<List<Quest>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
