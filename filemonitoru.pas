unit FileMonitorU;

{$mode objfpc}{$H+}

interface

uses
  Forms, Dialogs, Classes, SysUtils
  {$IFDEF DARWIN}
  , FSEvents;
  {$ELSE}
  ;
  {$ENDIF}

procedure StartFSEvents (AWatchPaths: Array of WideString);

implementation

{$IFDEF DARWIN}
procedure FSStreamCallBack (
                           streamRef: ConstFSEventStreamRef;
                           clientCallBackInfo: UnivPtr;
                           numEvents: size_t;
                           eventPaths: UnivPtr;
                           {const} eventFlags: {variable-size-array} FSEventStreamEventFlagsPtr;
                           {const} eventIds: {variable-size-array} FSEventStreamEventIdPtr
                           ); MWPascal;
begin
  ShowMessage ('changes happen for a reason');
end;

procedure StartFSEvents (AWatchPaths: Array of WideString);
  var
    AContext: FSEventStreamContext;
    APaths: Array[0..1023] of CFArrayRef;
    ACb: FSEventStreamCallback;
    i, i2: Integer;
    APath: String;
  begin
    if Assigned(FFStream) then
      exit;

    FillChar(AContext, SizeOf(AContext), 0);
    AContext.info := self;

    i2 := 0;
    for i := Low(AWatchPaths) to High(AWatchPaths) do
    begin
      APath := UTF8Encode(AWatchPaths[i]);
      APaths[i2] := CFArrayRef(CFSTR(PChar(APath)));
      Inc(i2);
    end;

    ACb := @FSStreamCallBack;
    FFStream := FSEventStreamCreate(
                                   nil,
                                   ACb,
                                   @AContext,
                                   CFArrayCreate(nil, @APaths, Length(AWatchPaths), nil),
                                   kFSEventStreamEventIdSinceNow,
                                   0,
                                   kFSEventStreamCreateFlagNoDefer{kFSEventStreamCreateFlagWatchRoot}
                                   );
    if Assigned(FFStream) then
    begin
      FSEventStreamScheduleWithRunLoop(FFStream, CFRunLoopGetCurrent, kCFRunLoopDefaultMode);
      FSEventStreamStart(FFStream);
    end;

  end;
{$ENDIF}

procedure StartFSEvents (AWatchPaths: Array of WideString);
begin
  //
end;

end.

