# Templates.psm1 - Manages Wal templates

<#
.DESCRIPTION
    Copies the contents of ./templates to ~/.config/wal/templates, will clobber templates with matching names
#>
function Add-WalTemplates {
    [CmdletBinding()]
    param(
        [string]$SourceDir = (Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath "templates")
    )
    
    $walTemplateDir = Join-Path -Path $HOME -ChildPath ".config/wal/templates"
    
    if (!(Test-Path -Path $walTemplateDir)) {
        Write-Verbose "Creating wal templates directory: $walTemplateDir"
        New-Item -Path $walTemplateDir -ItemType Directory -Force | Out-Null
    }

    Get-ChildItem -Path $SourceDir | ForEach-Object {
        $destinationPath = Join-Path -Path $walTemplateDir -ChildPath $_.Name
        if (!(Test-Path -Path $destinationPath)) {
            Write-Verbose "Copying template: $($_.Name)"
            Copy-Item -Path $_.FullName -Destination $walTemplateDir
        }
        else {
            Write-Verbose "Template already exists: $($_.Name)"
        }
    }
}

Export-ModuleMember -Function Add-WalTemplates
