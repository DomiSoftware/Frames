unit frCBGroupBoxObj;
//############################################################################//
//## Frame      : frCBGroupBoxObj                                             //
//## Author     : Dominic Mahon                                               //
//## Purpose    : No FMX groupbox for Checkboxes as distributed (11.3)        //
//## licence    : No rights reserved, freely given, no royalty fees           //
//## how to     : drop frame on project, add checkboxes                       //
//## properties : title - set title                                           //
//##            : single - true: single selection, false: for multiple        //
//##            : checked_names - returns array of string: checkbox names     //
//##            : checked_objects - returns array of Tcheckbox: objects       //
//##            : unchecked_names - returns array of string: checkbox names   //
//##            : unchecked_objects - returns array of Tcheckbox: objects     //
//##            : padding - padding for checkbox content                      //
//############################################################################//
//##    DATE    INITS VER  Comments                                           //
//## 2023/08/12  DRM  000  Initial release                                    //
//## 2023/08/13  DRM  001  Conversion into a frame                            //
//## 2023/08/16  DRM  002  added resize on frame title                        //
//## 2023/08/16  DRM  003  added an inner content so align top is possible    //
//##                  003  added design frame and customisable padding        //
//## 2023/08/16  DRM  004  added options to return unchecked boxes            //
//## 2023/08/17  DRM  005  hide title if blank text passed                    //
//############################################################################//

//just add checkboxes to rcContent
interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls,Math,
  FMX.Controls.Presentation, FMX.Objects;
type
  TCBGroupBoxObj = class(TFrame)
    rcOuterContent: TRectangle;
    rcBase: TRectangle;
    rcTitle: TRectangle;
    txtTitle: TText;
    rcContent: TRectangle;
    rcOuterTitle: TRectangle;
    procedure FrameResize(Sender: TObject);
  private
    Ftitle: string;
    FCheckBoxes: TArray<TCheckBox>;
    FSingle: Boolean;
    Fbasecolor: TAlphaColor;
    Fframecolor: TAlphaColor;
    Ftitlecolor: TAlphaColor;
    Fpadding: Single;
    procedure SetFtitle(const Value: string);
    function GetChecked: TArray<string>;
    procedure DoCheckBoxClick(Sender: TObject);
    function GetCheckedObj: TArray<TCheckbox>;
    procedure FbasecolorW(aCol: TAlphacolor);
    procedure FframecolorW(aCol: TAlphacolor);
    procedure FtitlecolorW(aCol: TAlphacolor);
    procedure FpaddingW(aValue: single);
    function GetUnChecked: TArray<string>;
    function GetUnCheckedObj: TArray<TCheckbox>;
  public
    constructor Create(AOwner: TComponent); override;
    property title: string read Ftitle write SetFtitle;
    property checked_names: TArray<string> read GetChecked;
    property checked_objects: TArray<TCheckBox> read GetCheckedObj;
    property unchecked_names: TArray<string> read GetUnChecked;
    property unchecked_objects: TArray<TCheckBox> read GetUnCheckedObj;
    property single: Boolean read FSingle write FSingle;
    property basecolor: TAlphaColor read Fbasecolor write FbasecolorW;
    property framecolor: TAlphaColor read Fframecolor write FframecolorW;
    property titlecolor: TAlphaColor read Ftitlecolor write FtitlecolorW;
    property padding: Single read Fpadding write FpaddingW;
end;

implementation

{$R *.fmx}

constructor TCBGroupBoxObj.Create(AOwner: TComponent);
begin
  inherited;
  // Initialize the frame components here
  basecolor:=TAlphaColorRec.null;
  framecolor:=TAlphaColorRec.Gainsboro;
  titlecolor:=TAlphaColorRec.Black;
  title:='';
  single:=false;
  rcTitle.Width:=txtTitle.Width+7;
  rcTitle.Height:=txtTitle.Height+3;
  rcOuterTitle.Height:=txtTitle.Height+4;
  rcTitle.Position.Y:=rcOuterContent.Position.y;
  rcTitle.Position.X:=rcOuterContent.Position.x;
  rcOuterContent.Margins.Top:=3;
  rcContent.Stroke.Color:=TAlphaColorRec.Null;  // #003

end;

procedure TCBGroupBoxObj.FpaddingW(aValue: single);
// #003
begin
  Fpadding:=aValue;
  rcContent.Padding.Left:=aValue;
  rcContent.Padding.Top:=aValue;
  rcContent.Padding.Right:=aValue;
  rcContent.Padding.Bottom:=aValue;
  end;

