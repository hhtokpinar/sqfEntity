class SearchFilter {

String txtNameText;
  String nameContains;
  String nameStartsWith;
  String nameEndsWith;
  int nameRadioValue=1;
  String descriptionContains;
  double minPrice;
  double maxPrice;
  bool isActive;
  bool isNotActive;
  int selectedCategoryId;
  static bool showIsDeleted = false;
  static void resetSearchFilter(){
    __instance = SearchFilter();
  }
  static SearchFilter __instance;
  static SearchFilter get getValues {
    return  __instance = __instance ?? SearchFilter()
      ..nameRadioValue=1;
  }
}
