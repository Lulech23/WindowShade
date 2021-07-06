powershell.exe "Get-ExecutionPolicy -Scope 'CurrentUser' | Out-File -FilePath '%TEMP%\executionpolicy.txt' -Force; Set-ExecutionPolicy -Scope 'CurrentUser' -ExecutionPolicy 'Unrestricted'; $script = Get-Content '%~dpnx0'; $script -notmatch 'supercalifragilisticexpialidocious' | Out-File -FilePath '%TEMP%\%~n0.ps1' -Force; Start-Process powershell.exe \"Set-Location -Path '%~dp0'; ^& '%TEMP%\%~n0.ps1' %1\" -verb RunAs" && exit

<#
//////////////////////////////////////////////////
//  WindowShade Standard Installer by Lulech23  //
//////////////////////////////////////////////////

Apply custom Windows color calibration profiles with ease!

What's New:
* Initial release

Notes:
* Formerly BluePill for Aya Neo

To-do:
* Add support for modifying existing profiles
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
    "Aya Neo v1.icc", "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bwBtAC8AdwBpAG4AZABvAHcAcwAvADIAMAAwADcALwAxADEALwBjAG8AbABvAHIALwBDAGEAbABpAGIAcgBhAHQAaQBvAG4AIgAgAHgAbQBsAG4AcwA6AHcAYwBzAD0AIgBoAHQAdABwADoALwAvAHMAYwBoAGUAbQBhAHMALgBtAGkAYwByAG8AcwBvAGYAdAAuAGMAbwBtAC8AdwBpAG4AZABvAHcAcwAvADIAMAAwADUALwAwADIALwBjAG8AbABvAHIALwBXAGMAcwBDAG8AbQBtAG8AbgBQAHIAbwBmAGkAbABlAFQAeQBwAGUAcwAiACAAeABtAGwAbgBzADoAbQBjAD0AIgBoAHQAdABwADoALwAvAHMAYwBoAGUAbQBhAHMALgBvAHAAZQBuAHgAbQBsAGYAbwByAG0AYQB0AHMALgBvAHIAZwAvAG0AYQByAGsAdQBwAC0AYwBvAG0AcABhAHQAaQBiAGkAbABpAHQAeQAvADIAMAAwADYAIgA+AA0ACgAJADwAYwBkAG0AOgBQAHIAbwBmAGkAbABlAE4AYQBtAGUAPgANAAoACQAJADwAdwBjAHMAOgBUAGUAeAB0ACAAeABtAGwAOgBsAGEAbgBnAD0AIgBlAG4ALQBVAFMAIgA+AEMAYQBsAGkAYgByAGEAdABlAGQAIABkAGkAcwBwAGwAYQB5ACAAcAByAG8AZgBpAGwAZQA8AC8AdwBjAHMAOgBUAGUAeAB0AD4ADQAKAAkAPAAvAGMAZABtADoAUAByAG8AZgBpAGwAZQBOAGEAbQBlAD4ADQAKAAkAPABjAGQAbQA6AEQAZQBzAGMAcgBpAHAAdABpAG8AbgA+AA0ACgAJAAkAPAB3AGMAcwA6AFQAZQB4AHQAIAB4AG0AbAA6AGwAYQBuAGcAPQAiAGUAbgAtAFUAUwAiAD4AcwBSAEcAQgAgAGQAaQBzAHAAbABhAHkAIABwAHIAbwBmAGkAbABlACAAdwBpAHQAaAAgAGQAaQBzAHAAbABhAHkAIABoAGEAcgBkAHcAYQByAGUAIABjAG8AbgBmAGkAZwB1AHIAYQB0AGkAbwBuACAAZABhAHQAYQAgAGQAZQByAGkAdgBlAGQAIABmAHIAbwBtACAAYwBhAGwAaQBiAHIAYQB0AGkAbwBuADwALwB3AGMAcwA6AFQAZQB4AHQAPgANAAoACQA8AC8AYwBkAG0AOgBEAGUAcwBjAHIAaQBwAHQAaQBvAG4APgANAAoACQA8AGMAZABtADoAQQB1AHQAaABvAHIAPgANAAoACQAJADwAdwBjAHMAOgBUAGUAeAB0ACAAeABtAGwAOgBsAGEAbgBnAD0AIgBlAG4ALQBVAFMAIgA+AE0AaQBjAHIAbwBzAG8AZgB0ACAARABpAHMAcABsAGEAeQAgAEMAbwBsAG8AcgAgAEMAYQBsAGkAYgByAGEAdABpAG8AbgA8AC8AdwBjAHMAOgBUAGUAeAB0AD4ADQAKAAkAPAAvAGMAZABtADoAQQB1AHQAaABvAHIAPgANAAoACQA8AGMAZABtADoATQBlAGEAcwB1AHIAZQBtAGUAbgB0AEMAbwBuAGQAaQB0AGkAbwBuAHMAPgANAAoACQAJADwAYwBkAG0AOgBDAG8AbABvAHIAUwBwAGEAYwBlAD4AQwBJAEUAWABZAFoAPAAvAGMAZABtADoAQwBvAGwAbwByAFMAcABhAGMAZQA+AA0ACgAJAAkAPABjAGQAbQA6AFcAaABpAHQAZQBQAG8AaQBuAHQATgBhAG0AZQA+AEQANgA1ADwALwBjAGQAbQA6AFcAaABpAHQAZQBQAG8AaQBuAHQATgBhAG0AZQA+AA0ACgAJADwALwBjAGQAbQA6AE0AZQBhAHMAdQByAGUAbQBlAG4AdABDAG8AbgBkAGkAdABpAG8AbgBzAD4ADQAKAAkAPABjAGQAbQA6AFMAZQBsAGYATAB1AG0AaQBuAG8AdQBzAD4AdAByAHUAZQA8AC8AYwBkAG0AOgBTAGUAbABmAEwAdQBtAGkAbgBvAHUAcwA+AA0ACgAJADwAYwBkAG0AOgBNAGEAeABDAG8AbABvAHIAYQBuAHQAPgAxAC4AMAA8AC8AYwBkAG0AOgBNAGEAeABDAG8AbABvAHIAYQBuAHQAPgANAAoACQA8AGMAZABtADoATQBpAG4AQwBvAGwAbwByAGEAbgB0AD4AMAAuADAAPAAvAGMAZABtADoATQBpAG4AQwBvAGwAbwByAGEAbgB0AD4ADQAKAAkAPABjAGQAbQA6AFIARwBCAFYAaQByAHQAdQBhAGwARABlAHYAaQBjAGUAPgANAAoACQAJADwAYwBkAG0AOgBNAGUAYQBzAHUAcgBlAG0AZQBuAHQARABhAHQAYQAgAFQAaQBtAGUAUwB0AGEAbQBwAD0AIgAyADAAMgAxAC0AMAA2AC0AMgA2AFQAMAA2ADoANAA5ADoAMAA5ACIAPgANAAoACQAJAAkAPABjAGQAbQA6AE0AYQB4AEMAbwBsAG8AcgBhAG4AdABVAHMAZQBkAD4AMQAuADAAPAAvAGMAZABtADoATQBhAHgAQwBvAGwAbwByAGEAbgB0AFUAcwBlAGQAPgANAAoACQAJAAkAPABjAGQAbQA6AE0AaQBuAEMAbwBsAG8AcgBhAG4AdABVAHMAZQBkAD4AMAAuADAAPAAvAGMAZABtADoATQBpAG4AQwBvAGwAbwByAGEAbgB0AFUAcwBlAGQAPgANAAoACQAJAAkAPABjAGQAbQA6AFcAaABpAHQAZQBQAHIAaQBtAGEAcgB5ACAAWAA9ACIAOQA1AC4AMAA1ACIAIABZAD0AIgAxADAAMAAuADAAMAAiACAAWgA9ACIAMQAwADgALgA5ADAAIgAvAD4ADQAKAAkACQAJADwAYwBkAG0AOgBSAGUAZABQAHIAaQBtAGEAcgB5ACAAWAA9ACIANAAxAC4AMgA0ACIAIABZAD0AIgAyADEALgAyADYAIgAgAFoAPQAiADEALgA5ADMAIgAvAD4ADQAKAAkACQAJADwAYwBkAG0AOgBHAHIAZQBlAG4AUAByAGkAbQBhAHIAeQAgAFgAPQAiADMANQAuADcANgAiACAAWQA9ACIANwAxAC4ANQAyACIAIABaAD0AIgAxADEALgA5ADIAIgAvAD4ADQAKAAkACQAJADwAYwBkAG0AOgBCAGwAdQBlAFAAcgBpAG0AYQByAHkAIABYAD0AIgAxADgALgAwADUAIgAgAFkAPQAiADcALgAyADIAIgAgAFoAPQAiADkANQAuADAANQAiAC8APgANAAoACQAJAAkAPABjAGQAbQA6AEIAbABhAGMAawBQAHIAaQBtAGEAcgB5ACAAWAA9ACIAMAAiACAAWQA9ACIAMAAiACAAWgA9ACIAMAAiAC8APgANAAoACQAJAAkAPABjAGQAbQA6AEcAYQBtAG0AYQBPAGYAZgBzAGUAdABHAGEAaQBuAEwAaQBuAGUAYQByAEcAYQBpAG4AIABHAGEAbQBtAGEAPQAiADIALgA0ACIAIABPAGYAZgBzAGUAdAA9ACIAMAAuADAANQA1ACIAIABHAGEAaQBuAD0AIgAwAC4AOQA0ADcAOAA2ADcAIgAgAEwAaQBuAGUAYQByAEcAYQBpAG4APQAiADEAMgAuADkAMgAiACAAVAByAGEAbgBzAGkAdABpAG8AbgBQAG8AaQBuAHQAPQAiADAALgAwADQAMAA0ADUAIgAvAD4ADQAKAAkACQA8AC8AYwBkAG0AOgBNAGUAYQBzAHUAcgBlAG0AZQBuAHQARABhAHQAYQA+AA0ACgAJADwALwBjAGQAbQA6AFIARwBCAFYAaQByAHQAdQBhAGwARABlAHYAaQBjAGUAPgANAAoACQA8AGMAZABtADoAQwBhAGwAaQBiAHIAYQB0AGkAbwBuAD4ADQAKAAkACQA8AGMAYQBsADoAQQBkAGEAcAB0AGUAcgBHAGEAbQBtAGEAQwBvAG4AZgBpAGcAdQByAGEAdABpAG8AbgA+AA0ACgAJAAkACQA8AGMAYQBsADoAUABhAHIAYQBtAGUAdABlAHIAaQB6AGUAZABDAHUAcgB2AGUAcwA+AA0ACgAJAAkACQAJADwAdwBjAHMAOgBSAGUAZABUAFIAQwAgAEcAYQBtAG0AYQA9ACIAMAAuADkANAAwADkAMAA5ACIAIABHAGEAaQBuAD0AIgAwAC4AOAA1ADEAOAA5ADMAIgAgAE8AZgBmAHMAZQB0ADEAPQAiADAALgAwACIALwA+AA0ACgAJAAkACQAJADwAdwBjAHMAOgBHAHIAZQBlAG4AVABSAEMAIABHAGEAbQBtAGEAPQAiADAALgA5ADQAMAA5ADAAOQAiACAARwBhAGkAbgA9ACIAMAAuADgAMwAwADgANQAyACIAIABPAGYAZgBzAGUAdAAxAD0AIgAwAC4AMAAiAC8APgANAAoACQAJAAkACQA8AHcAYwBzADoAQgBsAHUAZQBUAFIAQwAgAEcAYQBtAG0AYQA9ACIAMAAuADkANAAwADkAMAA5ACIAIABHAGEAaQBuAD0AIgAxAC4AMAAwADAAMAAwADAAIgAgAE8AZgBmAHMAZQB0ADEAPQAiADAALgAwACIALwA+AA0ACgAJAAkACQA8AC8AYwBhAGwAOgBQAGEAcgBhAG0AZQB0AGUAcgBpAHoAZQBkAEMAdQByAHYAZQBzAD4ADQAKAAkACQA8AC8AYwBhAGwAOgBBAGQAYQBwAHQAZQByAEcAYQBtAG0AYQBDAG8AbgBmAGkAZwB1AHIAYQB0AGkAbwBuAD4ADQAKAAkAPAAvAGMAZABtADoAQwBhAGwAaQBiAHIAYQB0AGkAbwBuAD4ADQAKADwALwBjAGQAbQA6AEMAbwBsAG8AcgBEAGUAdgBpAGMAZQBNAG8AZABlAGwAPgANAAoAPAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgA/AD4ADQAKADwAYwBhAG0AOgBDAG8AbABvAHIAQQBwAHAAZQBhAHIAYQBuAGMAZQBNAG8AZABlAGwAIABJAEQAPQAiAGgAdAB0AHAAOgAvAC8AcwBjAGgAZQBtAGEAcwAuAG0AaQBjAHIAbwBzAG8AZgB0AC4AYwBvAG0ALwB3AGkAbgBkAG8AdwBzAC8AMgAwADAANQAvADAAMgAvAGMAbwBsAG8AcgAvAEQANgA1AC4AYwBhAG0AcAAiACAAeABtAGwAbgBzADoAYwBhAG0APQAiAGgAdAB0AHAAOgAvAC8AcwBjAGgAZQBtAGEAcwAuAG0AaQBjAHIAbwBzAG8AZgB0AC4AYwBvAG0ALwB3AGkAbgBkAG8AdwBzAC8AMgAwADAANQAvADAAMgAvAGMAbwBsAG8AcgAvAEMAbwBsAG8AcgBBAHAAcABlAGEAcgBhAG4AYwBlAE0AbwBkAGUAbAAiACAAeABtAGwAbgBzADoAdwBjAHMAPQAiAGgAdAB0AHAAOgAvAC8AcwBjAGgAZQBtAGEAcwAuAG0AaQBjAHIAbwBzAG8AZgB0AC4AYwBvAG0ALwB3AGkAbgBkAG8AdwBzAC8AMgAwADAANQAvADAAMgAvAGMAbwBsAG8AcgAvAFcAYwBzAEMAbwBtAG0AbwBuAFAAcgBvAGYAaQBsAGUAVAB5AHAAZQBzACIAIAB4AG0AbABuAHMAOgB4AHMAPQAiAGgAdAB0AHAAOgAvAC8AdwB3AHcALgB3ADMALgBvAHIAZwAvADIAMAAwADEALwBYAE0ATABTAGMAaABlAG0AYQAtAGkAbgBzAHQAYQBuAGMAZQAiAD4ADQAKAAkAPABjAGEAbQA6AFAAcgBvAGYAaQBsAGUATgBhAG0AZQA+AA0ACgAJAAkAPAB3AGMAcwA6AFQAZQB4AHQAIAB4AG0AbAA6AGwAYQBuAGcAPQAiAGUAbgAtAFUAUwAiAD4AVwBDAFMAIABwAHIAbwBmAGkAbABlACAAZgBvAHIAIABzAFIARwBCACAAdgBpAGUAdwBpAG4AZwAgAGMAbwBuAGQAaQB0AGkAbwBuAHMAPAAvAHcAYwBzADoAVABlAHgAdAA+AA0ACgAJADwALwBjAGEAbQA6AFAAcgBvAGYAaQBsAGUATgBhAG0AZQA+AA0ACgAJADwAYwBhAG0AOgBEAGUAcwBjAHIAaQBwAHQAaQBvAG4APgANAAoACQAJADwAdwBjAHMAOgBUAGUAeAB0ACAAeABtAGwAOgBsAGEAbgBnAD0AIgBlAG4ALQBVAFMAIgA+AEQAZQBmAGEAdQBsAHQAIABwAHIAbwBmAGkAbABlACAAZgBvAHIAIABhACAAcwBSAEcAQgAgAG0AbwBuAGkAdABvAHIAIABpAG4AIABzAHQAYQBuAGQAYQByAGQAIAB2AGkAZQB3AGkAbgBnACAAYwBvAG4AZABpAHQAaQBvAG4AcwA8AC8AdwBjAHMAOgBUAGUAeAB0AD4ADQAKAAkAPAAvAGMAYQBtADoARABlAHMAYwByAGkAcAB0AGkAbwBuAD4ADQAKAAkAPABjAGEAbQA6AEEAdQB0AGgAbwByAD4ADQAKAAkACQA8AHcAYwBzADoAVABlAHgAdAAgAHgAbQBsADoAbABhAG4AZwA9ACIAZQBuAC0AVQBTACIAPgBNAGkAYwByAG8AcwBvAGYAdAAgAEMAbwByAHAAbwByAGEAdABpAG8AbgA8AC8AdwBjAHMAOgBUAGUAeAB0AD4ADQAKAAkAPAAvAGMAYQBtADoAQQB1AHQAaABvAHIAPgANAAoACQA8AGMAYQBtADoAVgBpAGUAdwBpAG4AZwBDAG8AbgBkAGkAdABpAG8AbgBzAD4ADQAKAAkACQA8AGMAYQBtADoAVwBoAGkAdABlAFAAbwBpAG4AdABOAGEAbQBlAD4ARAA2ADUAPAAvAGMAYQBtADoAVwBoAGkAdABlAFAAbwBpAG4AdABOAGEAbQBlAD4ADQAKAAkACQA8AGMAYQBtADoAQgBhAGMAawBnAHIAbwB1AG4AZAAgAFgAPQAiADEAOQAuADAAIgAgAFkAPQAiADIAMAAuADAAIgAgAFoAPQAiADIAMQAuADcAOAAiAC8APgANAAoACQAJADwAYwBhAG0AOgBTAHUAcgByAG8AdQBuAGQAPgBBAHYAZQByAGEAZwBlADwALwBjAGEAbQA6AFMAdQByAHIAbwB1AG4AZAA+AA0ACgAJAAkAPABjAGEAbQA6AEwAdQBtAGkAbgBhAG4AYwBlAE8AZgBBAGQAYQBwAHQAaQBuAGcARgBpAGUAbABkAD4AMQA2AC4AMAA8AC8AYwBhAG0AOgBMAHUAbQBpAG4AYQBuAGMAZQBPAGYAQQBkAGEAcAB0AGkAbgBnAEYAaQBlAGwAZAA+AA0ACgAJAAkAPABjAGEAbQA6AEQAZQBnAHIAZQBlAE8AZgBBAGQAYQBwAHQAYQB0AGkAbwBuAD4AMQA8AC8AYwBhAG0AOgBEAGUAZwByAGUAZQBPAGYAQQBkAGEAcAB0AGEAdABpAG8AbgA+AA0ACgAJADwALwBjAGEAbQA6AFYAaQBlAHcAaQBuAGcAQwBvAG4AZABpAHQAaQBvAG4AcwA+AA0ACgA8AC8AYwBhAG0AOgBDAG8AbABvAHIAQQBwAHAAZQBhAHIAYQBuAGMAZQBNAG8AZABlAGwAPgANAAoAPAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgA/AD4ADQAKADwAZwBtAG0AOgBHAGEAbQB1AHQATQBhAHAATQBvAGQAZQBsACAASQBEAD0AIgBoAHQAdABwADoALwAvAHMAYwBoAGUAbQBhAHMALgBtAGkAYwByAG8AcwBvAGYAdAAuAGMAbwBtAC8AdwBpAG4AZABvAHcAcwAvADIAMAAwADUALwAwADIALwBjAG8AbABvAHIALwBNAGUAZABpAGEAUwBpAG0ALgBnAG0AbQBwACIAIAB4AG0AbABuAHMAOgBnAG0AbQA9ACIAaAB0AHQAcAA6AC8ALwBzAGMAaABlAG0AYQBzAC4AbQBpAGMAcgBvAHMAbwBmAHQALgBjAG8AbQAvAHcAaQBuAGQAbwB3AHMALwAyADAAMAA1AC8AMAAyAC8AYwBvAGwAbwByAC8ARwBhAG0AdQB0AE0AYQBwAE0AbwBkAGUAbAAiACAAeABtAGwAbgBzADoAdwBjAHMAPQAiAGgAdAB0AHAAOgAvAC8AcwBjAGgAZQBtAGEAcwAuAG0AaQBjAHIAbwBzAG8AZgB0AC4AYwBvAG0ALwB3AGkAbgBkAG8AdwBzAC8AMgAwADAANQAvADAAMgAvAGMAbwBsAG8AcgAvAFcAYwBzAEMAbwBtAG0AbwBuAFAAcgBvAGYAaQBsAGUAVAB5AHAAZQBzACIAIAB4AG0AbABuAHMAOgB4AHMAPQAiAGgAdAB0AHAAOgAvAC8AdwB3AHcALgB3ADMALgBvAHIAZwAvADIAMAAwADEALwBYAE0ATABTAGMAaABlAG0AYQAtAGkAbgBzAHQAYQBuAGMAZQAiAD4ADQAKAAkAPABnAG0AbQA6AFAAcgBvAGYAaQBsAGUATgBhAG0AZQA+AA0ACgAJAAkAPAB3AGMAcwA6AFQAZQB4AHQAIAB4AG0AbAA6AGwAYQBuAGcAPQAiAGUAbgAtAFUAUwAiAD4AUAByAG8AbwBmAGkAbgBnACAALQAgAHMAaQBtAHUAbABhAHQAZQAgAHAAYQBwAGUAcgAvAG0AZQBkAGkAYQAgAGMAbwBsAG8AcgA8AC8AdwBjAHMAOgBUAGUAeAB0AD4ADQAKAAkAPAAvAGcAbQBtADoAUAByAG8AZgBpAGwAZQBOAGEAbQBlAD4ADQAKAAkAPABnAG0AbQA6AEQAZQBzAGMAcgBpAHAAdABpAG8AbgA+AA0ACgAJAAkAPAB3AGMAcwA6AFQAZQB4AHQAIAB4AG0AbAA6AGwAYQBuAGcAPQAiAGUAbgAtAFUAUwAiAD4AQQBwAHAAcgBvAHAAcgBpAGEAdABlACAAZgBvAHIAIABJAEMAQwAgAGEAYgBzAG8AbAB1AHQAZQAgAGMAbwBsAG8AcgBpAG0AZQB0AHIAaQBjACAAcgBlAG4AZABlAHIAaQBuAGcAIABpAG4AdABlAG4AdAAgAHcAbwByAGsAZgBsAG8AdwBzADwALwB3AGMAcwA6AFQAZQB4AHQAPgANAAoACQA8AC8AZwBtAG0AOgBEAGUAcwBjAHIAaQBwAHQAaQBvAG4APgANAAoACQA8AGcAbQBtADoAQQB1AHQAaABvAHIAPgANAAoACQAJADwAdwBjAHMAOgBUAGUAeAB0ACAAeABtAGwAOgBsAGEAbgBnAD0AIgBlAG4ALQBVAFMAIgA+AE0AaQBjAHIAbwBzAG8AZgB0ACAAQwBvAHIAcABvAHIAYQB0AGkAbwBuADwALwB3AGMAcwA6AFQAZQB4AHQAPgANAAoACQA8AC8AZwBtAG0AOgBBAHUAdABoAG8AcgA+AA0ACgAJADwAZwBtAG0AOgBEAGUAZgBhAHUAbAB0AEIAYQBzAGUAbABpAG4AZQBHAGEAbQB1AHQATQBhAHAATQBvAGQAZQBsAD4ASABQAE0AaQBuAEMARABfAEEAYgBzAG8AbAB1AHQAZQA8AC8AZwBtAG0AOgBEAGUAZgBhAHUAbAB0AEIAYQBzAGUAbABpAG4AZQBHAGEAbQB1AHQATQBhAHAATQBvAGQAZQBsAD4ADQAKADwALwBnAG0AbQA6AEcAYQBtAHUAdABNAGEAcABNAG8AZABlAGwAPgANAAoAAAA="
)


