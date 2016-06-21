package;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemapBuffer;
import flixel.FlxCamera;
import flixel.FlxObject;


/**
 * Example class that shows the capabilities of the lighting system.
 * Most of it has already done before, but the fact that you can now cut out windows is a new twist.
 * Written by sano98.
 * 
 * Note: In order for it to work, I might have set some private variables from base classes like FlxSprite or FlxTilemap to public!!
 */
class PlayState extends FlxState
{
	
	public var brickTileMap:FlxTilemap;
	public var brickString:String;
	
	public var couchSprite:FlxSprite;
	public var palmSprite:FlxSprite;
	
	public var cloudSprite:FlxSprite;
	public var sunSprite:FlxSprite;
	public var moonSprite:FlxSprite;
	public var sunSetSunSprite:FlxSprite;
	
	public var girlSprite:FlxSprite;
	
	public var lampSprite:FlxSprite;
	public var wallLampSprite:FlxSprite;
	public var fireSprite:FlxSprite;
	public var generatorSprite:FlxSprite;
	
	
	public var lightGroup:FlxTypedGroup<FlxSprite>;
	
	
	/**
	 * The layer of darkness, that is put over everything at night.
	 */
	public var silhouette:FlxSprite;
	
	
	/**
	 * Just a rectangle of blackness
	 */
	public var darkness:BitmapData;
	
	public var shadowCamera:FlxCamera;
	
	public var tileMapBuffer:FlxTilemapBuffer;
	
	public var dolly:FlxSprite;
	public var MOUSE_WHEEL_SPEED:Float;
	
	public var lightCone:FlxSprite;
	public var mouseLightCone:FlxSprite;
	public var lampLightCone:FlxSprite;
	public var redLightCone:FlxSprite;
	public var fireShineCone:FlxSprite;
	
	public var glowLightCone:FlxSprite;
	
	
	public var lightButton:FlxButton;
	
	//Switches through the different daytimes or lighting moods
	private var _lightMood:Int;
	
	private var _lightsOn:Bool = true;
	
	/**
	 * Just to avoid creating a point at 0|0 all the time in the bitmap copy functions
	 */
	private var _zeroPoint:Point;
	
