# File is from http://steamcommunity.com/id/guruant/games/?xml=1
#[xml]$BenGames = Get-Content "C:\Users\Ben\Desktop\games.xml"
[xml]$BenGames = (Invoke-WebRequest "http://steamcommunity.com/id/guruant/games/?xml=1").content
$bengames.gamesList.games.game | ForEach-Object {$_.Name}