<#
.SYNOPSIS
  Access the BallDontLie Game API via PowerShell
.DESCRIPTION
  See https://www.balldontlie.io/#get-all-games
.PARAMETER Year
  The year to retrieve
.PARAMETER Month
  The month to rereive

.OUTPUTS
  A json-formatted document served in stdout

.NOTES
  Version:        0.2
  Author:         Uri Yanover
  Creation Date:  2021-09-07
  Purpose/Change: Fix example
  
.EXAMPLE
  games.ps1 2019 5
#>

function Get-Data {
    [CmdletBinding()]
    param (
        # Duplication - see https://stackoverflow.com/questions/36656171/can-i-use-a-constant-in-the-validateset-attribute-of-a-powershell-function-param
        [Parameter(Mandatory = $true,
               HelpMessage = 'Year to query')]
        [ValidateRange(1900,[int16]::MaxValue)]
        [int16]$Year,
        [Parameter(Mandatory = $true,
               HelpMessage = 'Month to query')]
        [ValidateRange(1, 12)]
        [int16]$Month
    )

    $lastDay = [DateTime]::DaysInMonth($Year, $Month)
    $startDate = "{0,1:d4}-{1,1:d2}-{2,1:d2}" -f ($Year, $Month, 1) 
    $endDate = "{0,1:d4}-{1,1:d2}-{2,1:d2}" -f ($Year, $Month, $lastDay)

    $result = @()
    $currentPage = 0
    # More general URL parameters can be specified as in https://riptutorial.com/powershell/example/24405/encode-query-string-with---system-web-httputility---urlencode---
    while ($true) {
      $response = Invoke-RestMethod -Uri "https://www.balldontlie.io/api/v1/games?start_date=$startDate&end_date=$endDate&page=$currentPage&per_page=100"
      
      $result += ($response.data | ConvertTo-Json -Depth 100)
      $currentPage = $response.meta.next_page
      if($null -eq $currentPage) {
        break
      }
    }
    $result
}

Get-Data $args[0] $args[1]