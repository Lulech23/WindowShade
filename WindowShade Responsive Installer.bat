powershell.exe "Get-ExecutionPolicy -Scope 'CurrentUser' | Out-File -FilePath '%TEMP%\executionpolicy.txt' -Force; Set-ExecutionPolicy -Scope 'CurrentUser' -ExecutionPolicy 'Unrestricted'; $script = Get-Content '%~dpnx0'; $script -notmatch 'supercalifragilisticexpialidocious' | Out-File -FilePath '%TEMP%\%~n0.ps1' -Force; Start-Process powershell.exe \"Set-Location -Path '%~dp0'; ^& '%TEMP%\%~n0.ps1' %1\" -verb RunAs" && exit

<#
////////////////////////////////////////////////////
//  WindowShade Responsive Installer by Lulech23  //
////////////////////////////////////////////////////

Apply brightness-responsive Windows color calibration profiles with ease!

What's New:
* Initial release

Notes:
* 

To-do:
* 
#>


<#
INITIALIZATION
#>

# Version... obviously
$version = "1.0"

# Windows calibration profile path
$profile = ""
$path = "$env:WinDir\System32\spool\drivers\color"

# Step count
$steps = 0
$step  = 0


<#
BUILT-IN PROFILES
#>

# [Convert]::ToBase64String([IO.File]::ReadAllBytes($FileName))
$builtin = @(
    "Aya Neo v1.icz", "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"
)


<#
SHOW VERSION
#>

# Ooo, shiny!
Write-Host "`n                                                     " -BackgroundColor Blue -NoNewline
Write-Host "`n WindowShade Responsive Installer [v$version] by Lulech23 " -NoNewline -BackgroundColor Blue -ForegroundColor White
Write-Host "`n                                                     " -BackgroundColor Blue

# About
Write-Host "`nThis script will replace the current display calibration with a responsive"
Write-Host "profile selected from the menu below. Responsive profiles are packages comprised"
Write-Host "of unique color and gamma settings for different brightness levels."
Write-Host "`nYou may also run this script via command-line followed by the fully-qualified"
Write-Host "path to your *.icz package to install a new profile directly."
Write-Host "`nResponsive profiles require the use of an always-running background service." -ForegroundColor Cyan
Write-Host "The WindowShade service will override other calibrations while active." -ForegroundColor Cyan

