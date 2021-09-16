import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import '../tools/helper.dart';
import 'view.list.dart';

part 'chinook.g.dart';
part 'chinook.g.view.dart';

//  BEGIN chinook.db MODEL

// BEGIN TABLES

const tableAlbum = SqfEntityTable(
    tableName: 'Album',
    primaryKeyName: 'AlbumId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('Title', DbType.text),
      SqfEntityFieldRelationship(
          parentTable: tableArtist,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'ArtistId',
          isPrimaryKeyField: false),
    ]);

const tableArtist = SqfEntityTable(
    tableName: 'Artist',
    primaryKeyName: 'ArtistId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('Name', DbType.text),
    ]);

const tableCustomer = SqfEntityTable(
    tableName: 'Customer',
    primaryKeyName: 'CustomerId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('FirstName', DbType.text),
      SqfEntityField('LastName', DbType.text),
      SqfEntityField('Company', DbType.text),
      SqfEntityField('Address', DbType.text),
      SqfEntityField('City', DbType.text),
      SqfEntityField('State', DbType.text),
      SqfEntityField('Country', DbType.text),
      SqfEntityField('PostalCode', DbType.text),
      SqfEntityField('Phone', DbType.text),
      SqfEntityField('Fax', DbType.text),
      SqfEntityField('Email', DbType.text),
      SqfEntityFieldRelationship(
          parentTable: tableEmployee,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'SupportRepId',
          isPrimaryKeyField: false),
    ]);

const tableEmployee = SqfEntityTable(
    tableName: 'Employee',
    primaryKeyName: 'EmployeeId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('LastName', DbType.text),
      SqfEntityField('FirstName', DbType.text),
      SqfEntityField('Title', DbType.text),
      SqfEntityField('BirthDate', DbType.datetime),
      SqfEntityField('HireDate', DbType.datetime),
      SqfEntityField('Address', DbType.text),
      SqfEntityField('City', DbType.text),
      SqfEntityField('State', DbType.text),
      SqfEntityField('Country', DbType.text),
      SqfEntityField('PostalCode', DbType.text),
      SqfEntityField('Phone', DbType.text),
      SqfEntityField('Fax', DbType.text),
      SqfEntityField('Email', DbType.text),
      SqfEntityFieldRelationship(
          parentTable: null,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'ReportsTo',
          isPrimaryKeyField: false),
    ]);

const tableGenre = SqfEntityTable(
    tableName: 'Genre',
    primaryKeyName: 'GenreId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('Name', DbType.text),
    ]);

const tableInvoice = SqfEntityTable(
    tableName: 'Invoice',
    primaryKeyName: 'InvoiceId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('InvoiceDate', DbType.datetime),
      SqfEntityField('BillingAddress', DbType.text),
      SqfEntityField('BillingCity', DbType.text),
      SqfEntityField('BillingState', DbType.text),
      SqfEntityField('BillingCountry', DbType.text),
      SqfEntityField('BillingPostalCode', DbType.text),
      SqfEntityField('Total', DbType.real),
      SqfEntityFieldRelationship(
          parentTable: tableCustomer,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'CustomerId',
          isPrimaryKeyField: false),
    ]);

const tableInvoiceLine = SqfEntityTable(
    tableName: 'InvoiceLine',
    primaryKeyName: 'InvoiceLineId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('UnitPrice', DbType.real),
      SqfEntityField('Quantity', DbType.integer),
      SqfEntityFieldRelationship(
          parentTable: tableTrack,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'TrackId',
          isPrimaryKeyField: false),
      SqfEntityFieldRelationship(
          parentTable: tableInvoice,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'InvoiceId',
          isPrimaryKeyField: false),
    ]);

const tableMediaType = SqfEntityTable(
    tableName: 'MediaType',
    primaryKeyName: 'MediaTypeId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('Name', DbType.text),
    ]);

const tablePlaylist = SqfEntityTable(
    tableName: 'Playlist',
    primaryKeyName: 'PlaylistId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('Name', DbType.text),
    ]);

const tableTrack = SqfEntityTable(
    tableName: 'Track',
    primaryKeyName: 'TrackId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('Name', DbType.text),
      SqfEntityField('Composer', DbType.text),
      SqfEntityField('Milliseconds', DbType.integer),
      SqfEntityField('Bytes', DbType.integer),
      SqfEntityField('UnitPrice', DbType.real),
      SqfEntityFieldRelationship(
          parentTable: tableMediaType,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'MediaTypeId',
          isPrimaryKeyField: false),
      SqfEntityFieldRelationship(
          parentTable: tableGenre,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'GenreId',
          isPrimaryKeyField: false),
      SqfEntityFieldRelationship(
          parentTable: tableAlbum,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'AlbumId',
          isPrimaryKeyField: false),
      SqfEntityFieldRelationship(
          parentTable: tablePlaylist,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'mPlaylistTrack',
          relationType: RelationType.MANY_TO_MANY,
          manyToManyTableName: 'PlaylistTrack'),
    ]);

const tableV_tracks = SqfEntityTable(
  tableName: 'VTracks',
  objectType: ObjectType.view,
  fields: [
    SqfEntityField('Name', DbType.text),
    SqfEntityField('album', DbType.text),
    SqfEntityField('media', DbType.text),
    SqfEntityField('genres', DbType.text),
    SqfEntityFieldRelationship(
        parentTable: tableTrack,
        deleteRule: DeleteRule.NO_ACTION,
        fieldName: 'TrackId',
        isPrimaryKeyField: false),
  ],
  sqlStatement: '''SELECT
	trackid,
	track.name,
	album.Title AS album,
	mediatype.Name AS media,
	genre.Name AS genres
FROM
	track
INNER JOIN album ON Album.AlbumId = track.AlbumId
INNER JOIN mediatype ON mediatype.MediaTypeId = track.MediaTypeId
INNER JOIN genre ON genre.GenreId = track.GenreId''',
);

// END TABLES

// BEGIN DATABASE MODEL
@SqfEntityBuilder(chinookdb)
const chinookdb = SqfEntityModel(
    modelName: 'Chinookdb',
    databaseName: 'chinook_v1.4.0+1.db',
    bundledDatabasePath: 'assets/chinook.sqlite',
    databaseTables: [
      tableAlbum,
      tableArtist,
      tableCustomer,
      tableEmployee,
      tableGenre,
      tableInvoice,
      tableInvoiceLine,
      tableMediaType,
      tablePlaylist,
      tableTrack,
      tableV_tracks
    ],
    formTables: [
      tableAlbum,
      tableArtist,
      tableCustomer,
      tableEmployee,
      tableGenre,
      tableInvoice,
      tableInvoiceLine,
      tableMediaType,
      tablePlaylist,
      tableTrack,
    ]);
// END chinook.db MODEL
