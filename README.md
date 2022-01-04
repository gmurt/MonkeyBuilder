# MonkeyBuilder
MonkeyBuilder is a build automation tool for iOS & Android Firemonkey projects. 

![Screenshot](https://github.com/gmurt/MonkeyBuilder/blob/main/Docs/images/screenshot.png?raw=true)

### Requirements

Delphi 11 is the minumum required Delphi version to use MonkeyBuilder. As new Delphi versions are released, it wil very likely only support the latest version due to the ever-changing landscape of mobile app development.

### Please Note

MonkeyBuilder is still a work in progress. I developed it to allow me to automate my own build process with regards to Firemonkey apps I have developed.  There are going to be a lot of scenarios which it will fail due to the fact that your apps will be very different to mine and your apps may require build/deploy functionality which MonkeyBuilder does not yet support.

Due to other committments, my time is limited with regards to MonkeyBuilder.  I will keep developing it as and when I can but any help in finding/fixing issues or submitting pull requests would be gladly received.

### Is the code pretty?

Hell no! I never had any initial design or specification to work against... this project has very much been a test to see if I could get something working. The development has involved lots of trial and error along with trying to reverse engineer the Delphi build process using the log window and analysis of the files/folder structures it produces when building/deploying.

### Before you begin

To build apps for iOS, you'll need to have PAServer running on the Mac and also have the Mosco app installed and running which you can find in the \Bin folder of this repository. You'll need to set the location of the Mosco server in the MonkeyBuilder settings screen.


### Required third party libraries

The following libraries are required to enable you to build the MonkeyBuilder source code:

JsonDataObjects - https://github.com/ahausladen/JsonDataObjects

Delphi ZeroMQ - https://github.com/grijjy/DelphiZeroMQ

JCL - https://github.com/project-jedi/jcl

JVCL - https://github.com/project-jedi/jvcl

Spring4d - https://bitbucket.org/sglienke/spring4d


### Credits

A massive thanks has to go to Dave Nottage of DelphiWorlds (https://github.com/DelphiWorlds) who has developed the mosco app for MacOS along with the units for interfacing with this app over the network.  Without this, MonkeyBuilder for iOS just wouldn't have been possible.
