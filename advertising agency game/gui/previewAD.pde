import processing.sound.*;
import processing.video.*;
import com.jogamp.newt.opengl.GLWindow;


import javax.swing.JFrame;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.core.PSurfaceNone;
import processing.event.KeyEvent;
import processing.event.MouseEvent;
import java.awt.event.*;

class PreviewAd extends PApplet
{
  FrameParser parser;
  PImage bg;
  SoundFile music;
  SoundFile voiceClip;
  Movie animation;
  boolean loop = true;
  int currentFrameIndex = 0;
  String sketchPath = "";
  ArrayList<Frame> frames;
  
  @Override
  public void exitActual() {
  }
  
  public PreviewAd (String sketchPath)
  {
    super();
    this.sketchPath = sketchPath;
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  public PreviewAd(ArrayList<Frame> frames)
  {
    super();
    this.frames = frames;
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  public PreviewAd(Frame f)
  {
    super();
    this.frames = new ArrayList<Frame>();
    this.frames.add(f);
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  public void setup ()
  {

    if (getGraphics().isGL()) {
    final com.jogamp.newt.Window w = (com.jogamp.newt.Window) getSurface().getNative();
    w.setDefaultCloseOperation(com.jogamp.newt.Window.WindowClosingMode.DISPOSE_ON_CLOSE);
    }
    if (sketchPath != "")
    {
      parser = new FrameParser(this, "test.scene");
      parser.loadFrames(sketchPath);
      onChangeFrame();
    }
    else
    {
      parser = new FrameParser(this, frames);
      onChangeFrame();
    }
    
  }
  
  public void settings()
  {
    size(640, 480, OPENGL);
  }

  void onChangeFrame() // Updates all of the display variables to reflect the current frame
  {
      try { 
        if (parser.allFrames.get(currentFrameIndex).bg != null) bg = parser.allFrames.get(currentFrameIndex).bg;
        if (parser.allFrames.get(currentFrameIndex).music != null) {
          if (music != null) music.stop();
          music = parser.allFrames.get(currentFrameIndex).music;
          music.loop();
        }
        if (parser.allFrames.get(currentFrameIndex).voiceActingAudio != null) { 
          voiceClip = parser.allFrames.get(currentFrameIndex).voiceActingAudio;
          voiceClip.play();
        }
        if (parser.allFrames.get(currentFrameIndex).animation != null) {
          animation = parser.allFrames.get(currentFrameIndex).animation;
        }
      }
      catch (IndexOutOfBoundsException e) // if we reached the end...
      {
        if (loop) {
          if (parser.allFrames.size() != 0)
          {
            currentFrameIndex = 0;
            onChangeFrame();
          }
        }
        else exit();
      }
      
  }
  void draw()
  {
    renderVideo();
  }
  
  void renderVideo()
  {
    clear();
    // Display the background image
    if (bg != null) image(bg, 0, 0);
    if (animation != null) image(animation, 0, 0);
    
    if (voiceClip != null && !voiceClip.isPlaying())
    {
      currentFrameIndex += 1;
  
      onChangeFrame();
    }
  }
}

class Frame
{
  public SoundFile voiceActingAudio;
  public SoundFile music;
  public PImage bg;
  public Movie animation;
  public String endFrameOn;
  
}

class FrameParser
{
  public String fileName;
  public ArrayList<Frame> allFrames;
  public PApplet reference;
  
  public FrameParser(PApplet w, String filename)
  {
    reference = w;
    fileName = filename;
  }
  
  public FrameParser(PApplet w, ArrayList<Frame> frames)
  {
    reference = w;
    allFrames = frames;
  }
  
  public boolean loadFrames(String sketchPath)
  {
      allFrames = new ArrayList<Frame>();
     // Tries to load all the frames from the file. If it can't find one or more of the files requested, it will print an error
     // Returns true if successful, else returns false 
     String[] lines = loadStrings(sketchPath + "\\" + fileName);
     int currentFrameNumber = -1;
     for (String line : lines)
     {
       // Check if this is the header telling us what frame this is
       int i = line.indexOf("Frame ");
       if (i != -1)
       {
          currentFrameNumber = Integer.parseInt(line.substring(i + 6));
          allFrames.add(new Frame()); // to access it, we use allFrames.get(currentFrameNumber - 1)
          continue;
       }
       
       
       // Check if this line is specifying the bg image
       i = line.indexOf("bg: ");
       if (i != -1)
       {
         allFrames.get(currentFrameNumber - 1).bg = loadImage(sketchPath + "\\" +line.substring(i + 4)); // sets the background image to the one specified in this file
         continue;
       }
       
       // Check if this line is specifing the music
       i = line.indexOf("music: ");
       if (i != -1)
       {
         allFrames.get(currentFrameNumber - 1).music = new SoundFile(reference, sketchPath + "\\" + line.substring(i + 7)); 
         continue;
       }
       
       // Check if this line is specifing the voice acting clip
       i = line.indexOf("voice_acting: ");
       if (i != -1)
       {
         allFrames.get(currentFrameNumber - 1).voiceActingAudio = new SoundFile(reference, sketchPath + "\\" +line.substring(i + 14)); 
         continue;
       }
       
       // Check if this line is specifying the animation
       i = line.indexOf("animation: ");
       if (i != -1)
       {
         allFrames.get(currentFrameNumber - 1).animation = new Movie(reference, sketchPath + "\\" + line.substring(i + 11)); 
         continue;
       }
       
       // Check if this line is specifying when to end frame
       i = line.indexOf("endframe: ");
       if (i != -1)
       {
         allFrames.get(currentFrameNumber - 1).endFrameOn = line.substring(i + 10); 
         continue;
       }
       
     }
     

     return true;
  }
  
}
