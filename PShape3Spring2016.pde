/*
Name: Brandon Scott
Professor: Dr. Parson
Class: CSC 220 Spring 2016
Assignment: 3
Due date: 3/30/2016
Filename: PShape3Spring2016.pde
Purpose: Demonstrate 3D Pshape, textures, & tints.
Notes:
'f' will freeze the canvas
Changed original move() to rotate(), kept original code
Added my own move() which moves x,y positions for the shapes
Added movex, movey parameters for MyShape - determines the speed at which they
move in the x,y directions
Added xdirection, ydirection parameters for MyShape - determins which direction
the shapes start moving toward
*/

// STUDENT: NOTE to P5 programmers:
// There is no PShape capability in P5, and furthermore, while it
// is possible to loadImage() successfully in P5, attempting to use
// the loaded image with 3D beginShape()/endShape() results in this error:
// [GroupMarkerNotSet(crbug.com/242999)!:A04A1016927F0000]GL ERROR
// :GL_INVALID_OPERATION : glDrawArrays: attempt to render with no buffer
// attached to enabled attribute 2.
// Therefore, students who want to program using P5 and aren't afraid of
// a little trial and error, are welcome to do so in 2D (not WEBGL) as
// long as they get textures & tints to work as they do in my Processing demo
// of this code. They must do all push()es and pop()s outlined below, and satisfy
// all other proejct requirements, except they may substitute 2D for 3D, and not
// use WEBGL. Getting something working with textures and tints in P5 2D can
// tale the place of 3D for P5 programmers only. You must use 3D if you do
// this assignment in Processing. I am giving you code for a working example.

MyShape [] shapes = new MyShape[4];
boolean isfrozen = false ;

void setup() {
  randomSeed(123);
  // UNCOMMENT MAKE THE NEXT LINE FIRST FOR FULL SCREEN
  fullScreen(P3D);
  // OR UNCOMMENT MAKE THE NEXT LINE FIRST FOR fixed size
  //size(1500, 1000, P3D);
  //ortho();
  /*
  float fov = PI/4;
   float cameraZ = (height/2.0) / tan(fov/2.0);
   perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);
   */
  background(255);
  shapeMode(CENTER);
  // println("frameRate is " + frameRate);
  frameRate(30);
  /*
  MyShape(x, y, z,
   rotx, roty, rotz,
   movex, movey,
   xdirection, ydirection,
   R, G, B,
   scalefactor)
   */
  shapes[0] = new MyShape(width/4, height/2, 0,
                          3, 0, 1, // rotx, roty, rotz
                          0, 5, // movex, movey
                          1, 1, // xdirection, ydirection
                          255, 255, 0, // R, G, B
                          1.0); // LEFTMOST SHAPE
  shapes[1] = new MyShape(width/2-50, height/2, 0,
                          3, 1, 0, // rotx, roty, rotz
                          3, 0, // movex, movey
                          1, 1, // xdirection, ydirection
                          0, 255, 255, // R, G, B
                          1.5); // TOP MIDDLE SHAPE
  shapes[2] = new MyShape(3*width/4, height/2, 0,
                          3, 0, 1, // rotx, roty, rotz
                          0, 5, // movex, movey
                          1, -1, // xdirection, ydirection
                          255, 100, 0, // R, G, B
                          1.0); // RIGHTMOST SHAPE
  shapes[3] = new MyShape(width/2-50, 7*height/8, 0,
                          0, 1, 1,  // rotx, roty, rotz
                          3, 0, // movex, movey
                          -1, 1, // xdirection, ydirection
                          0, 0, 255, // R, G, B
                          2.5); // BOTTOM SHAPE
}

void draw() {
  if (isfrozen) {
    return ;
  }
  fill(0,0,0,10); // partial erase from last draw()
  // Uncomment to see the shapes move w/ a full erase
  //background(0);
  rectMode(CENTER);
  shapeMode(CENTER);
  // Painting the big, black, mostly-transparent rectangle does
  // not work at default Z because it creates a curtain that shapes move across.
  // Apparently, it needs to be plotted at a higher value of Z in order
  // to erase everything equally. For now I am leaving it off.
  //rect(width/2, height/2, width, height);
  //background(0);
  shapeMode(CENTER);
  for (int i = 0; i < shapes.length; i++) {
    shapes[i].display();
    // Rotate & move are now in separate methods
    shapes[i].rotate();
    shapes[i].move();
  }
}

