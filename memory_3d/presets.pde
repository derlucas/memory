

// update a preset (update name and filenames),  does not update the presets.txt
public void presetUpdate(int presetIndex, String name) {
  if("".contentEquals(name)) {
    name = "preset " + presetList.getItems().size();
  }
  
  Map<String, Object> item = presetList.getItem(presetIndex);
  item.put("name", name);
  item.put("text", name);
  PresetItem value = (PresetItem)item.get("value");
  value.setName(name);

  List<String> fileNames = new ArrayList<String>();

  for (int i = 0; i < elementsY * elementsX; i++) {
    ScrollableList list = lists[i];    
    String fileName = list.getItem((int)list.getValue()).get("value").toString();
    File file = new File(fileName);
    fileNames.add(file.getName());
  }

  value.setFileNames(fileNames);
}

// save a new preset in the list. does not update the presets.txt
public void presetNew(String name) {
  if("".contentEquals(name)) {
    name = "preset " + presetList.getItems().size();
  }

  PresetItem value = new PresetItem(name);
  List<String> fileNames = new ArrayList<String>();

  for (int i = 0; i < elementsY * elementsX; i++) {
    ScrollableList list = lists[i];    
    String fileName = list.getItem((int)list.getValue()).get("value").toString();
    File file = new File(fileName);
    fileNames.add(file.getName());
  }

  value.setFileNames(fileNames);
  presetList.addItem(name, value);
}

// load a preset (set the lists to the indexes from the filename)
public void presetLoad(int presetIndex) {
  if(presetIndex < presetList.getItems().size()) {
    
    Map<String, Object> item = presetList.getItem(presetIndex);
    if(item != null) {
      PresetItem preset = (PresetItem)item.get("value");
      if(preset != null) {
        int picCount = lists.length;
        
        for (int i = 0; i < preset.getFileNames().size(); i++) {
          if(i < picCount) {
             setListToName(lists[i], preset.getFileNames().get(i));
          }
        }
      }
    }
  }
}

public Boolean presetDelete(int presetIndex) {
  if(presetIndex < presetList.getItems().size()) {
    
    Map<String, Object> item = presetList.getItem(presetIndex);
    if(item != null) {
      presetList.removeItem(item.get("name").toString());
      return true;
    }
  }
  return false;
}

// set a ScrollableList thingi to a filename, we need this method because we only can
// set value which is the index. so we need to find the index by name
public void setListToName(ScrollableList list, String name) {
  //println("setListToName " + list + " name : " + name);
  List< Map< String , Object > > items = list.getItems();
  int counter = 0;
 
  for(Map< String , Object > itm: items) {
    if(itm.get("text").toString().equals(name)) {
      list.setValue(counter);
      break;
    }
    counter++;
  }
}



public void sortPresets() {  
  SortedMap<String, PresetItem> sortedMap = new TreeMap<String, PresetItem>();
    
  for (int i = 0; i < presetList.getItems().size(); i++) {
    Map<String, Object> item = presetList.getItem(i);   
    PresetItem presetItem = (PresetItem)item.get("value");    
    sortedMap.put(presetItem.getName(), presetItem);   
  }
  
  presetList.clear();
  
  for(Map.Entry<String,PresetItem> item: sortedMap.entrySet()) {
    presetList.addItem(item.getKey(), item.getValue());
  }
}

// save the presets into file
public void savePresets() {
  List<String> lines = new ArrayList<String>();
  
  for (int i = 0; i < presetList.getItems().size(); i++) {
    Map<String, Object> item = presetList.getItem(i);   
    PresetItem presetItem = (PresetItem)item.get("value");
    String line = presetItem.toString(); 
    lines.add(line);
   
  }  
  saveStrings("presets.txt", lines.toArray(new String[0]));
}

// load presets from file
public void loadPresets() { 
  presetList.clear();
  
  String[] lines = loadStrings("presets.txt");
  for (int i = 0; i < lines.length; i++) {
    PresetItem presetItem = new PresetItem();
    if(presetItem.load(lines[i])) {
//      println("loaded preset " + presetItem);
      presetList.addItem(presetItem.getName(), presetItem);
    }
  }  
}
