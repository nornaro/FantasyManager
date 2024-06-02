# PowerShell script to rename grass_4224738882_scatter_cache.res file to Grass1 -> Grass20

# Base file name without the counter
$baseName = "Grass"

# Extension of the file
$fileExtension = "_scatter_cache.res"

# Rename files from Grass1 to Grass20
for ($i = 1; $i -le 20; $i++) {
    $oldFileName = "grass_scatter_cache.res"
    $newFileName = "$baseName$i$fileExtension"
	cp $oldFileName $newFileName
}


grass_4224738882_scatter_cache.res