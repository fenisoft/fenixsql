{$IFDEF FPC}
  //{$MODE delphi}
  {$mode objfpc}{$H+}
{$ENDIF}


{$IFDEF LINUX}
  {$IFNDEF FPC}
    {$DEFINE UNIX}
  {$ENDIF}
{$ENDIF}

{$IFNDEF UNIX}
{$APPTYPE CONSOLE}
{$ENDIF}

