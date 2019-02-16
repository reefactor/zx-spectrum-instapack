unit h0;
interface
uses Overlay,OverXMS;
implementation
begin
OvrInit({'sn.ovr'{}ParamStr(0){});
{OvrInitXMS;{}
{
if ovrResult<>ovrOk then
 begin
  writeln('Overlays file SN.OVR not found...');
  halt;
 end;
{}
end.