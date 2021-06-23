function Get-InclusionList {
	param([String]$CheckString='')
	
	$wordMedial = "v","m","n","s","z","p","t","d","c","k","q","g","r","ts","dz","th","sh","tch"
	$v_Inclusion = "m","n","p","t","d","r"
	$ptd_Inclusion = "v","m","n","s","z","r"
	$nasal_Inclusion = "v","p","t","d","c","k","q","r","ts","dz","th","sh","tsh"
	$sz_Inclusion = "v","p","t","d","m","n","c","k","q","g","r"
	$ckq_Inclusion = "v","m","n","s","z","r","ts","dz","th","sh","tch"
	$g_Inclusion = "v","m","n","r","ts","dz","th","sh","tsh"
	$r_Inclusion = "v","p","t","d","m","n","ts","dz","th","sh","tch"
	$affricate_Inclusion = "v","p","m","n","c","k","q","g","r"
	$nucleus = "a","e","i","o","v","m","n","s","z","ts","dz","th","sh","tch"
	
	if($CheckString -match "v$"){
		return $v_Inclusion
	}
	# This check will also match 'ss', which should not be a problem, unless the phonotactics for this language change.
	elseif($CheckString -match "[ts][sh]$|dz$|tch$"){
		return $affricate_Inclusion
	}
	elseif($CheckString -match "[ptd]$"){
		return $ptd_Inclusion
	}
	elseif($CheckString -match "[mn]"){
		return $nasal_Inclusion
	}
	elseif($CheckString -match "[sz]$"){
		return $sz_Inclusion
	}
	elseif($CheckString -match "[ckq]$"){
		return $ckq_Inclusion
	}
	elseif($CheckString -match "[g]$"){
		return $g_Inclusion
	}
	elseif($CheckString -match "[r]$"){
		return $r_Inclusion
	}
	else{
		return $wordMedial
	}
}

function Get-Syllable {
	# Determine if there is an onset and build it
	param([Switch]$Initial,[Switch]$Final)

	$wordInitial = "ch","v","m","n","s","z","ch","p","t","d","c","k","q","g","ch","r","ts","dz","th","sh","tch","ch"
	$wordFinal = "ch","l","x","ch","l","x","ch","l","x","ch","l","x"

	$Syllable=''
	$CCount=0
	# Force the first syllable in a word to have an onset
	if($Initial -eq $true) {
		# Because an onset is being forced in the word initial position, reduce the number of onset consonants by 1
		$CCount = (Get-Random -Minimum 1 -Maximum 4) - 1
		$Syllable+=(Get-Random -InputObject $wordInitial)
	}
	else {
		$CCount = Get-Random -Minimum 0 -Maximum 4
	}
	for($i=0; $i -lt $CCount; $i++) {
		$Syllable+=(Get-Random -InputObject (Get-InclusionList -CheckString $Syllable))
	}
	
	# Build the rhyme
	$CCount=(Get-Random -Minimum 1 -Maximum 4)
	# Write-Host -Background Black -Foreground Green "`t[!] $RCCount Consonants..."
	$Syllable+=$nucleus | ?{$_ -match "[aeio]" -or $_ -in (Get-InclusionList -CheckString $Syllable)} | Get-Random
	# Write-Host -Background Black -Foreground Green "`t[!] $Rhyme"
	# To keep the rhyme consonant cluster to 3 or fewer, reduce the rhyme consonant count by 1 if the nucleus is a consonant
	if($Syllable -notmatch "[aeio]") {
		$RCCount-=1
		# Write-Host -Background Black -Foreground Green "`t[!] $RCCount Consonants..."
	}
	if($CCount -le 0) {
		return $Syllable
	}
	else {
		if($Final -eq $true) {
			# In order to account for the word final possibilities, reduce the consonant count by 1, again, and force the final consonant
			$CCount-=1
			for($i=0; $i -lt $CCount; $i++) {
				$Syllable+=(Get-Random -InputObject (Get-InclusionList -CheckString $Syllable))
				# Write-Host -Background Black -Foreground Green "`t[!] $Rhyme"
			}
			$Syllable+=((Get-InclusionList -CheckString $Syllable),$wordFinal) | Get-Random
			# Write-Host -Background Black -Foreground Green "`t[!] $Rhyme"
		}
		else {
			for($i=0; $i -lt $CCount; $i++) {
				$Syllable+=(Get-Random -InputObject (Get-InclusionList -CheckString $Syllable))
				# Write-Host -Background Black -Foreground Green "`t[!] $Rhyme"
			}
		}
		return $Syllable

	}
}

