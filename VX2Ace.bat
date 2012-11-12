@echo off
echo [Welcome to VX2Ace Automated Batch File]
echo Cleaning old files
call cleanup.bat
echo Executing VX2Hash
call VX2Hash.exe
echo Executing Hash2Ace
call Hash2Ace.exe
echo Completed

