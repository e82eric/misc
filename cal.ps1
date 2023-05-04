function print_month
{
	param($dateInMonth)
	$numberOfDaysInMonth = [DateTime]::DaysInMonth($dateInMonth.Year, $dateInMonth.Month)
	$firstDayOfMonth = [DateTime]::new($dateInMonth.Year, $dateInMonth.Month, 1)
	$firstDayOfWeekNumber = [int]$firstDayOfMonth.DayOfWeek

	$today = [DateTime]::Now

	Write-Host ""
	Write-Host "$((Get-Culture).DateTimeFormat.GetMonthName($dateInMonth.Month)) $($dateInMonth.Year)"
	Write-Host "Su Mo Tu We Th Fr Sa"
	$ctr = 1
	$weekString = ""
	for($i = 0; $i -lt 7; $i++)
	{
		$foregroundColor = [ConsoleColor]::Red
		$backgroundColor = [ConsoleColor]::Black

		if($dateInMonth.Month -eq $today.Month -And $today.Day -eq $ctr)
		{
			$foregroundColor = [ConsoleColor]::Black
			$backgroundColor = [ConsoleColor]::White
		}

		if($i -lt $firstDayOfWeekNumber)
		{
			Write-Host -NoNewLine -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor "   "
		}
		else
		{
			$ctrStr = " $($ctr.ToString())"
			Write-Host -NoNewLine -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor "$($ctrStr.SubString($ctrStr.Length - 2)) "
			$ctr++
		}
	}

	$weekString
	$dayOfWeekCtr = 1
	$weekString = ""
	for($i = $ctr; $i -le $numberOfDaysInMonth; $i++)
	{
		$foregroundColor = [ConsoleColor]::Red
		$backgroundColor = [ConsoleColor]::Black

		if($dateInMonth.Month -eq $today.Month -And $today.Day -eq $i)
		{
			$foregroundColor = [ConsoleColor]::Black
			$backgroundColor = [ConsoleColor]::White
		}

		$iStr = " $($i.ToString())"
		if($dayOfWeekCtr -lt 7)
		{
			Write-Host -NoNewLine -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor "$($iStr.SubString($iStr.Length - 2)) "
			$dayOfWeekCtr++
		}
		else
		{
			Write-Host -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor "$($iStr.SubString($iStr.Length - 2)) "
			$weekString = ""
			$dayOfWeekCtr = 1
		}
	}
}

function cal
{
	$today = [DateTime]::Now

	print_month $today.AddMonths(-1)
	Write-Host ""
	print_month $today
	Write-Host ""
	print_month $today.AddMonths(1)
}
