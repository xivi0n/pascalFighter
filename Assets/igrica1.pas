program p1;
{$MODE OBJFPC}
uses sdl;
var Surface, RealSurface:PSDL_Surface;
    Running:Boolean=true;
    MainMenu:Boolean=true;
    SelectMode: Boolean = True;
    Controls: Boolean = True;
    notQuit: Boolean=true;
    KeyState:array[0..1024] of Boolean;
    Background,Player1,Player2,
        HPBar1,HPBar2,
        HPRed1,HPRed2,
        UltimateTick,UltiReady,UltiBlack,
        StartButton,ExitButton,
        ChooseMode,PlayerControls,
        round0, round1, round2, dots,
        PlayerOneWin,PlayerTwoWin,
        Dmg1, Dmg2,Dmg22:PSDL_Surface;
    PlayerX1:integer=5;
    PlayerY1:integer=230;
    PlayerX2:integer=580;
    PlayerY2:integer=230;
    playerk1,playerk2,
        playerp1, playerp2,
        playerk22,
        playerd2,playerd1,
        bk1,bk2,bk3,bk5,
        gu,pu:array[1..25] of PSDL_Surface;
    kick,hpchange:boolean;
    KickAnim1,KickAnim2,PunchAnim1, lastMove:Cardinal;
    ScaleMode: Integer=1;
    Red1,Red2, M,bki,bk3i,
    UltiBar1, UltiBar2,
    bk5i, bk2i,
    RoundWin1, RoundWin2,
    Mode:integer;
    label statement;
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
    if ParamStr(I)='-8bit' then Bits:=24;
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
 for i:=1 to 4 do
        begin
        str(i,s);
        bk1[i]:=load('bk1'+s+'.bmp');
        end;
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
 for i:=1 to 5 do
        begin
        str(i,s);
        playerd2[i]:=Load('gd'+s+'.bmp');
        end;
 for i:=1 to 5 do
        begin
        str(i,s);
        playerd1[i]:=Load('pd'+s+'.bmp');
        end;
 for i:=1 to 8 do
        begin
        str(i,s);
        bk5[i]:=Load('bk5'+s+'.bmp');
        end;
 for i:=1 to 4 do
        begin
        str(i,s);
        playerp2[i]:=Load('gp'+s+'.bmp');
        end;
 playerp2[5]:=Load('gp3.bmp');

 for i:=1 to 16 do
        begin
        str(i,s);
        bk2[i]:=Load('bk2'+s+'.bmp');
        end;
 for i:=0 to 7 do
        begin
        str(i,s);
        bk3[i+1]:=Load('tmp-'+s+'.bmp');
        end;

 for i:=1 to 12 do
        begin
        str(i,s);
        gu[i]:=Load('gu'+s+'.bmp');
        end;
 for i:=1 to 14 do
        begin
        str(i,s);
        pu[i]:=Load('pu'+s+'.bmp');
        end;

 Dmg1:=Load('player1fly.bmp');
 Dmg2:=Load('player2fly.bmp');
 Dmg22:=Load('player2fly2.bmp');
 round0:=Load('0.bmp');
 round1:=Load('1.bmp');
 round2:=Load('2.bmp');
 Dots:=Load('dots.bmp');
 HPBar1:=Load('hppool1.bmp');
 HPBar2:=Load('hppool2.bmp');
 HPRed1:=Load('hptickreduce1.bmp');
 HPRed2:=Load('hptickreduce2.bmp');
 UltimateTick:=Load('ultimateTick.bmp');
 ExitButton:=Load('pressEsc.bmp');
 StartButton:=Load('pressStart.bmp');
 UltiReady:=Load('ultimateready.bmp');
 UltiBlack:=Load('UltimateBlack.bmp');
 PlayerControls:=Load('playerControls.bmp');
 ChooseMode:=Load('chooseMode.bmp');
 PlayerOneWin:=Load('playeronewin.bmp');
 PlayerTwoWin:=Load('PlayerTwoWin.bmp');
end;

procedure DrawBackground;
        begin
        if (bki=4) then bki:=1
                else bki:=bki+1;
        SDL_Delay(30);
        Draw(0,0,bk1[bki]);
        end;

