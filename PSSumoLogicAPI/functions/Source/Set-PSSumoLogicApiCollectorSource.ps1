#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Set-PSSumoLogicApiCollectorSource
{

    [CmdletBinding()]
    param
    (
        # Input CollectorId
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $Id,

        [parameter(
            position = 1,
            mandatory = 0)]
        [string]
        $pathExpression,

        [parameter(
            position = 2,
            mandatory = 1)]
        [string]
        $name,

        [parameter(
            position = 3,
            mandatory = 1)]
        [SumoLogicSourceType]
        $sourceType,

        [parameter(
            position = 4,
            mandatory = 0)]
        [string]
        $category,

        [parameter(
            position = 5,
            mandatory = 0)]
        [string]
        $description,

        [parameter(
            position = 6,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [bool]
        $alive = $PSSumoLogicApi.sourceParameter.alive,

        [parameter(
            position = 7,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $states = $PSSumoLogicApi.sourceParameter.states,

        [parameter(
            position = 8,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [bool]
        $automaticDateParsing = $PSSumoLogicApi.sourceParameter.automaticDateParsing,

        [parameter(
            position = 9,
            mandatory = 0)]
        [validateScript({Check-PSSumoLogicTimeZone -TimeZone $_ })]
        [validateSet(
            "Etc/GMT-12",
            "Etc/GMT-11",
            "Pacific/Midway",
            "America/Adak",
            "America/Anchorage",
            "Pacific/Gambier",
            "America/Dawson_Creek",
            "America/Ensenada",
            "America/Los_Angeles",
            "America/Chihuahua",
            "America/Denver",
            "America/Belize",
            "America/Cancun",
            "America/Chicago",
            "Chile/EasterIsland",
            "America/Bogota",
            "America/Havana",
            "America/New_York",
            "America/Caracas",
            "America/Campo_Grande",
            "America/Glace_Bay",
            "America/Goose_Bay",
            "America/Santiago",
            "America/La_Paz",
            "America/Argentina/Buenos_Aires",
            "America/Montevideo",
            "America/Araguaina",
            "America/Godthab",
            "America/Miquelon",
            "America/Sao_Paulo",
            "America/St_Johns",
            "America/Noronha",
            "Atlantic/Cape_Verde",
            "Europe/Belfast",
            "Africa/Abidjan",
            "Europe/Dublin",
            "Europe/Lisbon",
            "Europe/London",
            "UTC",
            "Africa/Algiers",
            "Africa/Windhoek",
            "Atlantic/Azores",
            "Atlantic/Stanley",
            "Europe/Amsterdam",
            "Europe/Belgrade",
            "Europe/Brussels",
            "Africa/Cairo",
            "Africa/Blantyre",
            "Asia/Beirut",
            "Asia/Damascus",
            "Asia/Gaza",
            "Asia/Jerusalem",
            "Africa/Addis_Ababa",
            "Asia/Riyadh89",
            "Europe/Minsk",
            "Asia/Tehran",
            "Asia/Dubai",
            "Asia/Yerevan",
            "Europe/Moscow",
            "Asia/Kabul",
            "Asia/Tashkent",
            "Asia/Kolkata",
            "Asia/Katmandu",
            "Asia/Dhaka",
            "Asia/Yekaterinburg",
            "Asia/Rangoon",
            "Asia/Bangkok",
            "Asia/Novosibirsk",
            "Etc/GMT+8",
            "Asia/Hong_Kong",
            "Asia/Krasnoyarsk",
            "Australia/Perth",
            "Australia/Eucla",
            "Asia/Irkutsk",
            "Asia/Seoul",
            "Asia/Tokyo",
            "Australia/Adelaide",
            "Australia/Darwin",
            "Pacific/Marquesas",
            "Etc/GMT+10",
            "Australia/Brisbane",
            "Australia/Hobart",
            "Asia/Yakutsk",
            "Australia/Lord_Howe",
            "Asia/Vladivostok",
            "Pacific/Norfolk",
            "Etc/GMT+12",
            "Asia/Anadyr",
            "Asia/Magadan",
            "Pacific/Auckland",
            "Pacific/Chatham",
            "Pacific/Tongatapu",
            "Pacific/Kiritimati")]
        [string]
        $timeZone = $PSSumoLogicApi.sourceParameter.timeZone,

        [parameter(
            position = 10,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [bool]
        $multilineProcessingEnabled = $PSSumoLogicApi.sourceParameter.multilineProcessingEnabled,

        [parameter(
            position = 11,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $filters,

        [parameter(
            position = 12,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession = $PSSumoLogicAPI.WebSession,

        [parameter(
            position = 13,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $timeoutSec = $PSSumoLogicAPI.TimeoutSec,

        [parameter(
            position = 14,
            mandatory = 0)]
        [switch]
        $Async      
    )

    begin
    {
        $ErrorActionPreference = $PSSumoLogicApi.errorPreference
    }

    process
    {
        try
        {	
            $sourceexpression = @{}
            if($pathExpression){$sourceexpression.add("pathExpression", $pathExpression)}
            if($name){$sourceexpression.add("name",$name)}
            if($sourceType){$sourceexpression.add("sourceType","$sourceType")}
            if($category){$sourceexpression.add("category",$category)}
            if($description){$sourceexpression.add("description",$description)}
            if($alive){$sourceexpression.add("alive",$alive)}
            if($automaticDateParsing){$sourceexpression.add("automaticDateParsing",$automaticDateParsing)}
            if($timeZone){$sourceexpression.add("timeZone",$timeZone)}
            if($multilineProcessingEnabled){$sourceexpression.add("multilineProcessingEnabled",$multilineProcessingEnabled)}
            if($filters){$sourceexpression.add("filters",$filtersobject)}
            if($sourceType -eq "LocalWindowsEventLog"){$sourceexpression.add("logNames",@("Security","Application","System","Others"))}
            $sourceexpression.add("states",$states)

            $jsonBody = @{ 
                source = $sourceexpression
            } | ConvertTo-Json

            if ($PSBoundParameters.ContainsKey("Async"))
            {
                Write-Verbose "Running Async execution"
                $command = {
                    param
                    (
                        [int]$Collector,
                        [hashtable]$PSSumoLogicApi,
                        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,
                        [int]$timeoutSec,
                        [string]$JsonBody,
                        [string]$verbose,
                        [string]$name
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
                    $checkParam = @{
                        Uri         = $uri.AbsoluteUri
                        Method      = "Get"
                        ContentType = $PSSumoLogicApi.contentType
                        WebSession  = $WebSession
                        TimeoutSec  = $timeoutSec
                    }
                    $checks = (Invoke-RestMethod @checkParam).sources

                    if ($name -in $checks.Name)
                    {
                        Write-Warning ("source name '{0}' already exist in '{1}'. Skip to next." -f $name, "$($checks.Name -join ", ")")
                    }
                    else
                    {
                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Post"
                            ContentType = $PSSumoLogicApi.contentType 
                            Body        = $JsonBody 
                            WebSession  = $WebSession 
                            TimeoutSec  = $timeoutSec
                        }
                        Write-Verbose ("source name '{0}' not found from check result '{1}'." -f $name, "$($checks.Name -join ', ')")
                        Invoke-RestMethod @param
                    }
                }

                $asyncParam = @{
                    Command     = $command
                    CollectorId = $Id
                    WebSession  = $WebSession
                    TimeoutSec  = $timeoutSec
                    JsonBody    = $jsonBody
                    Name        = $name
                }
                Invoke-PSSumoLogicApiInvokeCollectorAsync @asyncParam
            }
            else
            {
                foreach ($Collector in $Id)
                {
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
                    $checkParam = @{
                        Uri         = $uri.AbsoluteUri
                        Method      = "Get"
                        ContentType = $PSSumoLogicApi.contentType
                        WebSession  = $WebSession
                        TimeoutSec  = $timeoutSec
                    }
                    $checks = (Invoke-RestMethod @checkParam).sources

                    if ($name -in $checks.Name)
                    {
                        Write-Warning ("source name '{0}' already exist in '{1}'. Skip to next." -f $name, "$($checks.Name -join ", ")")
                    }
                    else
                    {
                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Post"
                            ContentType = $PSSumoLogicApi.contentType 
                            Body        = $JsonBody 
                            WebSession  = $WebSession
                            TimeoutSec  = $timeoutSec
                        }
                        Write-Verbose ("source name '{0}' not found from check result '{1}'." -f $name, "$($checks.Name)")
                        (Invoke-RestMethod @param).source 
                    }
                }
            }
        }
        catch
        {
            throw $_
        }
    }
}
