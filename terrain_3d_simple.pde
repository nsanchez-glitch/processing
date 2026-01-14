// 3D Terrain Generation with Keyboard Control
// Press 'R' key to generate new random terrain with random camera view
// This is a simplified version that works without joystick library

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

// Key press tracking
boolean rKeyWasPressed = false;

void setup() {
  size(800, 600, P3D);
  cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];
  
  // Generate initial terrain
  generateRandomTerrain();
}

void draw() {
  background(0);
  
  // Check keyboard input (R key simulates R_LEFT joystick button)
  if (keyPressed && (key == 'r' || key == 'R')) {
    if (!rKeyWasPressed) {
      generateRandomTerrain();
      rKeyWasPressed = true;
    }
  } else {
    rKeyWasPressed = false;
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
  
  // Display instructions
  camera();
  fill(255);
  textAlign(LEFT);
  text("Press 'R' to generate new random terrain", 10, 20);
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
