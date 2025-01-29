Class AvailableBackends : System.Management.Automation.IValidateSetValuesGenerator {
  [string[]] GetValidValues() {
    $backends = @()
    if (Get-Command 'python' -ErrorAction SilentlyContinue) {
      $backends = ConvertTo-Json -InputObject @('colorthief', 'colorz', 'haishoku') | python "$PSScriptRoot/checker.py" | ConvertFrom-Json
    }

    return $backends
  }
}