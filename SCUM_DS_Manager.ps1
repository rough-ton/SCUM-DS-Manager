if ($host.Name -eq 'ConsoleHost' -and -not $env:SCUM_GUI_RELAUNCHED) {
    $env:SCUM_GUI_RELAUNCHED = "1"
    Start-Process powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`"" -WindowStyle Hidden
    exit
}

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

$xamlString = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="SCUM DS Manager" Height="650" Width="800" WindowStartupLocation="CenterScreen"
        FontFamily="Segoe UI" FontSize="13">
    <Grid>
        <TabControl Name="MainTab" SelectedIndex="0" Margin="10">
            <!-- Hardware Tab -->
            <TabItem Header="Hardware">
                <Grid Margin="10">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>

                    <!-- Hardware Info Output -->
                    <StackPanel Grid.Row="0" Margin="0,0,0,10">
                        <TextBlock Text="Detected Hardware:" FontWeight="Bold" Margin="0,0,0,5"/>
                        <ScrollViewer Height="180" VerticalScrollBarVisibility="Auto">
                            <StackPanel Name="HardwareInfoPanel" />
                        </ScrollViewer>

                        <Separator Margin="0,10,0,10"/>

                        <TextBlock Text="System Checks:" FontWeight="Bold" Margin="0,0,0,5"/>
                        <StackPanel Name="HardwareChecklist" Margin="0,0,0,10">
                            <TextBlock Name="OSCheck" FontWeight="Bold" ToolTip="Requires a 64-bit Windows Server OS"/>
                            <TextBlock Name="RAMCheck" FontWeight="Bold" ToolTip="Minimum: 8 GB RAM required"/>
                            <TextBlock Name="DiskCheck" FontWeight="Bold" ToolTip="Minimum: 50 GB disk space required"/>
                        </StackPanel>
                    </StackPanel>

                    <Border Name="WarningBanner" Grid.Row="1" Background="#FFF7E5" BorderBrush="Goldenrod" BorderThickness="1" CornerRadius="4" Padding="10" Visibility="Collapsed">
                        <TextBlock Name="WarningText" Foreground="Goldenrod" FontWeight="SemiBold"/>
                    </Border>

                    <Border Name="ErrorBanner" Grid.Row="2" Background="#FFD6D6" BorderBrush="Firebrick" BorderThickness="1" CornerRadius="4" Padding="10" Margin="0,5,0,0" Visibility="Collapsed">
                        <TextBlock Name="ErrorText" Foreground="DarkRed" FontWeight="SemiBold"/>
                    </Border>

                    <StackPanel Grid.Row="3" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
                        <Button Name="RefreshHardwareBtn" Content="Refresh" Width="120"/>
                    </StackPanel>
                </Grid>
            </TabItem>

            <TabItem Header="SCUM Server Install">
                <Grid Margin="10">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>     <!-- Main install content -->
                        <RowDefinition Height="Auto"/>  <!-- Footer: disclaimer + logs + button -->
                    </Grid.RowDefinitions>

                    <!-- Main scrollable content -->
                    <ScrollViewer Grid.Row="0">
                        <StackPanel>
                            <!-- VC++ -->
                            <StackPanel Orientation="Horizontal" Margin="0,5">
                                <TextBlock Text="Visual C++ Redistributable:" Width="220"/>
                                <TextBlock Name="VCStatus" Text="Not Checked" Width="150"/>
                                <Button Name="VCInstallBtn" Content="Install" Width="130" Margin="5,0" IsEnabled="False"/>
                                <Button Name="VCUninstallBtn" Content="Uninstall" Width="100" IsEnabled="False"/>
                            </StackPanel>

                            <!-- DirectX -->
                            <StackPanel Orientation="Horizontal" Margin="0,5">
                                <TextBlock Text="DirectX End-User Runtime:" Width="220"/>
                                <TextBlock Name="DXStatus" Text="Not Checked" Width="150"/>
                                <Button Name="DXInstallBtn" Content="Install" Width="130" Margin="5,0" IsEnabled="False"/>
                                <Button Name="DXUninstallBtn" Content="Uninstall" Width="100" Margin="5" Visibility="Collapsed"/>
                            </StackPanel>
                            <TextBlock TextWrapping="Wrap" Margin="5,2,5,10" FontSize="12" Foreground="DarkGray"
                                    Text="Why no 'Uninstall' option? DirectX installs legacy DLLs to system folders and cannot be cleanly uninstalled. Manual removal is not recommended and is outside the scope of this script." />

                            <!-- SteamCMD -->
                            <StackPanel Orientation="Vertical" Margin="0,5">
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="SteamCMD:" Width="220"/>
                                    <TextBlock Name="SteamCMDStatus" Text="Not Checked" Width="150"/>
                                    <Button Name="SteamCMDInstallBtn" Content="Install" Width="130" Margin="5,0" IsEnabled="False"/>
                                    <Button Name="SteamCMDUninstallBtn" Content="Uninstall" Width="100" IsEnabled="False"/>
                                </StackPanel>

                                <StackPanel Name="SteamCMDPathPanel" Orientation="Horizontal" Margin="0,5,0,0" Visibility="Collapsed">
                                    <TextBlock Text="Install Path:" Width="90" VerticalAlignment="Center"/>
                                    <TextBox Name="SteamCMDPathBox" Text="C:\SteamCMD" Width="400" Margin="5,0"/>
                                    <Button Name="BrowseSteamCMDPathBtn" Content="Browse..." Width="75"/>
                                </StackPanel>
                            </StackPanel>

                            <!-- SCUM Server Files -->
                            <StackPanel Orientation="Vertical" Margin="0,5">
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="SCUM Server Files:" Width="220"/>
                                    <TextBlock Name="SCUMInstallStatus" Text="Not Checked" Width="150"/>
                                    <Button Name="SCUMInstallBtn" Content="Install" Width="130" Margin="5,0" IsEnabled="False"/>
                                    <Button Name="SCUMUninstallBtn" Content="Uninstall" Width="100" Margin="5,0" IsEnabled="False"/>
                                </StackPanel>

                                <StackPanel Name="SCUMPathPanel" Orientation="Horizontal" Margin="0,5,0,0" Visibility="Collapsed">
                                    <TextBlock Text="Install Path:" Width="90" VerticalAlignment="Center"/>
                                    <TextBox Name="SCUMPathBox" Text="C:\ScumServer" Width="400" Margin="5,0"/>
                                    <Button Name="BrowseSCUMPathBtn" Content="Browse..." Width="75"/>
                                </StackPanel>
                            </StackPanel>

                            <TextBlock TextWrapping="Wrap" Margin="5,2,5,10" FontSize="12" Foreground="DarkGray"
                                    Text="SCUM Server Files install button is locked until SteamCMD is detected. Please install SteamCMD first." />
                        </StackPanel>
                    </ScrollViewer>

                    <!-- Footer: Run Checks button, log output, then disclaimer -->
                    <StackPanel Grid.Row="1" Margin="0,10,0,0">
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,0,0,5">
                            <Button Name="RunAllChecksBtn" Content="Run Checks" Width="120"/>
                        </StackPanel>

                        <Expander Header="Show Log Output" IsExpanded="False" Margin="0,0,0,5">
                            <TextBox Name="OutputLog" IsReadOnly="True" AcceptsReturn="True" TextWrapping="Wrap"
                                    FontFamily="Consolas" FontSize="12" VerticalScrollBarVisibility="Auto" Height="100"/>
                        </Expander>

                        <Border Background="#FFF5F5" Padding="5" Margin="0,5,0,0">
                            <TextBlock TextWrapping="Wrap" FontSize="11" Foreground="Red" FontStyle="Italic"
                                    Text="Disclaimer: This tool (and the scripts within) is provided as-is, with zero warranty, guarantees, or promises. If it breaks something, deletes your stuff, or summons a tech demon, that’s on you." />
                        </Border>
                    </StackPanel>

                </Grid>
            </TabItem>


            <!-- Server Config Tab -->
            <TabItem Header="Server Config">
                <TextBlock TextWrapping="Wrap" Margin="10" FontSize="13" Text="Coming soon! SCUM Server config manager." />
            </TabItem>

            <!-- About Tab -->
            <TabItem Header="About">
                <Grid Margin="10">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>     <!-- Main content scrolls -->
                        <RowDefinition Height="Auto"/>  <!-- Disclaimer stays pinned -->
                    </Grid.RowDefinitions>

                    <!-- Scrollable main content -->
                    <ScrollViewer Grid.Row="0">
                        <StackPanel>
                            <TextBlock Text="SCUM DS (Dedicated Server) Manager" FontWeight="Bold" FontSize="16" Margin="0,0,0,10"/>
                            <TextBlock Text="Version: 1.0.0" FontSize="12" Margin="0,0,0,5"/>
                            <TextBlock Text="Developed by: Mike Roughton" FontSize="12" Margin="0,0,0,5"/>

                            <TextBlock TextWrapping="Wrap" FontSize="12" Margin="0,10,0,5"
                                    Text="This tool was built using native PowerShell to be fully transparent and easily auditable. All functions are visible in plain text, and nothing in this tool communicates externally or 'phones home'." />

                            <TextBlock Text="License:" FontWeight="Bold" FontSize="13" Margin="0,10,0,2"/>
                            <TextBlock TextWrapping="Wrap" FontSize="12" Margin="0,0,0,5"
                                    Text="This tool is licensed under the Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0) license. You are free to copy, modify, and share it, but commercial use is not permitted. You must provide attribution." />

                            <TextBlock Name="LicenseLink" Text="View License: https://creativecommons.org/licenses/by-nc/4.0/"
                                    FontSize="12" Foreground="Blue" Cursor="Hand" Margin="0,5,0,5" TextDecorations="Underline"/>

                            <TextBlock Text="Source Code:" FontWeight="Bold" FontSize="13" Margin="10,10,0,2"/>
                            <TextBlock Name="GitHubLink" Text="GitHub Repo: https://github.com/rough-ton/scum-ds-manager"
                                    FontSize="12" Foreground="Blue" Cursor="Hand" Margin="0,0,0,5" TextDecorations="Underline"/>

                            <TextBlock TextWrapping="Wrap" FontSize="12" Margin="0,15,0,0"
                                    Text="To report bugs, feature requests, or installation issues, please open an issue in the GitHub repository."/>
                        </StackPanel>
                    </ScrollViewer>

                    <!-- Disclaimer pinned to bottom -->
                    <Border Grid.Row="1" Background="#FFF5F5" Padding="5" Margin="0,10,0,0">
                        <TextBlock TextWrapping="Wrap"
                                FontSize="11" Foreground="Red" FontStyle="Italic"
                                Text="Disclaimer: This tool (and the scripts within) is provided as-is, with zero warranty, guarantees, or promises. If it breaks something, deletes your stuff, or summons a tech demon, that’s on you." />
                    </Border>
                </Grid>
            </TabItem>

        </TabControl>
    </Grid>
</Window>
"@

#########################################
########## Load and parse XAML ##########
#########################################
Add-Type -AssemblyName PresentationFramework

$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xamlString))
$window = [Windows.Markup.XamlReader]::Load($reader)

################################################################
########## Redirect all default output to the GUI log ##########
################################################################
$originalOutput = [Console]::Out
$logWriter = New-Object System.IO.StringWriter
[Console]::SetOut($logWriter)

##################################################
########## Utility function for logging ##########
##################################################
function Write-Log {
    param ($msg)

    $OutputLog.AppendText("[$(Get-Date -Format HH:mm:ss)] $msg`n")

    # Also capture anything written directly to the console
    $consoleOut = $logWriter.ToString()
    if ($consoleOut) {
        $OutputLog.AppendText($consoleOut)
        $logWriter.GetStringBuilder().Clear() | Out-Null
    }

    $OutputLog.ScrollToEnd()
}

