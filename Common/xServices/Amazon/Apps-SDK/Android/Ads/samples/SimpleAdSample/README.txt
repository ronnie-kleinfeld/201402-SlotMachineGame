Android Amazon Mobile Ads Simple Ad Sample

COMPILING THE PROJECT:
Before you can compile the project, you must have Eclipse and the Android SDK (v1.6 or higher) installed.

1) Import the project into Eclipse by right clicking inside the Package Explorer window and selecting "Import". Then choose "General/Existing Projects into Workspace" from the list, specify the sample app's folder as the root directory, and click "Finish".
2) Right click on the project in Package Explorer and open the project's properties.
3) Select "Java Build Path", and click on the "Libraries" tab.
4) Click on "Add External JARs" and add the Amazon Mobile Ads API JAR, amazon-ads-x.x.x.jar, located in the Ads/lib folder.
5) Click on the "Order and Export" tab, and select the recently added JAR for export. Click "OK" to close out the properties dialog.
6) In the menu bar, select the "Project" menu and click "Build All" if it's not grayed out.

RUNNING THE PROJECT:
1) Plug in a physical Android device into your computer, or setup an Android Virtual Device using the Android Virtual Device Manager.
2) Right click on the project, select the "Run As" menu, and click "Android Application". 