procedure DrawMainMenu;
var
  Ev: TSDL_Event;
  MainMenu: Boolean = True;
begin
  while MainMenu do begin
    while SDL_PollEvent(@Ev) <> 0 do begin
      case Ev.Type_ of
        SDL_QUITEV: begin
          Running:=False;
          MainMenu:=False;
          SelectMode:=False;
          Controls:=False;
          notQuit:=False;
        end;
        SDL_KEYDOWN: case Ev.Key.KeySym.Sym of
          SDLK_ESCAPE: begin
            Running:=False;
            MainMenu:=False;
            SelectMode:=False;
            Controls:=False;
            NotQuit:=false;
          end;
          SDLK_S: MainMenu:=False;
        end;
      end;
    end;
    if (bk5i=8) then bk5i:=1
                        else bk5i:=bk5i+1;
                        SDL_Delay(125);
    SDL_BlitSurface(bk5[bk5i], nil, Surface, nil);
    Draw(20,50,StartButton);
    Draw(20,120,ExitButton);
    SDL_Flip(surface);
  end;
end;

procedure DrawPlayerControl;
var
  Ev: TSDL_Event;
begin
  while Controls do begin
    while SDL_PollEvent(@Ev) <> 0  do begin
      case Ev.Type_ of
        SDL_QUITEV: begin
          Running:=False;
          Controls:=False;
          notQuit:=false;
        end;
        SDL_KEYDOWN: case Ev.Key.KeySym.Sym of
          SDLK_ESCAPE: begin
            Running:=False;
            Controls:=False;
            notQuit:=false;
          end;
          SDLK_Space: begin Controls:=False; end;
        end;
      end;
    end;
    if (bk3i=8) then bk3i:=1
                        else bk3i:=bk3i+1;
                        SDL_Delay(125);
    SDL_BlitSurface(bk3[bk3i], nil, Surface, nil);
    Draw(4,12,PlayerControls);
    SDL_Flip(surface);
  end;
end;

procedure DrawSelectMode;
var
  Ev: TSDL_Event;
begin
  while SelectMode do begin
    while SDL_PollEvent(@Ev) <> 0 do begin
      case Ev.Type_ of
        SDL_QUITEV: begin
          Running:=False;
          SelectMode:=False;
          notQuit:=false;
        end;
        SDL_KEYDOWN: case Ev.Key.KeySym.Sym of
          SDLK_ESCAPE: begin
            Running:=False;
            SelectMode:=False;
            Controls:=False;
            notQuit:=false;
          end;
          SDLK_1: begin SelectMode:=False; Mode:=1; end;
          SDLK_2: begin SelectMode:=False; Mode:=2; end;
          SDLK_3: begin SelectMode:=False; Mode:=3; end;
          SDLK_4: begin SelectMode:=False; Mode:=4; end;
        end;
      end;
    end;
    if (bk2i=16) then bk2i:=1
                        else bk2i:=bk2i+1;
                        SDL_Delay(125);
    SDL_BlitSurface(bk2[bk2i], nil, Surface, nil);
    Draw(4,12,ChooseMode);
    SDL_Flip(surface);
  end;
end;
{procedure DrawMainMenu;
        begin
        Repeat
                begin
                if (bk5i=8) then bk5i:=1
                        else bk5i:=bk5i+1;
                        SDL_Delay(125);
                        Draw(0,26,bk5[bk5i]);
                        SDL_Flip(Surface);
                end;
        until Key(SDLK_I)=true;
        end;    }

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
        end;

procedure DrawUltimateBars;
        var i:integer;
        begin
        Draw(0,50,UltiBlack);
        Draw(440,50,UltiBlack);
        for i:=1 to UltiBar1 do
                begin
                Draw(0+i,50,UltimateTick);
                end;
        for  i:=UltiBar2 downto 1 do
                begin
                Draw(640-i,50,UltimateTick);
                end;
        if (UltiBar2=200) then Draw(480,55,UltiReady);
        if (UltiBar1=200) then Draw(5,55,UltiReady);
        end;
procedure DrawScreen;

