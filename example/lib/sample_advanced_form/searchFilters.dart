class SearchFilterProduct {
  String? txtNameText;
  String? nameContains;
  String? nameStartsWith;
  String? nameEndsWith;
  int? nameRadioValue = 1;
  String? descriptionContains;
  double? minPrice;
  double? maxPrice;
  bool? isActive;
  bool? isNotActive;
  int? selectedCategoryId;
  static bool showIsDeleted = false;
  static void resetSearchFilter() {
    __instance = SearchFilterProduct();
  }

  static SearchFilterProduct? __instance;
  static SearchFilterProduct get getValues {
    return __instance = __instance ?? SearchFilterProduct()
      ..nameRadioValue = 1;
  }
}