<#
SHOW VERSION
#>

# Ooo, shiny!
Write-Host "`n                                                   " -BackgroundColor Blue -NoNewline
Write-Host "`n WindowShade Standard Installer [v$version] by Lulech23 " -NoNewline -BackgroundColor Blue -ForegroundColor White
Write-Host "`n                                                   " -BackgroundColor Blue

# About
Write-Host "`nThis script will replace the current display calibration with a custom profile"
Write-Host "selected from the menu below. You may also run this script via command-line"
Write-Host "followed by the fully-qualified path to your *.icc/*.icm profile to install a"
Write-Host "new profile directly."
Write-Host "`nInstalled profiles are permanent until removed and will persist across reboots." -ForegroundColor Cyan

# Current Profile
Write-Host "`nCalibration profile is currently set to: " -NoNewline
$profile = [string] (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles\").sRGB
$service = (Test-Path -Path "$env:AppData\WindowShade\wsservice.ps1")
if ($profile.length -gt 0) {
    Write-Host "$profile" -ForegroundColor Yellow
    Write-Host " * Display is calibrated" -ForegroundColor Gray
    Write-Host " * Colors and gamma have been customized to suit your display" -ForegroundColor Gray
    if ($service -eq $true) {
        Write-Host " * WindowShade service is active. Static profiles will be overridden" -ForegroundColor Gray
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
            if (($ext -ne ".icc") -And ($ext -ne ".icm")) {
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
            Filter = "ICC Profile (*.icc;*.icm)|*.icc;*.icm"
            Title = "Select a color calibration profile"
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
                $FileBrowser.FileName = ""
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
        Copy-Item "$profile" -Destination "$path\" -Force | Out-Null
        $profile = (Get-Item $profile).Name
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

    # Export selected profile
    [IO.File]::WriteAllBytes("$path\$($builtin[$profile - 1])", [Convert]::FromBase64String($builtin[$profile])) | Out-Null
    $profile = $builtin[$profile - 1]
}


<#
INSTALL PROFILE
#>

if (($task -eq 1) -Or ($task -eq 2)) {
    if (!(Test-Path -Path "$path\$profile")) {
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
                    reg add "$reg\$id" /t REG_MULTI_SZ /v "ICMProfile" /d "$profile" /f
                    $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
                    reg add "$reg\$id" /t REG_MULTI_SZ /v "ICMProfileAC" /d "$profile" /f
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
                reg add "$reg" /t REG_MULTI_SZ /v "ICMProfile" /d "$profile" /f
            }

            # Enable calibration management
            $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
            reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\Calibration" /t REG_DWORD /v "CalibrationManagementEnabled" /d 1 /f

            # Register calibration profile
            $step++; Write-Host "($step/$steps) " -NoNewline -ForegroundColor Cyan 
            reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM\RegisteredProfiles" /t REG_SZ /v "sRGB" /d "$profile" /f
            
            # Run calibration loader task to apply changes
            Enable-ScheduledTask -TaskName "\Microsoft\Windows\WindowsColorSystem\Calibration Loader" | Out-Null
            Start-ScheduledTask -TaskName "\Microsoft\Windows\WindowsColorSystem\Calibration Loader"
            
            # End process, we're done!
            Write-Host "`nProcess complete! " -NoNewline -ForegroundColor Green
            Write-Host "New calibration profile installed successfully. Enjoy!"
            Write-Host "If you liked this, stop by my website at " -NoNewline
            Write-Host "https://lucasc.me" -NoNewline -ForegroundColor Yellow
            Write-Host "!"
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