	private var _lastFramesMouseWheel:Int;
	
	
	override public function create():Void
	{
		FlxG.worldBounds.set( 0, 0, 640, 768); 
		FlxG.camera.setScrollBoundsRect(0, 0, 640, 768, false);
		this.MOUSE_WHEEL_SPEED = 16; //must be a multiple of tile size in pixels if not using the shadow camera
		this._lastFramesMouseWheel = 0;
		
		this.lightGroup = new FlxTypedGroup<FlxSprite>();
		
		trace("FlxG.camera size: " + FlxG.camera.width + "|" + FlxG.camera.height);
		
		this.shadowCamera = new FlxCamera(0, 0, 640, 480, 0);
		this.shadowCamera.setScrollBoundsRect(0, 0, 640, 768, false);
		
		
		//FlxG.cameras.add(this.shadowCamera);// <- if it is added, the darkness covers the whole screen. No idea why; even happens if camera.buffer gets erased each step.
		
		this._lightMood = 0;
		this._zeroPoint = new Point(0, 0);
		
		super.create();
		
		this.bgColor = 0xFF77AAFF;
		
		this.silhouette = new FlxSprite(0, 0);
		this.silhouette.makeGraphic(640, 480, 0x00000000);
		
		_modifyDarkness();
		
		
		
		this.dolly = new FlxSprite(50, 0);
		
		
		this.sunSprite = new FlxSprite(400, 75);
		this.sunSprite.loadGraphic("assets/images/pixel sun.png", false, 64, 64, false);
		this.add(this.sunSprite);
		this.sunSprite.blend = HARDLIGHT;
		
		this.sunSetSunSprite = new FlxSprite(400, 75);
		this.sunSetSunSprite.loadGraphic("assets/images/sunsetsun.png", false, 128, 128, false);
		this.add(this.sunSetSunSprite);
		this.sunSetSunSprite.visible = false;
		this.sunSetSunSprite.scrollFactor.y = 0.5;

		
		this.moonSprite = new FlxSprite(350, 80);
		this.moonSprite.loadGraphic("assets/images/moon.png", false, 64, 64, false);
		this.add(this.moonSprite);
		this.moonSprite.visible = false;
		
		this.cloudSprite = new FlxSprite(80, 86);
		this.cloudSprite.loadGraphic("assets/images/cloud01.png", false, 108, 26, false);
		this.add(this.cloudSprite);
		
		
		this.brickString = "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		
		
		
		
		
		
		this.brickTileMap = new FlxTilemap();
		this.brickTileMap.loadMapFromCSV(brickString, "assets/images/tile_brickwall2.png", 32, 32, 0, 0, 0);
		
		this.brickTileMap.set_cameras([FlxG.camera, this.shadowCamera]);
		
		this.add(brickTileMap);
		
		//this.tileMapBuffer = new FlxTilemapBuffer(32, 32, Std.int(640/32), Std.int(480/32) + 1);
		
		this.couchSprite = new FlxSprite(100, 211);
		this.couchSprite.loadGraphic("assets/images/gameObject_armchairB.png", false, 59, 45, false);
		this.add(this.couchSprite);
		
		this.couchSprite.set_cameras([FlxG.camera, this.shadowCamera]);
		
		this.palmSprite = new FlxSprite(370, 160);
		this.palmSprite.loadGraphic("assets/images/palm.png", false, 64, 96, false);
		this.add(this.palmSprite);
		
		this.palmSprite.set_cameras([FlxG.camera, this.shadowCamera]);
		
		this.generatorSprite = new FlxSprite(480, 200);
		this.generatorSprite.loadGraphic("assets/images/gameObject_generator.png", true, 49, 44, false);
		this.add(this.generatorSprite);
		this.generatorSprite.animation.add("running", [0, 1], 24, true, false, false);
		
		this.generatorSprite.set_cameras([FlxG.camera, this.shadowCamera]);
		
		
		
		this.lampSprite = new FlxSprite(75, 100);
		this.lampSprite.loadGraphic("assets/images/lamp.png", true, 30, 60, false);
		this.add(lampSprite);
		
		
		
		
		this.wallLampSprite = new FlxSprite(570, 160);
		this.wallLampSprite.loadGraphic("assets/images/red wall lamp.png", true, 20, 30, false);
		this.add(wallLampSprite);
		
		this.fireSprite  = new FlxSprite(280, 160);
		this.fireSprite.loadGraphic("assets/images/fire sprite.png", true, 46, 94, false);
		this.fireSprite.animation.add("burning", [0, 1, 2, 3], 12);
		this.fireSprite.animation.play("burning");
		this.add(this.fireSprite);
		this.fireSprite.visible = false;
		
		
		
		this.girlSprite = new FlxSprite(370, 193);
		girlSprite.loadGraphic("assets/images/arron jes cycle.png", true, 48, 61, true);
		girlSprite.animation.add("running", [0, 1, 2, 3, 4, 5, 6, 7], 16);
		
		
		this.add(girlSprite);
		this.girlSprite.animation.play("running");
		
		this.girlSprite.setFacingFlip(FlxObject.LEFT, true, false);
		this.girlSprite.setFacingFlip(FlxObject.RIGHT, false, false);
		
		this.girlSprite.velocity.x = 100;
		
		//this.girlSprite.set_cameras([FlxG.camera, this.shadowCamera]);
		
		
		
		//Light cones. They are stamped onto the darkness, but are not visible themselves
		//Animated light cones must be added, or else the animation won't play; 
		//but since we don't want to actually show them, they have to be turned invisible
		
		this.lampLightCone = new FlxSprite(45, 145);
		this.lampLightCone.loadGraphic("assets/images/lampLightCone.png", true, 90, 102, false);
		
		this.redLightCone = new FlxSprite(500, 100);
		this.redLightCone.loadGraphic("assets/images/red shine2.png", true, 163, 163, false);
		
		this.lightCone = new FlxSprite(320, 211);
		this.lightCone.loadGraphic("assets/images/glow-light.png", false, 64, 64, false);
		
		this.mouseLightCone = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
		this.mouseLightCone.loadGraphic("assets/images/glow-light.png", false, 64, 64, false);
		
		this.glowLightCone = new FlxSprite(this.generatorSprite.x + 28, this.generatorSprite.y + 24);
		this.glowLightCone.loadGraphic("assets/images/powerswitch_light.png", true, 4, 4);
		
		this.fireShineCone  = new FlxSprite(250, 150);
		this.fireShineCone.loadGraphic("assets/images/fireshine.png", true, 128, 128, false);
		this.fireShineCone.animation.add("burning", [0, 1, 2], 8);
		this.fireShineCone.animation.play("burning");
		this.lightGroup.add(this.fireShineCone);
		this.fireShineCone.visible = false;
		
		
		
		//The darkness layer.
		this.add(this.silhouette);
		this.silhouette.blend = MULTIPLY;
		this.silhouette.scrollFactor.y = 0; //must be 1 because of the sprites  -> Fuck That! We'll just consider the scroll factor in copyPixels 
		
		this.lightButton = new FlxButton(550, 20, "Day/Night", onLightButtonClick);
		this.add(this.lightButton);
		
		this.add(dolly);
		this.add(this.lightGroup);
		
		
	}
	
	
	public function updateSilhouette():Void
	{
		//Clear the shilouette:
		this.silhouette.pixels = new BitmapData(640, 480, true, 0x000000);
		
		
		//A static sprite:
		//this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), new Point(this.couchSprite.x, this.couchSprite.y - FlxG.camera.scroll.y), this.couchSprite.pixels, this._zeroPoint, true);
		//this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), new Point(this.palmSprite.x, this.palmSprite.y - FlxG.camera.scroll.y), this.palmSprite.pixels, this._zeroPoint, true);
		
		//A tilemap:
		
		var _point:Point = new Point();
		
		_point.x = 0;
		_point.y = ((FlxG.camera.scroll.y - this.brickTileMap.y ) - this.brickTileMap.offset.y);
		
		
		//_point.x = (FlxG.camera.scroll.x * this.brickTileMap.scrollFactor.x) - this.brickTileMap.x - this.brickTileMap.offset.x; //modified from getScreenPosition()
		//_point.y = -(FlxG.camera.scroll.y * this.brickTileMap.scrollFactor.y) - this.brickTileMap.y - this.brickTileMap.offset.y;
		
		
		//this.brickTileMap.drawTilemap(this.tileMapBuffer, FlxG.camera);
		//this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), _point , this.tileMapBuffer.pixels, _point, true);
		
		this.silhouette.pixels.copyPixels(this.darkness, this.darkness.rect, this._zeroPoint, this.shadowCamera.buffer, this._zeroPoint, true);
		this.shadowCamera.buffer.fillRect(this.shadowCamera.buffer.rect, 0x00000000);
		
		//Stamp out the glow of the silhouette:
		this.silhouette.stamp(this.glowLightCone, Std.int(this.glowLightCone.x), Std.int(this.glowLightCone.y - FlxG.camera.scroll.y));
		
		
		//An animated sprite:
		
		
		var _flashRect2 = new Rectangle(0, 0, this.girlSprite.framePixels.width, this.girlSprite.framePixels.height);
		
		if (this.girlSprite.flipX)
		{
			girlSprite.framePixels = girlSprite.frame.paintRotatedAndFlipped(null, this._zeroPoint, 0, true, false, false, true);
			this.silhouette.pixels.copyPixels(this.darkness, _flashRect2, new Point(this.girlSprite.x, this.girlSprite.y - FlxG.camera.scroll.y), this.girlSprite.framePixels, this._zeroPoint, true);
		}
		else
		{
			this.silhouette.pixels.copyPixels(this.darkness, _flashRect2, new Point(this.girlSprite.x, this.girlSprite.y - FlxG.camera.scroll.y), this.girlSprite.pixels, new Point(girlSprite.frame.frame.x, girlSprite.frame.frame.y), true);
		}
		
		
		
		//this.shadowCamera.fill(0x00000000, false); //seems to work the same as shadowCamera.buffer.fillRect. No difference visisble.
		
		
		//Stamp out the light of the silhouette:
		if (this._lightsOn)
		{
			this.silhouette.stamp(this.mouseLightCone, Std.int(this.mouseLightCone.x), Std.int(this.mouseLightCone.y - FlxG.camera.scroll.y));
			this.silhouette.stamp(this.lampLightCone, Std.int(this.lampLightCone.x), Std.int(this.lampLightCone.y - FlxG.camera.scroll.y));
			this.silhouette.stamp(this.redLightCone, Std.int(this.redLightCone.x), Std.int(this.redLightCone.y - FlxG.camera.scroll.y));
			//this.silhouette.stamp(this.fireShineCone, Std.int(this.fireShineCone.x), Std.int(this.fireShineCone.y - FlxG.camera.scroll.y));
			this.silhouette.stamp(this.fireSprite, Std.int(this.fireSprite.x), Std.int(this.fireSprite.y - FlxG.camera.scroll.y));
			
			for (m in 0...this.lightGroup.members.length)
				{
					this.silhouette.stamp(this.lightGroup.members[m], Std.int(this.lightGroup.members[m].x), Std.int(this.lightGroup.members[m].y - FlxG.camera.scroll.y));	
				}
		}
		this.silhouette.dirty = true;

	}
	
