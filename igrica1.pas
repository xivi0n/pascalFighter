program p1;
{$MODE OBJFPC}
uses sdl;
var Surface, RealSurface:PSDL_Surface;
    Running:Boolean=true;
    KeyState:array[0..1024] of Boolean;
    Background,Player1,Player2:PSDL_Surface;
    PlayerX1:integer=100-1;
    PlayerY1:integer=250-1;
    PlayerX2:integer=580;
    PlayerY2:integer=249;
    playerf,playerg:array[1..5] of PSDL_Surface;
    kick,alive:boolean;
    Anim2Start,Anim2End, Anim1Start,Anim1End:Cardinal;
    ScaleMode: Integer=1;
procedure Draw(X,Y:integer;Surf:PSDL_Surface);
        var
        R:TSDL_Rect;
        begin
        R.x:=X;
        R.y:=Y;
        R.w:=Surf^.w;
        R.h:=Surf^.h;
        SDL_BlitSurface(Surf,nil,Surface,@R);
        end;
function Key(K:integer):Boolean;
        begin
        if (K >= Low(KeyState))and(K <= High(KeyState)) then Result:=Keystate[K] else Result:=False;
        end;
{function InitVideo:boolean;
        begin
        Surface:=SDL_SetVideoMode(640,384,24,SDL_DOUBLEBUF);
        Result:=assigned(Surface);
        end;}
function InitVideo: Boolean;
var
  Flags: Cardinal = SDL_DOUBLEBUF or SDL_SWSURFACE;
  I: Integer;
  Bits: Integer = 24;
begin
  for I:=1 to ParamCount do begin
    if ParamStr(I)='-fullscreen' then begin
      Flags:=Flags + SDL_FULLSCREEN;
      SDL_ShowCursor(0);
    end;
    if ParamStr(I)='-double' then ScaleMode:=2;
    if ParamStr(I)='-triple' then ScaleMode:=3;
    if ParamStr(I)='-8bit' then Bits:=8;
  end;
  if ScaleMode > 1 then begin
    RealSurface:=SDL_SetVideoMode(640*ScaleMode, 384*ScaleMode, 24, Flags);
    with RealSurface^.format^ do
      Surface:=SDL_CreateRGBSurface(SDL_SWSURFACE, 640,384, 24, Rmask, Gmask, Bmask, Amask);
  end else begin
    Surface:=SDL_SetVideoMode(640, 384, Bits, Flags);
    RealSurface:=Surface;
  end;
  Result:=Assigned(Surface);
end;

procedure LoadImages;
var i:integer; s:string;
function Load(Name:AnsiString):PSDL_Surface;
        begin
        Result:=SDL_LoadBMP(PChar(Name));
        SDL_SetColorKey(Result,SDL_SRCCOLORKEY or SDL_RLEACCEL,SDL_MapRGB(Result^.format,255,0,255));
        end;
begin
 Background:=SDL_LoadBMP('pozadina1.bmp');
 Player1:=Load('idle1.bmp');
 for i:=1 to 5 do
        begin
        str(i,s);
        playerf[i]:=load('f'+s+'.bmp');
        end;
 Player2:=Load('idle2.bmp');
 for i:=1 to 3 do
        begin
        str(i,s);
        playerg[i]:=load('g'+s+'.bmp');
        end;
end;

procedure DrawScreen;

begin
 Draw(0,0,Background);
 Draw(PlayerX1,PlayerY1,Player1);
 Draw(PlayerX2,PlayerY1,Player2);
 SDL_Flip(Surface);
end;

procedure DrawAnimations1;
        procedure MovePlayer2(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D-25 < Player1) or (Player+D >580) then Exit;
                Player:=Player+D;
                end;
var i:integer;
begin
Anim1Start:=SDL_GetTicks()-Anim1Start;
for i:=1 to 5 do
 begin
 SDL_Delay(90);
 Draw(0,0,Background);
 if Key(SDLK_UP) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_RIGHT) then MovePlayer2(5,PlayerX1, PlayerX2);
        if Key(SDLK_LEFT) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_DOWN) then MovePlayer2(5,PlayerX1, PlayerX2);
 Draw(PlayerX2,PlayerY2,Player2);
 Draw(PlayerX1,PlayerY1,playerf[i]);
 SDL_Flip(surface);
 end;
 SDL_Delay(100);
