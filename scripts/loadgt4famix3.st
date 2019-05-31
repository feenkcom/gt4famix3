EpMonitor current debugMode: true.
EpMonitor current disable.
Metacello new
    baseline: 'GToolkit4Famix3';
    repository: 'github://feenkcom/gt4famix3/src';
    load.
World closeAllWindowsDiscardingChanges.
#GtWorldMenu asClass setGtDesktopLogo.


Smalltalk snapshot: true andQuit: false.