	private function _modifyDarkness():Void
	{
		//day
		if (_lightMood == 0)
		{
			this.darkness = new BitmapData(640, 480, true, 0xFFFA6306);
		}
		//sunset
		else if (_lightMood == 1)
		{
			this.darkness = new BitmapData(640, 480, true, 0xFF813304);
		}
		//dark night
		else if (_lightMood == 2)
		{
			this.darkness = new BitmapData(640, 480, true, 0xFF000000);
		}
		//moonlit night
		else if (_lightMood == 3)
		{
			this.darkness = new BitmapData(640, 480, true, 0xFF1f4C63);
		}
		//sunrise
		else
		{
			this.darkness = new BitmapData(640, 480, true, 0xFF7a5601);
		}
	}
	
	/**
	 * Changes between day and night
	 */
	public function onLightButtonClick():Void
	{
		_lightMood ++;
		if (_lightMood > 4)
		{
			_lightMood = 0;
		}
		
		_modifyDarkness();
		
		//day
		if (_lightMood == 0)
		{
			this.bgColor = 0xFF77AAFF;
			this.cloudSprite.color = 0xFFFFFFFF;
			this.silhouette.visible = false;
			this.moonSprite.visible = false;
			this.sunSprite.visible = true;
			this.sunSprite.y = 75;
			this.lampSprite.frame = lampSprite.frames.getByIndex(0);
			this.wallLampSprite.frame = wallLampSprite.frames.getByIndex(0);
			this.fireSprite.visible = false;
			this.glowLightCone.frame = this.glowLightCone.frames.getByIndex(0);
			this.generatorSprite.animation.stop();
		}
		//sunset
		else if (_lightMood == 1)
		{
			this.bgColor = 0xFFFA6306;
			this.cloudSprite.color = 0xFFFA6306;
			this.silhouette.visible = true;
			this.moonSprite.visible = false;
			this.sunSprite.visible = false;
			this.sunSetSunSprite.visible = true;
			this.fireSprite.visible = true;
			
			this.lampSprite.frame = lampSprite.frames.getByIndex(1);
			this.wallLampSprite.frame = wallLampSprite.frames.getByIndex(1);
			this.glowLightCone.frame = this.glowLightCone.frames.getByIndex(1);
			this.generatorSprite.animation.play("running");
			
		}
		//dark night
		else if (_lightMood == 2)
		{
			this.bgColor = 0xFF001122;
			this.cloudSprite.color = 0xFF001122;
			this.cloudSprite.x = 350;
			this.silhouette.visible = true;
			this.moonSprite.visible = true;
			this.moonSprite.color = this.moonSprite.color.getDarkened(0.4);
			this.moonSprite.x = 350;
			this.sunSprite.visible = false;
			this.sunSetSunSprite.visible = false;
			this.lampSprite.frame = lampSprite.frames.getByIndex(1);
			this.wallLampSprite.frame = wallLampSprite.frames.getByIndex(1);
			
		}
		//moonlit night	
		else if (_lightMood == 3)
		{
			this.bgColor = 0xFF1f4C63;
			this.cloudSprite.color = 0xFF1f4C63;
			this.cloudSprite.x = 80;
			this.silhouette.visible = true;
			this.moonSprite.visible = true;
			this.moonSprite.color = 0xFFFFFFFF;
			this.moonSprite.x = 400;
			this.sunSprite.visible = false;
			this.lampSprite.frame = lampSprite.frames.getByIndex(1);
			this.wallLampSprite.frame = wallLampSprite.frames.getByIndex(1);
		}
		//sunrise
		else
		{
			this.bgColor = 0xFFFBA6D4;
			this.cloudSprite.color = 0xFFFBA6D4;
			this.cloudSprite.x = 80;
			this.silhouette.visible = true;
			this.moonSprite.visible = false;
			this.sunSprite.visible = true;
			this.sunSprite.y = 200;
			this.lampSprite.frame = lampSprite.frames.getByIndex(1);
			this.wallLampSprite.frame = wallLampSprite.frames.getByIndex(1);
		}
	}
	
	
	/**
	 * Causes the girl to turn around before she would leave the stage
	 */
	public function girlDirection():Void
	{
		this.girlSprite.velocity.x = this.girlSprite.velocity.x * ( -1);
		
		if (girlSprite.facing == FlxObject.RIGHT)
		{
			girlSprite.facing = FlxObject.LEFT;
		}
		else
		{
			girlSprite.facing = FlxObject.RIGHT;
		}
	}
	
	
	