#####################################
########## Get UI controls ##########
#####################################
$HardwareInfoPanel = $window.FindName("HardwareInfoPanel")
$OSCheck = $window.FindName("OSCheck")
$RAMCheck = $window.FindName("RAMCheck")
$DiskCheck = $window.FindName("DiskCheck")
$WarningBanner = $window.FindName("WarningBanner")
$WarningText = $window.FindName("WarningText")
$ErrorBanner = $window.FindName("ErrorBanner")
$ErrorText = $window.FindName("ErrorText")
$RefreshHardwareBtn = $window.FindName("RefreshHardwareBtn")

$VCStatus = $window.FindName("VCStatus")
$DXStatus = $window.FindName("DXStatus")
$SteamCMDStatus = $window.FindName("SteamCMDStatus")

$VCInstallBtn = $window.FindName("VCInstallBtn")
$VCUninstallBtn = $window.FindName("VCUninstallBtn")

$DXInstallBtn = $window.FindName("DXInstallBtn")
$DXUninstallBtn = $window.FindName("DXUninstallBtn")

$SteamCMDPathPanel = $window.FindName("SteamCMDPathPanel")
$SteamCMDPathBox = $window.FindName("SteamCMDPathBox")
$BrowseSteamCMDPathBtn = $window.FindName("BrowseSteamCMDPathBtn")
$SteamCMDInstallBtn = $window.FindName("SteamCMDInstallBtn")
$SteamCMDUninstallBtn = $window.FindName("SteamCMDUninstallBtn")

