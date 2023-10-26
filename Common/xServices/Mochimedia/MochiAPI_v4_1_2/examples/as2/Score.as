﻿import mochi.as2.*;import ui.*;class Score{    private static var WALL_WIDTH:Number = 16;    private static var BALL_SIZE:Number = 8;        private static var PADDLE_WIDTH:Number = 48;    private static var PADDLE_HEIGHT:Number = 16;    private static var PLAYFIELD_WIDTH:Number = 400;    private static var PLAYFIELD_HEIGHT:Number = 300;                private static var _clip:MovieClip;    private static var _scoreDisplay:TextField;    private static var _score:MochiDigits;    private static var _ballPos:Object;    private static var _ballVelocity:Object;    private static var _paddlePos:Number;    private static var _speed:Number;                public static function create():Void    {        _clip = Init.clip.createEmptyMovieClip( '_playfield', Init.clip.getNextHighestDepth() );                _clip.createTextField( '_scoreDisplay', _clip.getNextHighestDepth(), WALL_WIDTH, WALL_WIDTH, 1, 1 );        _scoreDisplay = _clip._scoreDisplay;        _scoreDisplay.setNewTextFormat( new TextFormat( '_typewriter', 18, 0xFFFFFF, true ) );        _scoreDisplay.selectable = false;        _scoreDisplay.autoSize = 'left';                _clip.onEnterFrame = function():Void { Score.step(); };        _clip.onMouseMove = function():Void { Score.movePaddle(); };                            MochiSocial.addEventListener( MochiSocial.LOGGED_IN, remove );        MochiSocial.addEventListener( MochiSocial.LOGGED_OUT, remove );                Core.addEventListener( Core.RESIZED, center );        reset();    }        private static function endGame():Void    {        // BOARD_O is the board ID, obfuscated to help prevent hacking		// This value is private and should never be stored plain-text.		var BOARD_O:Object = { n: [11, 12, 5, 13, 10, 15, 0, 11, 1, 6, 0, 3, 2, 3, 5, 5], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};		var BOARD_ID:String = BOARD_O.f(0,"");		MochiScores.showLeaderboard({            boardID: BOARD_ID,             score: _score.value,            onClose: Core.returnToMain        });    }        private static function remove():Void    {        Core.removeEventListener( Core.RESIZED, center );        _clip.unloadMovie();                MochiSocial.removeEventListener( MochiSocial.LOGGED_IN, remove );        MochiSocial.removeEventListener( MochiSocial.LOGGED_OUT, remove );    }                public static function reset():Void    {        _score = new MochiDigits(0);        _scoreDisplay.text = '0';        _ballVelocity = { x:0, y: 1 };        _ballPos = { x:PLAYFIELD_WIDTH / 2, y:PLAYFIELD_HEIGHT / 2 };        _paddlePos = (PLAYFIELD_WIDTH - PADDLE_WIDTH) / 2;        _speed = 4;                redraw();        center();    }        private static function movePaddle():Void    {        _paddlePos = _clip._xmouse - PADDLE_WIDTH / 2;                if( _paddlePos < WALL_WIDTH )            _paddlePos = WALL_WIDTH;        else if( _paddlePos >= (PLAYFIELD_WIDTH - PADDLE_WIDTH - WALL_WIDTH) )            _paddlePos = PLAYFIELD_WIDTH - PADDLE_WIDTH - WALL_WIDTH;    }        private static function center():Void    {        _clip._x = (Stage.width - _clip._width) / 2;        _clip._y = (Stage.height - _clip._height) / 2;    }        private static function step():Void    {        var adjust:Number = Math.sqrt( _ballVelocity.x * _ballVelocity.x + _ballVelocity.y * _ballVelocity.y );        _ballVelocity.x *= _speed / adjust;        _ballVelocity.y *= _speed / adjust;                _ballPos.x += _ballVelocity.x;        _ballPos.y += _ballVelocity.y;                 // HIT THE TOP!        if( _ballPos.y < WALL_WIDTH + BALL_SIZE )        {            _ballPos.x -= _ballVelocity.x;            _ballPos.y -= _ballVelocity.y;            _ballVelocity.y = -_ballVelocity.y;            _speed += 0.05;        }        if( _ballPos.x < WALL_WIDTH + BALL_SIZE || _ballPos.x >= PLAYFIELD_WIDTH - WALL_WIDTH - BALL_SIZE )        {            _ballPos.x -= _ballVelocity.x;            _ballPos.y -= _ballVelocity.y;            _ballVelocity.x = -_ballVelocity.x;            _speed += 0.05;        }                if( _ballPos.y > PLAYFIELD_HEIGHT - PADDLE_HEIGHT - BALL_SIZE )        {            _ballPos.x -= _ballVelocity.x;            _ballPos.y -= _ballVelocity.y;            if( Math.abs( _paddlePos + PADDLE_WIDTH / 2 - _ballPos.x ) > PADDLE_WIDTH / 2 )            {                endGame();                remove();            }            else            {                                    _ballVelocity.x -= _paddlePos + PADDLE_WIDTH / 2;                _ballVelocity.y -= PLAYFIELD_HEIGHT - PADDLE_HEIGHT / 2;                            _scoreDisplay.text = (++_score.value).toString();                _speed += 0.1;            }        }        redraw();    }        private static function redraw():Void    {        _clip.clear();        // Draw walls        _clip.beginFill( 0xFFFFFF );        Drawing.drawBox( _clip, 0, 0, PLAYFIELD_WIDTH, PLAYFIELD_HEIGHT );        _clip.endFill();                // Clear playfield        _clip.beginFill( 0 );        Drawing.drawBox( _clip,            WALL_WIDTH,             WALL_WIDTH,             PLAYFIELD_WIDTH - WALL_WIDTH * 2,             PLAYFIELD_HEIGHT - WALL_WIDTH );        _clip.endFill();                // Draw the ball        _clip.beginFill( 0xFFFFFF );        Drawing.drawRoundedBox( _clip,            _ballPos.x - BALL_SIZE,            _ballPos.y - BALL_SIZE,            BALL_SIZE * 2,            BALL_SIZE * 2,            BALL_SIZE );        _clip.endFill();                // Draw the paddle        _clip.beginFill( 0xFFFFFF );        Drawing.drawBox( _clip,            _paddlePos,            PLAYFIELD_HEIGHT - PADDLE_HEIGHT,            PADDLE_WIDTH,            PADDLE_HEIGHT                          );        _clip.endFill();    }}