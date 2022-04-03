import controlP5.*;

ControlP5 cp5;
ArrayList<FrameGUI> frameGUIs;
void setup()
{
  frameGUIs = new ArrayList<FrameGUI>();
  size(1920, 1080);
  cp5 = new ControlP5(this);

  cp5.addButton("UploadImage");
  frameGUIs.add(new FrameGUI(cp5, "test", 1, 500, 400));
  frameGUIs.add(new FrameGUI(cp5, "test2", 2, 600, 900));
  //frameGUIs.get(1).setPosition(800, 400);

  //Todo--make adding multiple frames work. And then add delete and add buttons for frames
}

void draw()
{
}

public void UploadImage(int value)
{
  print("button pressed!");
  selectInput("Upload an image", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    // also check if selection was not valid type
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    // copy this file to the library folder, save as bg1, music1, dialogue1, etc
  }
}

public class FrameGUI extends Controller
{
  /* A container for all the contents of a single frame, including:
  - buttons for bg image, bgm, voiceclip, animation, and preview button
  - textArea for inputting subtitles
  - a canvas to put the preview in, or some other way to define boundaries of preview render
  
  
 */
 
 int id;
 int w = 375;
 int h = 200;
 
 Group theGroup;
 Button addBGimg;
 Button addBGM;
 Button addVoiceClip;
 Button addAnimation;
 Button viewPreviewAnim;
 
 Textfield subtitles;
 PreviewCanvas previewBox;
 
 public FrameGUI(ControlP5 theControlP5 , String theName, int id, int x, int y)
 {
   super(theControlP5, theName);
   this.id = id;
   this.setPosition(x, y);
   
   theGroup = cp5.addGroup("theGroup"+id)
                .setPosition(this.getPosition()[0],this.getPosition()[1])
                .setWidth(600)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setBackgroundHeight(300)
                .setLabel("Frame " + id)
                ;
   
   addBGimg = theControlP5.addButton("add_BG_IMG" + id).setGroup(theGroup).setPosition(56,40);
   addBGM = theControlP5.addButton("add_BGM" + id).setGroup(theGroup).setPosition(146,40);
   addVoiceClip = theControlP5.addButton("add_voiceclip" + id).setGroup(theGroup).setPosition(236,40);
   addAnimation = theControlP5.addButton("add_animation" + id).setGroup(theGroup).setPosition(326,40);
   viewPreviewAnim = theControlP5.addButton("view_preview" + id).setGroup(theGroup).setPosition(416,40);
   
   subtitles = cp5.addTextfield("subtitles" + id)
                  .setPosition(250,80)
                  .setSize(300,60)
                  .setFont(createFont("arial",12))
                  .setColor(color(255))
                  .setColorBackground(color(100,100))
                  .setColorForeground(color(255,100))
                  .setGroup(theGroup).setText("testorama");
   previewBox = new PreviewCanvas(loadImage("test.jpg"), theGroup);
   previewBox.pre();
   cp5.addCanvas(previewBox);
 }
 
}

public class PreviewCanvas extends Canvas
{
  PImage img;
  int x = 10;
  int y = 116;
  int maxW = 223;
  int maxH = 170;
  
  public PreviewCanvas(PImage backgroundImage, Group parent)
  {
    super();
    x += parent.getPosition()[0];
    y += parent.getPosition()[1];
    img = backgroundImage;
  }
  
    public void draw(PGraphics pg) {
    // renders a square with randomly changing colors
    // make changes here.
    pg.image(img, x, y, maxW, maxH); // todo: make it relative to position of group
  }
}