// We must implement the frozen command.
void keyPressed() {
  if (key == 'f') {
    isfrozen = ! isfrozen ;
    println("Frozen? " + isfrozen);
  }
}

// STUDENT: You must implement your own MyShape class that differs
// from mine in at least the following ways:
// 1. It must use multiple beginShape()/endShape() groupings for
//     different "body parts". They MUST differ from mine. Do not
//     use 3 rectangles that intersect in the center. Create a different
//     composite set of PShapes.
//  NOTE: Processing allows you to preconstruct PShape objects, including
//  a hierarchical group of PShape objects stored in the "shape" field here.
//  This Processing code constructs the group PShape within the constructor,
//  and displays it in the display() method. Preconstructed PShape objects can
//  be translated, scaled, rotated, etc. at display time; their preconstruction
//  improves rendering speed, since their geometries can be preloaded onto the
//  GPU card. P5, on the other hand, has no PShape. As of summer 2015 discussions on
//  github that included Shiffman, there was no clear plan for p5.PShape, and
//  anything available now would be doubtful. Therefore, P5 method MyShape.display()
//  MUST use beginShape()/endShape() to construct and render groups of vertices,
//  incurring construction and rendering costs on every call to display().
//  The P5 manual shows only 2D vertex() calls, but 3D vertex() calls appear here:
//  https://github.com/processing/p5.js/wiki/Getting-started-with-WebGL-in-p5
//  2. It must load an image supplied by the student and use that image to texture()
//  the shape. I used a PNG file with some semi-transparent pixel regions.
//  3. It must use tint() to tint the texture, tinting it different on each of
//  multiple objects of class MyShape.
//  4. Some myShape obejcts MUST use some combination of 3D translate() (including
//  a varying Z parameter) OR rotateX() OR rotateY() to achiece 3D effects. Note
//  that rotateZ() is just 2D rotate(); you may use it, but it does not fulfill
//  this requirement. This requires using P3D in Processing or WEBGL in P5.
//  5. Use translate() to position these objects.
//  6. Use scale() on at least some of these objects. Note that there are variants of
//  scale that take 2 or 3 parameters, scaling Y and/or Z differently from X.
//  7. The objects must change some of their display-oriented fields within each
//  call to move(), while keeping others constant. I did not change x, y, z, but I
//  changed rotation, and used different scales. My move() method changes only
//  3D rotations. Another possibility would be either to change Z or scale factor
//  to make the object approach/recede or grow/shrink.
//  8. Class MyShape must include data fields and a constructor to initialize them,
//  and the constructor must take some parameters. Document them.
//  9. A zero-parameter MyShape.display() method displays the MyShape object.
//     Keep freeze mode intact using code I have supplied that triggers on the 'f' key.
//     Detection of freeze mode occurs at the top of the global draw() function.
//  10. A zero-parameter MyShape.move() method changes data fields that will effect the
//  next call to display(). Think of this as an animated demo of the composite shape.
//  Mine is mildly animated. Create some sense of flow over time.
//
class MyShape {
  PShape shape ;
  int x ;
  int y ;
  int z ;
  float s ;
  int rotatex ;
  int rotatey ;
  int rotatez ;
  int rotxincr ;
  int rotyincr ;
  int rotzincr ;
  // movexincr & moveyincr - the speed that the shape should move in the x,y positions
  int movexincr ;
  int moveyincr ;
  // xdirection & direction - the direction the shape should move in x,y positions (either 1 or -1)
  int xdirection;
  int ydirection;
  int rred ;
  int ggreen ;
  int bblue;
  // int aalpha ; // Not currently used.
  // Constructor parameters for this class give unchanging x,y,z coordinates,
  // rotation increments for rotate[X|Y|Z](), unchanging color and scale factor.
  MyShape(int myx, int myy, int myz, int myrotx, int myroty, int myrotz,
    int mymovex, int mymovey,
    int myxdirection, int myydirection,
    int R, int G, int B, float scalefactor) {
    x = myx ;
    y = myy ;
    z = myz ;
    s = scalefactor;
    rotxincr = myrotx ;
    rotyincr = myroty ;
    rotzincr = myrotz ;
    movexincr = mymovex; // Incremement x by this
    moveyincr = mymovey; // Increment y by this
    xdirection = myxdirection; // Invert when hitting edge of screen
    ydirection = myydirection; // Invert when hitting edge of screen
    rotatex = rotatey = rotatez = 0 ; //  start them all at 0
    rred = R ;
    ggreen = G ;
    bblue = B ;
    // Load the image, build and texture-tile 3 square PShapes along the 3
    // different axes, then group them hierarchically with addChild().
    PImage img = loadImage("texture.png");
    textureMode(IMAGE);
    textureWrap(REPEAT);
    PShape s1 = createShape();
    s1.beginShape();
    s1.texture(img);
    s1.stroke(random(0,rred), random(0, ggreen), random(0, bblue), random(0,30));
    s1.tint(random(0, rred), random(0, ggreen), random(0, bblue));
    s1.vertex(-100, 0, 0, random(255), random(255));
    s1.vertex(100, 0, 0, random(255), random(255));
    s1.vertex(0, 100, 0, random(255), random(255));
    s1.endShape();
    // next plane
    PShape s2 = createShape();
    s2.beginShape();
    s2.texture(img);
    s2.stroke(random(0,rred), random(0, ggreen), random(0, bblue), random(0,30));
    s2.tint(random(0, rred), random(0, ggreen), random(0, bblue));
    s2.vertex(-100, 0, 0, random(255), random(255));
    s2.vertex(100, 0, 0, random(255), random(255));
    s2.vertex(0, 100, 0, random(255), random(255));
    s2.endShape();
    s2.rotateX(radians(random(90))); // rotate this triangle around the X axis
    s2.endShape();
    // next plane
    PShape s3 = createShape();
    s3.beginShape();
    s3.texture(img);
    s3.stroke(random(0,rred), random(0, ggreen), random(0, bblue), random(0,30));
    s3.tint(random(0, rred), random(0, ggreen), random(0, bblue));
    s3.vertex(-100, 0, 0, random(255), random(255));
    s3.vertex(100, 0, 0, random(255), random(255));
    s3.vertex(0, 100, 0, random(255), random(255));
    s3.rotateY(radians(random(90))); // rotate this triangle around the Y axis
    s3.endShape();
    shape = createShape(GROUP);
    // Grup the 3 shapes hieratchically.
    shape.addChild(s1);
    shape.addChild(s2);
    shape.addChild(s3);
  }
  // display the object's shapes with texture & tint.
  // Processing constructs the composite PShape within the
  // constructor code above, while P5 must repeat Shape
  // construction in every call to display().
  // STUDENT: read instructions for display() at start of this class.
  // You must create your own display() logic.
  void display() {
    pushMatrix();  // so we can restore world coordinates later
    translate(x, y, 0);
    scale(s);
    rotateX(radians(rotatex));
    rotateY(radians(rotatey));
    rotateZ(radians(rotatez));
    int ttint = ((/*aalpha*/255 & 255) << 24) | ((rred & 255) << 16) | ((ggreen & 255) << 8) | (bblue & 255);
    // Leave alpha at 100%. Make stroke opposite color of tint.
    shape.setStroke(~ttint);
    shape.setTint(ttint);
    //shape.setEmissive(ttint);
    //aalpha = 32 ;
    shape(shape, 0, 0);
    popMatrix() ;  // restore world coordinates
  }
  // OLD move() - now rotate()
  // move() updates only the rotator's in Parsson's solution.
  // STUDENT: read instructions for move() at start of this class.
  // You must create your own move() logic.
  void rotate() {
    rotatex = (rotatex + rotxincr) % 360 ;
    rotatey = (rotatey + rotyincr) % 360 ;
    rotatez = (rotatez + rotzincr) % 360 ;

    /*
    rred = (rred + 1) & 255 ;
     ggreen = (ggreen + 1) & 255;
     bblue = (bblue + 1) & 255 ;
     aalpha = (aalpha + 1) & 255 ;
     */
  }
  // move() - Changes an object's x,y position in the direction it is supposed to be moving.
  // Changes direction when it hits the edge of the screen (or close to the edge of the screen)
  void move() {
    // Move the object in x,y positions by incrementing them by their direction * speed
    x = x + (xdirection * movexincr);
    y = y + (ydirection * moveyincr);

    // Change the direction of the object if it hits the bounds of the screen
    // I tried multiplying the size by the scale factor to get a more accurate bounce for scaled objects,
    // But it isn't working very accurately, still. For 1.0 scalefactor, it seems pretty accurate.
    if (x > width-(100*s) || x < (100*s)) {
      xdirection *= -1;
    }

    if (y > height-(100*s) || y < (100*s)) {
      ydirection *= -1;
    }
  }
}
