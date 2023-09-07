# mp-2023-godot

This repository contains all Godot code / files that were created during the 2023 summer term master project.

## How to use this repository

Because the exploration during our work went into many directions, this repository also has different points of interest, which are tagged.

### study

With the tag "study", all relevant files are included that can be used to conduct the VR part of the quantitative study. Further information can be found in the mp-2023-study repository.
Commits in this tag add the user study, which is rooted in the study_shell.tscn node.

### shell

The tag "shell" contains components which are part of a vision of a VR shell, a system supporting different running apps or rooms, with different ways of switching between apps and rooms interacting with each other. This version only contains a rudimentary room switcher.

It includes three rooms/apps: Adventure (Bow and Arrow), Email and Calendar. Open the room switcher menu with A and select a room by pointing to it and using the grip button.
The bow and arrow game can be used by taking the bow and using grip, pulling on the string and releasing.
The mail room includes mails than can be grabbed, which expand.
The calendar room contains a calendar that can be navigated with the analog stick.

### vrobjects

The tag "vrobjects" contains work on a different study, one comparing three different implementations with varying degrees of composition.

- Meta slices 2D were inspired by Meta's implementation of 2D apps on oculus quest headsets
- 2D Tablets are a little bit more flexible, since they can be freely arranged
- Vr Objects are decomposable apps, i.e. in a calendar application, users would be able to take out single events or days.

In this tag these 3 interface methods are implemented in rudimentary fashion for a calendar and a mail application in a class room. The room switcher menu can be used to navigate to a specific scenario (use trigger to select a scenario). Handle bars can be used to move objects around.

### gaze-tracking

The tag "gaze-tracking" features experiments on gaze/eye tracking using Meta Quest Pro.

**Setup Gaze-Tracking**
Setup instructions are based on this [pull request](https://github.com/godotengine/godot/pull/77989).
1. Make a custom editor build of Godot from this pull request: https://github.com/godotengine/godot/pull/77989
2. Download the source code from this branch/tag: https://github.com/hpi-swa-lab/vr-shell/releases/tag/gaze-tracking
3. Modify the `vr-shell-gaze-tracking/android/build/src/com/godot/game/GodotApp.java` like this to ask for eye tracking permission:
```java
package com.godot.game;

import org.godotengine.godot.FullScreenGodotApp;
import android.content.pm.PackageManager;

import android.os.Bundle;

/**
 
Template activity for Godot Android builds.
Feel free to extend and modify this class for your custom logic.
*/
public class GodotApp extends FullScreenGodotApp {
    private static final String PERMISSION_EYE_TRACKING = "com.oculus.permission.EYE_TRACKING";
      private static final int REQUEST_CODE_PERMISSION_EYE_TRACKING = 1;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        setTheme(R.style.GodotAppMainTheme);
        super.onCreate(savedInstanceState);
        requestEyeTrackingPermissionIfNeeded();
    }

    private void requestEyeTrackingPermissionIfNeeded() {
        if (checkSelfPermission(PERMISSION_EYE_TRACKING) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[] {PERMISSION_EYE_TRACKING}, REQUEST_CODE_PERMISSION_EYE_TRACKING);
        }
    }
}
```
4. Update the `vr-shell-gaze-tracking/android/build/AndroidManifest.xml` to ask for eye tracking permission:
```xml
<uses-feature android:name="oculus.software.eye_tracking" android:required="true" />
<uses-permission android:name="com.oculus.permission.EYE_TRACKING" />
```
   

## Setup

### Meta Quest 2 Export

- **Be sure to also complete the recommended requirements for [Exporting to Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html#doc-exporting-for-android)!**
- Install openxr tools
- Install "Godot XR Android OpenXR Loaders" from the AssetLib
- Follow the guide on this page: <https://docs.godotengine.org/en/stable/tutorials/xr/deploying_to_android.html#setup>
