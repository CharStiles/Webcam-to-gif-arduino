//importing temboo so i can post this to tumblr
import com.temboo.core.*;
import com.temboo.Library.Tumblr.Post.*;
// Create a session using your Temboo account application details
TembooSession session = new TembooSession("yourTembooUsername", "appName", "appKey");
//Library for converting the gif to B64, thanks to Kevin Buck from temboo for helping me out
import javax.xml.bind.DatatypeConverter;
//library for creating and exporting gif http://extrapixel.github.io/gif-animation/
import gifAnimation.*;
import processing.opengl.*;
GifMaker gifExport;
 
import processing.serial.*;
 
Serial myPort;// The serial port
 
//capturing webcam
import processing.video.*;
Capture cam;
int gifNum=0;
boolean makeGif=false;
int startTime;
int elapsTime;
int once=1;
int makeGifHappenOnce;
float squeeze;
boolean dontFuckUpMyPort = true;
 
public void setup() {
  if (dontFuckUpMyPort ==true){
  size(320,240, OPENGL);
  frameRate(12);
  cam = new Capture(this, width,height,12);
  cam.start();
  println("gifAnimation " + Gif.version());
  myPort = new Serial(this, Serial.list()[2], 9600);
 // don't generate a serialEvent() unless you get a newline character:
 
  myPort.bufferUntil('\n');
  startTime=0;
  dontFuckUpMyPort=false;
  makeGifHappenOnce=1;
   }
 
  gifExport = new GifMaker(this, "export.gif");
  gifExport.setRepeat(0); // make it an endless animation
 
 
}
void captureEvent(Capture cam){
    cam.read();
}
 
void draw() {
  image(cam,0,0);
  dontFuckUpMyPort=false; 
 
  if (makeGif==true){
  gifExport.setQuality(5); // usually its at 10 but i need the file to be small for tumblr
  gifExport.setDelay(10);//again making the gif smaller
  gifExport.addFrame();
  }
 
  elapsTime = (millis() - startTime)/1000;//so elasped time starts over everytime someone hit the max pressure
  if (elapsTime==3){ //this is how long the gif will be time-wise
    if (once==0){
    stopGif();
    once=once+1;
    }
    }
 
}
////this is for getting the button information from arduino
void serialEvent (Serial myPort) {
 // get the ASCII string:
String inString = myPort.readStringUntil('\n');
 
 if (inString != null) {
 // trim off any whitespace:
 inString = trim(inString); 
 squeeze = float(inString);
 
 //setting it over inbetween people:
 if (squeeze==0){
 makeGifHappenOnce=0;
 }
 //make gif when someone squeezes the maximum amout
 if (squeeze > 230 && makeGifHappenOnce==0 && elapsTime > 5){ //if someone is squeezing hard and they havent totally let go and there wasnt a bug that would make the gif record over another gif
    makeGif=true;
    startTime = millis();// this resets elapsed time to 0
    once=0;
    makeGifHappenOnce++;
 
         }
     }
 
 }
 
void stopGif() {
  gifExport.finish();
  makeGif=false;
  println("gif saved");
  //converting the gif that was just saved in my data folder to base64
  byte b[] = loadBytes("export.gif"); 
  String b64 = DatatypeConverter.printBase64Binary(b);
  //posting it to tumblr via temboo
  runCreatePhotoPostWithImageFileChoreo(b64);
  //Hacky way to be able to re-create more than one gif per program run!
  setup();
}
 
//Below is temboo business
void runCreatePhotoPostWithImageFileChoreo(String b64) {
  // Create the Choreo object using your Temboo session
  CreatePhotoPostWithImageFile createPhotoPostWithImageFileChoreo = new CreatePhotoPostWithImageFile(session);
 
  // Set inputs
  createPhotoPostWithImageFileChoreo.setData(b64);
  createPhotoPostWithImageFileChoreo.setAPIKey("getYourOwn");
  createPhotoPostWithImageFileChoreo.setAccessToken("getYourOwn");
  createPhotoPostWithImageFileChoreo.setAccessTokenSecret("getYourOwn");
  createPhotoPostWithImageFileChoreo.setSecretKey("getYourOwn");
  createPhotoPostWithImageFileChoreo.setBaseHostname("tiny-fits-of-rage.tumblr.com");
 
  // Run the Choreo and store the results
  CreatePhotoPostWithImageFileResultSet createPhotoPostWithImageFileResults = createPhotoPostWithImageFileChoreo.run();
 
  // Print results
  println(createPhotoPostWithImageFileResults.getResponse());
 
}