# Current Profile
Write-Host "`nCalibration profile is currently set to: " -NoNewline
$profile = [string] (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles\").sRGB
$service = (Test-Path -Path "$env:AppData\WindowShade\wsservice.ps1")
if ($profile.length -gt 0) {
    Write-Host "$profile" -ForegroundColor Yellow
    Write-Host " * Display is calibrated" -ForegroundColor Gray
    Write-Host " * Colors and gamma have been customized to suit your display" -ForegroundColor Gray
    if ($service -eq $true) {
        Write-Host " * WindowShade service is active. Profile will adapt to display brightness" -ForegroundColor Gray
    } else {
        Write-Host " * WindowShade service not found. Profile will not adapt to display brightness" -ForegroundColor Gray
    }
} else {
    Write-Host "Default" -ForegroundColor Magenta
    Write-Host " * Display is not calibrated" -ForegroundColor Gray
    Write-Host " * Colors and gamma may be inaccurate" -ForegroundColor Gray
}
$profile = ""


<#
MENU ACTIONS
#>

# User action
if ($args.count -eq 0) {
    # Initialize tasks
    $task = 0
    $tasks = @(
        "Install an external profile",  # 1
        "Install a built-in profile",   # 2
        "Uninstall current profile"     # 3
        "Create *.icz package",         # 4
        "Exit"
    )

    # Get user selection
    Write-Host "`nPlease enter a number to choose an action:" -ForegroundColor Yellow
    for ($t = 1; $t -le $tasks.count; $t++) {
        Write-Host " ($t) $($tasks[$t - 1])"
    }
    Write-Host
    while ($task -eq 0) {
        $task = Read-Host "Select Action"

        # Ensure valid input
        if (($task -lt 1) -Or ($task -gt $tasks.count)) {
            Write-Host "`nERROR: " -NoNewline -ForegroundColor Red
            Write-Host "Invalid selection. Please try again."
            Write-Host
            $task = 0
        }
    }
} else {
    # Install external profile via CLI, if supplied
    Write-Host
    $task = 1
}


<#
EXTERNAL PROFILE
#>

if ($task -eq 1) {
    # Use supplied profile, if any
    if ($args.count -gt 0) {
        $profile = $args[0]

        # Ensure valid selection
        if (Test-Path -Path "$profile") {
            $ext = (Get-Item "$profile").Extension
            if ($ext -ne ".icz") {
                $profile = ""
            }
        } else {
            $profile = ""
        }

        if ($profile.length -eq 0) {
            Write-Host "`nERROR: " -NoNewline -ForegroundColor Red
            Write-Host "Requested profile not found. Please select and try again."
            Write-Host
            Write-Host "Press ENTER to continue"
        }
    }

    # Prompt for external profile, if not supplied
    if ($profile.length -eq 0) {
        Add-Type -AssemblyName System.Windows.Forms
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
            InitialDirectory = [Environment]::GetFolderPath("MyComputer") 
            Filter = "ICZ Package (*.icz)|*.icz"
            Title = "Select a calibration profile package"
        }
        while ($profile.length -eq 0) {
            $null = $FileBrowser.ShowDialog()
            $profile = $FileBrowser.FileName

            # Ensure valid selection
            if ($profile.length -gt 0) {
                if (!(Test-Path -Path "$profile")) {
                    $profile = ""
                }
            }
            if ($profile.length -eq 0) {
                Write-Host "`nERROR: " -NoNewline -ForegroundColor Red
                Write-Host "Invalid selection. Please cancel or try again."
                Write-Host
                $profile = ""
                $retry = Read-Host "Continue? (Y/N)"

                # Exit if cancelled
                if ($retry.Trim().ToUpper() -eq "N") {
                    $task = -1;
                    break;
                }
            }
        }
        if ($task -gt 0) {
            Write-Host
        }
    }

    # Copy selected profile to system
    if ($profile.length -gt 0) {
        # Ensure empty temp directory exists
        if (!(Test-Path -Path "$env:Temp\WindowShade")) {
            New-Item -ItemType directory -Path "$env:Temp\WindowShade"
        } else {
            Remove-Item "$env:Temp\WindowShade\*"
        }

        # Create temp files
        Copy-Item "$profile" -Destination "$env:Temp\WindowShade\package.zip" -Force
        $profile = (Get-Item $profile).BaseName
    }
}


<#
BUILT-IN PROFILE
#>

if ($task -eq 2) {
    # Get user selection
    Write-Host "`nPlease enter a number to choose a profile:" -ForegroundColor Yellow
    for ($b = 0; $b -lt $builtin.count; $b += 2) {
        Write-Host " ($(($b/2) + 1)) $($builtin[$b])"
    }
    Write-Host
    while ($profile.length -eq 0) {
        $profile = Read-Host "Select Profile"

        # Ensure valid input
        if (($profile -lt 1) -Or ($profile -gt ($builtin.count/2))) {
            Write-Host "`nERROR: " -NoNewline -ForegroundColor Red
            Write-Host "Invalid selection. Please try again."
            Write-Host
            $profile = ""
        }
    }
    Write-Host

    # Ensure empty temp directory exists
    if (!(Test-Path -Path "$env:Temp\WindowShade")) {
        New-Item -ItemType directory -Path "$env:Temp\WindowShade"
    } else {
        Remove-Item "$env:Temp\WindowShade\*"
    }

    # Export selected profile
    [IO.File]::WriteAllBytes("$env:Temp\WindowShade\package.zip", [Convert]::FromBase64String($builtin[$profile])) | Out-Null
    $profile = $builtin[$profile - 1].Replace(".icz", "")
}


<#
INSTALL PROFILE
#>