	/**
	 * Handles the scrolling of the cameras. For some reason unknown, the shadow camera has a 1 frame delay, so the shadow would be behind the scene when scrolling.
	 * This is resolved by delaying the scrolling of the FlxG.camera by one frame so they're in synch again.
	 */
	public function mouseWheelHandler():Void
	{
		trace("Mouse wheel handler");
		
		
		if ((this.shadowCamera.scroll.y - FlxG.mouse.wheel * this.MOUSE_WHEEL_SPEED) < this.shadowCamera.minScrollY)
		{
			this.shadowCamera.scroll.y = this.shadowCamera.minScrollY;
		}
		else if ((this.shadowCamera.scroll.y - FlxG.mouse.wheel * this.MOUSE_WHEEL_SPEED) >= (this.shadowCamera.maxScrollY))
		{
			this.shadowCamera.scroll.y = this.shadowCamera.minScrollY;
		}
		else
		{
			this.shadowCamera.scroll.y -= FlxG.mouse.wheel * this.MOUSE_WHEEL_SPEED;
		}
		
		this.shadowCamera.updateScroll(); //prevents the overscrolling at the bottom, where I have no clue what the cause is
		
		
		if ((FlxG.camera.scroll.y - this._lastFramesMouseWheel * this.MOUSE_WHEEL_SPEED) < FlxG.camera.minScrollY)
		{
			FlxG.camera.scroll.y = FlxG.camera.minScrollY;
		}
		else if ((FlxG.camera.scroll.y - this._lastFramesMouseWheel * this.MOUSE_WHEEL_SPEED) >= (FlxG.camera.maxScrollY))
		{
			FlxG.camera.scroll.y = FlxG.camera.minScrollY;
		}
		else
		{
			FlxG.camera.scroll.y -= this._lastFramesMouseWheel * this.MOUSE_WHEEL_SPEED;
		}
		
		this._lastFramesMouseWheel = FlxG.mouse.wheel;
	}
	

	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed); //must come before the updatSilhouette()-call, or else the darkness-layer of animated sprites wil have a lag of 1 or more pixels
		
		
		
		
		
		if ((FlxG.mouse.wheel != 0) || (this._lastFramesMouseWheel != 0))
		{
			mouseWheelHandler();
		}
		
		if (FlxG.keys.justPressed.U)
		{
			this.shadowCamera.scroll.y += 8;
			FlxG.camera.scroll.y += 8;
		}
		
		if (FlxG.keys.justPressed.D)
		{
			this.shadowCamera.scroll.y -= 8;
			FlxG.camera.scroll.y -= 8;
		}
		
		if (FlxG.keys.justPressed.S)
		{
			this._lightsOn = !this._lightsOn;
		}
		
		if ((this.girlSprite.x < 10) || (this.girlSprite.x > 600))
		{
			girlDirection();
		}
		
		if (_lightMood > 0)
		{
			this.updateSilhouette();
			
			this.mouseLightCone.x = FlxG.mouse.x - Std.int(this.mouseLightCone.width / 2);
			this.mouseLightCone.y = FlxG.mouse.y - Std.int(this.mouseLightCone.height / 2);
		}
		
		
	}
}
