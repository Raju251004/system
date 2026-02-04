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
    extends $NotifierProvider<QuestController, List<Quest>> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Quest> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Quest>>(value),
    );
  }
}

String _$questControllerHash() => r'0f065a629ace49166c1ff72b7dc7054b59bc26cb';

abstract class _$QuestController extends $Notifier<List<Quest>> {
  List<Quest> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Quest>, List<Quest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Quest>, List<Quest>>,
              List<Quest>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
