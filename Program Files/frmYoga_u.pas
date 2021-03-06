unit frmYoga_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, jpeg, Buttons, Spin, Grids, DBGrids,
  DB, ADODB ,clsNewStudent_u ,DateUtils,MPlayer ;

type
  TfrmYoga = class(TForm)
    pgcYoga: TPageControl;
    tsHome: TTabSheet;
    tsTeacher: TTabSheet;
    tsStudent: TTabSheet;
    imgHome: TImage;
    pnlWelcome: TPanel;
    btnTeacherAccess: TButton;
    btnStudentAccess: TButton;
    btnNext: TBitBtn;
    btnReset: TBitBtn;
    btnHelp: TBitBtn;
    imgTeacher: TImage;
    imgStudent: TImage;
    pnlLogin: TPanel;
    pnlTeacher: TPanel;
    lblTeacherName: TLabel;
    redTeacher: TRichEdit;
    lblTeacherSurname: TLabel;
    edtTeacherName: TEdit;
    edtTeacherSurname: TEdit;
    sedTeacherHours: TSpinEdit;
    lblTeacherHours: TLabel;
    chkAccomodation: TCheckBox;
    btnTeacherUpdate: TButton;
    edtTeacherLevel: TEdit;
    lblTeacherLevel: TLabel;
    btnTeacherAdd: TButton;
    btnHome: TBitBtn;
    btnTeacherClose: TBitBtn;
    btnTeacherBack: TBitBtn;
    btnTeacherReset: TBitBtn;
    btnTeacherHelp: TBitBtn;
    pnlStudent: TPanel;
    lblStudentName: TLabel;
    lblStudentSurname: TLabel;
    lblSudentJoined: TLabel;
    lblStudentDonation: TLabel;
    edtStudentName: TEdit;
    edtStudentSurname: TEdit;
    edtStudentDonation: TEdit;
    dtpStudentJoined: TDateTimePicker;
    redStudent: TRichEdit;
    btnStudentClose: TBitBtn;
    btnStudentHome: TBitBtn;
    btnStudentBack: TBitBtn;
    btnStudentReset: TBitBtn;
    btnStudentHelp: TBitBtn;
    btnDonation: TButton;
    conYoga: TADOConnection;
    qryYogaStudents: TADOQuery;
    dsrYogaStudents: TDataSource;
    dbgStudents: TDBGrid;
    qryYogaTeachers: TADOQuery;
    dsrYogaTeachers: TDataSource;
    dbgTeachers: TDBGrid;
    btnShowStudents: TButton;
    btnStatContributions: TButton;
    btnStatCourses: TButton;
    btnDeleteTeacher: TButton;
    btnAddStudent: TButton;
    btnViewClasses: TButton;
    mpBonobo: TMediaPlayer;
    procedure btnTeacherAccessClick(Sender: TObject);
    procedure btnStudentAccessClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnShowStudentsClick(Sender: TObject);
    procedure btnStatContributionsClick(Sender: TObject);
    procedure btnStatCoursesClick(Sender: TObject);
    procedure btnTeacherAddClick(Sender: TObject);
    procedure btnTeacherUpdateClick(Sender: TObject);
    procedure btnDeleteTeacherClick(Sender: TObject);
    procedure btnAddStudentClick(Sender: TObject);
    procedure btnDonationClick(Sender: TObject);
    procedure btnViewClassesClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnTeacherResetClick(Sender: TObject);
    procedure btnTeacherBackClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnTeacherHelpClick(Sender: TObject);
    procedure btnStudentResetClick(Sender: TObject);
    procedure btnStudentHomeClick(Sender: TObject);
    procedure btnStudentBackClick(Sender: TObject);
  private
    { Private declarations }

    iTeacherID, iStudentID : Integer ;
    btnDynamicAddStudent : TButton ;
    objNewStudent : TNewStudent ;
    arrCourse , arrVenue : array [1..10] of string ;
    arrNumStudents : array [1..10] of integer;

    procedure btnDynamicAddStudentClick(Sender: TObject);
    procedure TeacherDisplay ;
    procedure ReadFromFile ;
    procedure StudentLogin (pStudentID:Integer);

  public
    { Public declarations }
  end;

var
  frmYoga: TfrmYoga;

implementation

{$R *.dfm}

