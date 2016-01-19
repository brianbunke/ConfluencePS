﻿function Remove-ConfSpace {
    <#
    .SYNOPSIS
    Remove an existing Confluence space.

    .DESCRIPTION
    Delete an existing Confluence space, including child content.
    "The space is deleted in a long running task, so the space cannot be considered deleted when this resource returns."

    .PARAMETER Key
    The key (short code) of the space to delete. Accepts multiple keys via pipeline input.

    .EXAMPLE
    Remove-ConfSpace -Key XYZ -Confirm
    Delete a space with key XYZ (note that key != name). Confirm will prompt before deletion.

    .EXAMPLE
    Get-ConfSpace -Name ald | Remove-ConfSpace -Verbose -WhatIf
    Get spaces matching '*ald*' (like Reginald and Alderaan), piping them to be deleted.
    Would remove each space one by one with verbose output; -WhatIf flag active.

    .LINK
    https://github.com/brianbunke/ConfluencePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
    param (
		[Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
		[Alias('SpaceKey')]
        [string]$Key

        # Probably an extra param later to loop checking the status & wait for completion?
    )

    BEGIN {
        If (!($Header) -or !($BaseURI)) {
            Write-Debug 'URI or authentication not found. Calling Set-ConfInfo'
            Set-ConfInfo
        }
    }

    PROCESS {
        $URI = $BaseURI + "/space/$Key"

        Write-Verbose "Sending delete request to $URI"
        If ($PSCmdlet.ShouldProcess("Space key $Key")) {
            $Rest = Invoke-RestMethod -Headers $Header -Uri $URI -Method Delete

            # Successful response provides a "longtask" status link
                # (add additional code here later to check and/or wait for the status)
        }
    }
}
