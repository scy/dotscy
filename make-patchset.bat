@Echo Off
REM Create a patch for e-mail submission:
git format-patch --stdout --thread -C origin..HEAD > patch.txt