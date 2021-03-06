unit clsNewStudent_u;

interface
type
  TNewStudent = class(TObject)
  private
    fName , fSurname : string ;
    fDateJoined : TDate ;
    fCourse : Char ;
    fMentorID : Integer ;
    fDonation : Real ;

    procedure DetermineCourse;
    procedure DetermineMentorID ;

  public
    constructor Create(pName,pSurname:string;pDatejoined :TDate);
    procedure SetDonation(pDonation:Real);
    function GetMentorID : Integer ;
    function GetCourse : Char ;
    function ToString :string ;

end;

implementation

uses SysUtils, DateUtils ;

{ TNewStudent }

constructor TNewStudent.Create(pName, pSurname: string; pDatejoined: TDate);
begin
  // constructor
  fName := pName ;
  fSurname := pSurname ;
  fDateJoined := pDatejoined ;
  DetermineCourse ;
  DetermineMentorID;
end;

procedure TNewStudent.DetermineCourse;
var
  iYearsPracticed : Integer ;
begin
  // Determining the course there are only 10 courses that are completed yearly,
  // if the student has practiced for more than 10 years they will be on the final course
  iYearsPracticed :=  YearsBetween(Date,fDateJoined);
  if iYearsPracticed >= 10 then
    fCourse := 'J'
  else
    if iYearsPracticed = 0 then
      fCourse := 'A'
    else
      fCourse :=  Chr(iYearsPracticed +64);

end;

procedure TNewStudent.DetermineMentorID;
begin
  // Assigning the student to a teacher based on their course
  fMentorID := Ord(fCourse)-64 ;

end;

function TNewStudent.GetCourse: Char;
begin
  // main form needs the course
  Result := fCourse ;
end;

function TNewStudent.GetMentorID: Integer;
begin
  // main form needs to show the teacher name
  Result := fMentorID ;
end;

procedure TNewStudent.SetDonation(pDonation: Real);
begin
  //  Dontions made by the students
  fDonation := pDonation ;
end;

function TNewStudent.ToString: string;
begin
  Result := 'New student details :' +#10;
  Result := Result + ' Name : '+ fName +#10;
  Result := Result + ' Surname : '+ fSurname +#10;
  Result := Result + ' Date joined : '+ DateToStr(fDateJoined)+#10 ;
  Result := Result + ' Course : '+ fCourse  +#10 ;
  Result := Result + ' Donation : '+ FloatToStrF(fDonation,ffCurrency,10,2)+#10 ;
  Result := Result + ' Mentor ID : '+ IntToStr(fMentorID)  ;
end;

end.