$SCUMInstallStatus = $window.FindName("SCUMInstallStatus")
$SCUMInstallBtn = $window.FindName("SCUMInstallBtn")
$SCUMUninstallBtn = $window.FindName("SCUMUninstallBtn")
$SCUMPathPanel = $window.FindName("SCUMPathPanel")
$SCUMPathBox = $window.FindName("SCUMPathBox")
$BrowseSCUMPathBtn = $window.FindName("BrowseSCUMPathBtn")

$RunAllChecksBtn = $window.FindName("RunAllChecksBtn")
$OutputLog = $window.FindName("OutputLog")

$ChecksAlreadyRan = $false
$MainTab = $window.FindName("MainTab")

$MainTab.Add_SelectionChanged({
        $selectedTab = $MainTab.SelectedItem

        if ($selectedTab.Header -eq "SCUM Server Install" -and -not $ChecksAlreadyRan) {
            # Defer checks until after tab render completes
            $window.Dispatcher.InvokeAsync({
                    $RunAllChecksBtn.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
                    $ChecksAlreadyRan = $true
                }, [System.Windows.Threading.DispatcherPriority]::ApplicationIdle)
        }
    })

########## Helper for result display ##########
function Set-CheckText {
    param (
        [System.Windows.Controls.TextBlock]$Control,
        [string]$Message,
        [bool]$Passed
    )
    $Control.Text = if ($Passed) { "✔ $Message" } else { "✘ $Message" }
    $Control.Foreground = if ($Passed) {
        [System.Windows.Media.Brushes]::Green
    }
    else {
        [System.Windows.Media.Brushes]::Red
    }
}

