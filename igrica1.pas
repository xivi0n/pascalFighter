program p1;
{$MODE OBJFPC}
uses sdl;
var Surface, RealSurface:PSDL_Surface;
    Running:Boolean=true;
    KeyState:array[0..1024] of Boolean;
    Background,Player1,Player2,HPBar1,HPBar2,HPRed1,HPRed2:PSDL_Surface;
    PlayerX1:integer=5;
    PlayerY1:integer=230;
    PlayerX2:integer=580;
    PlayerY2:integer=230;
    playerk1,playerk2,playerp1, playerk22:array[1..5] of PSDL_Surface;
    kick,hpchange:boolean;
    KickAnim1,KickAnim2,PunchAnim1:Cardinal;
    ScaleMode: Integer=1;
    Red1,Red2:integer;
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
    RealSurface:=SDL_SetVideoMode(640*ScaleMode, 360*ScaleMode, 24, Flags);
    with RealSurface^.format^ do
      Surface:=SDL_CreateRGBSurface(SDL_SWSURFACE, 640,360, 24, Rmask, Gmask, Bmask, Amask);
  end else begin
    Surface:=SDL_SetVideoMode(640, 360, Bits, Flags);
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
        playerk1[i]:=load('f'+s+'.bmp');
        end;
 for i:=1 to 3 do
        begin
        str(i,s);
        playerp1[i]:=Load('p1'+s+'.bmp');
        end;
 playerp1[4]:=Load('p12.bmp');
 Player2:=Load('idle2.bmp');
 for i:=1 to 3 do
        begin
        str(i,s);
        playerk2[i]:=load('g'+s+'.bmp');
        end;
 playerk2[4]:=load('g2.bmp');
 for i:=1 to 5 do
        begin
        str(i,s);
        playerk22[i]:=Load('gk2'+s+'.bmp');
        end;
 HPBar1:=Load('hppool1.bmp');
 HPBar2:=Load('hppool2.bmp');
 HPRed1:=Load('hptickreduce1.bmp');
 HPRed2:=Load('hptickreduce2.bmp');
end;
procedure DrawHPBars;
        var i:integer;
        begin
        Draw(0,5,HPBar1);
        Draw(320,5,HPBar2);
        for i:=1 to Red1 do
                begin
                Draw(286-i,11,HPRed1);
                end;
        for i:=1 to Red2 do
                begin
                Draw(326+i,11,HPRed2);
                end;
        SDL_FLip(Surface);
        end;
procedure DrawScreen;

begin
 Draw(0,0,Background);
 Draw(PlayerX1,PlayerY1,Player1);
 Draw(PlayerX2,PlayerY1,Player2);
 DrawHPBars;
 SDL_Flip(Surface);
end;

function ifDO(X1,X2:integer):boolean;
        begin
        if (abs(X2-X1)<=45) then ifDO:=true else ifDO:=false;
        end;

procedure DrawPunch1;
        procedure MovePlayer2(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D-25 < Player1) or (Player+D >580) then Exit;
                Player:=Player+D;
                end;
var i:integer;
begin
 for i:=1 to 4 do
        begin
        SDL_Delay(90);
        Draw(0,0,Background);
        DrawHPBars;
        if Key(SDLK_UP) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_RIGHT) then MovePlayer2(5,PlayerX1, PlayerX2);
        if Key(SDLK_LEFT) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_DOWN) then MovePlayer2(5,PlayerX1, PlayerX2);
        HPChange:=ifDO(PlayerX1,PlayerX2);
        if (HPChange=true) then Red2:=Red2+2;
        Draw(PlayerX2,PlayerY2,Player2);
        Draw(PlayerX1,PlayerY1,playerp1[i]);
        SDL_Flip(surface);
        end;
 SDL_Delay(100);
 PunchAnim1:=SDL_GetTicks();
end;

procedure DrawKick1;
        procedure MovePlayer2(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D-25 < Player1) or (Player+D >580) then Exit;
                Player:=Player+D;
                end;
