VX2ACE
======

## Version 0.91 (Untested : Windows)

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
```
1 . A working linux port. For whatever reason I'd want that.
2 . Purify source code, and make the process a little easier.
3 . Integrity Checker for the command line version
```

### Few problems:
```
Armor
  Prevent Critical has not been solved and implemented.

State
  Offset by Opposite, is not supported.

Scripts
  So far I have been able to extract scripts.rvdata and scripts.rvdata2
  However repacking has posed a problem when working with the editor.
  Besides, who would need their old VX Scripts for Ace anyway, since their 
  incompatible anyway.
```  

### How to Use:
vx2ace-conf.rb - VX2Ace Config File
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

ActorParam2Class=<Boolean>
  A change in VXA was that Actor's no longer had Parameters
  This was instead moved to classes.
  By default V2A does not copy Actor Parameters to the corresponding classes
  **You should only use this, if each actor has there own unique class.
  default:
    true

CleverClassEquip=<Boolean>
  This will try to create unique weapon and armor types for classes
  default:
    false
```
#### NOTE - this file is actually loaded as ruby code, so you can do some crazy stuff if you need to.

### General Instructions
Instructions - READ EM
```
<VXDataIn>  
<VXDataOut>
<AceDataData>  
  these refer to the vx2ace-conf.rb constants
```

Windows Users
```
1 . Copy your *.rvdata (RMVX) into the <VXDataIn> folder, if the folder does not exist, create it.
    Do not copy:
      Animations.rvdata
      Scripts.rvdata
     
    To use them in Ace simply change the extensions to rvdata2 and copy them to your project's data folder.
2 . Run VX2Hash.exe
3 . Wait for it to finish, and check the <VXDataOut>, ensure that you have *.vx2dump files.
4 . Run Hash2Ace.exe
5 . Wait for it to finish, and check the <AceDataOut> folder to ensure that you have *.rvdata2 files.
6 . Copy your new files from the <AceDataOut> folder into your Ace project's data folder and replace
7 . Congrats, you have converted your RMVX project to Ace.
8 . You may copy your Animations.rvdata, Scripts.rvdata,
    after renaming them to change their extension to rvdata2.
      These are the only files that remain persistent between VX and VXA
     
9 . Give cookies to IceDragon     
10. You could just use the VX2Ace.bat, and then copy the files from <AceDataOut>, your choice.
```

Linux / Command-line Users
```
nix-main.rb has a few parameters you can use.
Just simply run nix-main.rb with no parameters to see the help, or just --help as a parameter

<--src> 
  Source folder, 
    default: <VXDataIn> when using --tohash
    default: <VXDataOut> when using --toace

<--dest>
  Destination folder, 
    default: <VXDataOut> when using --tohash
    default: <AceDataOut> when using --toace 

1 . Copy your *.rvdata (RMVX) into the <--src> folder, if the folder does not exist, create it.
    Do not copy:
      Animations.rvdata
      Scripts.rvdata
     
    To use them in Ace simply change the extensions to rvdata2 and copy them to your project's data folder.
2 . ruby nix-main.rb --tohash
3 . Wait for it to finish, and check the <--dest>, ensure that you have *.vx2dump files.
4 . ruby nix-main.rb --toace
5 . Wait for it to finish, and check the <--src> folder to ensure that you have *.rvdata2 files.
5 . Your done
```
