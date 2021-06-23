This is a word generator as commissioned by u/saluraropicrusa
  It is written in PowerShell v5.1
  
  NOTE: It is HIGHLY recommended to vet the source of any script or application you plan on using on your own
  devices. DO NOT install software or add code to your profile from unknown sources, even if that source seems
  super friendly and may even possibly resemble a teddy bear. If you can't read code, find someone who can, and
  vet the source.
  
-= Installation =-
There are two methods to make use of this application (loose use of the term).

I. Copy the code into your PowerShell profile. (If you already have your PowerShell profile populated, skip to 1.f.
	1. Open PowerShell by doing one of the following:
		a. Press the Windows Control button on your keyboard or click on the search bar in your system tray
		at the bottom of your screen.
		b. Begin typing 'PowerShell'. The PowerShell application should show up before you've finished typing.
		c. Double-click the PowerShell icon.
		d. Type the following into the command line:
		
			notepad.exe $PROFILE
		
		e. An empty notepad should now be open. Click 'File' and select 'Save', or press Ctrl + S.
		f. Copy all of the code in the WordGenerator.ps1 file, and paste it into your profile document.
		g. Repeat step 1.e
		h. Close the notepad document.
		i. Close and reopen PowerShell.
		j. Type the following into the command line:
		
			Generate-Words
		
		k. Proceed to "Intent and Use" in this document.
	
	2. Save the WordGenerator.ps1 file somewhere you can remember the location of, and run a command in powershell.
		NOTE: This is safer, because it doesn't load any variables, functions, or other code to your PowerShell console
		every time you open PowerShell.
		
		a. Save WordGenerator.ps1 Somewhere you can remember, like:
		
			C:\Users\yourUserName\Documents\
		
		NOTE: You will be using a command to run the application that you may not be comfortable with. Instead of having
		to remember the command, save it in your profile with an easy to remember name. It will still be safe, because none
		of the code in the application will be included, and will only be invoked if you run the command you've created with
		the easy to remember name.
		
		b. Follow steps 1.a through 1.e.
		c. Copy the following code into the notepad document:
		
			# It is important that you replace the '<' and '>' and everything between them with the full path where you saved the .ps1 file.
			function Run-WordGenerator {
				powershell.exe -command "& { . <Path_You_Saved_the_ps1_Document_to>\WordGenerator.ps1; Generate-Words }"
			}
		
		d. Follow steps 1.g through 1.icon
		e. Type the following into theh command line:
		
			Run-WordGenerator
		
		f. Proceed to "Intent and Use" in this document.
			
		

-= Intent and Use =-
This generator creates a list of some user defined number of random words for a constructed language.


In order to begin generating words for the, as of yet unnamed, construced language, begin by selecting
  how many syllables you would like from the dropdown menu.
  You are limited to a numbere of syllables 1 - 5 inclusive.

The generator will create ten words by default, but will create as few (minimum 1) as you like, or as many
  as your CPU can handle.
  NOTE: 1000 was enough to processor lag the development machine.

There is a radio button available that will insert a '.' between each syllable of each word.

When all options are selected to your liking, click the 'Generate' button.

The field that the words populate in is a listbox. You will not be able to type into the listbox, nor will
  you be able to right click. You can select, Ctrl + select, and Shift + select items.
  The entire word will be selected with a single click, rather than placing a cursor or having to double-click.

Once the items you want are selected, click the 'Copy' button, to copy them to your clipboard.
  Your favored items will now be ready to paste into whatever other media you like.

Upon completion, you can click the 'x' in the top-right corner, like a savage, or click the 'Exit' button, to
  gracefully exit the GUI.