<#
.SYNOPSIS
    Turns notification lines sent by devcontainers into native Windows toasts.

.DESCRIPTION
    Listens on a TCP port and renders every received "<title><TAB><body>" line as
    a Windows toast. Counterpart of notify.sh, which Claude Code runs inside the
    container where no notification daemon is reachable.

    One instance serves every container and every project on the machine.

    TcpListener rather than HttpListener: no URL ACL reservation, so no
    administrator rights are needed. Toasts use the built-in WinRT API, so no
    module has to be installed.

    Requires Windows PowerShell 5.1 (the version shipped with Windows).
    PowerShell 7 lacks the WinRT projections this uses.

.PARAMETER Port
    TCP port to listen on. Must match CLAUDE_NOTIFY_PORT in the container.

.PARAMETER BindAny
    Bind 0.0.0.0 instead of loopback, for Docker setups whose proxy cannot reach
    host loopback. Connections are then restricted to AllowedRemotePrefixes.

.EXAMPLE
    Install to run at logon:

    schtasks /Create /TN "Claude Toast Bridge" /SC ONLOGON /RL LIMITED /F /TR ^
      "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File %USERPROFILE%\claude-notify\windows-toast-bridge.ps1"

.EXAMPLE
    Verify from inside a container:

    printf 'Claude Code\tbridge online\n' > /dev/tcp/host.docker.internal/47823
#>

[CmdletBinding()]
param(
    [int]$Port = 47823,
    [switch]$BindAny
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Registered AUMID of Windows PowerShell. Toasts must be shown under an
# application known to the shell, otherwise they are silently dropped.
$AppUserModelId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'

# Docker Desktop reaches the host from these ranges; used only with -BindAny.
$AllowedRemotePrefixes = @('127.', '172.', '192.168.65.')

$FieldSeparator = "`t"
$ReadTimeoutMilliseconds = 3000
$MaxLineLength = 512

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] > $null

<#
.SYNOPSIS
    Shows a Windows toast.
.PARAMETER Title
    First line of the toast.
.PARAMETER Body
    Second line of the toast.
#>
function Show-Toast {
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][string]$Body
    )

    $safeTitle = [System.Security.SecurityElement]::Escape($Title)
    $safeBody = [System.Security.SecurityElement]::Escape($Body)

    $document = New-Object Windows.Data.Xml.Dom.XmlDocument
    $document.LoadXml(@"
<toast activationType="foreground">
  <visual>
    <binding template="ToastGeneric">
      <text>$safeTitle</text>
      <text>$safeBody</text>
    </binding>
  </visual>
</toast>
"@)

    $toast = New-Object Windows.UI.Notifications.ToastNotification $document

    # Same tag => a new toast replaces the previous one instead of stacking,
    # so a burst of permission requests from one project shows one toast.
    # The tag is derived from the title, which notify.sh scopes per project.
    $tag = ($Title -replace '[^\w-]', '_')
    if ($tag.Length -gt 60) { $tag = $tag.Substring(0, 60) }
    $toast.Tag = $tag
    $toast.Group = 'claude-code'

    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppUserModelId).Show($toast)
}

<#
.SYNOPSIS
    Tells whether a remote address may send notifications.
.PARAMETER Address
    Remote IP address of the connection.
#>
function Test-RemoteAllowed {
    param([Parameter(Mandatory)][string]$Address)

    if (-not $BindAny) { return $true }
    foreach ($prefix in $AllowedRemotePrefixes) {
        if ($Address.StartsWith($prefix)) { return $true }
    }
    return $false
}

$bindAddress = if ($BindAny) { [System.Net.IPAddress]::Any } else { [System.Net.IPAddress]::Loopback }
$listener = New-Object System.Net.Sockets.TcpListener $bindAddress, $Port
$listener.Start()
Write-Host "Claude toast bridge listening on ${bindAddress}:${Port}"

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $remoteAddress = $client.Client.RemoteEndPoint.Address.ToString()
            if (-not (Test-RemoteAllowed -Address $remoteAddress)) {
                Write-Host "Rejected connection from $remoteAddress"
                continue
            }

            $stream = $client.GetStream()
            $stream.ReadTimeout = $ReadTimeoutMilliseconds
            $reader = New-Object System.IO.StreamReader $stream
            $line = $reader.ReadLine()
            if ([string]::IsNullOrWhiteSpace($line)) { continue }

            if ($line.Length -gt $MaxLineLength) {
                $line = $line.Substring(0, $MaxLineLength)
            }

            $parts = $line.Split($FieldSeparator, 2)
            $title = $parts[0]
            $body = if ($parts.Length -gt 1) { $parts[1] } else { '' }
            Show-Toast -Title $title -Body $body
        }
        catch {
            # One bad client must never take the bridge down.
            Write-Host "Dropped connection: $($_.Exception.Message)"
        }
        finally {
            $client.Close()
        }
    }
}
finally {
    $listener.Stop()
}
