unit mainForm;

interface

uses
  Windows, Graphics, Forms, mmSystem, ExtCtrls, StdCtrls,
  ComCtrls, Controls, Classes, SysUtils, Dialogs, Math,
  registry, Spin, Buttons, {HH, HH_FUNCS,} Messages, ShellApi;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    lblWrong: TLabel;
    grpPlayingControls: TGroupBox;
    btnStart: TButton;
    btnStop: TButton;
    optListen: TRadioButton;
    optTest: TRadioButton;
    speedBar: TTrackBar;
    lblSpeed: TLabel;
    lblVolume: TLabel;
    volumeBar: TTrackBar;
    grpLearningOptions: TGroupBox;
    chkColours: TCheckBox;
    lstNaming: TComboBox;
    grpInstrumentDetails: TGroupBox;
    lblDevice: TLabel;
    lstDevices: TComboBox;
    lblInstrument: TLabel;
    lstInstrument: TComboBox;
    lblBigTestNote: TStaticText;
    lblCurrentScore: TLabel;
    lblCurrentNo: TLabel;
    lblBestScore: TLabel;
    lblBestNo: TLabel;
    btnHelp: TButton;
    btnExit: TButton;
    lblNotation: TLabel;
    lblOctaveRange: TLabel;
    chkEditColours: TCheckBox;
    lblNotes: TLabel;
    lstNotes: TListBox;
    Label2: TLabel;
    ColorDialog1: TColorDialog;
    btnDefaultColours: TButton;
    chkOctaveTolerant: TCheckBox;
    lstRangeStart: TComboBox;
    lstRangeEnd: TComboBox;
    btnHint: TSpeedButton;
    lblLink: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure speedBarChange(Sender: TObject);
    procedure volumeBarChange(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstNamingChange(Sender: TObject);
    procedure lstInstrumentChange(Sender: TObject);
    function getDevices:Boolean;
    procedure lstDevicesChange(Sender: TObject);
    procedure stopPlaying;
    function isTestNote(note:Integer):Boolean;
    procedure chkColoursClick(Sender: TObject);
    procedure processNote;
    procedure chkEditColoursClick(Sender: TObject);
    procedure btnDefaultColoursClick(Sender: TObject);
    procedure ColorDialog1Close(Sender: TObject);
    procedure showPalette;
    function mouseposToNote(var X:Integer; Y:Integer):Integer;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grpLearningOptionsMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cancelNote;
    procedure highlightKey(x:Integer;down:Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure midiSetup;
    procedure highlightClickedKey(note:Integer);
    procedure lstRangeStartChange(Sender: TObject);
    procedure lstRangeEndChange(Sender: TObject);
    procedure btnHintClick(Sender: TObject);
    function hintDown(Sender:TObject):Boolean;
    procedure optListenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure lstRangeStartDropDown(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lblLinkClick(Sender: TObject);

  private
    { Private declarations }
    procedure CMDialogChar(var Message: TCMDialogChar);
      message CM_DIALOGCHAR;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  lphMidiOut:PHMidiOut;
  PHMIDIOUT : ^HMIDIOUT;
  HMIDIOUT: Integer;
  sendMidi, mousePressed:Boolean;
  clickedNote,notePlaying,notation,noteColour:Integer;
  currentRun,bestRun:Integer;
  userResponded:Boolean;
  volume:Integer;
  keyWidth,pianoBottom,blackKeyHeight,pianoLeft,pianoTop:Integer;
  regKey, keysDown:String;
  range, startOctave, dragNote:Integer;
  toneRow: array[0..84] of Boolean;
  colours: array[0..11] of TColor;
  {mHHelp: THookHelpSystem; }
  helpWindow: hwnd;

  procedure playNote(note:Byte);
  procedure stopNote(note:Byte);
  procedure clearRow;

Const
  noteName: array[0..4,0..11] of String[2]
  =(('C','C#','D','D#','E','F','F#','G','G#','A','A#','B')
    ,('C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B')
    ,('Do','Di','Re','Ri','Mi','Fa','Fi','So','Si','La','Li','Ti')
    ,('Do','Ra','Re','Me','Mi','Fa','Se','So','Le','La','Te','Ti')
    ,('0','1','2','3','4','5','6','7','8','9','10','11'));
  divPerSec: Integer=20;
  defaultColours: array[0..11] of TColor=(clRed,$000080FF{orange},clYellow,clLime,
clGreen,clOlive,clTeal,clAqua,clBlue,{clNavy,}clFuchsia,clPurple,clMaroon);
  keyMapping:String='Q2W3ER5T6Y7UI9O0P'#219#187#220'AZSXCFVGBNJMK'#188'L'#190#191;

implementation

{$R *.DFM}

procedure TForm1.CMDialogChar(var Message: TCMDialogChar);
{ Ignore accelerators without an [ALT] key } 
begin 
  if ((Message.KeyData and $20000000) = 0) then Message.Result := 1
  else inherited;
end; 

procedure TForm1.FormPaint(Sender: TObject);
var
   x,leftPos,keyDivision,blackBottom:Integer;
begin
With Canvas do
 begin
 Brush.Color:=clWhite;
 Rectangle (pianoLeft,pianoTop,pianoLeft+keyWidth*7*range+1,pianoBottom);
 Brush.Color:=clBlack;
 x:=1;
 leftPos:=pianoLeft+keyWidth;
 keyDivision:=keyWidth div 3;
 blackBottom:=pianoTop+blackKeyHeight;
 while x<7*range do
    begin
    MoveTo (leftPos,pianoTop);
    LineTo (leftPos,pianoBottom-1);
    If ((x mod 7) <>3) and ((x mod 7) <> 0) then
       Rectangle (leftPos-keyDivision,pianoTop,leftPos+keyDivision,blackBottom);
    inc(x);
    inc(leftPos,keyWidth);
    end;
 end;
if chkEditColours.Checked then showPalette;
end;

procedure TForm1.highlightKey(x:Integer;down:Boolean);
var
   o,n,leftBound,rightBound:Integer;
begin
dec(x,startOctave*12);
o:=x div 12;
x:=x mod 12;
If x>4 then Inc(x);
If x>12 then Inc(x);
With Canvas do begin
If (x Mod 2)=1 Then
   begin
   x:=(x+1) div 2;
   {black key}
   If down then
      Brush.Color:=noteColour
   Else
      Brush.Color:=clBlack;
   n:=pianoLeft+keyWidth*(o*7+x);
   FillRect(Rect(n-keyWidth div 3+1,pianoTop+1,n+keyWidth div 3-1,pianoTop+blackKeyHeight-1));
   end
Else
   begin
   {white key}
   x:=x div 2;
   n:=pianoLeft+keyWidth*(o*7+x);
   If down then
      Brush.Color:=noteColour
   Else
      Brush.Color:=clWhite;
   //paint lower portion of white note
   FillRect(Rect(n+1,pianoTop+blackKeyHeight,n+keyWidth,pianoBottom-1));
   //paint around adjacent black note
   if (x=0) or (x=3) then leftBound:=n+1 else leftBound:=n+keyWidth div 3;
   if (x=2) or (x=6) then rightBound:=n+keyWidth else rightBound:=n+keyWidth-keyWidth div 3;
   FillRect(Rect(leftBound,pianoTop+1,rightBound,pianoTop+blackKeyHeight));
   end;
end;
end;

procedure TForm1.highlightClickedKey(note:Integer);
begin
noteColour:=colours[(note mod 12)*Ord(chkColours.Checked)];
lblBigTestNote.Font.Color:=noteColour;
lblBigTestNote.Caption:=noteName[notation,note mod 12];
highlightKey(note,True);
end;

function TForm1.getDevices:Boolean;
var
  DevID, numDevs: Integer;
  Caps: TMidiOutCaps;
begin
Repeat
  numDevs:=midiOutGetNumdevs;
Until (numDevs>0) or (MessageDlg('Absolute Pitch will not be able to play notes'
+' because you do not have any MIDI devices installed. Either connect a device'
+' and click Retry, or click Cancel to close Absolute Pitch.',mtError,[mbRetry,mbCancel],0)=mrCancel);
if numDevs=0 then
  Result:=false
else
  begin
  Result:=true;
  for DevID:=-1 to numDevs-1 do
    begin
    midiOutGetDevCaps(DevID, @Caps, SizeOf(TMidiOutCaps));
    lstDevices.Items.Add(StrPas(Caps.szPName));
    end;
  lstDevices.ItemIndex:=0;
  end;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
if not hintDown(Sender) then
  begin
  stopPlaying;
  lblWrong.Visible:=false;
  end;
end;

procedure playNote(note:Byte);
begin
midiOutShortMsg(hMidiOut,144+256*(12+note)+65536*volume);
notePlaying:=note;
end;

procedure stopNote(note:Byte);
begin
midiOutShortMsg(hMidiOut,128+256*(12+note)+65536*volume);
end;

procedure TForm1.stopPlaying;
begin
Timer1.Enabled:=False;
midiOutShortMsg(hMidiOut,176+256*120);
btnStart.Enabled:=true;
btnStop.Enabled:=false;
if chkColours.Checked then chkEditColours.Enabled:=true;
if optListen.Checked then
  begin
  highlightKey(notePlaying,False);
  lblBigTestNote.Caption:='';
  end
else if currentRun>bestRun then
  begin
  bestRun:=currentRun;
  lblBestNo.Caption:=IntToStr(bestRun);
  lblBestNo.Left:=lblBestScore.Left+(lblBestScore.Width-lblBestNo.Width) div 2;
  end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  octave: Integer;
begin
if Button<>mbLeft then Exit;
octave:=mouseposToNote(X,Y);
if X=-1 then Exit; //out of piano range
if chkEditColours.Checked then
  begin
  if (ssCtrl in Shift) then with ColorDialog1 do //allow user to define own colour
    begin
    Color:=colours[X];
    if Execute then
      begin
      colours[X]:=Color;
      showPalette;
      end;
    end
  else //allow user to drag and drop to swap colours
    begin
    dragNote:=X;
    Screen.Cursor:=crDrag;
    end;
  end
else
  begin
  if Timer1.Enabled then
    begin
    if optTest.Checked then
      begin
      clickedNote:=X+12*(startOctave+octave);
      if not isTestNote(clickedNote mod 12) or ((not chkOctaveTolerant.Checked) and (notePlaying<>clickedNote))
      or (chkOctaveTolerant.Checked and (notePlaying mod 12<>clickedNote mod 12)) then
        begin
        stopPlaying;
        lblWrong.Caption:='Wrong: '+noteName[notation,notePlaying mod 12];
        lblWrong.Visible:=true;
        end
      else
        begin
        userResponded:=true;
        highlightClickedKey(clickedNote);
        end
      end;
    end
  else
    begin
    mousePressed:=true;
    lblWrong.Visible:=false;
    Application.ProcessMessages;
    stopNote(clickedNote);
    highlightKey(clickedNote,False);
    clickedNote:=X+12*(startOctave+octave);
    processNote;
    end;
  end;
end;

function TForm1.mouseposToNote(var X:Integer; Y:Integer):Integer;
//returns octave
var
  keyNo:Integer;
begin
if (Screen.Cursor=crDefault) or (Screen.Cursor=crHelp) then
  begin
  X:=-1;
  Result:=-1;
  end
else
  begin
  Dec(X,pianoLeft); //trim left margin
  Result:=X div (keyWidth*7); //return octave
  //number white notes 0 to 11
  keyNo:=2*((X mod (keyWidth*7)) div keyWidth);
  if keyNo>4 then dec(keyNo);
  if (Y-pianoTop<=blackKeyHeight) then //at black key level
    begin
    if (X mod keyWidth>2*keyWidth div 3) then
      begin
      if (keyNo<>4) and (keyNo<11) then inc(keyNo);
      end
    else if (X mod keyWidth<keyWidth div 3) and (keyNo>0) and (keyNo<>5) then dec(keyNo);
    end;
  X:=keyNo;
  end;
end;

procedure TForm1.processNote;
var
  i,note:Integer;
begin
note:=clickedNote mod 12;
If Timer1.enabled then
   begin
   userResponded:=True;
   If isTestNote(note) and (note=notePlaying mod 12) then
      highlightClickedKey(clickedNote);
   end
Else
   begin
   for i:=0 to 11 do lstNotes.Selected[i]:=false;
   lstNotes.Selected[note]:=true;
   highlightClickedKey(clickedNote);
   playNote(clickedNote);
   end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  dragColour:TColor;
begin
if Button<>mbLeft then Exit;
if (dragNote>-1) then
  begin
  //determine drop note, then swap notes
  if (mouseposToNote(X,Y)>-1) and (X<>dragNote) then //swap colours
    begin
    dragColour:=colours[dragNote];
    colours[dragNote]:=colours[X];
    colours[X]:=dragColour;
    showPalette;
    end;
  dragNote:=-1;
  Screen.Cursor:=crDefault;
  end
else if not lblWrong.Visible then
  begin
  mousePressed:=false;
  if not(ssCtrl in Shift) then cancelNote;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  options,x,i: Integer;
begin
{mHHelp:=THookHelpSystem.Create('AbsolutePitch.chm', '', htHHAPI);  }
keysDown:='';
notePlaying:=-1;
clickedNote:=-1;
dragNote:=-1;
if not getDevices then
  begin
  ShowMessage('This software requires a MIDI device on which to play sounds, and none'
  +'could be found on your PC.');
  Close;//exit if no devices found
  end;
lstDevices.ItemIndex:=0;//default is MIDI_MAPPER
lstInstrument.ItemIndex:=0;//default is piano
lstNaming.ItemIndex:=0;
notation:=0;
regKey:='Software\Silvawood\'+Application.Title;
With TRegistry.Create do
	begin
	try
		RootKey:=HKEY_CURRENT_USER;
		if OpenKey(regKey,false) then
			begin
  		x:=ReadInteger('x');
      options:=ReadInteger('options');
      chkColours.Checked:=((options and 1)=1);
      lstRangeStart.ItemIndex:=(options shr 20) and 7;
      lstRangeEnd.ItemIndex:=(options shr 23) and 7;
      range:=lstRangeEnd.ItemIndex-lstRangeStart.ItemIndex+1;
      chkOctaveTolerant.Checked:=((options and 2)=2);
      notation:=(options shr 2) and 7;
      lstNaming.ItemIndex:=notation;
      speedBar.Position:=(options shr 5) and 15;
      volumeBar.Position:=(options shr 9) and 15;
      lstInstrument.ItemIndex:=(options shr 13) and 127;
    	lstDevices.ItemIndex:=(options shr 26);
    	if (x and 32768)>0 then
    		Form1.WindowState:=wsMaximized
    	else
    		begin
    		Form1.Width:=x shr 16;
    		Form1.Height:=(x and 32767);
    		end;
      ReadBinaryData('colours', colours, sizeOf(colours));
      end;
	except end;
	Free;
  end;
if range<=0 then
  begin
  lstRangeStart.ItemIndex:=3;
  lstRangeEnd.ItemIndex:=3;
  range:=1;
  for i:=0 to 11 do colours[i]:=defaultColours[i];
  end;
startOctave:=lstRangeStart.ItemIndex+1;
lstNamingChange(Sender);
lstNotes.Selected[0]:=true;
speedBarChange(Sender);
volume:=(12*volumeBar.Position)+7;
midiSetup;
Application.ShowHint:=false;
end;

procedure TForm1.btnStartClick(Sender: TObject);
var
  note:Integer;
begin
if hintDown(Sender) then Exit;
btnStart.Enabled:=false;
btnStop.Enabled:=true;
lblWrong.Visible:=false;
lblBigTestNote.Caption:='';
chkEditColours.Checked:=false;
chkEditColours.Enabled:=false;
btnDefaultColours.Enabled:=false;
userResponded:=False;
currentRun:=0;
clearRow;
Randomize;
volume:=(12*volumeBar.Position)+7;
if lstNotes.SelCount=12 then
  note:=Trunc(Random(range*12))
else
  Repeat
    note:=Trunc(Random(range*12));
  Until not lstNotes.Selected[note mod 12]; //first note not a test note
inc(note,startOctave*12);
toneRow[note]:=true;
playNote(note);
Timer1.Enabled:=True;
end;

procedure clearRow;
var
  i:Integer;
begin
i:=0;
while i<=range*12 do
  begin
  toneRow[i]:=false;
  inc(i);
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i, note:Integer;
begin
Repeat
  note:=Trunc(Random(range*12));
Until not toneRow[note] and (note<>notePlaying);
toneRow[note]:=true;
i:=0;
While toneRow[i] do inc(i);
if i=range*12 then clearRow; //all notes played
inc(note,startOctave*12);
stopNote(notePlaying);
If optListen.Checked then
  begin
  if isTestNote(notePlaying) then
    begin
    lblBigTestNote.Font.Color:=colours[(note mod 12)*Ord(chkColours.Checked)];
    highlightKey(notePlaying,False);
    lblBigTestNote.Caption:='';
    end;
  if isTestNote(note) then highlightClickedKey(note);
  end
Else
  begin
  If isTestNote(notePlaying) then
    begin
    If userResponded then
      begin
      Inc(currentRun);
      lblCurrentNo.Caption:=IntToStr(currentRun);
      lblCurrentNo.Left:=lblCurrentScore.Left+(lblCurrentScore.Width-lblCurrentNo.Width) div 2;
      userResponded:=false;
      end
    Else
      begin
      lblWrong.Caption:='Missed: '+noteName[notation,notePlaying mod 12];
      lblWrong.Visible:=true;
      stopPlaying;
      Exit;
      end;
    end;
  end;
playNote(note);
end;

function TForm1.isTestNote(note:Integer):Boolean;
begin
Result:=lstNotes.Selected[note mod 12];
end;

procedure TForm1.speedBarChange(Sender: TObject);
begin
if not hintDown(Sender) then Timer1.Interval:=4000 div speedBar.Position;
end;

procedure TForm1.volumeBarChange(Sender: TObject);
begin
if not hintDown(Sender) then volume:=(12*volumeBar.Position)+7;
end;

procedure TForm1.btnExitClick(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.btnHelpClick(Sender: TObject);
begin
helpWindow:=HtmlHelp(GetDesktopWindow, 'AbsolutePitch.chm', HH_DISPLAY_TOPIC, 0);
end;

procedure TForm1.FormResize(Sender: TObject);
var
   formWidth:Integer;
begin
formWidth:=Form1.Width-20;
keyWidth:=formWidth div (7*range);
pianoLeft:=(formWidth-range*7*keyWidth)div 2;
pianoTop:=10;
pianoBottom:=Form1.Height - 330;
blackKeyHeight:=pianoBottom div 2;
grpPlayingControls.Top:=pianoBottom+10;
grpLearningOptions.Top:=pianoBottom+10;
lblBigTestNote.Top:=pianoBottom+16;
lblBigTestNote.Left:=formWidth div 2 - 88;
grpPlayingControls.Left:=lblBigTestNote.Left-190;
grpLearningOptions.Left:=lblBigTestNote.Left+190;
grpInstrumentDetails.Top:=pianoBottom+220;
grpInstrumentDetails.Left:=grpPlayingControls.Left;
lblLink.Top:=pianoBottom+270;
lblLink.Left:=(formWidth - lblLink.Width) div 2;
lblWrong.Left:=(formWidth - lblWrong.Width) div 2;
lblWrong.Top:=(pianoBottom div 2)-(lblWrong.Height div 2);
btnHelp.Top:=pianoBottom+186;
btnHint.Top:=btnHelp.Top;
btnExit.Top:=btnHelp.Top;
btnHelp.Left:=lblBigTestNote.Left;
btnHint.Left:=btnHelp.Left+65;
btnExit.Left:=lblBigTestNote.Left+102;
lblCurrentScore.Left:=lblBigTestNote.Left;
lblCurrentNo.Left:=lblCurrentScore.Left;
lblBestScore.Left:=lblBigTestNote.Left+lblBigTestNote.Width-lblBestScore.Width;
lblBestNo.Left:=lblBestScore.Left;
lblCurrentScore.Top:=pianoBottom+140;
lblCurrentNo.Top:=lblCurrentScore.Top+15;
lblBestScore.Top:=lblCurrentScore.Top;
lblBestNo.Top:=lblCurrentNo.Top;
Refresh;
if chkEditColours.Checked then showPalette;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
   x,options:Integer;
begin
stopPlaying;
with TRegistry.Create do
  try
		RootKey:=HKEY_CURRENT_USER;
		if OpenKey(regKey,true) then
			begin
  		x:=(Form1.Width shl 16) or (Ord(Form1.WindowState=wsMaximized) shl 15) or (Form1.Height and 32767);
    	WriteInteger('x',x);
  		options:=Ord(chkColours.Checked) or (Ord(chkOctaveTolerant.Checked) shl 1) or (notation shl 2)
      or (speedBar.Position shl 5) or (volumeBar.Position shl 9) or (lstInstrument.ItemIndex shl 13)
    	or (lstRangeStart.ItemIndex shl 20) or (lstRangeEnd.ItemIndex shl 23) or (lstDevices.ItemIndex shl 26);
      WriteInteger('y',(x xor options));
      WriteInteger('options',options);
      WriteBinaryData('colours', colours, sizeOf(colours));
    	end;
	finally
		Free;
    FreeMem(lphMidiOut);
		midiOutClose(hMidiOut);
  end;
end;

procedure TForm1.lstNamingChange(Sender: TObject);
var
  i:Integer;
begin
if hintDown(Sender) then Exit;
notation:=lstNaming.ItemIndex;
lstNotes.Clear;
for i:=0 to 11 do lstNotes.Items.Add(noteName[notation,i]);
end;

procedure TForm1.lstInstrumentChange(Sender: TObject);
begin
{set instrument}
midiOutShortMsg(hMidiOut,192+256*lstInstrument.ItemIndex);
end;

procedure TForm1.lstDevicesChange(Sender: TObject);
begin
midiOutClose(hMidiOut);
Freemem(lphMidiOut);
midiSetup;
end;

procedure TForm1.midiSetup;
begin
//set up midi
GetMem(lphMidiOut,2);
//set device
midiOutOpen(lphMidiOut,lstDevices.ItemIndex-1,0,0,0);
hMidiOut:=lphMidiOut^;
//set instrument
midiOutShortMsg(hMidiOut,192+256*lstInstrument.ItemIndex);
end;

procedure TForm1.chkColoursClick(Sender: TObject);
begin
if hintDown(Sender) then Exit;
if not chkColours.Checked then chkEditColours.Checked:=false;
chkEditColours.Enabled:=chkColours.Checked;
btnDefaultColours.Enabled:=chkEditColours.Checked;
end;

procedure TForm1.chkEditColoursClick(Sender: TObject);
begin
if hintDown(Sender) then Exit;
if chkEditColours.Checked then btnStopClick(Sender);
Refresh;
btnDefaultColours.Enabled:=chkEditColours.Checked;
end;

procedure TForm1.showPalette;
var
  i: Integer;
begin
for i:=12*startOctave to 12*(startOctave+range)-1 do
  begin
  noteColour:=colours[i mod 12];
  highlightKey(i,true);
  end;
end;

procedure TForm1.btnDefaultColoursClick(Sender: TObject);
var
  i: Integer;
begin
if not hintDown(Sender) and (MessageDlg('Are you sure you want to return colours to their defaults?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
  for i:=0 to 11 do colours[i]:=defaultColours[i];
  showPalette;
  end;
end;

procedure TForm1.ColorDialog1Close(Sender: TObject);
begin
chkEditColoursClick(Sender);
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  newNote: Integer;
begin
If Screen.Cursor=crHelp then Exit;
If (X>pianoLeft) and (X<pianoLeft+keyWidth*range*7) and (Y>pianoTop) and (Y<pianoBottom) then
  begin
  if Screen.Cursor=crDefault then Screen.Cursor:=crHandPoint;
  if mousePressed then
    begin
    newNote:=X+12*(startOctave+mouseposToNote(X,Y));
    if newNote<>clickedNote then
      begin
      highlightKey(clickedNote,False);
      stopNote(clickedNote);
      clickedNote:=newNote;
      processNote;
      end;
    end;
  end
else
  Screen.Cursor:=crDefault;
end;

procedure TForm1.grpLearningOptionsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
if Screen.Cursor<>crHelp then Screen.Cursor:=crDefault;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  keyNote,keysDownPos: Integer;
begin
if optTest.Checked then
  begin
  if Timer1.Enabled and (Key=32) then cancelNote;
  end
else if not (ssCtrl in Shift) and not Timer1.Enabled then
  begin
  keyNote:=Pos(Chr(Key),keyMapping);
  keysDownPos:=Pos(chr(keyNote),keysDown);
  if keysDownPos>0 then
    begin
    Delete(keysDown,keysDownPos,1);
    inc(keyNote,12*startOctave -1);
    highlightKey(keyNote,false);
    stopNote(keyNote);
    if length(keysDown)>0 then
      begin
      keyNote:=(Ord(keysDown[length(keysDown)]) -1) mod 12;
      lblBigTestNote.Font.Color:=colours[keyNote*Ord(chkColours.Checked)];
      lblBigTestNote.Caption:=noteName[notation,keyNote];
      end
    else
      lblBigTestNote.Caption:='';
    end;
  end;
end;

procedure TForm1.cancelNote;
begin
highlightKey(clickedNote,False);
lblBigTestNote.Caption:='';
if not Timer1.Enabled then stopNote(clickedNote);
clickedNote:=-1;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  keyNote:Integer;
begin
if optTest.Checked then
  begin
  if (Key<>32) or not Timer1.Enabled then Exit;
  if isTestNote(notePlaying) or (isTestNote(notePlaying mod 12) and chkOctaveTolerant.Checked) then
    begin
    userResponded:=true;
    clickedNote:=notePlaying;
    highlightClickedKey(notePlaying);
    end
  else
    begin
    lblWrong.Caption:='Wrong: '+noteName[notation,notePlaying mod 12];
    lblWrong.Visible:=true;
    stopPlaying;
    end;
  end
else if not Timer1.Enabled then //note not already playing
  begin
  keyNote:=Pos(Chr(Key),keyMapping);
  if (Pos(chr(keyNote),keysDown)=0) and (keyNote>0) and (keyNote<range*12+1) then
    begin
    keysDown:=keysDown+Chr(keyNote);
    inc(keyNote,12*startOctave -1);
    highlightClickedKey(keyNote);
    playNote(keyNote);
    end;
  end;
end;

procedure TForm1.lstRangeStartChange(Sender: TObject);
begin
if hintDown(Sender) then Exit;
if lstRangeStart.ItemIndex>lstRangeEnd.ItemIndex then
  lstRangeEnd.ItemIndex:=lstRangeStart.ItemIndex;
range:=lstRangeEnd.ItemIndex-lstRangeStart.ItemIndex+1;
startOctave:=lstRangeStart.ItemIndex+1;
Resize;
end;

procedure TForm1.lstRangeEndChange(Sender: TObject);
begin
if lstRangeEnd.ItemIndex<lstRangeStart.ItemIndex then
  begin
  lstRangeStart.ItemIndex:=lstRangeEnd.ItemIndex;
  startOctave:=lstRangeStart.ItemIndex+1;
  end;
range:=lstRangeEnd.ItemIndex-lstRangeStart.ItemIndex+1;
Resize;
end;

procedure TForm1.btnHintClick(Sender: TObject);
begin
if btnHint.Down then Screen.Cursor:=crHelp else Screen.Cursor:=crDefault;
Application.ShowHint:=btnHint.Down;
end;

function TForm1.hintDown(Sender:TObject):Boolean;
begin
Result:=btnHint.Down;
if Result then
  begin
  helpWindow:=HtmlHelp(GetDesktopWindow, 'AbsolutePitch.chm', HH_HELP_CONTEXT, TWinControl(Sender).HelpContext);
  btnHint.Down:=false;
  Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.optListenMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
hintDown(Sender);
end;

procedure TForm1.FormClick(Sender: TObject);
begin
hintDown(Sender);
end;

procedure TForm1.lstRangeStartDropDown(Sender: TObject);
begin
hintDown(Sender);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if IsWindow(helpWindow) then SendMessage(helpWindow,wm_close,0,0);
end;

procedure TForm1.lblLinkClick(Sender: TObject);
begin
ShellExecute(Application.Handle, PChar('open'), PChar('http://www.silvawood.co.uk/pitch'), PChar(0), nil, SW_NORMAL);
end;

end.
