set DLC=D:\dlc\122.64bit
set OEPAS=mypasoe

set HTTP_PORT=7493
set HTTPS_PORT=7494
set SHUTDOWN_PORT=7495

set CWD=%~dp0

start /wait /B /D"%DLC%" CMD /c "servers\pasoe\bin\tcman create -R -f -p %HTTP_PORT% -P %HTTPS_PORT% -s %SHUTDOWN_PORT% "%CWD%\..\%OEPAS%"

"..\%OEPAS%\bin\oeprop" -f "%CWD%\mypasoe.props"

PAUSE