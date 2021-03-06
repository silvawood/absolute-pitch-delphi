�
 TFORM1 0S*  TPF0TForm1Form1Left*TopaHelpContext�BorderIconsbiSystemMenu
biMinimize
biMaximizebiHelp CaptionAbsolute PitchClientHeight�ClientWidth^Color	clBtnFaceConstraints.MinHeight|Constraints.MinWidthDFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
KeyPreview	OldCreateOrderPositionpoScreenCenterScaledVisible	OnClick	FormClickOnClose	FormCloseOnCloseQueryFormCloseQueryOnCreate
FormCreate	OnKeyDownFormKeyDownOnKeyUp	FormKeyUpOnMouseDownFormMouseDownOnMouseMoveFormMouseMove	OnMouseUpFormMouseUpOnPaint	FormPaintOnResize
FormResizePixelsPerInch`
TextHeight TLabellblWrongLeftGTopWidth�HeightY	AlignmenttaCenterAutoSizeColor	clBtnFaceFont.CharsetANSI_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.Style ParentColor
ParentFontTransparent	Visible  TLabellblCurrentScoreLeft� Top� WidthQHeightHint%Your score so far in the current test	AlignmenttaCenterCaptionCurrent ScoreFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontParentShowHintShowHint	  TLabellblCurrentNoLeft� Top� WidthQHeightHint%Your score so far in the current test	AlignmenttaCenterAutoSizeCaption0Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontParentShowHintShowHint	  TLabellblBestScoreLeftHTop� WidthBHeightHintThe best score in this session	AlignmenttaCenterCaption
Best ScoreFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontParentShowHintShowHint	  TLabel	lblBestNoLeftHTop� WidthBHeightHintThe best score in this session	AlignmenttaCenterAutoSizeCaption0Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontParentShowHintShowHint	  TSpeedButtonbtnHintLeft)TopWidthHeightHintJWhen pressed down, enables you to click a control to display specific help
AllowAllUp	
GroupIndexCaption?Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontParentShowHintShowHint	OnClickbtnHintClick  TLabellblLinkLeft� Top�WidthHeightCursorcrHandPointCaption<Click here to try the free new web version of Absolute PitchFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsUnderline 
ParentFontOnClicklblLinkClick  	TGroupBoxgrpPlayingControlsLeftTopXWidth� Height� HelpContext� CaptionPlaying controlsTabOrder OnClick	FormClickOnMouseMovegrpLearningOptionsMouseMove TLabellblSpeedLeftTop\Width� HeightHint%Controls the duration of notes played	AlignmenttaCenterAutoSizeCaptionSpeedParentShowHintShowHint	  TLabel	lblVolumeLeftTop� Width� HeightHint%Controls the loudness of played notes	AlignmenttaCenterAutoSizeCaptionVolumeParentShowHintShowHint	  TButtonbtnStartLeft	TopWidthKHeightHint$Starts a listening session or a testHelpContext� Caption&StartParentShowHintShowHint	TabOrder OnClickbtnStartClick  TButtonbtnStopLeft]TopWidthKHeightHint#Stops a listening session or a testHelpContext� CaptionSto&pEnabledParentShowHintShowHint	TabOrderOnClickbtnStopClick  TRadioButton	optListenLeftTopDWidth7HeightHint"Select if you want to learn a noteHelpContextxCaption&ListenChecked	ParentShowHintShowHint	TabOrderTabStop	OnMouseDownoptListenMouseDown  TRadioButtonoptTestLeftbTopDWidth/HeightHint)Select if you want to be tested on a noteHelpContext� Caption&TestParentShowHintShowHint	TabOrderOnMouseDownoptListenMouseDown  	TTrackBarspeedBarLeftTopmWidth� Height!Hint%Controls the duration of notes playedHelpContext� MaxMinParentShowHintPageSizePositionShowHint	TabOrderOnChangespeedBarChange  	TTrackBar	volumeBarLeftTop� Width� Height!Hint%Controls the loudness of played notesHelpContextParentShowHintPageSizePosition
ShowHint	TabOrderOnChangevolumeBarChange   	TGroupBoxgrpLearningOptionsLeft�TopXWidth� Height� HelpContextnCaptionLearning optionsTabOrderOnClick	FormClickOnMouseMovegrpLearningOptionsMouseMove TLabellblNotationLeft5Top>WidthxHeight	AlignmenttaCenterAutoSizeCaptionNotation  TLabellblOctaveRangeLeft5TopWidthxHeight	AlignmenttaCenterAutoSizeCaptionOctave range  TLabellblNotesLeftTopWidth,Height	AlignmenttaCenterAutoSizeCaptionNote(s)  TLabelLabel2LeftjTop'Width	HeightCaptionto  	TCheckBox
chkColoursLeft8Top� WidthaHeightHint+Tick to use a different color for each noteHelpContextCaption&Use coloursParentShowHintShowHint	TabOrderOnClickchkColoursClick  	TComboBox	lstNamingLeft5TopNWidthxHeightHint The naming system used for notesHelpContext� StylecsDropDownListParentShowHintShowHint	TabOrderOnChangelstNamingChange
OnDropDownlstRangeStartDropDownItems.StringsLetter (sharps)Letter (flats)Solfege (sharp)Solfege (flat)Integer   	TCheckBoxchkEditColoursLeftJTop� WidthWHeightHint.Tick to edit the palette used for note coloursHelpContext2CaptionEdit paletteEnabledParentShowHintShowHint	TabOrderOnClickchkEditColoursClick  TListBoxlstNotesLeftTop#Width,Height� Hint"Select the notes you want to learnHelpContext� 
ItemHeightMultiSelect	ParentShowHintShowHint	TabOrder   TButtonbtnDefaultColoursLeft@Top� WidthaHeightHint6Click to return note colours to their default settingsHelpContext(CaptionDefault coloursEnabledParentShowHintShowHint	TabOrderOnClickbtnDefaultColoursClick  	TCheckBoxchkOctaveTolerantLeft8TopoWidthqHeightHintOTick for test responses to be marked correct despite being in the wrong octave.HelpContext� CaptionOctave-tolerantChecked	ParentShowHintShowHint	State	cbCheckedTabOrderOnClick	FormClick  	TComboBoxlstRangeStartLeft>Top#Width$HeightHint,The number of the lowest octave on the pianoHelpContext� StylecsDropDownListParentShowHintShowHint	TabOrderOnChangelstRangeStartChange
OnDropDownlstRangeStartDropDownItems.Strings1234567   	TComboBoxlstRangeEndLeft}Top#Width$HeightHint-The number of the highest octave on the pianoHelpContext� StylecsDropDownListParentShowHintShowHint	TabOrderOnChangelstRangeEndChangeOnClick	FormClick
OnDropDownlstRangeStartDropDownItems.Strings1234567    	TGroupBoxgrpInstrumentDetailsLeft0Top0Width-Height-HelpContextFCaptionInstrument detailsTabOrderOnClick	FormClick TLabel	lblDeviceLeftTopWidthOHeight	AlignmenttaRightJustifyCaptionMIDI out device:  TLabellblInstrumentLeftHTopWidth4HeightHint3Select the number of the voice to use to play notes	AlignmenttaRightJustifyCaptionInstrument:ParentShowHintShowHint	  	TComboBox
lstDevicesLeftlTopWidth� HeightHint$The device on which notes are playedHelpContext� StylecsDropDownListParentShowHintShowHint	TabOrder OnChangelstDevicesChange
OnDropDownlstRangeStartDropDown  	TComboBoxlstInstrumentLeft�TopWidth� HeightHint(The instrument on which notes are playedHelpContextPStylecsDropDownListParentShowHintShowHint	TabOrderOnChangelstInstrumentChangeOnClick	FormClick
OnDropDownlstRangeStartDropDownItems.Strings0 Acoustic Grand Piano1 Bright Acoustic Piano2 Electric Grand Piano3 Honky-tonk Piano4 Rhodes Piano5 Chorused Piano6 Harpsichord
7 Clavinet	8 Celesta9 Glockenspiel10 Music Box11 Vibraphone
12 Marimba13 Xylophone14 Tubular Bells15 Dulcimer16 Hammond Organ17 Percussive Organ18 Rock Organ19 Church Organ20 Reed Organ21 Accordion22 Harmonica23 Tango Accordion24 Acoustic Guitar (nylon)25 Acoustic Guitar (steel)26 Electric Guitar (jazz)27 Electric Guitar (clean)28 Electric Guitar (muted)29 Overdriven Guitar30 Distortion Guitar31 Guitar Harmonics32 Acoustic Bass33 Electric Bass (finger)34 Electric Bass (pick)35 Fretless Bass36 Slap Bass 137 Slap Bass 238 Synth Bass 139 Synth Bass 2	40 Violin41 Viola42 Cello43 Contrabass44 Tremolo Strings45 Pizzicato Strings46 Orchestral Harp
47 Timpani48 String Ensemble 149 String Ensemble 250 SynthStrings 151 SynthStrings 252 Choir Aahs53 Voice Oohs54 Synth Voice55 Orchestra Hit
56 Trumpet57 Trombone58 Tuba59 Muted Trumpet60 French Horn61 Brass Section62 Synth Brass 163 Synth Brass 264 Soprano Sax65 Alto Sax66 Tenor Sax67 Baritone Sax68 Oboe69 English Horn
70 Bassoon71 Clarinet
72 Piccolo73 Flute74 Recorder75 Pan Flute76 Bottle Blow77 Shakuhachi
78 Whistle
79 Ocarina80 Lead 1 (square)81 Lead 2 (sawtooth)82 Lead 3 (calliope lead)83 Lead 4 (chiff lead)84 Lead 5 (charang)85 Lead 6 (voice)86 Lead 7 (fifths)87 Lead 8 (bass + lead)88 Pad 1 (new age)89 Pad 2 (warm)90 Pad 3 (polysynth)91 Pad 4 (choir)92 Pad 5 (bowed)93 Pad 6 (metallic)94 Pad 7 (halo)95 Pad 8 (sweep)96 FX 1 (rain)97 FX 2 (soundtrack)98 FX 3 (crystal)99 FX 4 (atmosphere)100 FX 5 (brightness)101 FX 6 (goblins)102 FX 7 (echoes)103 FX 8 (sci-fi)	104 Sitar	105 Banjo106 Shamisen107 Koto108 Kalimba109 Bagpipe
110 Fiddle
111 Shanai112 Tinkle Bell	113 Agogo114 Steel Drums115 Woodblock116 Taiko Drum117 Melodic Tom118 Synth Drum119 Reverse Cymbal120 Guitar Fret Noise121 Breath Noise122 Seashore123 Bird Tweet124 Telephone Ring125 Helicopter126 Applause127 Gunshot    TStaticTextlblBigTestNoteLeft� Top]Width� HeighttHint3Displays the note being learned or the note clickedHelpContextF	AlignmenttaCenterAutoSizeBorderStyle	sbsSunkenFont.CharsetANSI_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.Style 
ParentFontParentShowHintShowHint	TabOrderOnMouseMovegrpLearningOptionsMouseMove  TButtonbtnHelpLeft� TopWidthAHeightHint$Displays the help for Absolute PitchCaption&HelpParentShowHintShowHint	TabOrderOnClickbtnHelpClick  TButtonbtnExitLeftJTopWidthKHeightHintCloses Absolute PitchCaption&ExitParentShowHintShowHint	TabOrderOnClickbtnExitClick  TTimerTimer1EnabledOnTimerTimer1TimerLeftTop  TColorDialogColorDialog1OnCloseColorDialog1CloseLefthTop   