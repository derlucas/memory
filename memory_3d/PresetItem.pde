public class PresetItem {

  public String name = null;
  public List<String> fileNames = new ArrayList<String>();

  public PresetItem() {
  }

  public PresetItem(String name) {
    this.name = name;
  }

  public Boolean load(String lineFromFile) {   
    int atPos = lineFromFile.indexOf("@");
    if(atPos > 0) {
      this.name = lineFromFile.substring(0, atPos);
      String rest = lineFromFile.substring(atPos+1);
      String files[] = rest.split(";");
      
      for(int i = 0; i < files.length; i++) {  
        if(files[i] != null && !files[i].trim().isEmpty()){
          fileNames.add(files[i]);      
        }
      }
      return true;
    }
    return false;
  }

  public PresetItem addFileName(String fileName) {
    fileNames.add(fileName);
    return this;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public List<String> getFileNames() {
    return fileNames;
  }

  public void setFileNames(List<String> fileNames) {
    this.fileNames = fileNames;
  }

  public String toString() {
    String listString = "";

    for (String s : fileNames) {
      File file = new File(s);
      listString += file.getName() + ";";
    }

    return name + "@" + listString;
  }
}