end;

procedure DrawAnimations2;
        procedure MovePlayer1(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D+25>Player1) or (Player+D<0) then Exit;
                Player:=Player+D;
                end;
var i:integer;
begin
Anim2Start:=SDL_GetTicks()-Anim2Start;
for i:=1 to 3 do
 begin
 SDL_Delay(90);
 Draw(0,0,Background);
 if Key(SDLK_W) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_D) then MovePlayer1(5,PlayerX2, PlayerX1);
        if Key(SDLK_A) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_S) then MovePlayer1(5,PlayerX2, PlayerX1);
 Draw(PlayerX1,PlayerY1,Player1);
 Draw(PlayerX2,PlayerY2,playerg[i]);
 SDL_Flip(surface);
 end;
SDL_Delay(100);
end;

procedure UpdateGame;

        procedure MovePlayer2(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D-25 < Player1) or (Player+D >580) then Exit;
                Player:=Player+D;
                end;
        procedure MovePlayer1(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D+25>Player1) or (Player+D<0) then Exit;
                Player:=Player+D;
                end;
        var R:TSDL_Rect;
        begin
        if Key(SDLK_W) then MovePlayer1(-1,PlayerX2, PlayerX1)
                else if Key(SDLK_D) then MovePlayer1(1,PlayerX2, PlayerX1);
        if Key(SDLK_A) then MovePlayer1(-1,PlayerX2, PlayerX1)
                else if Key(SDLK_S) then MovePlayer1(1,PlayerX2, PlayerX1);
        if key(SDLK_Q) then begin
                                Anim1End:=SDL_GetTicks()-Anim1End;
                                if (Anim1End-Anim1Start>200) or (Anim1Start=0) then
                                DrawAnimations1;
                                end;

        if Key(SDLK_UP) then MovePlayer2(-1,PlayerX1, PlayerX2)
                else if Key(SDLK_RIGHT) then MovePlayer2(1,PlayerX1, PlayerX2);
        if Key(SDLK_LEFT) then MovePlayer2(-1,PlayerX1, PlayerX2)
                else if Key(SDLK_DOWN) then MovePlayer2(1,PlayerX1, PlayerX2);
        if key(SDLK_L) then begin
                                Anim2End:=SDL_GetTicks()-Anim2End;
                                write(Anim2End);
                                if (Anim2End-Anim2Start>400) or (Anim2Start=0) then
                                DrawAnimations2;
                                end;
        end;

procedure MainLoop;
var LastTime,CurrentTime:Cardinal;



procedure HandleEvents;
var Ev:TSDL_Event;


procedure HandleKey(Sym:integer;Down:Boolean);
        begin
        if (Sym >= Low(KeyState))and(Sym <= High(KeyState)) then KeyState[Sym]:=Down;
        case Sym of
                SDLK_Escape:Running:=False;
                end;
        end;
        begin
        while SDL_PollEvent(@Ev) <> 0 do
                begin
                case Ev.Type_ of
                        SDL_QUITEV: Running:=False;
                        SDL_KEYDOWN:HandleKey(Ev.Key.KeySym.Sym,True);
                        SDL_KEYUP:HandleKey(Ev.Key.KeySym.Sym, False);
                        end;
                end;
        end;

begin
LastTime:=SDL_GetTicks();
while Running do
        begin
        CurrentTime:=SDL_GetTicks();
        if CurrentTime - LastTime > 1000 then LastTime:=CurrentTime - 60;
        {while CurrentTime - LastTime>1000/30 do begin
                UpdateGame;
                inc(LastTime,30);
                end;}
        UpdateGame;
        HandleEvents;
        DrawScreen;
        end;
end;
begin
 SDL_INIT(SDL_INIT_VIDEO);
 If not InitVideo then Exit;
 SDL_WM_SetCaption('game','game');
 LoadImages;
 DrawScreen;
 MainLoop;
 SDL_Quit;
end.