function Get-Word {
	param([int]$SyllableNumber=0,[Switch]$MarkSyllableBoundaries)
	# Generate a random number of syllables, between 1 and 5 inclusive, that will compose the word
	if($SyllableNumber -eq 0) {
		$SyllableCount = Get-Random -Minimum 1 -Maximum 6
	}
	else {
		$SyllableCount = $SyllableNumber
	}
	$outWord=''
	if($SyllableCount -eq 1) {
		$outWord=Get-Syllable -Initial -Final
	}
	else {
		$outWord=Get-Syllable -Initial
		if($MarkSyllableBoundaries -eq $true){
			for($i=0; $i -lt ($SyllableCount - 2); $i++) {
				$outWord+="."+(Get-Syllable)
			}
			$outWord+="."+(Get-Syllable -Final)
		}
		else {
			for($i=0; $i -lt ($SyllableCount - 2); $i++) {
				$outWord+=(Get-Syllable)
			}
			$outWord+=(Get-Syllable -Final)
		}
	}
	return $outWord
}

# All of this, just for a GUI
function Generate-Words {
Add-Type -AssemblyName System.Windows.Forms
$main_form                 = New-Object System.Windows.Forms.Form
$main_form.Text            = "Word Generator"
$main_form.Width           = 600
$main_form.Height          = 500
$main_form.FormBorderStyle = 'Fixed3D'

# You gotta have a sweet shingle
$title          = New-Object System.Windows.Forms.Label
$title.Text     = 'Word Generator'
$title.AutoSize = $true
$title.Height   = 10
$title.Width    = 25
$title.Location = New-Object System.Drawing.Point(20,20)
$title.Font     = 'Times New Roman,13'

# Select how many syllables you want... if you care at all
$SyllableComboBox              = New-Object System.Windows.Forms.ComboBox
[void]$SyllableComboBox.Items.Add("Any")
1..5 | %{[void]$SyllableComboBox.Items.Add($_)}
$SyllableComboBox.AutoSize     = $true
$SyllableComboBox.SelectedItem = "Any"
$SyllableComboBox.Location     = New-Object System.Drawing.Point(20,50)

# Tell the user what the selection is for
$SyllableLabel          = New-Object System.Windows.Forms.Label
$SyllableLabel.Text     = 'Number of Syllables'
$SyllableLabel.Font     = 'Times New Roman,10'
$SyllableLabel.AutoSize = $true
$SyllableLabel.Height   = 10
$SyllableLabel.Width    = 20
$SyllableLabel.Location = New-Object System.Drawing.Point(140,50) 

# Generate as many words as you want... within reason
$IterationsTextBox           = New-Object System.Windows.Forms.TextBox
$IterationsTextBox.Height    = 10
$IterationsTextBox.Width     = 40
$IterationsTextBox.Font      = 'Times New Roman,10'
$IterationsTextBox.Text      = '10'
$IterationsTextBox.Location  = New-Object System.Drawing.Point(260,50)

# Tell the user they can do that
$IterationsLabel          = New-Object System.Windows.Forms.Label
$IterationsLabel.Text     = 'Number of Iterations'
$IterationsLabel.Font     = 'Times New Roman, 10'
$IterationsLabel.AutoSize = $true
$IterationsLabel.Location = New-Object System.Drawing.Point(300,50)

# Put a '.' between each syllable, if that suits your fancy
$SeparatorCheckBox          = New-Object System.Windows.Forms.CheckBox
$SeparatorCheckBox.Text     = 'Separate Syllables'
$SeparatorCheckBox.Font     = 'Times New Roman,10'
$SeparatorCheckBox.AutoSize = $true
$SeparatorCheckBox.Location = New-Object System.Drawing.Point(430,50)

# Tell the user they can do that, too
# I chose to use a listbox instead of a textbox, because of ease of population, and single click whole item selection
$ResultsListBox            = New-Object System.Windows.Forms.ListBox
$ResultsListBox.Location   = New-Object System.Drawing.Point(10,120)
$ResultsListBox.Size       = '560,400'
$ResultsListBox.AutoSize   = $false
# This is an artifact for those who don't like listboxes. If you're feeling froggy, you can change it to a textbox.
#$ResultsListBox.Multiline  = $true
#$ResultsListBox.ScrollBars = 'Vertical'
$ResultsListBox.ScrollAlwaysVisible
$ResultsListBox.SelectionMode = 'MultiExtended'

# Make sure the button can do the things
$GenerateScriptBlock = {
if([string]$SyllableComboBox.SelectedItem -match "Any") {
    $SyllableNumber=0
}
else {
    $SyllableNumber=$SyllableComboBox.SelectedIndex
}
if($IterationsTextBox.Text -match "\d+" -and [int]$IterationsTextBox.Text -gt 0) {
# This is an artifact for those who don't like listboxes. If you're feeling froggy, you can change it to a textbox.
#$ResultsListBox.Text=''
#1..[int]$IterationsTextBox.Text | %{$ResultsListBox.Text+=(Get-Word -SyllableNumber $SyllableNumber -MarkSyllableBoundaries:$SeparatorCheckBox.Checked)+"`r`n"}
$ResultsListBox.Items.Clear()
1..[int]$IterationsTextBox.Text | %{$ResultsListBox.Items.Add((Get-Word -SyllableNumber $SyllableNumber -MarkSyllableBoundaries:$SeparatorCheckBox.Checked))}
}
else {
$ResultsListBox.Items.Clear()
$ResultsListBox.Items.Add("The iterations value must be a positive integer")
}
}

# Make the button that makes the things
$GenerateButton          = New-Object System.Windows.Forms.Button
$GenerateButton.Text     = 'Generate'
$GenerateButton.AutoSize = $true
$GenerateButton.Location = New-Object System.Drawing.Point(20,80)
$GenerateButton.Add_Click($GenerateScriptBlock)
$GenerateButton.TabIndex = 0

# Listboxes are annoying to build a context menu for. Build a button instead. Fewer headaches.
$CopyButton          = New-Object System.Windows.Forms.Button
$CopyButton.Text     = 'Copy'
$CopyButton.AutoSize = $true
$CopyButton.Location = New-Object System.Drawing.Point(100,80)
$CopyButton.Add_Click({Set-Clipboard -Value $ResultsListBox.SelectedItems}) 

# Clean close for the application
$ExitButton          = New-Object System.Windows.Forms.Button
$ExitButton.Text     = 'Exit'
$ExitButton.AutoSize = $true
$ExitButton.Location = New-Object System.Drawing.Point(180,80)
$ExitButton.Add_Click({$main_form.Add_FormClosing({$_.Cancel=$false});$main_form.Close()})

# Populate the frame
[void]$main_form.Controls.AddRange(@($title,$SyllableComboBox,$SyllableLabel,$IterationsTextBox,$IterationsLabel,$SeparatorCheckBox,$GenerateButton,$CopyButton,$ExitButton,$ResultsListBox))

# Show the frame
$main_form.ShowDialog()
}