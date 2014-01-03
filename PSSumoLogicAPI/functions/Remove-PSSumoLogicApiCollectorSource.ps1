#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Remove-PSSumoLogicApiCollectorSource
{
    [CmdletBinding()]
    param
    (
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $CollectorIds,

        [parameter(
            position = 1,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $SourceIds = $null,

        [parameter(
            position = 2,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-SumoLogicApiCredential),

        [parameter(
            position = 3,
            mandatory = 0)]
        [switch]
        $Async
    )

    try
    {
        if ($PSBoundParameters.Async.IsPresent)
        {
            Write-Verbose "Running Async execution"
            $command = {
                param
                (
                    [int]$CollectorId,
                    [int]$SourceId,
                    [hashtable]$PSSumoLogicApi,
                    [System.Management.Automation.PSCredential]$Credential,
                    [string]$verbose
                )

                $VerbosePreference = $verbose
                [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $CollectorId, $SourceId))).uri
                Write-Verbose -Message ("Sending Get source Request to {0}" -f $uri)
                Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Delete -Headers $PSSumoLogicApi.contentType -Credential $Credential
            }

            Invoke-PSSumoLogicApiInvokeCollectorSourceAsync -Command $command -CollectorIds $CollectorIds -SourceIds $SourceIds -credential $Credential
        }
        else # not Async Invokation
        {
            foreach ($CollectorId in $CollectorIds)
            {
                foreach ($SourceId in $SourceIds)
                {
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $CollectorId, $SourceId))).uri
                    Write-Verbose -Message ("Posting Delete Source for specific Collector, souce Request to {0}" -f $uri)
                    (Invoke-RestMethod -Uri $uri -Method Delete -Headers $PSSumoLogicApi.contentType -Credential $Credential).source
                }
            }
        }
    }
    catch
    {
        throw $_
    }
}
