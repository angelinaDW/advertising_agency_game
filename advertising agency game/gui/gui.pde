import controlP5.*;

ControlP5 cp5;
ArrayList<FrameGUI> frameGUIs;
ArrayList<Frame> frames;

public int mostRecentlyAccessedFrame;
void setup()
{
  print(sketchPath());
  frameGUIs = new ArrayList<FrameGUI>();
  frames = new ArrayList<Frame>();

  cp5 = new ControlP5(this);

  cp5.addButton("UploadImage");
  frameGUIs.add(new FrameGUI(cp5, "test", 1, 500, 400));
  frameGUIs.add(new FrameGUI(cp5, "test2", 2, 600, 900));
  //frameGUIs.get(1).setPosition(800, 400);

  //Todo--make adding multiple frames work. And then add delete and add buttons for frames
}

void settings()
{
    size(1920, 1080);
}
void draw()
{
}

 void imgSelected(File selection)
 {
   print("uwu");
   Frame f;
   try {
     f =  frames.get(mostRecentlyAccessedFrame - 1);
     f.bg = loadImage(selection.getAbsolutePath());
  
   }
   catch (Exception e)
   {
     print("made it to the part");
     println(selection.getAbsolutePath());
     //print(e);
     f = new Frame();
     f.bg = loadImage(selection.getAbsolutePath());
     frames.add(f);
     print("here");
     mostRecentlyAccessedFrame = frames.size();
     print(frames);
   }
   frameGUIs.get(mostRecentlyAccessedFrame - 1).UpdatePreview(f.bg);
   
 
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
 
 public void UpdatePreview(PImage w)
{
  previewBox.img = w;
}

 
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
   addBGimg.onClick(new CallbackListener() {
     public void controlEvent(CallbackEvent theEvent)
     {
         mostRecentlyAccessedFrame = Integer.parseInt(theEvent.getController().getName().substring(10, theEvent.getController().getName().length()));
         selectInput("Upload an image", "imgSelected");
     }
     


 
   });
   addBGM = theControlP5.addButton("add_BGM" + id).setGroup(theGroup).setPosition(146,40);
   addVoiceClip = theControlP5.addButton("add_voiceclip" + id).setGroup(theGroup).setPosition(236,40);
   addAnimation = theControlP5.addButton("add_animation" + id).setGroup(theGroup).setPosition(326,40);
   viewPreviewAnim = theControlP5.addButton("view_preview" + id).setGroup(theGroup).setPosition(416,40);
   viewPreviewAnim.onClick(new CallbackListener() {
     public void controlEvent(CallbackEvent theEvent)
     {
          print("oi");
         PreviewAd ad = new PreviewAd(sketchPath());
     }
   });
   
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
 
 public void add_BG_IMG(int value)
 {
   selectInput("Choose a background image", "bgIMG_selected");
 }


}

public class PreviewCanvas extends Canvas
{
  public PImage img;
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