begin
 DrawBackground;
 Draw(PlayerX2,PlayerY1,Player2);
 Draw(PlayerX1,PlayerY1,Player1);
 DrawHPBars;
 DrawUltimateBars;
 SDL_Flip(Surface);
end;

function ifDO(X1,X2:integer):boolean;
        begin
        if (abs(X2-X1)<=45) then ifDO:=true else ifDO:=false;
        end;
procedure DrawUltimate1;

        procedure MovePlayer2(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D-25 < Player1) or (Player+D >580) then Exit;
                Player:=Player+D;
                end;

        var i,Y,j:integer; PL:PSDL_Surface;
begin
 PL:=Player1;
 Y:=PlayerY1;
 HPChange:=ifDO(PlayerX1,PlayerX2);
 if (HPChange=false) then PL:=Player2;
 for i:=1 to 14 do
        begin
        SDL_Delay(80);
        DrawBackground;
        DrawUltimateBars;
        DrawHPBars;
        if (HPChange=true) then begin
                                        if (i=1) then  PL:=Dmg2;
                                        if (i=6) then PlayerY2:=PlayerY2-15;
                                        if (i=14) then begin PlayerX2:=PlayerX2+10;
                                                for j:=1 to 5 do
                                                                begin
                                                                SDL_Delay(1);
                                                                DrawBackground;
                                                                DrawUltimateBars;
                                                                DrawHPBars;
                                                                PlayerY2:=PlayerY2+3;
                                                                Draw(PlayerX2,PlayerY2,PL);
                                                                Draw(PlayerX1,PlayerY1,pu[13]);
                                                                SDL_FLip(surface);
                                                                end;
                                                end;
                                        Red2:=Red2+7;
                                        end;
        Draw(PlayerX2,PlayerY2,Pl);
        Draw(PlayerX1,PlayerY1,pu[i]);
        SDL_Flip(surface);
        end;
if (HPChange=true) then begin
        DrawBackground;
        DrawUltimateBars;
        DrawHPBars;
        Draw(PlayerX2,PlayerY2,Dmg22);
        Draw(PlayerX1,PlayerY1,pu[14]);
        SDL_Flip(Surface);
        SDL_Delay(250);
        DrawBackground;
        DrawUltimateBars;
        DrawHPBars;
        Draw(PlayerX2,PlayerY2,Dmg2);
        Draw(PlayerX1,PlayerY1,pu[14]);
        SDL_Flip(Surface);
        SDL_Delay(250);
        end;
end;
procedure DrawUltimate2;

        procedure MovePlayer1(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D+25>Player1) or (Player+D<0) then Exit;
                Player:=Player+D;
                end;

        var i,Y:integer; PL:PSDL_Surface;
begin
 PL:=Player1;
 Y:=PlayerY1;
 HPChange:=ifDO(PlayerX1,PlayerX2);
 for i:=1 to 12 do
        begin
        SDL_Delay(80);
        DrawBackground;
        DrawUltimateBars;
        DrawHPBars;
        if (HPChange=true) then begin
                                        if (i=10) then begin PL:=Dmg1; PlayerY1:=PlayerY1-15; end;
                                        Red1:=Red1+7;
                                        end;
        Draw(PlayerX1,PlayerY1,Pl);
        Draw(PlayerX2,PlayerY2,gu[i]);
        SDL_Flip(surface);
        end;
if (HPChange=true) then
        for i:=1 to 10 do
                begin
                SDL_Delay(40);
                DrawBackground;
                DrawUltimateBars;
                DrawHPBars;
                MovePlayer1(-20,PlayerX2, PlayerX1);
                Draw(PlayerX1,PlayerY1,Dmg1);
                Draw(PlayerX2,PlayerY2,gu[12]);
                SDL_FLip(surface);
                end;
if (Y<>PlayerY1) then PlayerY1:=PlayerY1+15;
end;
procedure DrawDeath2;
        var i:integer;
        begin
        for i:=1 to 5 do
                begin
                SDL_Delay(150);
                //DrawUltimateBars;
                DrawBackground;
                //DrawHPBars;
                Draw(PlayerX1, PlayerY1, Player1);
                Draw(PlayerX2, PlayerY2, playerd2[i]);
                SDL_Flip(surface);
                end;
        end;

