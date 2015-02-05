EnvGet, HomeDir, USERPROFILE
DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, HomeDir . "\Dropbox\Images\Green on Pale.jpg", UInt, 3)
