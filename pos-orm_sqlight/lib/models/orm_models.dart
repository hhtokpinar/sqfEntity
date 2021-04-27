import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'orm_models.g.dart';

part 'orm_models.g.view.dart';

// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:sqfentity_gen/sqfentity_gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sqfentity/sqfentity.dart';
// // Define the 'Todo' constant as SqfEntityTable.
// // import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:sqfentity/sqfentity.dart';
// import 'package:sqfentity_gen/sqfentity_gen.dart';
// import '../tools/helper.dart';
// import 'view.list.dart';

// part 'orm_models.g.dart';
// part 'orm_models.g.view.dart';

const SqfEntityTable users = SqfEntityTable(
    tableName: 'users',
    primaryKeyName: 'id',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_unique,
    fields: [
      // SqfEntityField('id', DbType.integer),
      SqfEntityField('email', DbType.text),
      SqfEntityField('name', DbType.text),
      SqfEntityField('phone', DbType.text),
      SqfEntityField('password', DbType.text),
      SqfEntityField('dob', DbType.date),
      SqfEntityField('longitude', DbType.text),
      SqfEntityField('latitude', DbType.text),
      SqfEntityField('category', DbType.text),
      SqfEntityField('created_at', DbType.text),
    ]);
const SqfEntityTable transactions = SqfEntityTable(
    tableName: 'transactions',
    primaryKeyName: 'id',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_unique,
    fields: [
      // SqfEntityField('id', DbType.integer),
      SqfEntityField('customer_id', DbType.integer),
      SqfEntityField('transaction_type', DbType.text),
      SqfEntityField('phone', DbType.text),
      SqfEntityField('password', DbType.text),
      SqfEntityField('dob', DbType.date),
      SqfEntityField('longitude', DbType.text),
      SqfEntityField('latitude', DbType.text),
      SqfEntityField('category', DbType.text),
    ]);

const SqfEntityTable transactionsdetails = SqfEntityTable(
    tableName: 'transactionsdetails',
    primaryKeyName: 'id',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_unique,
    fields: [
      // SqfEntityField('id', DbType.integer),
      SqfEntityField('item_id', DbType.integer),
      SqfEntityField('quantity', DbType.integer),
      SqfEntityField('price', DbType.text),
      SqfEntityField('created_at', DbType.date),
    ]);
const SqfEntityTable collections = SqfEntityTable(
    tableName: 'collections',
    primaryKeyName: 'id',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_unique,
    fields: [
      // SqfEntityField('id', DbType.integer),
      SqfEntityField('amount', DbType.text),
      SqfEntityField('customer_id', DbType.integer),
      SqfEntityField('created_at', DbType.date),
    ]);
const SqfEntityTable customers = SqfEntityTable(
    tableName: 'customers',
    primaryKeyName: 'id',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_unique,
    fields: [
      // SqfEntityField('id', DbType.integer),
      SqfEntityField('customer_name', DbType.text),
      SqfEntityField('phone', DbType.text),
      SqfEntityField('address', DbType.text),
      SqfEntityField('created_at', DbType.date),
    ]);
const SqfEntityTable items = SqfEntityTable(
    tableName: 'items',
    primaryKeyName: 'id',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_unique,
    fields: [
      // SqfEntityField('id', DbType.integer),
      SqfEntityField('item_name', DbType.text),
      SqfEntityField('barcode', DbType.text),
      SqfEntityField('price1', DbType.text),
      SqfEntityField('price2', DbType.text),
      SqfEntityField('price3', DbType.text),
      SqfEntityField('created_at', DbType.date),
    ]);
const SqfEntityTable itemsimages = SqfEntityTable(
    tableName: 'itemsimages',
    primaryKeyName: 'id',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_unique,
    fields: [
      // SqfEntityField('id', DbType.integer),
      SqfEntityField('item_id', DbType.integer),
      SqfEntityField('image', DbType.text),
    ]);
// Define the 'identity' constant as SqfEntitySequence.
// const SqfEntitySequence seqIdentity = SqfEntitySequence(
//   sequenceName: 'identity',
//   maxValue: 90000,
// );

// STEP 3: Create your Database Model constant instanced from SqfEntityModel
// Note: SqfEntity provides support for the use of multiple databases. So you can create many Database Models and use them in the application.
@SqfEntityBuilder(myDbModel)
const SqfEntityModel myDbModel = SqfEntityModel(
  databaseName: 'POS.db',
  databaseTables: [
    users,
    transactions,
    transactionsdetails,
    collections,
    items,
    customers,
    itemsimages
  ],
  formTables: [
    users,
    transactions,
    transactionsdetails,
    collections,
    items,
    customers,
    itemsimages
  ],
);
