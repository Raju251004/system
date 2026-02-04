// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AssessmentController)
final assessmentControllerProvider = AssessmentControllerProvider._();

final class AssessmentControllerProvider
    extends $AsyncNotifierProvider<AssessmentController, Map<String, dynamic>> {
  AssessmentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assessmentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assessmentControllerHash();

  @$internal
  @override
  AssessmentController create() => AssessmentController();
}

String _$assessmentControllerHash() =>
    r'38715a22f00c0bd45c7bad6f264c25da8f343bb5';

abstract class _$AssessmentController
    extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
