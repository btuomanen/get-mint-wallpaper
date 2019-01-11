#!/usr/bin/pwsh
# powershell script to download debs from Linux Mint repo

# probably enough to download if there's this many!  crank it up or down as you please.
$maxdebs=20

$repourl = "http://packages.linuxmint.com/pool/main/m/"
$mintrepo = Invoke-WebRequest -Uri $repourl


$linkstocheck = ($mintrepo.Links | select href | where-object {$_ -like "*backgrounds*"} ).ForEach({($repourl + $_.href)})

# iterator that counts number of downloaded deb files.
$i = 0

ForEach ($link in $linkstocheck)
{
    #Write-Host ("Link " + $i + " is: " + $link)
    #$i++
    $dirlist = Invoke-WebRequest -Uri $link

    $debfiles = @($dirlist.Links | select href | Where-Object { $_.href -like "*.deb" } )
    
    foreach($debfile in $debfiles)
    {
        $deblink = ($link + $debfile.href)
        wget -c $deblink -O ("~/backgrounds/" + $debfile.href)
        $i++

    }

    if ($i -ge $maxdebs) { Break }

}
