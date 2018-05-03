import controlP5.*;
import java.util.*;
import codeanticode.syphon.*;

ControlP5 cp5;
int listHeight = 120;
int listWidth = 120;
int listMargin = 10;
int elementsX = 3;
int elementsY = 3;
int blendmode = 0;

Map<String, PImage> imagesAvailable = new HashMap<String, PImage>();
ScrollableList lists[] = new ScrollableList[elementsX * elementsY];
ScrollableList presetList;
Textfield presetNameField;
SecondApplet sa;

void settings() {
  size(1200, 1000);
}

void setup() {
  String[] args = {"TwoFrameTest"};
  sa = new SecondApplet(elementsX, elementsY);
  PApplet.runSketch(args, sa);

  cp5 = new ControlP5(this);  
  int counter = 0;

  for (int y = 0; y < elementsY; y++) {
    for (int x = 0; x < elementsX; x++) {      
      ScrollableList list = cp5.addScrollableList("list_" + counter)
        .setId(counter)
        .setPosition(listMargin + x * (listMargin+listHeight), listMargin + y * (listMargin+listWidth))
        .setSize(listWidth, listHeight).setBarHeight(0).setItemHeight(20)
        .setType(ScrollableList.LIST).setBarVisible(false);
      lists[counter] = list; 
      counter++;
    }
  }

  cp5.addButtonBar("bar").setPosition(140, 660).setSize(600, 20)
    .addItems(split("reload_files pr._prev pr._next pr._update pr._savenew pr._open pr._delete pr._sort", " "));
    
  cp5.addButtonBar("blendmode").setPosition(140, 690).setSize(150, 20)
    .addItems(split("SWITCH ROTATE", " ")).setValue(0);

  presetList = cp5.addScrollableList("presetlist").setPosition(10, 660).setSize(listWidth, 320)
    .setBarHeight(20).setItemHeight(20).setType(ScrollableList.LIST).setBarVisible(true);

  PFont font = createFont("Verdana", 14);
  presetNameField = cp5.addTextfield("presetName").setPosition(140, 720).setSize(120, 25).setFont(font).setFocus(true);
  
  reloadFiles();
  loadPresets();
}

void draw() {
  background(0);  
}

void reloadFiles() {
  File dir = new File(sketchPath() + "/images");
  
  if (dir.isDirectory()) {
    for (int i = 0; i < elementsY * elementsX; i++) {
      lists[i].clear();
    }        
    imagesAvailable.clear();
  
    for (File file : dir.listFiles()) {
      String fileName = file.getName();
      if (fileName.endsWith(".jpg") || fileName.endsWith(".png")) {       
        imagesAvailable.put(fileName, requestImage(file.getPath()));
        
        for (int i = 0; i < elementsY * elementsX; i++) {
          lists[i].addItem(fileName, file.getPath());
        }
      }
    }
  }
}

void loadImg(Map<String, Object> item, int imgIndex) {
  if (item != null && item.containsKey("value")) {
    String path = item.get("value").toString();
    if (path != null) {
      File file = new File(path);
      if (file.exists() && imgIndex >= 0 && imgIndex < elementsX * elementsY ) {
        
        // try to fetch image from our preloaded buffer, if not available load from disk
        if(imagesAvailable.containsKey(file.getName())) {
          sa.loadImage(imgIndex, imagesAvailable.get(file.getName()), blendmode); 
        } else {
          sa.loadImage(imgIndex, loadImage(file.getPath()), blendmode);  
        }
      }
    }
  }
}

void keyPressed() {
  if (keyCode == RIGHT) {
    int presetInt = (int)presetList.getValue();
    if (presetInt<presetList.getItems().size()) {
        presetList.setValue(presetInt+1);
        presetLoad(presetInt+1);
      }
  } else if(keyCode == LEFT) {
    int presetInt = (int)presetList.getValue();
    if (presetInt>0) {
        presetList.setValue(presetInt-1);
        presetLoad(presetInt-1);
      }
  }  
}

public void controlEvent(ControlEvent theEvent) {
//  println("event: id "+theEvent.getId() + " name: " + theEvent.getName() + " value: " + theEvent.getValue());


  if (theEvent.getName().startsWith("list_")) {
    ScrollableList list = (ScrollableList)theEvent.getController();
    loadImg(list.getItem((int)theEvent.getValue()), theEvent.getId());
  } else if (theEvent.getName().equals("bar")) {

    int presetInt;

    switch(((int)theEvent.getValue())) {
    case 0: 
      reloadFiles(); 
      break;
    case 1:
      // prev
      presetInt = (int)presetList.getValue();
      if (presetInt>0) {
        presetList.setValue(presetInt-1);
        presetLoad(presetInt-1);
      }
      break;
    case 2:
      // next
      presetInt = (int)presetList.getValue();
      if (presetInt<presetList.getItems().size()) {
        presetList.setValue(presetInt+1);
        presetLoad(presetInt+1);
      }
      break;
    case 3:
      // update/save
      presetInt = (int)presetList.getValue();
      presetUpdate(presetInt, presetNameField.getText());
      savePresets();
      break;
    case 4:
      // save new
      presetInt = (int)presetList.getValue();
      presetNew(presetNameField.getText());
      savePresets();
      break;
    case 5:
      // open
      presetInt = (int)presetList.getValue();
      presetLoad(presetInt);
      break;
    case 6:
      // delete
      if(presetList.getItems().size() > 0) {
        presetInt = (int)presetList.getValue();      
        if(presetDelete(presetInt)) {
          savePresets();
        }
      }
      break;
    case 7:
      // sort
      sortPresets();
      savePresets();
      break;
    }
  } else if (theEvent.getName().equals("presetlist")) {
    Map<String, Object> item = presetList.getItem((int)theEvent.getValue());
    presetNameField.setText((String)item.get("name"));
  }
}