procedure TfrmYoga.btnAddStudentClick(Sender: TObject);
begin
  // adding a student
  pgcYoga.ActivePageIndex := 2 ;
  lblStudentDonation.Visible := False ;
  edtStudentDonation.Visible := False ;
  pnlStudent.Caption := 'Add Student';
  btnDonation.Visible := False ;
  btnViewClasses.Visible := False ;

  //Dynamic button instantiation
  btnDynamicAddStudent := TButton.Create(frmYoga);
  btnDynamicAddStudent.Parent := pgcYoga.ActivePage ;
  btnDynamicAddStudent.Top := 249 ;
  btnDynamicAddStudent.Left := 96;
  btnDynamicAddStudent.Width := 121 ;
  btnDynamicAddStudent.Height := 41 ;
  btnDynamicAddStudent.Caption := 'Add Student';
  // Binding the on click event
  btnDynamicAddStudent.OnClick :=  btnDynamicAddStudentClick ;
end;

procedure TfrmYoga.btnDeleteTeacherClick(Sender: TObject);
var
  iIDnumber : Integer ;
begin
  //Delete teacher records
  iIDnumber := StrToInt(InputBox('Delete teacher','Please neter the teacher ID of the teacher you would like to remove','13'));
  if iIDnumber <= 10  then
  begin
    ShowMessage('Please note you cannont remove any of the any of the first 10 teachers as they are the owners of the school');
    Exit ;
  end;
  qryYogaTeachers.SQL.Text := 'Delete from tblTeachers where TeacherID = '+ IntToStr(iIDnumber) ;
  qryYogaTeachers.ExecSQL  ;
  qryYogaTeachers.SQL.Text := 'Select * from tblTeachers order by TeacherID ' ;
  qryYogaTeachers.Open ;
end;

procedure TfrmYoga.btnDonationClick(Sender: TObject);
var
  rDonation : Real; 
begin
  // Donations
  redStudent.Clear ;
  rDonation := StrToFloat(edtStudentDonation.Text);
  //VALIDATION
  if edtStudentDonation.Text = '' then
  begin
    ShowMessage('Please enter a donation amount ');
    Exit ;
  end;

  if rDonation < 0 then
  begin
    ShowMessage('Please enter a valid donation amount ');
    Exit ;
  end;

  // Updationg the text file
  qryYogaStudents.SQL.Text := 'Update tblStudents set Donation = Donation +'+ FloatToStrF(rDonation,ffFixed,10,2) +' where StudentID = '+ IntToStr(iStudentID);
  qryYogaStudents.ExecSQL ;
  StudentLogin(iStudentID);  
end;

procedure TfrmYoga.btnDynamicAddStudentClick(Sender: TObject);
var
  sStudentName , sStudentSurname : string ;
  dDateJoined : TDate ;
  rDonation : Real ;
  iNum ,k , iCount : Integer ;
  bVaildName , bValidSurname: Boolean ;
  tFile : TextFile ;
