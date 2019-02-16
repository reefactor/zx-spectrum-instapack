{============================================================================}
{== IS THE WINDOWS RUNNING ? ================================================}
{============================================================================}
function WinX:boolean;  ASSEMBLER;
asm
  Mov AX,$4680                          {  Win 3.x Standard check       }
  Int $2F                               {  Call Int 2F                  }
  Cmp AX,0                              {  IF AX = 0 Win in real mode   }
  JNE @EnhancedCheck                    {  If not check for enhanced mode}
  Mov AL,1                              {  Set Result to true           }
  Jmp @Exit                             {  Go to end of routine         }
@EnhancedCheck:                         {  Else check for enhanced mode }
  Mov AX,$1600                          {  Win 3.x Enhanced check       }
  Int $2F                               {  Call Int 2F                  }
  Cmp AL,0                              {  Check returned value         }
  Je @False                             {  If not one of the below it   }
  Cmp AL,$80                            {  is NOT installed             }
  Je @False
  Mov AL,1                              {  Nope it must BE INSTALLED    }
  Jmp @Exit
@False:
  Mov AL,0                              {  Set Result to False          }
@Exit:
end;
{============================================================================}
{== WINDOWS VERSION =========================================================}
{============================================================================}
function WinVer:word;  ASSEMBLER;
asm
  Mov AX,$1600                     {    Enhanced mode check             }
  Int $2F                          {    Call Int 2F                     }
end;
{============================================================================}
{== IS THIS WINDOWS-95 ? ====================================================}
{============================================================================}
function is95;
begin
Is95:=false;
if winx then if (Lo(WinVer)=4) then Is95:=true;
end;