var i:integer;
begin
for i:=1 to 5 do
 begin
 SDL_Delay(90);
 Draw(0,0,Background);
 DrawHPBars;
 if Key(SDLK_UP) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_RIGHT) then MovePlayer2(5,PlayerX1, PlayerX2);
        if Key(SDLK_LEFT) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_DOWN) then MovePlayer2(5,PlayerX1, PlayerX2);
 HPChange:=ifDO(PlayerX1,PlayerX2);
 if (HPChange=true) then Red2:=Red2+2;
 Draw(PlayerX2,PlayerY2,Player2);
 Draw(PlayerX1,PlayerY1,playerk1[i]);
 SDL_Flip(surface);
 end;
 SDL_Delay(100);
 KickAnim1:=SDL_GetTicks();
end;

procedure DrawKick2;
        procedure MovePlayer1(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D+25>Player1) or (Player+D<0) then Exit;
                Player:=Player+D;
                end;
var i:integer;
begin
for i:=1 to 4 do
 begin
 SDL_Delay(90);
 Draw(0,0,Background);
 DrawHPBars;
 if Key(SDLK_W) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_D) then MovePlayer1(5,PlayerX2, PlayerX1);
        if Key(SDLK_A) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_S) then MovePlayer1(5,PlayerX2, PlayerX1);
 HPChange:=ifDO(PlayerX1,PlayerX2);
 if (HPChange=true) then Red1:=Red1+2;
 Draw(PlayerX1,PlayerY1,Player1);
 Draw(PlayerX2,PlayerY2,playerk2[i]);
 SDL_Flip(surface);
 end;
SDL_Delay(100);
KickAnim2:=SDL_GetTicks();
end;

procedure DrawKick22;
        procedure MovePlayer1(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D+25>Player1) or (Player+D<0) then Exit;
                Player:=Player+D;
                end;
var i:integer;
begin
for i:=1 to 5 do
 begin
 SDL_Delay(90);
 Draw(0,0,Background);
 DrawHPBars;
 if Key(SDLK_W) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_D) then MovePlayer1(5,PlayerX2, PlayerX1);
        if Key(SDLK_A) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_S) then MovePlayer1(5,PlayerX2, PlayerX1);
 HPChange:=ifDO(PlayerX1,PlayerX2);
 if (HPChange=true) then Red1:=Red1+2;
 Draw(PlayerX1,PlayerY1,Player1);
 Draw(PlayerX2,PlayerY2,playerk22[i]);
 SDL_Flip(surface);
 end;
SDL_Delay(100);
KickAnim2:=SDL_GetTicks();
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
        HPChange:=true;
        if (HPChange=true) then DrawHPBars;
        if Key(SDLK_W) then MovePlayer1(-1,PlayerX2, PlayerX1)
                else if Key(SDLK_D) then MovePlayer1(1,PlayerX2, PlayerX1);
        if Key(SDLK_A) then MovePlayer1(-1,PlayerX2, PlayerX1)
                else if Key(SDLK_S) then MovePlayer1(1,PlayerX2, PlayerX1);
        if key(SDLK_Q) then
                if (SDL_GetTicks()-KickAnim1>400)
                        or (KickAnim1=0) then
                                DrawKick1;
        if Key(SDLK_E) then
                if (SDL_GetTicks()-PunchAnim1>400)
                        or (PunchAnim1=0) then
                                DrawPunch1;


        if Key(SDLK_UP) then MovePlayer2(-1,PlayerX1, PlayerX2)
                else if Key(SDLK_RIGHT) then MovePlayer2(1,PlayerX1, PlayerX2);
        if Key(SDLK_LEFT) then MovePlayer2(-1,PlayerX1, PlayerX2)
                else if Key(SDLK_DOWN) then MovePlayer2(1,PlayerX1, PlayerX2);
        if key(SDLK_L) then
                if (SDL_GetTicks()-KickAnim2>400) then
                                        DrawKick22;
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
