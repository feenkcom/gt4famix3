# Glamorous Toolkit for Famix3
This repository holds the Glamorous Toolkit extensions for Famix3

## How to load

```
EpMonitor current disable.
[ 
  Metacello new
    baseline: 'GToolkit4Famix3';
    repository: 'github://feenkcom/gt4famix3/src';
    load
] ensure: [ EpMonitor current enable ].
```