begin
  redStudent.Clear;
  //Dynamic learner add button
  sStudentName := edtStudentName.Text ;
  sStudentSurname := edtStudentSurname.Text ;
  dDateJoined := dtpStudentJoined.Date ;

  //validation
  if sStudentName = '' then
  begin
    ShowMessage('Please enter a student name');
    Exit ;
  end;

  if sStudentSurname = '' then
  begin
    ShowMessage('Please enter a student surnname');
    Exit ;
  end;

  bVaildName := True ;
  for k := 1 to Length(sStudentName) do
      if  Not(UpCase(sStudentName[k]) in ['A'..'Z'])  then
        bVaildName := False ;

  if bVaildName = false  then
  begin
    ShowMessage('Please enter a name with only letters');
    exit ;
  end;


  bValidSurname := True ;
  for k := 1 to Length(sStudentSurname) do
      if  Not(UpCase(sStudentSurname[k]) in ['A'..'Z'])  then
        bValidSurname := False ;

  if bValidSurname = False then
  begin
    ShowMessage('Please enter a Surname with only letters');
    exit ;
  end;

  if dDateJoined > Date  then
  begin
    ShowMessage('Please enter a date in the past when you actually joined ');
    exit ;
  end;


  if MessageDlg('Has the student made a donation?',mtCustom,[mbYes,mbNo],0) = mrYes then
    rDonation := StrToFloat(InputBox('Donation','Please enter the amount the student entered',''))
  else
    rDonation := 0.00 ;

  //Instantiate object class
  objNewStudent := TNewStudent.Create(sStudentName,sStudentSurname,dDateJoined)  ;
  objNewStudent.SetDonation(rDonation);

  redStudent.Lines.Add(objNewStudent.ToString);
  // the mentor's ID is linked to the course that they teach which is equal to the index of the arrays
  redStudent.Lines.Add('Course Information: '+arrCourse[objNewStudent.GetMentorID]);
  redStudent.Lines.Add('Course Venue: '+arrVenue[objNewStudent.GetMentorID]);

  //Insert into table
  qryYogaStudents.SQL.Text := 'Select * from tblStudents ' ;
  qryYogaStudents.Open ;
  iNum := qryYogaStudents.RecordCount+1 ;
  qryYogaStudents.SQL.Text := 'Insert into tblStudents (StudentID,Name,Surname,[Date joined],Course,Donation,MentorID) values ('+IntToStr(iNum )+','+QuotedStr(sStudentName)+','+QuotedStr(sStudentSurname)+',#'+DateToStr(dDateJoined)+'#,'+QuotedStr(objNewStudent.GetCourse)+','+FloatToStrF(rDonation,ffFixed,10,2)+','+IntToStr(objNewStudent.GetMentorID)+')';
  qryYogaStudents.ExecSQL ;

  qryYogaStudents.SQL.Text := 'Select Name as [Yoga Teacher] from tblTeachers where TeacherID ='+IntToStr(objNewStudent.GetMentorID);
  qryYogaStudents.Open ;
  // Update array
  Inc(arrNumStudents[objNewStudent.GetMentorID]);
  // update textfile
  AssignFile(tFile,'CourseInfo.txt');
  Rewrite(tFile);
  iCount := 0;

  while iCount < 10  do
  begin
    Inc(iCount);
    Writeln(tFile,arrCourse[iCount],'#',arrVenue[iCount],'#',IntToStr(arrNumStudents[iCount]));
  end;
  CloseFile(tFile);
  ReadFromFile ;
end;

procedure TfrmYoga.btnHelpClick(Sender: TObject);
begin
  //Help button
  ShowMessage('Please click the button to access the relevent protal');
end;

procedure TfrmYoga.btnHomeClick(Sender: TObject);
begin
  // Home button teacher form
  pgcYoga.ActivePageIndex := 0 ;
end;

procedure TfrmYoga.btnNextClick(Sender: TObject);
begin
  //Next home
  ShowMessage('Please click on the relevent button to access the next page you would like to go to');
end;

procedure TfrmYoga.btnResetClick(Sender: TObject);
begin
  // Reset home
end;

procedure TfrmYoga.btnShowStudentsClick(Sender: TObject);
var
  iNumStudents : Integer ;
begin
  // Complex selection
  // Both tables
  qryYogaTeachers.SQL.Text := ' Select tblStudents.Name,tblStudents.Surname,Course from tblTeachers,tblStudents where (tblTeachers.TeacherID = tblStudents.MentorID) and (MentorID = ' + IntToStr(iTeacherID)+')  Order by tblStudents.Name' ;
  qryYogaTeachers.Open ;

  iNumStudents := qryYogaTeachers.RecordCount ;
  redTeacher.Clear ;
  redTeacher.Lines.Add('You have '+ IntToStr(iNumStudents) + ' contributing students');
  redTeacher.Lines.Add('The course you teach is: '+ arrCourse[iTeacherID]);
  redTeacher.Lines.Add('The venue you teach in is: '+ arrVenue[iTeacherID]);
end;

procedure TfrmYoga.btnStatContributionsClick(Sender: TObject);
begin
  // Display total amount contributed per course
  qryYogaTeachers.SQL.Text := 'Select course, Format(Sum(Donation),"Currency") as [Total amount of students Donation] from tblStudents group by course ';
  qryYogaTeachers.Open ;
end;

procedure TfrmYoga.btnStatCoursesClick(Sender: TObject);
var
  iHigh ,k : integer ;
begin
  //display total number of students per course
  qryYogaTeachers.SQL.Text := 'Select Course,Count(*) as [Number of people] from tblStudents group by Course ';
  qryYogaTeachers.Open ;

  redTeacher.Lines.Add('There are only 10 courses available for the students starting from beginner course A to final course J');

  // finding course description with the highest number of students
  iHigh := 1 ;
  for k := 2 to 10 do
    if arrNumStudents[k] > arrNumStudents[iHigh] then
      iHigh := k ;

  redTeacher.Clear ;
  redTeacher.Lines.Add('Course with most number of students: ' + arrCourse[iHigh]) ;
  redTeacher.Lines.Add('The above course has: ' + IntToStr(iHigh)+ ' number of students');

