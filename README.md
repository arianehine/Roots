Roots Project

This application was designed to help individuals improve their carbon impact, and as a result hopefully instill long term eco-friendly behaviours which will help in the fight against climate change.

This application is an iOS app, and uses different libraries to work. You will need to ensure these libraries have been imported, when setting the project up in xCode, and you'll also need to ensure that the encryption key has been set.

For ease of marking, the encryption key is included here in case a marker or external examiner wishes to check the code. This would NEVER be done in production as it compromises the whole system's security.

When you run `pod install' to fetch the dependencies, you'll be asked for the encryption key.
Please enter:
$3N2@C7@pXp

Is is important this EXACT key is set when Cocoapod Keys asks for it, in the terminal.

To run the sythesiser please run python3 Synthesiser.py - this will create the synthesisedData file which can then be dragged into the repo to be used for encryption. This fine should NOT be shipped with the application, only the encrypted version synthesisedDataEncrypted.txt

Once pod install has finished running, you should have a file Roots.xcworkspace - this is the file which you can open and run the code from, to verify that everything works.

Once you are in the Roots.xcworkspace file, set up a new scheme and select 'Roots', from here select your target emulator device
