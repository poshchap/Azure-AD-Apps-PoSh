

function Get-AzureADApplicationUserOptions {

##########################################################################################################
<#
.SYNOPSIS

    Retrives user based options for Azure AD Applications or for Service Principals

.DESCRIPTION

    Retrives user based options for Azure AD Applications or for Service Principals. 

    Shows the following user based options:
    
        * User Assignment Required
        * Visible To Users
        * Self Service Access  

.EXAMPLE

    Get-AzureADApplicationUserOptions

    User Get-AzureADApplication to retrieve a list of applications and then shows the following properties:
    UserAssignmentRequired, VisibleToUsers, SelfServiceAppAccess
                              

.EXAMPLE

    Get-AzureADApplicationUserOptions -ServicePrincipal

    User Get-AzureADServicePrincial to retrieve a list of applications and then shows the following 
    properties: UserAssignmentRequired, VisibleToUsers, SelfServiceAppAccess


.NOTES
    THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
    FITNESS FOR A PARTICULAR PURPOSE.

    This sample is not supported under any Microsoft standard support program or service. 
    The script is provided AS IS without warranty of any kind. Microsoft further disclaims all
    implied warranties including, without limitation, any implied warranties of merchantability
    or of fitness for a particular purpose. The entire risk arising out of the use or performance
    of the sample and documentation remains with you. In no event shall Microsoft, its authors,
    or anyone else involved in the creation, production, or delivery of the script be liable for 
    any damages whatsoever (including, without limitation, damages for loss of business profits, 
    business interruption, loss of business information, or other pecuniary loss) arising out of 
    the use of or inability to use the sample or documentation, even if Microsoft has been advised 
    of the possibility of such damages, rising out of the use of or inability to use the sample script, 
    even if Microsoft has been advised of the possibility of such damages. 

#>

##########################################################################################################

#Version: 1.0

##########################################################################################################

    ################################
    #Define and validate Parameters
    ################################

    [CmdletBinding()]
    param(

          #The switch gets all service principals
          [Parameter(Position=0)]
          [switch]$ServicePrincipal

          )


##########################################################################################################

    #############
    #region MAIN
    #############

    if ($ServicePrincipal) {

        Get-AzureADServicePrincipal -All $true | Sort-Object DisplayName | 
        Select-Object DisplayName, @{n='UserAssigmentRequired';e={$_.AppRoleAssignmentRequired}},`
                                   @{n='VisibleToUsers';e={if($_.Tags -contains "HideApp") {$false} else {$true}}},`
                                   @{n='SelfServiceAppAccess';e={if($_.Tags -contains "SelfServiceAppAccess") {$true} else {$false}}}

    } 
    else {

        $Apps = Get-AzureADApplication -All $true | Sort-Object DisplayName
    
        $Apps | ForEach-Object {

            $AppId = $_.AppId
            Get-AzureADServicePrincipal -Filter "AppId eq '$AppId'" | 
            Select-Object DisplayName, @{n='UserAssigmentRequired';e={$_.AppRoleAssignmentRequired}},`
                                @{n='VisibleToUsers';e={if($_.Tags -contains "HideApp") {$false} else {$true}}},`
                                @{n='SelfServiceAppAccess';e={if($_.Tags -contains "SelfServiceAppAccess") {$true} else {$false}}}

        }


    }


}