end;

procedure TfrmYoga.btnStudentAccessClick(Sender: TObject);
begin
  // Student login
  if MessageDlg('Are you already registered as a student?',mtInformation,[mbYes,mbNo],0) = mrYes  then
  begin
    iStudentID := StrToInt(InputBox('StudentID','Please enter your student ID','1'));
    qryYogaStudents.SQL.Text := 'Select * from tblStudents where StudentID =' + IntToStr(iStudentID) ;
    qryYogaStudents.Open ;
    pgcYoga.ActivePageIndex := 2;
  end
  else
    ShowMessage('Please ask your teacher to register you with the yoga school');
  StudentLogin(iStudentID);
end;

procedure TfrmYoga.btnStudentBackClick(Sender: TObject);
begin
  //Student back
  pgcYoga.ActivePageIndex := 0 ;
end;

procedure TfrmYoga.btnStudentHomeClick(Sender: TObject);
begin
  // student home
  pgcYoga.ActivePageIndex := 0;
end;

procedure TfrmYoga.btnStudentResetClick(Sender: TObject);
begin
  //reset student form
  edtStudentName.Clear ;
  edtStudentSurname.Clear ;
  edtStudentDonation.Clear ;
  dtpStudentJoined.Date := Now ;
  redStudent.Clear ;
end;

procedure TfrmYoga.btnTeacherAccessClick(Sender: TObject);
var
  sPasscode : string ;
begin
  //Teacher login
  sPasscode := InputBox('Pass code','Please enter the teacher passcode','Yoga4life');
  if (sPasscode <> '') or (sPasscode = 'Yoga4Life') then
  begin
    pgcYoga.ActivePageIndex := 1 ;
    TeacherDisplay ;
  end
  else
    begin
      ShowMessage('The passcode you entered is incorrect please try again');
    end;
end;

procedure TfrmYoga.btnTeacherAddClick(Sender: TObject);
var
  sName , sSurname : string ;
  iHours , iLevel: Integer ;
  bAccomodation : Boolean ;
begin
  // Add new teacher
  redTeacher.Clear;

  sName := edtTeacherName.Text ;
  sSurname := edtTeacherSurname.Text ;
  iHours := sedTeacherHours.Value ;
  bAccomodation := chkAccomodation.Checked ;
  iLevel := StrToInt(edtTeacherLevel.Text);

  //VALIDATION
  if sName = '' then
  begin
    ShowMessage('Please enter a name');
    Exit ;
  end;

  if sSurname = '' then
  begin
    ShowMessage('Please enter a Surname');
    Exit ;
  end;

  if iHours <0 then
  begin
    ShowMessage('Please anter a proper number of hours');
    Exit ;
  end;

  if not(iLevel in [0..9]) then
  begin
    ShowMessage('Please anter an appropriate level');
    Exit ;
  end;

  //There are only 10 levels
  if Not((iLevel > 0) and (iLevel<11)) then
  begin
    ShowMessage('There are only 10 levels, please enter your actual level');
    Exit ;
  end;

  qryYogaTeachers.SQL.Text := 'Insert into tblTeachers (Name,Surname,[Hours of practice],Accomodation,[level]) values ('+QuotedStr(sName)+','+QuotedStr(sSurname)+','+IntToStr(iHours)+','+BooltoStr(bAccomodation)+','+IntToStr(iLevel)+')';

  qryYogaTeachers.ExecSQL ;
  qryYogaTeachers.SQL.Text := 'Select * from tblteachers where Name = '+ QuotedStr(sName);
  qryYogaTeachers.Open ;
end;

procedure TfrmYoga.btnTeacherBackClick(Sender: TObject);
begin
  //Back from teacher form
  pgcYoga.ActivePageIndex := 0;
end;

procedure TfrmYoga.btnTeacherHelpClick(Sender: TObject);
begin
  // Help Teacher button
  ShowMessage('As a teacher you can do many things, Please click on the relevent button to do the task you need to do');
end;

procedure TfrmYoga.btnTeacherResetClick(Sender: TObject);
begin
  //Reset Teacher form
  edtTeacherName.Clear ;
  edtTeacherSurname.Clear ;
  sedTeacherHours.Clear ;
  chkAccomodation.Checked := False ;
  edtTeacherLevel.Clear ;
end;

