// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Configuration for using `package:build`-compatible build systems.
///
/// See:
/// * [build_runner](https://pub.dev/packages/build_runner)
///
/// This library is **not** intended to be imported by typical end-users unless
/// you are creating a custom compilation pipeline. See documentation for
/// details, and `build.yaml` for how these builders are configured by default.
library sqfentity_gen.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sqfentity_gen/src/sqfentity_formgenerator.dart';
import 'package:sqfentity_gen/src/sqfentity_generator.dart';

Builder sqfentityBuilder(BuilderOptions options) =>
    SharedPartBuilder([SqfEntityGenerator()], 'sqfentity');

Builder sqfentityFormBuilder(BuilderOptions options) =>
    LibraryBuilder(SqfEntityFormGenerator(),
        generatedExtension: '.g.view.dart');

Builder sqfentityFormBuilderTest(BuilderOptions options) =>
    LibraryBuilder(SqfEntityFormGenerator(),
        generatedExtension: '.t1.view.dart');
