# This works for now, but it's pretty inefficient, and horrible to follow

$arrUsers = @(
	"guruant",
	"thegruffalo" # Is this even the right username?
)

$allGames = @()
$allUsers = @()
$objGames = @()
$arrMatches = @()

forEach ($strUser in $arrUsers){
	$objUser = New-Object PSObject
	$objUser | Add-Member -Name "Name" -MemberType NoteProperty -Value $strUser 
	$usersGames = @()
	([xml](Invoke-WebRequest ("http://steamcommunity.com/id/" + $strUser + "/games/?xml=1")).content).gamesList.games.game.name."#cdata-section" | ForEach-Object {
		$usersGames += $_
	}
	$usersGames | Sort-Object
	$objUser | Add-Member -Name "Games" -MemberType NoteProperty -Value $usersGames
	$allGames += $usersGames
	$allUsers += $objUser
}

$allGames = $allGames | Get-Unique -AsString 

forEach ($game in $allGames){
	$objGame = New-Object PSObject
	$objGame | Add-Member -Name "Name" -MemberType NoteProperty -Value $game
	forEach ($objUser in $allUsers){
		$objGame | Add-Member -Name $objUser.Name -MemberType NoteProperty -Value ($objUser.Games -Contains $game)
	}
	$objGames += $objGame
}

ForEach ($objGame in $objGames){
	$match = $true
	$arrUsers | ForEach-Object {
		if ($objGame.$_ -eq $false){
			$match = $false
		}
	}
	if ($match -eq $true){
		$arrMatches += $objGame
	}
}

$arrMatches