procedure TCBGroupBoxObj.FbasecolorW(aCol: TAlphacolor);
begin
  Fbasecolor:=acol;
  rcBase.Fill.Color:=acol;
  rcContent.Fill.Color:=acol;
  rcOuterContent.Fill.Color:=acol;
  rcTitle.Fill.Color:=acol;
  end;

procedure TCBGroupBoxObj.FframecolorW(aCol: TAlphacolor);
begin
  Fframecolor:=acol;
  rcOuterContent.stroke.Color:=acol;
  rcTitle.stroke.Color:=acol;
end;

procedure TCBGroupBoxObj.FrameResize(Sender: TObject);
begin
  rcTitle.Position.Y:=rcContent.Position.y;
  rcTitle.Position.X:=rcContent.Position.x;

end;

procedure TCBGroupBoxObj.FtitlecolorW(aCol: TAlphacolor);
begin
  Ftitlecolor:=acol;
  txtTitle.Color:=acol;
end;

function TCBGroupBoxObj.GetChecked: TArray<string>;
var
  I: integer;
  Child: TControl;
begin
  SetLength(Result, 0);
  for I := 0 to rcContent.ControlsCount - 1 do
  begin
    Child := rcContent.Controls[I];
    if (Child is TCheckBox) and (TCheckBox(Child).IsChecked) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := Child.Name;
    end;
  end;
end;

function TCBGroupBoxObj.GetCheckedObj: TArray<TCheckbox>;
var
  I: integer;
  Child: TControl;
begin
  SetLength(FCheckBoxes, 0);
  for I := 0 to rcContent.ControlsCount - 1 do
  begin
    Child := rcContent.Controls[I];
    if (Child is TCheckBox) and (TCheckBox(Child).IsChecked) then
    begin
      SetLength(FCheckBoxes, Length(FCheckBoxes) + 1);
      Result[Length(FCheckBoxes) - 1] := (Child as TCheckBox);
    end;
  end;
  result:=FCheckBoxes;
end;

function TCBGroupBoxObj.GetUnChecked: TArray<string>;
//004 new feature - suggested by Sasho Bozhinov on forums
var
  I: integer;
  Child: TControl;
begin
  SetLength(Result, 0);
  for I := 0 to rcContent.ControlsCount - 1 do
  begin
    Child := rcContent.Controls[I];
    if (Child is TCheckBox) and (not(TCheckBox(Child).IsChecked)) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := Child.Name;
    end;
  end;
end;

function TCBGroupBoxObj.GetUnCheckedObj: TArray<TCheckbox>;
//004 new feature - suggested by Sasho Bozhinov on forums
var
  I: integer;
  Child: TControl;
begin
  SetLength(FCheckBoxes, 0);
  for I := 0 to rcContent.ControlsCount - 1 do
  begin
    Child := rcContent.Controls[I];
    if (Child is TCheckBox) and (not(TCheckBox(Child).IsChecked)) then
    begin
      SetLength(FCheckBoxes, Length(FCheckBoxes) + 1);
      Result[Length(FCheckBoxes) - 1] := (Child as TCheckBox);
    end;
  end;
  result:=FCheckBoxes;
end;



procedure TCBGroupBoxObj.SetFtitle(const Value: string);
var
  fs, I: integer;
  Child: TControl;
  begin
  Ftitle := Value;
  // #005 hide caption if blank text supplied
  if Ftitle>'' then
  begin
  rcOuterTitle.Visible:=True;      //#005
  txtTitle.Text := Ftitle;
  rcTitle.Width:=txtTitle.Width+7;
  rcTitle.Height:=txtTitle.Height+3;
  rcTitle.Position.Y:=rcOuterContent.Position.y;
  rcTitle.Position.X:=rcOuterContent.Position.x;
  rcOuterTitle.Height:=txtTitle.Height+4;  //#005
  for I := 0 to rcContent.ControlsCount - 1 do
  begin
    Child := rcContent.Controls[I];
    if (Child is TCheckBox) then
    begin
      (rcContent.Controls[I] as TCheckBox).OnChange := DoCheckBoxClick;
      (rcContent.Controls[I] as TCheckBox).OnClick := DoCheckBoxClick;
    end;
  end;
  end else
  // #005 hide
  rcOuterTitle.Visible:=false;
end;

procedure TCBGroupBoxObj.DoCheckBoxClick(Sender: TObject);
var
  CheckBox: TCheckBox;
  I: integer;
begin
  CheckBox := (Sender as TCheckBox);
  for I := 0 to rcContent.ControlsCount - 1 do
  begin
    //if single uncheck others
    if FSingle = true then
      if (rcContent.Controls[I] as TCheckBox) <> CheckBox then
        (rcContent.Controls[I] as TCheckBox).IsChecked := False;
  end;
end;

end.
