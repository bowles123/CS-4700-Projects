//Brian Bowles, CS 4700 Program 5, 12/01/15.

// Global variables
// Canvas area for text
var textCanvas;  
// Drawing environment for text canvas
var textContext; 

// Canvas area for rocket
var gameCanvas;  
// Drawing environment for rocket
var gameContext; 
var rocketSize = 10;

// Adjust as needed
var fontSize = 20;  
// Y-Position where to draw rocket message (if needed) in text canvas
var rocketMessagePosition = fontSize;  
// Y-coordinates of Rocket height message
var heightTextPosition = rocketMessagePosition + fontSize + 10;
// Y-coordinates of Rocket velocity message
var velocityTextPosition = heightTextPosition + fontSize + 10;
// Y-coordinates of Rocket fuel message
var fuelTextPosition = velocityTextPosition + fontSize + 10;
// X-coordinate of the messages
var messageX = 0;

// Time interval in milliseconds for animation, set as desired
var deltaTimeInterval = 100;

// Is the engine burning?
var burning = false;

// Game class
var game;
// Has the game been initialized?
var initialized = false;

// You add this function, and change this context, it is passed
// the height of the rocket.
function drawLander(height) {
  // The y-coordinate goes from 0 to canvas.height, so need to reverse for
  // the rocket appearing to go down.
  var ycoord = gameCanvas.height - height;
  var rocketSize = 5;
  // Rocket is a square, draw it. You should draw a nice rocket.
  gameContext.fillRect(gameCanvas.width/2, height-rocketSize, rocketSize, rocketSize);
}

// Draw where to land
function drawSurface(height) {
}

// Display a message. Takes in the text and where to display that message.
function message(text, ycoord) {
  textContext.clearRect(messageX, ycoord - fontSize, textCanvas.width, fontSize + 10);
  textContext.strokeText(text, 0, ycoord);
}

// The Planet class models a Planet, which has a gravity and
// a ground height.
function Planet(gravity, ground) {
    this.gravity = gravity;
    this.ground = ground;
    this.getGravity = (function() { return this.gravity; });
    this.getGround = (function() { return this.ground; });
}

// The Rocket class models a Rocket, which has a current height
// above a planet, amount of fuel left, current velocity, and
// engine strength
function Rocket(velocity, height, fuel, engine, planet) {
  this.height = height
  this.velocity = velocity
  this.fuel = fuel
  this.planet = planet
  this.engine = engine
  this.amountFuel = this.fuel
  this.nextHeight = function(deltaTime) { this.height = this.height + this.velocity * deltaTime}
  this.nextVelocity = function(burnRate, deltaTime) { this.velocity = this.velocity + ((this.engine * burnRate) - this.planet.getGravity())}
  this.reportHeight = function() { return this.height }
  this.reportVelocity = function() { return this.velocity }
  this.reportFuel = function() { return this.amountFuel }
  this.toString = function() {
    return "HEIGHT " + this.height + " Velocity " + this.velocity 
               + " FUEL " + this.amountFuel;
  }

  // Reports whether or not the rocket has reached the surface of the earth.
  this.reachedSurface = function() { 
	if (this.height <= 0) return true;
	else return false;
  }
  
  // Reports whether or not the rocket landed safely.
  // Takes in the value for a safe velocity.
  this.landed = function(safeVelocity) { 
	if(Math.abs(this.velocity) <= Math.abs(safeVelocity)) return true;
	else return false;
  }

  // Moves the rocket to the new position.
  // Takes in the rate at which the fuel burns and the increments that time changes.
  this.move = function(burnRate, deltaTime) { 
    var br = burnRate;
	
	// Calculate the new amount fuel.
    if (this.amountFuel < (br * deltaTime)) {
      br = this.amountFuel / deltaTime;
      this.amountFuel = 0.0;
      }
    else {
      this.amountFuel = this.amountFuel - br * deltaTime;
    }
   // Calculates the new height and velocity of the rocket.
   this.nextHeight(deltaTime);
   this.nextVelocity(br, deltaTime);
  }

}

