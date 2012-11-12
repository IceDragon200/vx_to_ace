# VX2ACE
## Version 0.91

### Warranty
This software is provided, as is.
There is no warranty, so before you screw yourself over, backup your projects
Use at your own risk.

### What is this?
Nothing big, this little package contains 2 scripts so to speak, 
which convert VX (rvdata) to a VX2Ace (vx2dump) and then to Ace (rvdata2)

### Features
```
  Conversion of RPG Maker VX project data to RPG Maker VXA Compliant

```

### Future Plans
A working linux port. For whatever reason I'd want that.
Purify source code, and make the process a little easier.

### Few problems:
```
### Armor
  Prevent Critical has not been solved and implemented.

### State
  Offset by Opposite, is not supported.

### Scripts
  So far I have been able to extract scripts.rvdata and scripts.rvdata2
  However repacking has posed a problem when working with the editor.

```  

### How to Use:
vx2ace.conf - VX2Ace Config File
```
VXDataIn=<String>
  Set a folder for the source *.rvdata
  default:
    "vx2-data-in"

VXDataOut=<String>
  Set a output folder for the VX Hash Data
  default:
    "vx2-data-out"

AceDataOut=<String>
  Set a output directory for the Completed Ace data
  default:
    "vx2-data-out-ace"

ActorParam2Class=<Integer>
  A change in VXA was that Actor's no longer had Parameters
  This was instead moved to classes.
  By default V2A does not copy Actor Parameters to the corresponding classes
  **You should only use this, if each actor has there own unique class.
  default:
    1

CleverClassEquip=<Integer>
  This will try to create unique weapon and armor types for classes
  default:
    0
```
#### NOTE - this file is actually loaded as ruby code, so you can do some crazy stuff if you need to.

### General Instructions
Windows Users
```
1 .Copy your rvdata (RMVX) into the VXData(In) folder, if the folder does not exist, create it.
   Do not copy:
     Animations.rvdata
     Scripts.rvdata
     MapInfos.rvdata
     CommonEvents.rvdata
     
   To use them in Ace simply change the extensions to rvdata2 and copy them to your project's data folder.
   
2 .Run VX2Hash
3 .Wait for it to finish, and check the VXData(Out), ensure that you have .vx2dump files in it.
4 .Run Hash2Ace
5 .Wait for it to finish, and check the output_data(Ace) folder.
6 .Copy your new files from the output_data(Ace) folder into your Ace project's data folder and replace
7 .Congrats, you have converted your RMVX project to Ace.
8 .You may copy your Animations.rvdata, Scripts.rvdata, MapInfos.rvdata, CommonEvents.rvdata,
   after renaming them to change their extension to rvdata2.
     These are the only files that remain persistent between VX and VXA
     
9 .Give cookies to IceDragon     
10.You could just use the VX2Ace.bat, and then copy the files from output_data(Ace), your choice.
```

Linux Users
```
Soon to come :D
```