#################################
########## Log Handler ##########
#################################
function Start-AndLogProcess {
    param (
        [string]$ExePath,
        [string]$Arguments
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $ExePath
    $psi.Arguments = $Arguments
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi

    $process.Start() | Out-Null

    while (-not $process.HasExited) {
        while (-not $process.StandardOutput.EndOfStream) {
            $line = $process.StandardOutput.ReadLine()
            Write-Log $line
        }
        Start-Sleep -Milliseconds 100
    }

    # Flush any remaining error lines
    while (-not $process.StandardError.EndOfStream) {
        $errorLine = $process.StandardError.ReadLine()
        Write-Log "[stderr] $errorLine"
    }

    $exitCode = $process.ExitCode
    if ($exitCode -eq 0) {
        Write-Log "Process completed successfully."
    }
    else {
        Write-Log "Process exited with code $exitCode."
    }

    return $exitCode
}

########################################
########## Load hardware info ##########
########################################

function Load-HardwareInfo {
    $HardwareInfoPanel.Children.Clear()

    $os = Get-CimInstance Win32_OperatingSystem
    $ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

    function Add-InfoRow {
        param ($label, $value)
        $row = New-Object System.Windows.Controls.StackPanel
        $row.Orientation = "Horizontal"
        $lbl = New-Object System.Windows.Controls.TextBlock
        $lbl.Text = "${label}: "
        $lbl.FontWeight = "Bold"
        $lbl.Width = 140
        $val = New-Object System.Windows.Controls.TextBlock
        $val.Text = $value
        $row.Children.Add($lbl)
        $row.Children.Add($val)
        $HardwareInfoPanel.Children.Add($row)
    }

    Add-InfoRow "Hostname" $env:COMPUTERNAME
    Add-InfoRow "OS Type" "$($os.Caption) ($env:PROCESSOR_ARCHITECTURE)"
    Add-InfoRow "OS Version" $os.Version
    Add-InfoRow "OS Build" $os.BuildNumber
    Add-InfoRow "RAM Installed" "$ramGB GB"

    $diskOk = $false
    $freeSpaceGB = $null
    $systemDrive = "$($env:SystemDrive)".TrimEnd('\')

    foreach ($disk in $disks) {
        $driveLetter = $disk.DeviceID.TrimEnd(':')
        $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
        Add-InfoRow "Drive $driveLetter" "$freeGB GB free"

        if ($disk.DeviceID -eq $systemDrive) {
            $freeSpaceGB = $freeGB
            if ($freeGB -ge 50) { $diskOk = $true }
        }
    }

    $isServer = $os.Caption -match "Windows Server"
    $is64 = $env:PROCESSOR_ARCHITECTURE -eq "AMD64"
    $osOk = $isServer -and $is64
    $ramOk = $ramGB -ge 8

    Set-CheckText $OSCheck "Operating System: $($os.Caption) ($env:PROCESSOR_ARCHITECTURE)" $osOk
    Set-CheckText $RAMCheck "Memory: $ramGB GB detected (Minimum: 8 GB)" $ramOk
    if ($null -ne $freeSpaceGB) {
        Set-CheckText $DiskCheck "Disk Space (System Drive): $freeSpaceGB GB free (Minimum: 50 GB)" $diskOk
    }
    else {
        Set-CheckText $DiskCheck "Disk Space: Unable to detect system drive" $false
    }

    $WarningBanner.Visibility = if (-not $isServer) { "Visible" } else { "Collapsed" }
    $WarningText.Text = "Running on a workstation OS may cause instability."

    if (-not $ramOk -or -not $diskOk) {
        $issues = @()
        if (-not $ramOk) { $issues += "- At least 8GB RAM required." }
        if (-not $diskOk) { $issues += "- At least 50GB free disk space required on system drive." }
        $ErrorText.Text = $issues -join "`n"
        $ErrorBanner.Visibility = "Visible"
    }
    else {
        $ErrorBanner.Visibility = "Collapsed"
    }
}


$window.Add_Loaded({ Load-HardwareInfo })
$RefreshHardwareBtn.Add_Click({
        Load-HardwareInfo
    })

##############################
########## VCRedist ##########
##############################

# Check if VCRedist is installed or not
function Check-VCRedist {
    param ([bool]$Silent = $false)

    if (-not $Silent) { Write-Log "Checking Visual C++ Redistributable..." }

    $vc = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
    Get-ItemProperty |
    Where-Object { $_.DisplayName -like "Microsoft Visual C++ 2015-2022* (x64)*" }

    $VCStatus.FontWeight = 'Bold'

    if ($vc) {
        $VCStatus.Text = "Installed"
        $VCStatus.Foreground = [System.Windows.Media.Brushes]::Green
        if (-not $Silent) { Write-Log "Visual C++ Redistributable is installed." }
    }
    else {
        $VCStatus.Text = "Not Installed"
        $VCStatus.Foreground = [System.Windows.Media.Brushes]::Red
        if (-not $Silent) { Write-Log "Visual C++ Redistributable is not installed." }
    }
}


# VCRedist Install Button
$VCInstallBtn.Add_Click({
        Write-Log "Installing Visual C++ Redistributable..."

        try {
            Start-Process -NoNewWindow -Wait -FilePath "winget" -ArgumentList 'install --id Microsoft.VCRedist.2015+.x64 --silent --accept-package-agreements --accept-source-agreements'
            Write-Log "Visual C++ Redistributable installation completed."
        }
        catch {
            Write-Log "Visual C++ install failed: $_"
        }

        Check-VCRedist
        $RunAllChecksBtn.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
    })

# VCRedist Uninstall Button
$VCUninstallBtn.Add_Click({
        Write-Log "Attempting to uninstall Visual C++ Redistributable (x64) via registry..."

        $vcKeyPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        )

        $found = $false

        foreach ($keyPath in $vcKeyPaths) {
            Get-ChildItem $keyPath | ForEach-Object {
                $props = Get-ItemProperty $_.PsPath
                if ($props.DisplayName -like "Microsoft Visual C++ 2015-2022* (x64)*") {
                    $found = $true
                    Write-Log "Found: $($props.DisplayName)"

                    if ($props.UninstallString) {
                        $uninstallCmd = $props.UninstallString

                        # Remove surrounding quotes if present
                        if ($uninstallCmd.StartsWith('"')) {
                            $parts = $uninstallCmd -split '"'
                            $exe = $parts[1]
                            $args = $parts[2].Trim()
                        }
                        else {
                            $exe, $args = $uninstallCmd -split '\s+', 2
                        }

                        try {
                            Write-Log "Running uninstall command: $exe $args"
                            Start-Process -FilePath $exe -ArgumentList $args -Wait -NoNewWindow
                            Write-Log "Uninstall completed."
                        }
                        catch {
                            Write-Log "Uninstall failed: $_"
                        }
                    }
                    else {
                        Write-Log "No uninstall command found for $($props.DisplayName)"
                    }
                }
            }
        }

        if (-not $found) {
            Write-Log "No matching Visual C++ Redistributable found in registry."
        }

        # Refresh the status
        Check-VCRedist
        $RunAllChecksBtn.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
    })

##############################
########## DirectX ###########
##############################

# Check if DirectX is installed or not
function Check-DirectX {
    param ([bool]$Silent = $false)

    if (-not $Silent) { Write-Log "Checking for DirectX End-User Runtime components..." }

    $dxDlls = @(
        "$env:SystemRoot\System32\d3dx9_43.dll",
        "$env:SystemRoot\SysWOW64\d3dx9_43.dll",
        "$env:SystemRoot\System32\d3dx10_43.dll",
        "$env:SystemRoot\System32\d3dx11_43.dll"
    )

    $dllFound = $dxDlls | Where-Object { Test-Path $_ }

    $DXStatus.FontWeight = 'Bold'

    if ($dllFound) {
        $DXStatus.Text = "Installed"
        $DXStatus.Foreground = [System.Windows.Media.Brushes]::Green
        if (-not $Silent) { Write-Log "DirectX runtime DLLs detected." }
        return
    }

    # Fallback registry check
    $dxKeyPath = "HKLM:\SOFTWARE\Microsoft\DirectX"
    $dxSetupLogPath = "HKLM:\SOFTWARE\Microsoft\DirectX\Setup"

    $dxVersion = ""
    $dxInstalled = $false

    if (Test-Path $dxKeyPath) {
        try {
            $dxVersion = (Get-ItemProperty -Path $dxKeyPath).Version
            if (-not $Silent) { Write-Log "DirectX version reported in registry: $dxVersion" }
        }
        catch {
            if (-not $Silent) { Write-Log "Failed to read DirectX version from registry." }
        }
    }

    if (Test-Path $dxSetupLogPath) {
        try {
            $lastSetupDate = (Get-ItemProperty -Path $dxSetupLogPath).InstalledVersion
            if ($lastSetupDate) {
                if (-not $Silent) { Write-Log "DirectX Setup InstalledVersion: $lastSetupDate" }
                $dxInstalled = $true
            }
        }
        catch {
            if (-not $Silent) { Write-Log "DirectX Setup registry fallback not found." }
        }
    }

    if ($dxInstalled -or $dxVersion -like "4.09.*") {
        $DXStatus.Text = "Installed"
        $DXStatus.Foreground = [System.Windows.Media.Brushes]::Green
        if (-not $Silent) { Write-Log "DirectX runtime likely installed based on registry." }
    }
    else {
        $DXStatus.Text = "Not Installed"
        $DXStatus.Foreground = [System.Windows.Media.Brushes]::Red
        if (-not $Silent) { Write-Log "No DirectX runtime indicators found." }
    }
}

# DirectX Install Button
$DXInstallBtn.Add_Click({
        Write-Log "Downloading and installing DirectX End-User Runtimes..."

        $dxUrl = "https://download.microsoft.com/download/8/4/a/84a35bf1-dafe-4ae8-82af-ad2ae20b6b14/directx_Jun2010_redist.exe"
        $installerPath = "$env:TEMP\directx_Jun2010_redist.exe"
        $extractPath = "$env:TEMP\DXRedist"

        try {
            Write-Log "Downloading DirectX installer..."
            Invoke-WebRequest -Uri $dxUrl -OutFile $installerPath -UseBasicParsing

            Write-Log "Extracting DirectX installer..."
            Start-Process -FilePath $installerPath -ArgumentList "/Q /T:`"$extractPath`"" -Wait -NoNewWindow

            Write-Log "Running DXSETUP.exe silently..."
            Start-Process -FilePath "$extractPath\DXSETUP.exe" -ArgumentList "/silent" -Wait -NoNewWindow

            Write-Log "DirectX installation completed."
        }
        catch {
            Write-Log "DirectX installation failed: $_"
        }
        finally {
            # Clean up installer files
            if (Test-Path $installerPath) { Remove-Item $installerPath -Force }
            if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }
        }

        # Re-check after install
        Check-DirectX
        $RunAllChecksBtn.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
    })

# DirectX Uninstall Button
$DXUninstallBtn.Add_Click({
        Write-Log "DirectX End-User Runtimes cannot be uninstalled via this script."
        Write-Log "They are installed as system components in (System32) and must be manually removed if needed."
        $DXStatus.Text = "Manual Uninstall Required"
    })

##############################
########## SteamCMD ##########
##############################

# Check if SteamCMD is installed or not
function Check-SteamCMD {
    param ([bool]$Silent = $false)

    if (-not $Silent) { Write-Log "Checking SteamCMD..." }

    $SteamCMDStatus.FontWeight = 'Bold'
    $found = Test-Path "C:\SteamCMD\steamcmd.exe"

    if ($found) {
        $SteamCMDStatus.Text = "Installed"
        $SteamCMDStatus.Foreground = [System.Windows.Media.Brushes]::Green
        if (-not $Silent) { Write-Log "SteamCMD is installed." }
        return $true
    }
    else {
        $SteamCMDStatus.Text = "Not Installed"
        $SteamCMDStatus.Foreground = [System.Windows.Media.Brushes]::Red
        if (-not $Silent) { Write-Log "SteamCMD is not installed." }
        return $false
    }
}

# SteamCMD Install Button
$SteamCMDInstallBtn.Add_Click({
        if ($SteamCMDPathPanel.Visibility -eq "Collapsed") {
            $SteamCMDPathPanel.Visibility = "Visible"
            $SteamCMDInstallBtn.Content = "Confirm Install"
            Write-Log "Please confirm the install path for SteamCMD."
            return
        }

        $extractPath = $SteamCMDPathBox.Text.Trim()
        if (-not $extractPath) {
            Write-Log "No install path provided for SteamCMD."
            return
        }

        Write-Log "Installing SteamCMD to: $extractPath"

        try {
            $zipPath = "$env:TEMP\steamcmd.zip"
            Write-Log "Downloading SteamCMD zip from Steam CDN..."
            Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -OutFile $zipPath -UseBasicParsing

            Write-Log "Extracting SteamCMD zip to: $extractPath"
            Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

            Write-Log "Removing temp zip file: $zipPath"
            Remove-Item $zipPath -Force

            Write-Log "SteamCMD files extracted successfully to: $extractPath"

            Check-SteamCMD
        }
        catch {
            Write-Log "Failed to install SteamCMD: $_"
        }

        # Reset UI
        $SteamCMDPathPanel.Visibility = "Collapsed"
        $SteamCMDInstallBtn.Content = "Install"

        # Re-run checks
        $RunAllChecksBtn.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
    })

# SteamCMD Uninstall Button
$SteamCMDUninstallBtn.Add_Click({
        $steamPath = $SteamCMDPathBox.Text.Trim()
        if (-not $steamPath) {
            $steamPath = "C:\SteamCMD"
        }

        if (-not (Test-Path $steamPath)) {
            Write-Log "SteamCMD directory not found at: $steamPath"
            return
        }

        $confirm = [System.Windows.MessageBox]::Show(
            "Are you sure you want to uninstall SteamCMD from:`n$steamPath`nThis will permanently delete all SteamCMD files.",
            "Confirm Uninstall",
            "YesNo",
            "Warning"
        )

        if ($confirm -ne "Yes") {
            Write-Log "SteamCMD uninstall canceled by user."
            return
        }

        try {
            Write-Log "Uninstalling SteamCMD from: $steamPath"
            Remove-Item -Path $steamPath -Recurse -Force
            Write-Log "SteamCMD files removed successfully."

            # Optional: clear out the text box if uninstalled
            $SteamCMDPathBox.Text = ""

        }
        catch {
            Write-Log "Failed to uninstall SteamCMD: $_"
        }

        Check-SteamCMD
        $RunAllChecksBtn.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
    })

# SteamCMD Browse Button
$BrowseSteamCMDPathBtn.Add_Click({
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog

        # Set default if empty
        if (-not $SteamCMDPathBox.Text) {
            $SteamCMDPathBox.Text = "C:\SteamCMD"
        }

        $dialog.SelectedPath = $SteamCMDPathBox.Text
        if ($dialog.ShowDialog() -eq "OK") {
            $SteamCMDPathBox.Text = $dialog.SelectedPath
        }
    })

#################################
########## SCUM Server ##########
#################################

# Check if SCUM Server Files are installed or not
function Check-SCUM {
    param ([bool]$Silent = $false)

    if (-not $Silent) { Write-Log "Checking SCUM server files..." }

    $SCUMInstallStatus.FontWeight = 'Bold'

    $installRoot = $SCUMPathBox.Text.Trim()
    if (-not $installRoot) {
        $installRoot = "C:\ScumServer"
        if (-not $Silent) { Write-Log "SCUM install path not provided. Using default: $installRoot" }
    }

    # Try checking both direct and nested install locations
    $directPath = Join-Path $installRoot "SCUMServer.exe"
    $nestedPath = Join-Path $installRoot "SCUM\Binaries\Win64\SCUMServer.exe"

    if (Test-Path $nestedPath) {
        $SCUMInstallStatus.Text = "Installed"
        $SCUMInstallStatus.Foreground = [System.Windows.Media.Brushes]::Green
        if (-not $Silent) { Write-Log "SCUM server detected at: $nestedPath" }
        return $true
    }
    elseif (Test-Path $directPath) {
        $SCUMInstallStatus.Text = "Installed"
        $SCUMInstallStatus.Foreground = [System.Windows.Media.Brushes]::Green
        if (-not $Silent) { Write-Log "SCUM server detected at: $directPath" }
        return $true
    }
    else {
        $SCUMInstallStatus.Text = "Not Installed"
        $SCUMInstallStatus.Foreground = [System.Windows.Media.Brushes]::Red
        if (-not $Silent) { Write-Log "SCUMServer.exe not found at either expected location." }
        return $false
    }
}

# SCUM Server Install Button
$SCUMInstallBtn.Add_Click({
        if ($SCUMPathPanel.Visibility -eq "Collapsed") {
            $SCUMPathPanel.Visibility = "Visible"
            $SCUMInstallBtn.Content = "Confirm Install"
            Write-Log "Please confirm the install path for SCUM Server Files."
            return
        }

        $scumPath = $SCUMPathBox.Text
        $steamcmdPath = "C:\SteamCMD\steamcmd.exe"

        if (-not (Test-Path $steamcmdPath)) {
            Write-Log "SteamCMD is not installed at expected path: $steamcmdPath"
            return
        }

        $scriptPath = "$env:TEMP\scumcmd_script.txt"
        @"
login anonymous
force_install_dir "$scumPath"
app_update 3792580 validate
quit
"@ | Out-File -Encoding ASCII -FilePath $scriptPath

        $stdoutPath = "$env:TEMP\scum_stdout.txt"
        $stderrPath = "$env:TEMP\scum_stderr.txt"

        try {
            Write-Log "Launching SteamCMD to install SCUM server files..."

            $processInfo = New-Object System.Diagnostics.ProcessStartInfo
            $processInfo.FileName = $steamcmdPath
            $processInfo.Arguments = "+runscript `"$scriptPath`""
            $processInfo.UseShellExecute = $false
            $processInfo.RedirectStandardOutput = $true
            $processInfo.RedirectStandardError = $true
            $processInfo.CreateNoWindow = $true

            $process = New-Object System.Diagnostics.Process
            $process.StartInfo = $processInfo
            $process.Start() | Out-Null

            while (-not $process.StandardOutput.EndOfStream) {
                $line = $process.StandardOutput.ReadLine()
                if ($line) { Write-Log $line }
            }

            while (-not $process.StandardError.EndOfStream) {
                $err = $process.StandardError.ReadLine()
                if ($err) { Write-Log "[stderr] $err" }
            }

            $process.WaitForExit()

            if ($process.ExitCode -eq 0) {
                Write-Log "SCUM server installation complete."
                $SCUMInstallStatus.Text = "Installed"
                $SCUMInstallStatus.Foreground = [System.Windows.Media.Brushes]::Green
            }
            else {
                Write-Log "SteamCMD exited with code $($process.ExitCode)."
                $SCUMInstallStatus.Text = "Failed"
                $SCUMInstallStatus.Foreground = [System.Windows.Media.Brushes]::Red
            }
        }
        catch {
            Write-Log "SCUM server installation failed: $_"
            $SCUMInstallStatus.Text = "Failed"
            $SCUMInstallStatus.Foreground = [System.Windows.Media.Brushes]::Red
        }
        finally {
            Remove-Item $scriptPath -ErrorAction SilentlyContinue
            $SCUMPathPanel.Visibility = "Collapsed"
            $SCUMInstallBtn.Content = "Install"
        }

    })

# SCUM Server Browse Button
$BrowseSCUMPathBtn.Add_Click({
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $dialog.SelectedPath = $SCUMPathBox.Text
        if ($dialog.ShowDialog() -eq "OK") {
            $SCUMPathBox.Text = $dialog.SelectedPath
        }
    })

# SCUM Server Uninstall Button
$SCUMUninstallBtn.Add_Click({
        $installPath = $SCUMPathBox.Text.Trim()

        if (-not $installPath) {
            $installPath = "C:\ScumServer"
        }

        if (-not (Test-Path $installPath)) {
            Write-Log "SCUM server directory not found at: $installPath"
            return
        }

        $confirm = [System.Windows.MessageBox]::Show(
            "Are you sure you want to uninstall the SCUM server from:`n$installPath`nThis will permanently delete all server files.",
            "Confirm Uninstall",
            "YesNo",
            "Warning"
        )

        if ($confirm -ne "Yes") {
            Write-Log "SCUM server uninstall canceled by user."
            return
        }

        try {
            Write-Log "Uninstalling SCUM server files from: $installPath"
            Remove-Item -Path $installPath -Recurse -Force
            Write-Log "SCUM server files removed successfully."

            # Update status label
            $SCUMInstallStatus.Text = "Not Installed"
            $SCUMInstallStatus.Foreground = [System.Windows.Media.Brushes]::Red
        }
        catch {
            Write-Log "Failed to uninstall SCUM server: $_"
        }

        # Refresh status and button states
        $scumInstalled = Check-SCUM
        $steamInstalled = Check-SteamCMD
        $SCUMInstallBtn.IsEnabled = (-not $scumInstalled -and $steamInstalled)
        $SCUMUninstallBtn.IsEnabled = $scumInstalled
    })

####################################
########## Run All Checks ##########
####################################

$RunAllChecksBtn.Add_Click({
        # Perform checks silently
        Check-VCRedist -Silent $true
        Check-DirectX -Silent $true
        $steamInstalled = Check-SteamCMD -Silent $true
        $scumInstalled = Check-SCUM -Silent $true

        # Update buttons
        $VCInstallBtn.IsEnabled = ($VCStatus.Text -eq "Not Installed")
        $VCUninstallBtn.IsEnabled = ($VCStatus.Text -eq "Installed")

        $DXInstallBtn.IsEnabled = ($DXStatus.Text -eq "Not Installed")
        $DXUninstallBtn.IsEnabled = ($DXStatus.Text -eq "Installed")

        $SteamCMDInstallBtn.IsEnabled = ($SteamCMDStatus.Text -eq "Not Installed")
        $SteamCMDUninstallBtn.IsEnabled = ($SteamCMDStatus.Text -eq "Installed")

        $SCUMInstallBtn.IsEnabled = (-not $scumInstalled -and $steamInstalled)
        $SCUMUninstallBtn.IsEnabled = $scumInstalled
    })

#################################
########## URL Handler ##########
#################################

$LicenseLink = $window.FindName("LicenseLink")
$GitHubLink = $window.FindName("GitHubLink")

$LicenseLink.Add_MouseDown({
        Start-Process "https://creativecommons.org/licenses/by-nc/4.0/"
    })

$GitHubLink.Add_MouseDown({
        Start-Process "https://github.com/rough-ton/scum-ds-manager"
    })

$window.ShowDialog() | Out-Null

# Restore console output after window is closed
$window.Closed += {
    [Console]::SetOut($originalOutput)
}
