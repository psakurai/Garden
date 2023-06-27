class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.desc, this.title});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageassetPath() {
    return imageAssetPath!;
  }

  String getTitle() {
    return title!;
  }

  String getDesc() {
    return desc!;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = SliderModel();

  //1
  sliderModel.setDesc(
      "We’re here to disrupt the way you\n currently jogged, offering an unparalleled services combining modern standards with spectacular experiences.");
  sliderModel.setTitle("Garden is now\nconvenient, modernized,\nand evolved.");
  sliderModel.setImageAssetPath("assets/images/onb1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  //2
  sliderModel.setDesc(
      "Now compete with other player.\n Receive golds and up your level!");
  sliderModel.setTitle("An app that is\nenabling students around\nUTM!");
  sliderModel.setImageAssetPath("assets/images/onb1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  //3
  sliderModel.setDesc(
      "Now collect unique plants,\n badges and complete all missions!");
  sliderModel.setTitle("An app that is\nenabling students around\nUTM!");
  sliderModel.setImageAssetPath("assets/images/onb1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  return slides;
}
