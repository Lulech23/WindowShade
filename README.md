# 💻 WindowShade (Color Calibration Tools)
WindowShade is a collection of color calibration tools written in PowerShell. It currently features support for installing and applying color profiles from a built-in database, external \*.icc or \*.icm files, or restoring defaults if the applied calibration is no longer desired. Support for modifying profiles is planned.

WindowShade also supports a custom \*.icz file package which comprises multiple color profiles for use at different brightness levels. This can be used to offset natural display tinting at different levels, or to intentionally alter display color for different viewing conditions (e.g. red filter for low light, high gamma for outdoors, etc). This is handled through a background service, also written in pure PowerShell, which is generated on-the-fly. 

## About
Windows includes built-in tools for calibrating display color and gamma, but many users may never realize it. These tools are old and increasingly buried beneath layers of legacy menus. Plus, applying a calibration profile *persistently* is not obvious and can be confusing.

WindowShade removes this unnecessary complexity and makes it easy for anyone to install calibration profiles tailor-made for their displays. Proper calibration is not simple and requires lots of time, so it is WindowShade's goal to facilitate easy sharing of profiles for all kinds of Windows devices.

#### You could go from this... to this!
![WindowShade Comparison](/screenshots/windowshade.jpg)

## How to Use
WindowShade currently includes two separate installers, but many behaviors are shared between them. However, cross-compatibility is not guaranteed, so you should always use the same installer to install and uninstall a particular profile. Each installer serves a different purpose, so choose the one that's best for you.

#### Which installer is right for me?
* Use the **Standard Installer** to setup a single \*.icc or \*.icm profile to remain permanent until uninstalled.
* Use the **Responsive Installer** to setup an \*.icz package with an always-running service to adjust display calibration dynamically based on brightness (does not apply to desktop monitors)

#### To Install a Profile:
1. Download the latest version of WindowShade from [releases](https://github.com/Lulech23/WindowShade/releases). 
2. Run `WindowShade Installer.bat`.
3. Enter a number corresponding to the desired menu option and press `ENTER`.
4. Follow the prompts to complete setup--it's easy!

#### To Uninstall:
1. Run `WindowShade Installer.bat` again.
2. Enter the number corresponding to the "uninstall" menu option and press `ENTER`.
3. All changes to your system will be reverted.

#### To Update:
Just run the installer again--uninstalling first isn't necessary!

## Advanced Usage
**Did you know?** Both installers also support command-line profile installation!

#### To Install a Profile:
1. Open PowerShell or CMD and navigate to the directory where `WindowShade Installer.bat` is stored
2. Enter `WindowShade Installer.bat` followed by the **fully qualified** path to your custom profile (no relative paths). _Example:_ `".\WindowShade Standard Installer.bat" "C:\Users\Me\Downloads\MyCustomProfile.icc"`
3. Run the command to apply your custom profile

#### To Create a Profile Package:
1. Turn your display up to 100% brightness
2. Search for and run `dccw.exe`
3. Proceed through the Windows calibration process until you are satisfied with the results, but **do not** click "Finish"!
4. Open File Explorer and navigate to `%WINDIR%\System32\spool\drivers\color`
5. Locate the temp calibration profile created by `dccw` and copy it to a safe location. Rename it "100.icc" for 100% brightness
6. Return to the calibration window and click **back** until you reach the gamma adjustment screen
7. Turn your display down to 75% brightness
8. Repeat steps 3-7, reducing your display brightness by 25% each time. When finished, you should have 5 profiles: "0.icc", "25.icc", "50.icc", "75.icc", and "100.icc"
9. Run `WindowShade Responsive Installer.bat` and choose to create a new \*.icz package
10. Proceed through the installer prompts to locate your profiles
11. An \*.icz package will be created, ready for installation

## Known Issues
* **None for now! Hooray!**