// The Game class models a Game, the safeVelocity is the
// velocity within which the rocket can land.  The crashVelocity
// is the Velocity in which the rocket is blasted to smithereens.
function Game(rocket, safeVelocity, crashVelocity) {
  this.rocket = rocket;
  this.deltaTime = deltaTimeInterval / 1000;

  // Rocket explodes if reached surface going faster than this
  this.tooFast = crashVelocity;

// Message if lander crashes
  this.crashedMessage = "Crashed and Burned Sucker!\n";
  this.explodedMessage = "Blasted to Smithereens!\n";
  this.landedMessage = "Landed Safely! One small step for man, one giant leap for mankind\n";

// Safe landing velocity must be between 0 and this number
  this.safeVelocity = safeVelocity;

  // Strategy is either burn or no burn.
  this.strategy = function() { 
	if (burning) return 1;
	return 0;
  }

  // Play the game until the rocket is either landed, or crashed.
  this.play = function() {
	// Get the burn rate and draw the rocket.
    var burnRate = this.strategy();
	var c = document.getElementById("gameCanvas");
	var context = c.getContext("2d")
	var rocket = document.getElementById("rocket");
	var earth = document.getElementById("earth");
	context.drawImage(rocket, 150, 0, 35, 50)
	
	// Get the values of height, velocity, and fuel and display them.
	stringHeight = "Height: " + this.rocket.reportHeight();
	stringVelocity = "Velocity: " + this.rocket.reportVelocity();
	stringFuel = "Fuel: " + this.rocket.reportFuel();
	message(stringHeight, 50)
	message(stringVelocity, 80)
	message(stringFuel, 110)
	
	// Move rocket to new location.
	this.rocket.move(burnRate, this.deltaTime)
		
	// Clear rocket image and draw it at a new height.
	gameContext.clearRect(0,0, gameCanvas.width, gameCanvas.height);
	context.drawImage(earth, 20, gameCanvas.height - 300, 300, 300)
	context.drawImage(rocket, 150, -(this.rocket.height), 35, 50)
	
	// End game and display message if the rocket has reached the surface
	if (this.rocket.reachedSurface() == true)
		if(this.rocket.landed(this.safeVelocity) == true) {
			alert(this.landedMessage)
			intiliazed = false
		}
		else 
			if(Math.abs(this.rocket.reportVelocity()) < Math.abs(this.tooFast)) {
				alert(this.crashedMessage)
				intiliazed = false
			}
			else {
				alert(this.explodedMessage)
				intiliazed = false
			}
   }
  }

// Functions to turn the engines on/off
	function burn() { burning = true }
	function noburn() { burning = false }

// Main function to start the game
function gameStart() {
  if (!initialized) {
    // Initialize the drawing environments
    textCanvas = document.getElementById("textCanvas");
    textContext = textCanvas.getContext("2d");
    textContext.clearRect(0,0,textCanvas.width,textCanvas.height);
    gameCanvas = document.getElementById('gameCanvas');
    gameContext = gameCanvas.getContext("2d");
    gameContext.clearRect(0,0,textCanvas.width,textCanvas.height);
    textContext.font = fontSize + "px Courier"; // Set the font as desired

	var c = document.getElementById("gameCanvas");
	var context = c.getContext("2d")
	var earth = document.getElementById("earth");
	context.drawImage(earth, 20, gameCanvas.height - 300, 300, 300)
	
    // Create a few objects
    var pluto = new Planet(0.1, 200.0);
    var jupiter = new Planet(1.0, 4.0);
    var myRocket = new Rocket(0.0, 100.00, 100.0, 1.0, pluto);
    drawSurface(pluto.getGround());
    game = new Game(myRocket, -5.0, -10.0);
    noburn();
    initialized = true;
  }

  // Start the game
  game.play();
  return false;
}

// Animate
setInterval(gameStart, deltaTimeInterval);
