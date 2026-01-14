// 3D Terrain Generation with Joystick Control
// Press R_LEFT button on joystick to generate new random terrain with random camera view

import processing.core.*;
import net.java.games.input.*;

// Terrain parameters
int cols, rows;
int scl = 20;  // Scale of each terrain cell
int w = 2000;  // Width of terrain
int h = 1600;  // Height of terrain

float flying = 0;  // Animation parameter

// Terrain grid
float[][] terrain;

// Random offsets for noise generation
float noiseOffsetX = 0;
float noiseOffsetY = 0;

// Camera parameters
float camX, camY, camZ;
float camRotX, camRotY, camRotZ;

// Joystick
ControllerEnvironment ce;
Controller controller;
boolean rLeftPressed = false;
boolean rLeftWasPressed = false;

void setup() {
  size(800, 600, P3D);
  cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];
  
  // Initialize joystick
  ce = ControllerEnvironment.getDefaultEnvironment();
  Controller[] controllers = ce.getControllers();
  
  // Find first available controller (joystick/gamepad)
  for (Controller c : controllers) {
    if (c.getType() == Controller.Type.GAMEPAD || 
        c.getType() == Controller.Type.STICK) {
      controller = c;
      println("Controller found: " + c.getName());
      break;
    }
  }
  
  if (controller == null) {
    println("No joystick/gamepad found. Use keyboard 'R' key as alternative.");
  }
  
  // Generate initial terrain
  generateRandomTerrain();
}

void draw() {
  background(0);
  
  // Check joystick input
  checkJoystickInput();
  
  // Check keyboard alternative
  if (keyPressed && (key == 'r' || key == 'R')) {
    if (!rLeftWasPressed) {
      generateRandomTerrain();
      rLeftWasPressed = true;
    }
  } else {
    rLeftWasPressed = false;
  }
  
  // Apply camera transformation
  translate(width/2, height/2);
  rotateX(camRotX);
  rotateY(camRotY);
  rotateZ(camRotZ);
  translate(camX, camY, camZ);
  
  // Generate terrain mesh
  flying -= 0.01;
  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff + noiseOffsetX, yoff + noiseOffsetY), 0, 1, -100, 100);
      xoff += 0.1;
    }
    yoff += 0.1;
  }
  
  // Draw terrain
  stroke(255);
  noFill();
  
  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      // Color based on height
      float h1 = terrain[x][y];
      float h2 = terrain[x][y+1];
      
      // Higher terrain is whiter, lower is darker
      float c1 = map(h1, -100, 100, 100, 255);
      float c2 = map(h2, -100, 100, 100, 255);
      
      stroke(c1);
      vertex(x*scl, y*scl, terrain[x][y]);
      stroke(c2);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
    }
    endShape();
  }
}

void checkJoystickInput() {
  if (controller == null) return;
  
  controller.poll();
  Component[] components = controller.getComponents();
  
  // Look for R_LEFT button (usually mapped to different indices depending on controller)
  // Common mappings: Button 4, 5, or other shoulder buttons
  for (Component comp : components) {
    if (comp.getName().contains("Button") || comp.getIdentifier().getName().contains("Button")) {
      float value = comp.getPollData();
      
      // Check for button press (usually index 4 or 5 for shoulder buttons)
      // This checks multiple possible buttons that could be R_LEFT
      String identifier = comp.getIdentifier().getName();
      if (identifier.equals("4") || identifier.equals("5") || 
          identifier.contains("rb") || identifier.contains("r1")) {
        if (value > 0.5 && !rLeftPressed) {
          println("R_LEFT button pressed - generating new terrain");
          generateRandomTerrain();
          rLeftPressed = true;
        } else if (value < 0.5) {
          rLeftPressed = false;
        }
      }
    }
  }
}

void generateRandomTerrain() {
  println("Generating new random terrain...");
  
  // Randomize noise offsets for completely different terrain
  noiseOffsetX = random(1000);
  noiseOffsetY = random(1000);
  flying = random(1000);
  
  // Generate random camera position
  // Position camera at random location around the terrain
  float angle = random(TWO_PI);  // Random angle around terrain
  float distance = random(400, 800);  // Random distance from center
  float height = random(-200, 200);  // Random height
  
  camX = cos(angle) * distance;
  camZ = sin(angle) * distance;
  camY = height;
  
  // Random camera rotation to point towards terrain center
  // Add some randomness to make it more interesting
  camRotX = random(PI/6, PI/3);  // Look down at terrain with variation
  camRotY = angle + random(-PI/8, PI/8);  // Face towards center with variation
  camRotZ = random(-PI/16, PI/16);  // Slight roll for uniqueness
  
  println("New terrain generated with offsets: " + noiseOffsetX + ", " + noiseOffsetY);
  println("Camera position: (" + camX + ", " + camY + ", " + camZ + ")");
  println("Camera rotation: (" + degrees(camRotX) + "°, " + degrees(camRotY) + "°, " + degrees(camRotZ) + "°)");
}
