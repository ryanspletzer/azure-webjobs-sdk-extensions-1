function RunTest([string] $project, [string] $description,[bool] $skipBuild = $false, $filter = $null) {
    Write-Host "Running test: $description" -ForegroundColor DarkCyan
    Write-Host "-----------------------------------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host

    $cmdargs = "test", ".\test\$project\", "-v", "q"
    
    if ($filter) {
       $cmdargs += "--filter", "$filter"
    }

# We'll always rebuild for now.
#    if ($skipBuild){
#        $cmdargs += "--no-build"
#    }
#    else {
#        Write-Host "Rebuilding project" -ForegroundColor Red
#    }
    
    & dotnet $cmdargs | Out-Host
    $r = $?
    
    Write-Host
    Write-Host "-----------------------------------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host

    return $r
}


$tests = @(
  @{project ="WebJobs.Extensions.Tests"; description="Core extension Tests"},
  @{project ="WebJobs.Extensions.Http.Tests"; description="HTTP extension tests"},
  @{project ="WebJobs.Extensions.CosmosDB.Tests"; description="CosmosDB extension tests"},
  @{project ="WebJobs.Extensions.MobileApps.Tests"; description="Mobile Apps extension tests"},
  @{project ="WebJobs.Extensions.SendGrid.Tests"; description="SendGrid extension tests"},
  @{project ="WebJobs.Extensions.Twilio.Tests"; description="Twilio extension tests"}
)

$success = $true
$testRunSucceeded = $true

foreach ($test in $tests){
    $testRunSucceeded = RunTest $test.project $test.description $testRunSucceeded $test.filter
    $success = $testRunSucceeded -and $success
}

if (-not $success) { exit 1 }