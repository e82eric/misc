function fill_month_grid
{
	param($dateInMonth)
  $monthNumber = $dateInMonth.Month
	$numberOfDaysInMonth = [DateTime]::DaysInMonth($dateInMonth.Year, $dateInMonth.Month)
	$firstDayOfMonth = [DateTime]::new($dateInMonth.Year, $dateInMonth.Month, 1)
	$firstDayOfWeekNumber = [int]$firstDayOfMonth.DayOfWeek

	$today = [DateTime]::Now

  $weeks = New-Object object[] 6

  $gridIndex = 0
  for($i = 0; $i -lt 6; $i++)
  {
    $week = New-Object object[] 7
    for($j = 0; $j -lt 7; $j++)
    {
      $dayOfMonthNumber = $gridIndex - $firstDayOfWeekNumber + 1
      if($gridIndex -lt $firstDayOfWeekNumber -or $gridIndex -ge $numberOfDaysInMonth + $firstDayOfWeekNumber)
      {
        $dayObj = @{ IsEmpty = $true }
      }
      else
      {
        $isToday = $false
        if($monthNumber -eq $today.Month -And $today.Day -eq $dayOfMonthNumber)
        {
          $isToday = $true
        }
        $dayObj = @{ IsEmpty = $false; Number = $dayOfMonthNumber; IsToday = $isToday }
      }
      $week[$j] = $dayObj
      $gridIndex++
    }
    $weeks[$i] = $week
  }

  @{ Weeks = $weeks; DateInMonth = $dateInMonth }
}

function print_week
{
  param($weekArray)

  for($i = 0; $i -lt 7; $i++)
  {
    if($weekArray[$i].IsToday)
    {
      $foregroundColor = [ConsoleColor]::Black
      $backgroundColor = [ConsoleColor]::White
    }
    else
    {
      $foregroundColor = [ConsoleColor]::Red
      $backgroundColor = [ConsoleColor]::Black
    }

    if($weekArray[$i].IsEmpty)
    {
      Write-Host -NoNewLine -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor "   "
    }
    else
    {
      $iStr = " $($weekArray[$i].Number.ToString())"
      Write-Host -NoNewLine -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor "$($iStr.SubString($iStr.Length - 2))"
      Write-Host -NoNewLine " "
    }
  }
}

function print_months_horizontal
{
  param($months)
  foreach($month in $months)
  {
    $monthYearHeader = "$((Get-Culture).DateTimeFormat.GetMonthName($month.DateInMonth.Month)) $($month.DateInMonth.Year)"
    Write-Host -NoNewLine $monthYearHeader.PadRight(20)
    Write-Host -NoNewLine "     "
  }
  Write-Host ""
  foreach($month in $months)
  {
    Write-Host -NoNewLine "Su Mo Tu We Th Fr Sa"
    Write-Host -NoNewLine "     "
  }
  Write-Host ""

  for($i = 0; $i -lt 6; $i++)
  {
    foreach($month in $months)
    {
      print_week $month.Weeks[$i]
      Write-Host -NoNewLine "    "
    }
    Write-Host ""
  }
}

function cal
{
  param(
    $monthsBack = 6,
    $monthsForward = 6,
    [switch]$year = $false
  )
	$today = [DateTime]::Now

  $startMonth = $monthsBack * -1
  if($year)
  {
    $startMonth = ($today.Month + 1) * -1
    $monthsForward = 12 - $today.Month
  }

  $ctr = 0
  $i = $startMonth
  while($i -lt $monthsForward + 1)
  {
    $chunk = [Math]::Min(3, ($monthsForward - $i + 1))
    $months = New-Object object[] $chunk
    for($j = 0; $j -lt $chunk; $j++)
    {
      $months[$j] = fill_month_grid $today.AddMonths($i)
      $i++
    }
    print_months_horizontal $months
  }
}