procedure DrawDeath1;
        var i:integer;
        begin
        for i:=1 to 5 do
                begin
                SDL_Delay(150);
                //DrawUltimateBars;
                DrawBackground;
                //DrawHPBars;
                Draw(PlayerX2, PlayerY2, Player2);
                Draw(PlayerX1, PlayerY1, playerd1[i]);
                SDL_Flip(surface);
                end;
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
        SDL_Delay(40);
        DrawBackground;
        DrawUltimateBars;
        DrawHPBars;
        if Key(SDLK_UP) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_RIGHT) then MovePlayer2(5,PlayerX1, PlayerX2);
        if Key(SDLK_LEFT) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_DOWN) then MovePlayer2(5,PlayerX1, PlayerX2);
        Draw(PlayerX2,PlayerY2,Player2);
        Draw(PlayerX1,PlayerY1,playerp1[i]);
        HPChange:=ifDO(PlayerX1,PlayerX2);
        if (HPChange=true) then begin   MovePlayer2(10,PlayerX1,PlayerX2);
                                        Red2:=Red2+2;
                                        end;
        SDL_Flip(surface);
        end;
 PunchAnim1:=SDL_GetTicks();
SDL_Delay(100);
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
 DrawBackground;
 DrawUltimateBars;
 DrawHPBars;
 if Key(SDLK_UP) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_RIGHT) then MovePlayer2(5,PlayerX1, PlayerX2);
        if Key(SDLK_LEFT) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_DOWN) then MovePlayer2(5,PlayerX1, PlayerX2);
 HPChange:=ifDO(PlayerX1,PlayerX2);
 if (HPChange=true) then begin Red2:=Red2+2; movePlayer2(2,PlayerX1, PlayerX2); end;
 Draw(PlayerX2,PlayerY2,Player2);
 Draw(PlayerX1,PlayerY1,playerk1[i]);
 SDL_Flip(surface);
 SDL_Delay(40);
 end;
 KickAnim1:=SDL_GetTicks();
SDL_Delay(100);
end;


procedure DrawPunch2;
        procedure MovePlayer1(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D+25>Player1) or (Player+D<0) then Exit;
                Player:=Player+D;
                end;
var i:integer;
begin
for i:=1 to 5 do
 begin
 SDL_Delay(40);
 DrawBackground;
 DrawUltimateBars;
 DrawHPBars;
 if Key(SDLK_W) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_D) then MovePlayer1(5,PlayerX2, PlayerX1);
        if Key(SDLK_A) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_S) then MovePlayer1(5,PlayerX2, PlayerX1);
 HPChange:=ifDO(PlayerX1,PlayerX2);
 if (HPChange=true) then begin Red1:=Red1+2; movePlayer1(-5,PlayerX2, PlayerX1); end;
 Draw(PlayerX1,PlayerY1,Player1);
 Draw(PlayerX2,PlayerY2,playerp2[i]);
 SDL_Flip(surface);
 if (i=4) then SDL_Delay(100);
 end;
KickAnim2:=SDL_GetTicks();
SDL_Delay(100);
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
 SDL_Delay(40);
 DrawBackground;
 DrawUltimateBars;
 DrawHPBars;
 if Key(SDLK_W) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_D) then MovePlayer1(5,PlayerX2, PlayerX1);
        if Key(SDLK_A) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_S) then MovePlayer1(5,PlayerX2, PlayerX1);
 HPChange:=ifDO(PlayerX1,PlayerX2);
 if (HPChange=true) then begin Red1:=Red1+2; movePlayer1(-10,PlayerX2, PlayerX1); end;
 Draw(PlayerX1,PlayerY1,Player1);
 Draw(PlayerX2,PlayerY2,playerk22[i]);
 SDL_Flip(surface);
 end;
KickAnim2:=SDL_GetTicks();
SDL_Delay(100);
end;
procedure ResetGame;
        begin
        PlayerX1:=5;
        PlayerY1:=230;
        PlayerX2:=580;
        PlayerY2:=230;
        Red1:=0;
        Red2:=0;
        UltiBar1:=0;
        UltiBar2:=0;
        end;
