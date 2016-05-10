package;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
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
	
	
	/**
	 * The layer of darkness, that is put over everything at night.
	 */
	public var silhouette:FlxSprite;
	
	
	/**
	 * Just a rectangle of blackness
	 */
	public var darkness:BitmapData;
	
	public var tileMapBuffer:FlxTilemapBuffer;
	
	
	
	
	public var lightCone:FlxSprite;
	public var mouseLightCone:FlxSprite;
	public var lampLightCone:FlxSprite;
	public var redLightCone:FlxSprite;
	public var fireShineCone:FlxSprite;
	
	
	public var lightButton:FlxButton;
	
	//Switches through the different daytimes or lighting moods
	private var _lightMood:Int;
	
	/**
	 * Just to avoid creating a point at 0|0 all the time in the bitmap copy functions
	 */
	private var _zeroPoint:Point;
	
	
	override public function create():Void
	{
		FlxG.worldBounds.set( 0, 0, 640, 480); 
		FlxG.camera.setScrollBoundsRect(0, 0, 640, 480, true);
		
		
		this._lightMood = 0;
		this._zeroPoint = new Point(0, 0);
		
		super.create();
		
		this.bgColor = 0xFF77AAFF;
		
		this.silhouette = new FlxSprite(0, 0);
		this.silhouette.makeGraphic(640, 480, 0x00000000);
		
		_modifyDarkness();
		
		
		
		this.tileMapBuffer = new FlxTilemapBuffer(32, 32, 20, 8);
		
		
		
		this.sunSprite = new FlxSprite(400, 75);
		this.sunSprite.loadGraphic("assets/images/pixel sun.png", false, 64, 64, false);
		this.add(this.sunSprite);
		this.sunSprite.blend = HARDLIGHT;
		
		this.sunSetSunSprite = new FlxSprite(400, 75);
		this.sunSetSunSprite.loadGraphic("assets/images/sunsetsun.png", false, 128, 128, false);
		this.add(this.sunSetSunSprite);
		this.sunSetSunSprite.visible = false;

		
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
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3, 4, 4, 4, 4, 0, 1, 2, 3;\n";
		this.brickString = this.brickString + "0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3;\n";
		
		
		
		
		
		this.brickTileMap = new FlxTilemap();
		this.brickTileMap.loadMapFromCSV(brickString, "assets/images/tile_brickwall2.png", 32, 32, 0, 0, 0);
		this.add(brickTileMap);
		
	
		
		this.couchSprite = new FlxSprite(100, 211);
		this.couchSprite.loadGraphic("assets/images/gameObject_armchairB.png", false, 59, 45, false);
		this.add(this.couchSprite);
		
		this.palmSprite = new FlxSprite(370, 160);
		this.palmSprite.loadGraphic("assets/images/palm.png", false, 64, 96, false);
		this.add(this.palmSprite);
		
		
		
		
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
		
		this.fireShineCone  = new FlxSprite(250, 150);
		this.fireShineCone.loadGraphic("assets/images/fireshine.png", true, 128, 128, false);
		this.fireShineCone.animation.add("burning", [0, 1, 2], 8);
		this.fireShineCone.animation.play("burning");
		this.add(this.fireShineCone);
		this.fireShineCone.visible = false;
		
		
		
		//The darkness layer.
		this.add(this.silhouette);
		this.silhouette.blend = MULTIPLY;
		
		this.lightButton = new FlxButton(550, 20, "Day/Night", onLightButtonClick);
		this.add(this.lightButton);
		
		
	}
	
	
	public function updateSilhouette():Void
	{
		//Clear the shilouette:
		this.silhouette.pixels = new BitmapData(640, 480, true, 0x000000);
		
		//A static sprite:
		this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), new Point(this.couchSprite.x, this.couchSprite.y), this.couchSprite.pixels, this._zeroPoint, true);
		this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), new Point(this.palmSprite.x, this.palmSprite.y), this.palmSprite.pixels, this._zeroPoint, true);
		
		//A tilemap:
		this.brickTileMap.drawTilemap(this.tileMapBuffer, this.camera);
		this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), this._zeroPoint, this.tileMapBuffer.pixels, this._zeroPoint, true);
		
		//An animated sprite:
		var _flashRect2 = new Rectangle(0, 0, this.girlSprite.framePixels.width, this.girlSprite.framePixels.height);
		
		
		
		if (this.girlSprite.flipX)
		{
			girlSprite.framePixels = girlSprite.frame.paintRotatedAndFlipped(null, this._zeroPoint, 0, true, false, false, true);
			this.silhouette.pixels.copyPixels(this.darkness, _flashRect2, new Point(this.girlSprite.x, this.girlSprite.y), this.girlSprite.framePixels, this._zeroPoint, true);
		}
		else
		{
			this.silhouette.pixels.copyPixels(this.darkness, _flashRect2, new Point(this.girlSprite.x, this.girlSprite.y), this.girlSprite.pixels, new Point(girlSprite.frame.frame.x, girlSprite.frame.frame.y), true);
		}
		
		
		
		//Stamp out the light of the silhouette:
		this.silhouette.stamp(this.mouseLightCone, Std.int(this.mouseLightCone.x), Std.int(this.mouseLightCone.y));
		this.silhouette.stamp(this.lampLightCone, Std.int(this.lampLightCone.x), Std.int(this.lampLightCone.y));
		this.silhouette.stamp(this.redLightCone, Std.int(this.redLightCone.x), Std.int(this.redLightCone.y));
		this.silhouette.stamp(this.fireShineCone, Std.int(this.fireShineCone.x), Std.int(this.fireShineCone.y));
		this.silhouette.stamp(this.fireSprite, Std.int(this.fireSprite.x), Std.int(this.fireSprite.y));
		
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
	 * Let's the girl turn around before she would leave the stage
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
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_lightMood > 0)
		{
			this.updateSilhouette();
			this.mouseLightCone.x = FlxG.mouse.screenX - Std.int(this.mouseLightCone.width / 2);
			this.mouseLightCone.y = FlxG.mouse.screenY - Std.int(this.mouseLightCone.height / 2);
		}
		
		if ((this.girlSprite.x < 10) || (this.girlSprite.x > 600))
		{
			girlDirection();
		}
	}
}
