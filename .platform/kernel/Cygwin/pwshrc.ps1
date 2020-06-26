function Set-Title([string]$title) { $host.ui.RawUI.WindowTitle = $title }
Set-Alias -Name:"title" -Value:"Set-Title" -Description:"" -Option:"None"

