### ---------------------------------------------------------------------------------
### ASC Alert simulation for Azure DNS
### ---------------------------------------------------------------------------------

Resolve-DnsName bbcnewsv2vjtpsuy.onion.to
Resolve-DnsName all.mainnet.ethdisco.net
Resolve-DnsName micros0ft.com 
Resolve-DnsName 164e9408d12a701d91d206c6ab192994.info 


For($i=0; $i -le 150; $i++) {
$rand = -join ((97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})
Resolve-DnsName "$rand.com"
}


Resolve-DnsName aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.ru # investigate

$rand = -join ((97..122) | Get-Random -Count 63 | ForEach-Object {[char]$_})
Resolve-DnsName "$rand.contoso.com"


For($i=0; $i -le 1000; $i++) {

$rand = -join ((97..122) | Get-Random -Count 63 | ForEach-Object {[char]$_})
Resolve-DnsName "$rand.contoso.com"
}


Resolve-DnsName reseed.i2p-projekt.de 

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');