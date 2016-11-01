{$IFDEF VER120}      //delphi 4
  {$DEFINE D6M}
  {$DEFINE D6MFPC}
{$ENDIF}

{$IFDEF VER130}     // delphi 5
  {$DEFINE D6M}
  {$DEFINE D6MFPC}
{$ENDIF}

{$IFDEF VER140}     //delphi 6
  {$DEFINE D6P}
{$ENDIF}

{$IFDEF VER145}     //kylix
  {$DEFINE D6P}
{$ENDIF}

{$IFDEF VER150}     //delphi 7
  {$DEFINE D6P}
{$ENDIF}

{$IFDEF VER180}    // turbo delphi 2006
  {$DEFINE D6P}
{$ENDIF}

{$IFDEF VER200}    //  delphi 2009
  {$DEFINE D6P}
  {$DEFINE D9P}
{$ENDIF}

{$IFDEF VER210}    //  delphi 2010
  {$DEFINE D6P}
  {$DEFINE D9P}
{$ENDIF}

{$IFDEF VER220}    //  delphi XE
  {$DEFINE D6P}
  {$DEFINE DXE}
  {$DEFINE D9P}
{$ENDIF}

{$IFDEF VER230}    
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF VER240}    
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF VER250}    
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF VER260}    
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF VER270}    
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF VER280}    
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF VER290}    
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF VER300}  // delphi seattle 10
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF VER310} //delphi berlin 10.1
  {$DEFINE D6P}
  {$DEFINE D9P}
  {$DEFINE DXE}
{$ENDIF}

{$IFDEF FPC}
  //{$MODE DELPHI}
  {$mode objfpc}{$H+}
  {$DEFINE D6MFPC}
{$ENDIF} 

{$IFDEF LINUX}
  {$IFNDEF UNIX}
    {$DEFINE UNIX}
  {$ENDIF}
{$ENDIF}

//enamble this switch for interbase version < 6.0
//{$DEFINE FBL_IB5} 

//enable to switch to interbase 6 or firebird 1.0.x under linux with freepascal
//{$DEFINE LIBCRYPT}

//enable this switch with freepascal < 1.9.8
//{$DEFINE FPC_INFD}


//enable this switch for thread-safe feature for classes TFBLDatabase,TFBLTransaction,TFBDSql
//{$DEFINE FBL_THREADSAFE}
