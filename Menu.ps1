# https://www.reddit.com/r/PowerShell/comments/4ad8or/create_user_menus_from_objectsarrays/
# https://www.reddit.com/r/PowerShell/comments/49tqgx/need_some_help_with_an_automation_script_im/
# http://www.powertheshell.com/input_psv3/

function Menu {
    Param (
        [Parameter(
            ValueFromPipeline=$True,
            ValueFromPipelinebyPropertyName=$True)]
        [object[]]$Object,
        $Prompt,
        [switch]$AllowCancel,
        [switch]$AllowMultiple
    )

    if ($input) {
        $Object = @($input)
    }

    if (!$Object) { Throw 'Must provide an object.' }
    Write-Host ''

    do {
        if ($Prompt) {
            Write-Host $Prompt
        } elseif ($AllowCancel) {
            Write-Host 'Choose an option, or enter "C" to cancel'
        } else {
            Write-Host 'Choose an option'
        }

        for ($i = 0; $i -lt $Object.Count; $i++) {
            Write-Host "$($i+1). $($Object[$i])"
        }

        Write-Host ''

        if ($AllowMultiple) {
            $answers = @(Read-Host).Split(',').Trim()

            if ($AllowCancel -and $answers -match 'c') {
                return
            }

            $ok = $true
            foreach ($ans in $answers) {
                if ($ans -in 1..$Object.Count) {
                    $Object[$ans-1]
                } else {
                    Write-Host 'Not an option!' -ForegroundColor Red
                    Write-Host ''
                    $ok = $false
                }
            }
        } else {
            $answer = Read-Host

            if ($AllowCancel -and $answer.ToLower() -eq 'c') {
                return
            }

            $ok = $true
            if ($answer -in 1..$Object.Count) {
                $Object[$answer-1]
            } else {
                Write-Host 'Not an option!' -ForegroundColor Red
                Write-Host ''
                $ok = $false
            }
        }
    } while (!$ok)
}