if (($task -eq 1) -Or ($task -eq 2)) {
    if (!(Test-Path -Path "$env:Temp\WindowShade\package.zip")) {
        # Ensure copied profile exists
        Write-Host "ERROR: " -NoNewline -ForegroundColor Red
        Write-Host "Profile installation failed! Directory or file is inaccessible."
    } else {
        # Show setup Info
        Write-Host "Setup will install: " -NoNewline -ForegroundColor Yellow
        Write-Host $profile
        Write-Host
        for ($s = 5; $s -ge 0; $s--) {
            $p = if ($s -eq 1) { "" } else { "s" }
            Write-Host "`rPlease wait $s second$p to continue, or close now (Ctrl + C) to cancel..." -NoNewLine -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
        Write-Host

        # Copy temp files to system
        Expand-Archive "$env:Temp\WindowShade\package.zip" -DestinationPath "$env:Temp\WindowShade" -Force
        Copy-Item "$env:Temp\WindowShade\0.icc"   -Destination "$path\$profile 0.icc"   -Force | Out-Null
        Copy-Item "$env:Temp\WindowShade\25.icc"  -Destination "$path\$profile 25.icc"  -Force | Out-Null
        Copy-Item "$env:Temp\WindowShade\50.icc"  -Destination "$path\$profile 50.icc"  -Force | Out-Null
        Copy-Item "$env:Temp\WindowShade\75.icc"  -Destination "$path\$profile 75.icc"  -Force | Out-Null
        Copy-Item "$env:Temp\WindowShade\100.icc" -Destination "$path\$profile 100.icc" -Force | Out-Null
            
        # Cleanup temp files
        Remove-Item "$env:Temp\WindowShade\*"


        <#
        INITIALIZE CALIBRATION REGISTRY
        #>

        Write-Host "`nInitializing calibration data for display(s)..."
        Start-Sleep -Seconds 1

        # Delete existing user calibration, if any
        wmic process where "name='colorcpl.exe'" delete | Out-Null
        $regpath = (reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations" 2>$null)
        if ($regpath.length -gt 0) {
            reg delete "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations" /f 2>$null | Out-Null
        }
        $regpath = (reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles" 2>$null)
        if ($regpath.length -gt 0) {
            reg delete "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles" /f 2>$null | Out-Null
        }

        # Temporarily spawn color calibration control panel to generate defaults
        Start-Process -WindowStyle Minimized "$env:WinDir\System32\colorcpl.exe"
        $ready = 0
        Do {
            Start-Sleep -Seconds 1
            $ready = (Get-Process "colorcpl" -ErrorAction SilentlyContinue).length
        } Until ($ready -ge 1)
        wmic process where "name='colorcpl.exe'" delete | Out-Null
        Start-Sleep -Seconds 1
        
        # If initialization succeeded...
        $regpath = (reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations\Display" 2>$null) -match "HKEY_CURRENT_USER"
        if ($regpath.count -gt 0) {
            # Get display IDs
            $guid = ([regex]::Match($regpath[0], '\{(.*?)\}')).Value
            $ids = @((reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations\Display\$guid" 2>$null) -match "HKEY_CURRENT_USER" | Split-Path -Leaf)
            
            # Ensure controlset defaults exist for current display(s)
            for ($i = 0; $i -lt $ids.count; $i++) {
                $id = $ids[$i]
                if ((reg query "HKLM\SYSTEM\ControlSet001\Control\Class\$guid\$id" 2>$null).length -eq 0) {
                    reg add "HKLM\SYSTEM\ControlSet001\Control\Class\$guid\$id" /t REG_MULTI_SZ /v "ICMProfile" /f 2>$null | Out-Null
                }
                if ((reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\$guid\$id" 2>$null).length -eq 0) {
                    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\$guid\$id" /t REG_MULTI_SZ /v "ICMProfile" /f 2>$null | Out-Null
                }
            }


            <#
            APPLY CALIBRATION TO REGISTRY
            #>

            Write-Host "`nUpdating system config (this may take a while)...`n"

            # Set starting step count
            $steps = 2

            # Associate calibration profile with display(s)
            $regpath = (reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations\Display" 2>$null) -match "HKEY_CURRENT_USER"
            $steps += ($regpath.count*$ids.count*5)
            for ($r = 0; $r -lt $regpath.count; $r++) {
                $reg = $regpath[$r]
                for ($i = 0; $i -lt $ids.count; $i++) {
                    $id = $ids[$i]
                    $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
                    reg add "$reg\$id" /t REG_DWORD /v "UsePerUserProfiles" /d 1 /f
                    $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
                    reg add "$reg\$id" /t REG_MULTI_SZ /v "ICMProfile" /d "$profile 75.icc" /f
                    $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
                    reg add "$reg\$id" /t REG_MULTI_SZ /v "ICMProfileAC" /d "$profile 75.icc" /f
                    $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
                    reg add "$reg\$id" /t REG_MULTI_SZ /v "ICMProfileSnapshot" /f
                    $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
                    reg add "$reg\$id" /t REG_MULTI_SZ /v "ICMProfileSnapshotAC" /f
                }
            }

            # Enable calibration profile
            $regpath = (reg query "HKLM\SYSTEM\ControlSet001\Control\Class" /f "ICMProfile" /s /c /e) -match "HKEY_LOCAL_MACHINE"
            $regpath += (reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /f "ICMProfile" /s /c /e) -match "HKEY_LOCAL_MACHINE"
            $steps += $regpath.count
            for ($r = 0; $r -lt $regpath.count; $r++) {
                $reg = $regpath[$r]
                $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
                reg add "$reg" /t REG_MULTI_SZ /v "ICMProfile" /d "$profile 75.icc" /f
            }

            # Enable calibration management
            $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
            reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\Calibration" /t REG_DWORD /v "CalibrationManagementEnabled" /d 1 /f

            # Register calibration profile
            $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
            reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles" /t REG_SZ /v "sRGB" /d "$profile 75.icc" /f
            
            # Run calibration loader task to apply changes
            Enable-ScheduledTask -TaskName "\Microsoft\Windows\WindowsColorSystem\Calibration Loader" | Out-Null
            Start-ScheduledTask -TaskName "\Microsoft\Windows\WindowsColorSystem\Calibration Loader"


            <#
            CREATE CALIBRATION SERVICE
            #>

            Write-Host "`nCreating calibration service..."

            # Ensure service directory exists
            if (!(Test-Path -Path "$env:AppData\WindowShade")) {
                New-Item -ItemType directory -Path "$env:AppData\WindowShade"
            }

            $service = 
                "<#" + 
                "`n//////////////////////////////////////////////////" + 
                "`n//  WindowShade Responsive Service by Lulech23  //" + 
                "`n//////////////////////////////////////////////////" + 
                "`n" + 
                "`nApply brightness-responsive Windows color calibration profiles with ease!" + 
                "`n" + 
                "`nUsage:" + 
                "`n``.\wsservice.ps1 `"C:\0.icc`" `"C:\25.icc`" `"C:\50.icc`" `"C:\75.icc`" `"C:\100.icc`"``" + 
                "`n" + 
                "`nService MUST be run as administrator!" + 
                "`n" + 
                "`nWhat`'s New:" + 
                "`n* Initial release" + 
                "`n" + 
                "`nNotes:" + 
                "`n* " + 
                "`n" + 
                "`nTo-do:" + 
                "`n* " + 
                "`n#>" + 
                "`n" + 
                "`n<#" + 
                "`nINITIALIZE SYSTRAY ICON" + 
                "`n#>" + 
                "`n" + 
                "`n# Add assemblies" + 
                "`nAdd-Type -AssemblyName System.Drawing" + 
                "`nAdd-Type -AssemblyName System.Windows.Forms" + 
                "`n" + 
                "`n# Get systray icon" + 
                "`n`$icon = [System.Drawing.Icon]::ExtractAssociatedIcon(`"`$env:WinDir\System32\quickassist.exe`") " + 
                "`n" + 
                "`n# Create context menu" + 
                "`n`$ContextMenu = New-Object System.Windows.Forms.ContextMenu" + 
                "`n" + 
                "`n# Create context menu items" + 
                "`n`$ItemExit = New-Object System.Windows.Forms.MenuItem" + 
                "`n`$ItemExit.Text = `"Exit`"" + 
                "`n`$ItemExit.Add_Click({" + 
                "`n    `$NotifyIcon.Visible = `$false" + 
                "`n    Stop-Process `$pid" + 
                "`n})" + 
                "`n`$ContextMenu.MenuItems.Add(`$ItemExit)" + 
                "`n " + 
                "`n# Create systray icon" + 
                "`n`$NotifyIcon = New-Object System.Windows.Forms.NotifyIcon" + 
                "`n`$NotifyIcon.Text = `"WindowShade Service`"" + 
                "`n`$NotifyIcon.Icon = `$icon" + 
                "`n`$NotifyIcon.Visible = `$true" + 
                "`n`$NotifyIcon.ContextMenu = `$ContextMenu" + 
                "`n" + 
                "`n# Hide PowerShell window" + 
                "`n`$WindowCode = `'[DllImport(`"user32.dll`")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);`'" + 
                "`n`$AsyncWindow = Add-Type -MemberDefinition `$WindowCode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru" + 
                "`n`$null = `$AsyncWindow::ShowWindowAsync((Get-Process -PID `$PID).MainWindowHandle, 0)" + 
                "`n" + 
                "`n" + 
                "`n<#" + 
                "`nINITIALIZE SERVICE" + 
                "`n#>" + 
                "`n" + 
                "`n# Initialize display IDs" + 
                "`n`$guid = `"{4d36e96e-e325-11ce-bfc1-08002be10318}`"" + 
                "`n`$ids = @((reg query `"HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations\Display\`$guid`" 2>`$null) -match `"HKEY_CURRENT_USER`" | Split-Path -Leaf)" + 
                "`n" + 
                "`n# Initialize display profiles" + 
                "`n`$Profile = 0..100" + 
                "`n`$Profile[0]   = (Get-Item `"`$(`$args[0])`").Name" + 
                "`n`$Profile[25]  = (Get-Item `"`$(`$args[1])`").Name" + 
                "`n`$Profile[50]  = (Get-Item `"`$(`$args[2])`").Name" + 
                "`n`$Profile[75]  = (Get-Item `"`$(`$args[3])`").Name" + 
                "`n`$Profile[100] = (Get-Item `"`$(`$args[4])`").Name" + 
                "`n`$CurrentProfile = `"`"" + 
                "`n" + 
                "`n# Initialize display brightness" + 
                "`n`$Brightness = -1" + 
                "`n`$CurrentBrightness = 0" + 
                "`n" + 
                "`n# Initialize functions" + 
                "`nfunction Round-To(`$n, `$v) {" + 
                "`n    return [math]::Floor(`$n/`$v)*`$v;" + 
                "`n}" + 
                "`n" + 
                "`n" + 
                "`n<#" + 
                "`nPERFORM SERVICE" + 
                "`n#>" + 
                "`n" + 
                "`n# Listen for changes in brightness" + 
                "`nfor (;;) {" + 
                "`n    `$CurrentBrightness = (Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness" + 
                "`n    `$CurrentBrightness = (Round-To `$CurrentBrightness 25)" + 
                "`n" + 
                "`n    # If brightness has changed..." + 
                "`n    if (`$Brightness -ne `$CurrentBrightness) {" + 
                "`n        Get-Date -Format `"``n[MM/dd/yyyy HH:mm]`" | Write-Host -ForegroundColor Gray" + 
                "`n        Write-Host `"Detected brightness adjustment`" -ForegroundColor Yellow " + 
                "`n        Write-Host `"Previous value: `$Brightness, New value: `$CurrentBrightness`"" + 
                "`n        Write-Host `"``nSetting brightness profile...`" -ForegroundColor Cyan" + 
                "`n" + 
                "`n        # Get profile based on brightness" + 
                "`n        `$CurrentProfile = `$Profile[`$CurrentBrightness]" + 
                "`n        for (`$i = 0; `$i -lt `$ids.count; `$i++) {" + 
                "`n            `$id = `$ids[`$i]" + 
                "`n" + 
                "`n            # Associate calibration profile with display(s)" + 
                "`n            `$regpath = `"HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations\Display\`$guid`"" + 
                "`n            reg add `"`$regpath\`$id`" /t REG_MULTI_SZ /v `"ICMProfile`" /d `"`$CurrentProfile`" /f" + 
                "`n            reg add `"`$regpath\`$id`" /t REG_MULTI_SZ /v `"ICMProfileAC`" /d `"`$CurrentProfile`" /f" + 
                "`n            reg add `"`$regpath\`$id`" /t REG_MULTI_SZ /v `"ICMProfileSnapshot`" /f" + 
                "`n            reg add `"`$regpath\`$id`" /t REG_MULTI_SZ /v `"ICMProfileSnapshotAC`" /f" + 
                "`n            " + 
                "`n            # Enable calibration profile" + 
                "`n            `$regpath = `"HKLM\SYSTEM\ControlSet001\Control\Class\`$guid`"" + 
                "`n            reg add `"`$regpath\`$id`" /t REG_MULTI_SZ /v `"ICMProfile`" /d `"`$CurrentProfile`" /f" + 
                "`n            `$regpath = `"HKLM\SYSTEM\CurrentControlSet\Control\Class\`$guid`"" + 
                "`n            reg add `"`$regpath\`$id`" /t REG_MULTI_SZ /v `"ICMProfile`" /d `"`$CurrentProfile`" /f" + 
                "`n        }" + 
                "`n            " + 
                "`n        # Run calibration loader task to apply changes" + 
                "`n        Enable-ScheduledTask -TaskName `"\Microsoft\Windows\WindowsColorSystem\Calibration Loader`" | Out-Null" + 
                "`n        Start-ScheduledTask -TaskName `"\Microsoft\Windows\WindowsColorSystem\Calibration Loader`"" + 
                "`n" + 
                "`n        # Update brightness check" + 
                "`n        `$Brightness = `$CurrentBrightness" + 
                "`n    }" + 
                "`n" + 
                "`n    # Set brightness check frequency" + 
                "`n    Start-Sleep 1" + 
                "`n}"

            # Create calibration service
            Set-Content -Path "$env:AppData\WindowShade\wsservice.ps1" -Value $service -Force


            <#
            CREATE CALIBRATION TASK
            #>

            $service = 
                "<?xml version=`"1.0`" encoding=`"UTF-16`"?>" +
                "`n<Task version=`"1.4`" xmlns=`"http://schemas.microsoft.com/windows/2004/02/mit/task`">" +
                "`n	<RegistrationInfo>" +
                "`n		<Date>2021-07-02T17:30:28.6095531</Date>" +
                "`n		<Author>BUILTIN\Administrators</Author>" +
                "`n		<Description>Runs the WindowShade service for brightness-responsive calibration profiles</Description>" +
                "`n		<URI>\WindowShade\WindowShade Service</URI>" +
                "`n	</RegistrationInfo>" +
                "`n	<Triggers>" +
                "`n		<LogonTrigger>" +
                "`n			<Enabled>true</Enabled>" +
                "`n		</LogonTrigger>" +
                "`n	</Triggers>" +
                "`n	<Principals>" +
                "`n		<Principal id=`"Author`">" +
                "`n			<GroupId>S-1-5-32-544</GroupId>" +
                "`n			<RunLevel>HighestAvailable</RunLevel>" +
                "`n		</Principal>" +
                "`n	</Principals>" +
                "`n	<Settings>" +
                "`n		<MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>" +
                "`n		<DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>" +
                "`n		<StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>" +
                "`n		<AllowHardTerminate>true</AllowHardTerminate>" +
                "`n		<StartWhenAvailable>true</StartWhenAvailable>" +
                "`n		<RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>" +
                "`n		<IdleSettings>" +
                "`n			<StopOnIdleEnd>false</StopOnIdleEnd>" +
                "`n			<RestartOnIdle>false</RestartOnIdle>" +
                "`n		</IdleSettings>" +
                "`n		<AllowStartOnDemand>true</AllowStartOnDemand>" +
                "`n		<Enabled>true</Enabled>" +
                "`n		<Hidden>false</Hidden>" +
                "`n		<RunOnlyIfIdle>false</RunOnlyIfIdle>" +
                "`n		<DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>" +
                "`n		<UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>" +
                "`n		<WakeToRun>false</WakeToRun>" +
                "`n		<ExecutionTimeLimit>PT0S</ExecutionTimeLimit>" +
                "`n		<Priority>7</Priority>" +
                "`n	</Settings>" +
                "`n	<Actions Context=`"Author`">" +
                "`n		<Exec>" +
                "`n			<Command>powershell</Command>" +
                "`n			<Arguments>-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:AppData\WindowShade\wsservice.ps1`" `"$path\$profile 0.icc`" `"$path\$profile 25.icc`" `"$path\$profile 50.icc`" `"$path\$profile 75.icc`" `"$path\$profile 100.icc`"</Arguments>" +
                "`n		</Exec>" +
                "`n	</Actions>" +
                "`n</Task>"

            # Create calibration task
            Set-Content -Path "$env:AppData\WindowShade\wstask.xml" -Value $service -Force

            # Import task to Windows scheduler
            $task = (Get-ScheduledTask "WindowShade Service" -ErrorAction "SilentlyContinue" | Out-String)
            if ($task.length -gt 0) {
                # Delete old task, if any
                Unregister-ScheduledTask -TaskName "WindowShade Service" -Confirm:$False -ErrorAction "SilentlyContinue"
            }
            Register-ScheduledTask -TaskName "WindowShade Service" -Xml (Get-Content "$env:AppData\WindowShade\wstask.xml" | Out-String)

            # Run imported task
            Enable-ScheduledTask -TaskName "WindowShade Service" | Out-Null
            Start-ScheduledTask -TaskName "WindowShade Service"

            # Ensure task creation succeeded
            $task = (Get-ScheduledTask "WindowShade Service" -ErrorAction "SilentlyContinue" | Out-String)
            
            # End process, we're done!
            if ($task.length -gt 0) {
                Write-Host "`nProcess complete! " -NoNewline -ForegroundColor Green
                Write-Host "New calibration profile installed successfully. Enjoy!"
                Write-Host "If you liked this, stop by my website at " -NoNewline
                Write-Host "https://lucasc.me" -NoNewline -ForegroundColor Yellow
                Write-Host "!"
            } else {
                # Show error if service creation failed
                Write-Host "`nCreating calibration service failed!" -ForegroundColor Magenta
                Write-Host "`nPlease import `"$env:AppData\WindowShade\wstask.xml`" to Task Scheduler" 
                Write-Host "manually, if it exists."
            }
        } else {
            # Show error if initialization failed
            Write-Host "Initializing calibration data failed!" -ForegroundColor Magenta 
            Write-Host "`nPlease start display calibration manually to restore defaults and run this script again."
        }
    }
}


<#
UNINSTALL PROFILE
#>

if ($task -eq 3) {
    Write-Host "`nUnregistering calibration service..."
    Start-Sleep -Seconds 1

    # Unregister calibration service
    Stop-ScheduledTask -TaskName "WindowShade Service" | Out-Null
    Unregister-ScheduledTask -TaskName "WindowShade Service" -Confirm:$False -ErrorAction "SilentlyContinue"
    Remove-Item "$env:AppData\WindowShade\*"
    
    # Revert display calibration
    Write-Host "`nReverting display calibration (this may take a while)...`n"
    Start-Sleep -Seconds 1

    # Set starting step count
    $steps = 2

    # Unregister user calibration profile
    $regpath = (reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles" 2>$null)
    if ($regpath.length -gt 0) {
        $steps++; $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
        reg delete "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles" /f
    }

    # Disassociate calibration profile from display(s)
    $regpath = (reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations" 2>$null)
    if ($regpath.length -gt 0) {
        $steps++; $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
        reg delete "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\ProfileAssociations" /f
    }

    # Disable calibration profile
    $regpath = (reg query "HKLM\SYSTEM\ControlSet001\Control\Class" /f "ICMProfile" /s /c /e) -match "HKEY_LOCAL_MACHINE"
    $regpath += (reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /f "ICMProfile" /s /c /e) -match "HKEY_LOCAL_MACHINE"
    $steps += $regpath.count
    for ($r = 0; $r -lt $regpath.count; $r++) {
        $reg = $regpath[$r]
        $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
        reg delete "$reg" /v ICMProfile /f
    }
    
    # Disable calibration management
    $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\Calibration" /t REG_DWORD /v "CalibrationManagementEnabled" /d 0 /f

    # Unregister system calibration profile
    $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
    reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles" /v "sRGB" /f
    
    # Run calibration loader task to apply changes
    Enable-ScheduledTask -TaskName "\Microsoft\Windows\WindowsColorSystem\Calibration Loader" | Out-Null
    Start-ScheduledTask -TaskName "\Microsoft\Windows\WindowsColorSystem\Calibration Loader"
    
    # End process, we're done!
    Write-Host "`nProcess complete! " -NoNewline -ForegroundColor Green
    Write-Host "Original calibration restored. Enjoy, I guess..."
}


<#
CREATE PACKAGE
#>

if ($task -eq 4) {
    # Initialize package profiles
    $profile = 0..100
    $p = 0

    # Initialize file browser
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = [Environment]::GetFolderPath("MyComputer") 
        Filter = "ICC Profile (*.icc;*.icm)|*.icc;*.icm"
        Title = "Select a color calibration profile"
    }


    <#
    GET PROFILES
    #>
    
    # Prompt for external profile, if not supplied
    :browse while ($profile[$p].length -le 1) {
        Write-Host "`nSelect an *.icc\*.icm profile for $p-$([math]::min($p + 24, 100))% brightness"
        Read-Host "Press ENTER to open file browser"

        $null = $FileBrowser.ShowDialog()
        $profile[$p] = $FileBrowser.FileName

        # Ensure valid selection
        if ($profile[$p].length -gt 1) {
            if (!(Test-Path -Path "$($profile[0])")) {
                $profile[$p] = ""
            }
        }
        if ($profile[$p].length -le 1) {
            Write-Host "ERROR: " -NoNewline -ForegroundColor Red
            Write-Host "Invalid selection. Please cancel or try again."
            Write-Host
            $FileBrowser.FileName = ""
            $profile[$p] = ""
            $retry = Read-Host "Continue? (Y/N)"

            # Exit if cancelled
            if ($retry.Trim().ToUpper() -eq "N") {
                $task = -1;
                break;
            }
        } else {
            # Show selected profile
            Write-Host "Selected: " -NoNewline -ForegroundColor Yellow
            Write-Host "$($profile[$p])"

            # Reset file browser properties
            $FileBrowser.InitialDirectory = (Split-Path -parent "$($profile[$p])")
            $FileBrowser.FileName = ""

            # Continue to next file
            switch ($p) {
                0   { $p = 25;  break; }
                25  { $p = 50;  break; }
                50  { $p = 75;  break; }
                75  { $p = 100; break; }
                100 { break browse; }
            }
        }
    }
    if ($task -gt 0) {
        Write-Host


        <#
        CREATE PACKAGE
        #>

        # Ensure empty temp directory exists
        if (!(Test-Path -Path "$env:Temp\WindowShade")) {
            New-Item -ItemType directory -Path "$env:Temp\WindowShade"
        } else {
            Remove-Item "$env:Temp\WindowShade\*"
        }

        # Copy files to temp directory and rename
        Copy-Item "$($profile[0])"   -Destination "$env:Temp\WindowShade\0.icc"
        Copy-Item "$($profile[25])"  -Destination "$env:Temp\WindowShade\25.icc"
        Copy-Item "$($profile[50])"  -Destination "$env:Temp\WindowShade\50.icc"
        Copy-Item "$($profile[75])"  -Destination "$env:Temp\WindowShade\75.icc"
        Copy-Item "$($profile[100])" -Destination "$env:Temp\WindowShade\100.icc"

        # Create profile package
        Compress-Archive -Path "$env:Temp\WindowShade\*" -DestinationPath "$env:Temp\WindowShade\package.zip" -Force


        <#
        SAVE PACKAGE
        #>

        # Initialize file browser
        $package = "";
        $FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{ 
            InitialDirectory = [Environment]::GetFolderPath("MyComputer") 
            Filter = "ICZ Package (*.icz)|*.icz"
            Title = "Choose a location to save calibration profile package"
        }

        # Prompt for save location
        while ($package.length -eq 0) {
            $null = $FileBrowser.ShowDialog()
            $package = $FileBrowser.FileName

            # Ensure valid filname
            if ($package.length -le 1) {
                Write-Host "`nERROR: " -NoNewline -ForegroundColor Red
                Write-Host "Invalid location or filename. Please cancel or try again."
                Write-Host
                $FileBrowser.FileName = ""
                $package = ""
                $retry = Read-Host "Continue? (Y/N)"

                # Exit if cancelled
                if ($retry.Trim().ToUpper() -eq "N") {
                    $task = -1;
                    break;
                }
            }
        }
        if ($task -gt 0) {
            # Save package to chosen location
            Copy-Item "$env:Temp\WindowShade\package.zip" "$package" -Force
            
            # Cleanup temp files
            Remove-Item "$env:Temp\WindowShade\*"

            # End process, we're done!
            Write-Host "Process complete! " -NoNewline -ForegroundColor Green
            Write-Host "Calibration package saved to:"
            Write-Host "$package"
        }
    }
}


<#
FINALIZATION
#>

# Exit, we're done!
Write-Host
for ($s = 5; $s -ge 0; $s--) {
    $p = if ($s -eq 1) { "" } else { "s" }
    Write-Host "`rSetup will cleanup and exit in $s second$p, please wait..." -NoNewLine -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}
Write-Host
Write-Host "`nCleaning up..."
Start-Sleep -Seconds 1

# Reset execution policy and delete temporary script file
$policy = "Default"
if (Test-Path -Path "$env:Temp\executionpolicy.txt") {
    $policy = [string] (Get-Content -Path "$env:Temp\executionpolicy.txt")
}
Start-Process powershell.exe "Set-ExecutionPolicy -Scope 'CurrentUser' -ExecutionPolicy '$policy'; Remove-Item -Path '$env:Temp\executionpolicy.txt' -Force; Remove-Item -Path '$PSCommandPath' -Force"