procedure DrawStatus;
        begin
        case RoundWin1 of
                0: Draw(150,60,round0);
                1: Draw(150,60,round1);
                2: Draw(150,60,round2);
                end;
        Draw(255,60,Dots);
        case RoundWin2 of
                 0: Draw(340,60,round0);
                 1: Draw(340,60,round1);
                 2: Draw(340,60,round2);
                 end;
        SDL_Flip(Surface);
        SDL_Delay(5000);
        end;
procedure Player1WIN;
        begin
        DrawDeath2;
        if (RoundWin1<=1) then begin ResetGame; RoundWin1:=RoundWin1+1; end;
        if (RoundWin1=2) then Running:=false;
        DrawStatus;
        if (roundWin1=2) then
                begin
                DrawBackground;
                Draw(PlayerX2,PlayerY2,playerd2[5]);
                Draw(PlayerX1,PlayerY1,Player1);
                Draw(120,60,PlayerOneWin);
                SDL_Flip(Surface);
                SDL_Delay(10000);
                end;
        end;

procedure Player2WIN;
        begin
        DrawDeath1;
        if (RoundWin2<=1) then Begin ResetGame; RoundWin2:=RoundWin2+1; end;
        if (RoundWin2=2) then Running:=false;
        write(roundwin2,' ', red1,' ',red2);
        DrawStatus;
        if (roundWin2=2) then
                begin
                DrawBackground;
                Draw(PlayerX1,PlayerY1,playerd1[5]);
                Draw(PlayerX2,PlayerY2,Player2);
                Draw(120,60,PlayerTwoWin);
                SDL_Flip(Surface);
                SDL_Delay(10000);
                end;
        end;
procedure Bot1;

        procedure MovePlayer1(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D+25>Player1) or (Player+D<0) then Exit;
                Player:=Player+D;
                end;
         procedure CheckForUlti1;
                begin
                if (UltiBar1=200) then begin  UltiBar1:=0; DrawUltimate1; end;
                end;

                procedure moveBot;
                        var lastMove1:Cardinal; K:integer;
                        begin
                        K:=Random(10000);
                        write(k);
                        if (M=0) then begin m:=m+1; lastmove:=SDL_GetTicks(); end;
                        if ((Red1<=Red2) or (SDL_GetTicks()-lastMove>5000))
                                and (K>100)
                         then begin
                                 movePlayer1(5, PlayerX2, PlayerX1);
                                 if (SDL_GetTicks()-lastMove>10000) then lastMove:=SDL_GetTicks();
                                end
                         else
                                begin
                                movePlayer1(-5,PlayerX2,PlayerX1);
                                end;
                        end;
        var k:integer;
        begin
        K:=Random(10000);
        if (ifDo(PlayerX2,PlayerX1)=true) then
                begin
                if (K<8500)  then moveBot
                        else if (SDL_GetTicks()-KickAnim2>400) then
                                begin
                                        CheckForUlti1;
                                        if (Random(2)=1) then DrawKick1
                                         else DrawPunch1;
                                end;
                end
                else moveBot;
        end;
