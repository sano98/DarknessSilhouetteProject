package;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemapBuffer;
import flixel.FlxCamera;
import flixel.FlxObject;

class PlayState extends FlxState
{
	
	public var brickTileMap:FlxTilemap;
	public var brickString:String;
	
	public var couchSprite:FlxSprite;
	public var cloudSprite:FlxSprite;
	
	public var girlSprite:FlxSprite;
	
	public var silhouette:FlxSprite;
	
	public var darkness:BitmapData;
	
	public var tileMapBuffer:FlxTilemapBuffer;
	
	public var lightCone:FlxSprite;
	public var mouseLightCone:FlxSprite;
	
	public var lightButton:FlxButton;
	
	private var _day:Bool;
	
	
	override public function create():Void
	{
		FlxG.worldBounds.set( 0, 0, 640, 480); 
		FlxG.camera.setScrollBoundsRect(0, 0, 640, 480, true);
		
		this._day = true;
		
		super.create();
		
		this.bgColor = 0xFF77AAFF;
		
		this.silhouette = new FlxSprite(0, 0);
		this.silhouette.makeGraphic(640, 480, 0x00000000);
		this.darkness = new BitmapData(640, 480, true, 0xFF000000);
		
		this.tileMapBuffer = new FlxTilemapBuffer(32, 32, 20, 8);
		
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
		//this.brickTileMap.loadMapFrom2DArray([[0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3,], [2, 3, 2, 1, 4, 4, 4, 4, 2, 1, 0, 3, ]], "assets/images/tile_brickwall2.png", 32, 32, 0,  0, 0);
		this.add(brickTileMap);
		
	
		
		this.couchSprite = new FlxSprite(100, 211);
		this.couchSprite.loadGraphic("assets/images/gameObject_armchairB.png", false, 59, 45, false);
		this.add(this.couchSprite);
		
		this.girlSprite = new FlxSprite(370, 193);
		girlSprite.loadGraphic("assets/images/arron jes cycle.png", true, 48, 61, true);
		//this.girl.pixels = this.bitmapColorTransform(girl.pixels, testColorTransform);
		girlSprite.animation.add("running", [0, 1, 2, 3, 4, 5, 6, 7], 16);
		girlSprite.animation.callback = function(n:String, frameNumber:Int, frameIndex:Int):Void
		{
			//trace("new frame");
			//this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), new Point(this.girlSprite.x + 50 * frameNumber, this.girlSprite.y), this.girlSprite.framePixels, null, true);
		}
		this.add(girlSprite);
		this.girlSprite.animation.play("running");
		
		this.girlSprite.setFacingFlip(FlxObject.LEFT, true, false);
		this.girlSprite.setFacingFlip(FlxObject.RIGHT, false, false);
		
		this.girlSprite.velocity.x = 100;
		
		this.lightCone = new FlxSprite(320, 211);
		this.lightCone.loadGraphic("assets/images/glow-light.png", false, 64, 64, false);
		
		this.mouseLightCone = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
		this.mouseLightCone.loadGraphic("assets/images/glow-light.png", false, 64, 64, false);
		
		this.add(this.silhouette);
		this.silhouette.blend = MULTIPLY;
		//this.updateSilhouette();
		
		this.lightButton = new FlxButton(550, 20, "Day/Night", onLightButtonClick);
		this.add(this.lightButton);
		
	}
	
	
	public function updateSilhouette():Void
	{
		
		
		this.silhouette.pixels = new BitmapData(640, 480, true, 0x000000);
		
		this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), new Point(this.couchSprite.x, this.couchSprite.y), this.couchSprite.pixels, new Point (0,0), true);
		
		
		
		this.brickTileMap.drawTilemap(this.tileMapBuffer, this.camera);
		this.silhouette.pixels.copyPixels(this.darkness, new Rectangle(0, 0, 640, 480), new Point(0, 0), this.tileMapBuffer.pixels, new Point (0,0), true);
		
		
		var _flashPoint = new Point(0, 0);
		var _flashRect2 = new Rectangle(0, 0, 1, 1);
		
		
		_flashPoint.x = girlSprite.frame.frame.x;
		_flashPoint.y = girlSprite.frame.frame.y;
		_flashRect2.width =  this.girlSprite.framePixels.width;
		_flashRect2.height =  this.girlSprite.framePixels.height;
		
		this.silhouette.pixels.copyPixels(this.darkness, _flashRect2, new Point(this.girlSprite.x, this.girlSprite.y), this.girlSprite.framePixels, new Point (0,0), true);
		
		//this.silhouette.pixels.copyPixels(this.darkness, _flashRect2, new Point(this.girlSprite.x, this.girlSprite.y), this.girlSprite.pixels, _flashPoint, true);
		_flashRect2.width =  this.girlSprite.framePixels.width;
		_flashRect2.height =  this.girlSprite.framePixels.height;
		
		
		
		//this.silhouette.pixels.copyPixels(this.emptiness, new Rectangle(this.lightCone.x, this.lightCone.y, this.lightCone.width, this.lightCone.height), new Point(this.lightCone.x, this.lightCone.y), this.lightCone.pixels, new Point (0,0), true);
		
		
		
		this.silhouette.stamp(this.lightCone, Std.int(this.lightCone.x), Std.int(this.lightCone.y));
		this.silhouette.stamp(this.mouseLightCone, Std.int(this.mouseLightCone.x), Std.int(this.mouseLightCone.y));
		
		this.silhouette.alpha = 0.9;
		//this.silhouette.blend = LIGHTEN;
	}
	
	
	
	public function onLightButtonClick():Void
	{
		if (_day)
		{
			this.bgColor = 0xFF112233;
			this.cloudSprite.color = 0xFF112233;
			this.silhouette.visible = true;
		}
		else
		{
			this.bgColor = 0xFF77AAFF;
			this.cloudSprite.color = 0xFFFFFFFF;
			this.silhouette.visible = false;
		}
		
		_day = !_day;
	}
	
	
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
		
		
		if (!(this._day))
		{
			this.updateSilhouette();
			this.mouseLightCone.x = FlxG.mouse.screenX - Std.int(this.mouseLightCone.width / 2);
			this.mouseLightCone.y = FlxG.mouse.screenY - Std.int(this.mouseLightCone.height / 2);
		}
		
		
		
		if ((this.girlSprite.x < 10) || (this.girlSprite.x > 600))
		{
			girlDirection();
		}
		
		super.update(elapsed);
	}
}