procedure TfrmYoga.btnTeacherUpdateClick(Sender: TObject);
var
  iHours : Integer ;
  bAccomodaton : Boolean ;
begin
 // updating the teacher table
 redTeacher.Clear ;
  iHours := sedTeacherHours.Value ;
  bAccomodaton := chkAccomodation.Checked ;

  ShowMessage('Please note you may only update your hours and your accomodation fields');

  //validation
  if iHours <0  then
  begin
    Showmessage('Please enter a appropriate number of hours');
    exit ;
  end;

  qryYogaStudents.SQL.Text := 'Update tblTeachers Set [Hours of practice] = [Hours of practice] + '+ IntToStr(iHours)+',Accomodation = '+BoolToStr(bAccomodaton)+' where TeacherID = ' +IntToStr(iTeacherID);
  qryYogaStudents.ExecSQL;
  TeacherDisplay ;
end;

procedure TfrmYoga.btnViewClassesClick(Sender: TObject);
var
iCourseIndex : integer ;
sCourseInfo ,sVenue : string ;
begin
  //Displaying class Information
  redStudent.Clear ;


  if dtpStudentJoined.Date > Date  then
  begin
    ShowMessage('Please enter the date you joined ');
    exit ;
  end;

  iCourseIndex := YearsBetween(Date,dtpStudentJoined.Date);

  sCourseInfo := arrCourse[iCourseIndex];
  if iCourseIndex >= 10 then
    sCourseInfo := 'J'
  else
    if iCourseIndex = 0 then
      sCourseInfo := 'A'
    else
      sCourseInfo :=  Chr(iCourseIndex +64);

  sVenue := arrVenue[iCourseIndex];

  redStudent.Lines.Add('Course details: '+ sCourseInfo) ;
  redStudent.Lines.Add('Venue: '+ sVenue);

  qryYogaStudents.SQL.Text :=' Select Name as [Your teacher is] from tblTeachers where TeacherID =' + IntToStr(iCourseIndex) ;
  qryYogaStudents.Open ; 

end;

procedure TfrmYoga.FormActivate(Sender: TObject);
begin
  //Form OnActivate
  pgcYoga.ActivePageIndex := 0 ;
  dtpStudentJoined.Date := Now ;
  ReadFromFile ;

  //Media player extra feature
  mpBonobo.FileName := 'Bonobo.mp3';
  mpBonobo.Open ;
  mpBonobo.Play ;
  mpBonobo.VisibleButtons := [btPlay,btStop] ;
end;

procedure TfrmYoga.ReadFromFile;
var
  sLine : string ;
  iPos ,iCount : Integer ;
  tCourseInfoFile : TextFile ;
begin
  // Reading text file data into arrays
  if FileExists('CourseInfo.txt')<> True  then
  begin
    ShowMessage('The file does not exist');
    Exit ;
  end;

  AssignFile(tCourseInfoFile,'CourseInfo.txt');
  Reset(tCourseInfoFile);
  iCount := 0;

  while not Eof(tCourseInfoFile) and (iCount <10) do
  begin
    Readln(tCourseInfoFile,sLine);
    Inc(iCount);

    //sLine = Ashtanga,intense flowing style with a set sequence of postures#A1#0
    iPos := Pos('#',sLine);
    arrCourse[iCount] := Copy(sLine,1,iPos-1);
    Delete(sLine,1,iPos);

    //A1#0
    iPos := Pos('#',sLine);
    arrVenue[iCount] := Copy(sLine,1,iPos-1);
    Delete(sLine,1,iPos);

    //0
    arrNumStudents[iCount] := StrToInt(sLine);
  end;

  CloseFile(tCourseInfoFile);
end;

procedure TfrmYoga.StudentLogin(pStudentID: Integer);
begin
  //Diplaying Student data as they login
  qryYogaStudents.SQL.Text := 'Select * from tblStudents where StudentID = ' + IntToStr(pStudentID) ;
  qryYogaStudents.Open ;
end;

procedure TfrmYoga.TeacherDisplay;
begin
  // teacher display information
  // Initialised Teacher ID
  iTeacherID := StrToInt(InputBox('TeacherID','Please enter your teacher ID','1'));

  qryYogaTeachers.SQL.Text := 'Select * from tblTeachers where TeacherID =' + IntToStr(iTeacherID) ;
  qryYogaTeachers.Open ;

  redTeacher.Clear ;
  redTeacher.Lines.Add('Your Teacher record is displayed below');

end;

end.
