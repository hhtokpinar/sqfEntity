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
    if (__instance == null) {
      __instance = SearchFilter();
      __instance.nameRadioValue=1;
    }
    return __instance;
  }
}