procedure Bot2;

        procedure MovePlayer2(D:integer; Player1:integer; var Player:integer);
                begin
                if(Player+D-25 < Player1) or (Player+D >580) then Exit;
                Player:=Player+D;
                end;
        procedure CheckForUlti2;
                begin
                if (UltiBar2=200) then begin  UltiBar2:=0; DrawUltimate2; end;
                end;

                procedure moveBot;
                        var lastMove1:Cardinal; K:integer;
                        begin
                        K:=Random(10000);
                        if (M=0) then begin m:=m+1; lastmove:=SDL_GetTicks(); end;
                        if ((Red1>=Red2) or (SDL_GetTicks()-lastMove>5000))
                                and (K>100)
                         then begin
                                 movePlayer2(-5, PlayerX1, PlayerX2);
                                 if (SDL_GetTicks()-lastMove>10000) then lastMove:=SDL_GetTicks();
                                end
                         else
                                begin
                                movePlayer2(5,PlayerX1,PlayerX2);
                                end;
                        end;
        var k:integer;
        begin
        K:=Random(10000);
        if (ifDo(PlayerX1,PlayerX2)=true) then
                begin
                if (K<8500)  then moveBot
                        else if (SDL_GetTicks()-KickAnim2>400) then
                                begin
                                        CheckForUlti2;
                                        if (Random(2)=1) then DrawKick22
                                         else DrawPunch2;
                                end;
                end
                else moveBot;
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

        procedure CheckForUlti1;
                begin
                if (UltiBar1=200) then begin  UltiBar1:=0; DrawUltimate1; end;
                end;
        procedure CheckForUlti2;
                begin
                if (UltiBar2=200) then begin  UltiBar2:=0; DrawUltimate2; end;
                end;

        var R:TSDL_Rect;
        begin
        HPChange:=true;
        if (HPChange=true) then DrawHPBars;
        if Key(SDLK_W) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_D) then MovePlayer1(5,PlayerX2, PlayerX1);
        if Key(SDLK_A) then MovePlayer1(-5,PlayerX2, PlayerX1)
                else if Key(SDLK_S) then MovePlayer1(5,PlayerX2, PlayerX1);
        if key(SDLK_R) then
                if (SDL_GetTicks()-KickAnim1>400)
                        or (KickAnim1=0) then
                                DrawKick1;
        if Key(SDLK_T) then
                if (SDL_GetTicks()-PunchAnim1>400)
                        or (PunchAnim1=0) then
                                DrawPunch1;

        if (Mode=2) or (Mode=4) then Bot2;
        if (Mode=3) or (Mode=4) then Bot1;

        if Key(SDLK_UP) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_RIGHT) then MovePlayer2(5,PlayerX1, PlayerX2);
        if Key(SDLK_LEFT) then MovePlayer2(-5,PlayerX1, PlayerX2)
                else if Key(SDLK_DOWN) then MovePlayer2(5,PlayerX1, PlayerX2);
        if key(SDLK_J) then
                if (SDL_GetTicks()-KickAnim2>400) then
                                        DrawKick22;
        if key(SDLK_K) then
                if (SDL_GetTicks()-KickAnim2>400) then
                                        DrawPunch2;
        if Key(SDLK_Y) then if (UltiBar1=200) then CheckForUlti1;
        if Key(SDLK_L) then if (UltiBar2=200) then CheckForUlti2;
        end;

procedure MainLoop;
var LastTime,CurrentTime:Cardinal;
 i:integer;



procedure HandleEvents;
var Ev:TSDL_Event;


procedure HandleKey(Sym:integer;Down:Boolean);
        begin
        if (Sym >= Low(KeyState))and(Sym <= High(KeyState)) then KeyState[Sym]:=Down;
        case Sym of
                SDLK_Escape:begin Running:=False; notQuit:=false; end;
                end;
        end;
        begin
        while SDL_PollEvent(@Ev) <> 0 do
                begin
                case Ev.Type_ of
                        SDL_QUITEV: begin Running:=False; notQuit:=false; end;
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
        if CurrentTime - LastTime > 60 then
                begin
                LastTime:=CurrentTime;
                if (UltiBar1<200) then UltiBar1:=Ultibar1+1;
                if (UltiBar2<200) then UltiBar2:=Ultibar2+1;
                end;
        {while CurrentTime - LastTime>1000/30 do begin
                UpdateGame;
                inc(LastTime,30);
                end;}
        if (Red2>=314) then Player1WIN
        else begin
                UpdateGame;
                HandleEvents;
                DrawScreen;
             end;
        if (Red1>=316) then Player2WIN
        else begin
                UpdateGame;
                HandleEvents;
                DrawScreen;
                end;
        end;
end;
begin
 Randomize;
 SDL_INIT(SDL_INIT_VIDEO);
 If not InitVideo then Exit;
 SDL_WM_SetCaption('pascalFighter','pascalFighter');
 LoadImages;
 if (notQuit=true) then
 statement:begin
        Running:=True;
        MainMenu:=True;
        SelectMode:=True;
        Controls:=True;
        DrawMainMenu;
        SDL_Delay(200);
        DrawSelectMode;
        DrawPlayerControl;
        SDL_Delay(200);
        DrawScreen;
        MainLoop;
        end;
 if (notQuit=true) then GoTo statement;
 SDL_Quit;
end.
