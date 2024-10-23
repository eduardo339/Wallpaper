# Ruta de descarga y permisos para entornos gestionados con Acronis Cyber Protect Cloud
$imageUrl = "https://github.com/eduardo339/Wallpaper/blob/main/3.5Roles.jpg?raw=true"
# Definir una ruta segura para la cuenta del sistema
$imagePath = "C:\Temp\3.5Roles.jpg"
$bmpImagePath = "C:\Temp\3.5Roles.bmp"

# Crear el directorio si no existe
if (!(Test-Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory
}

# Asegurar los permisos adecuados para la carpeta C:\Temp
$acl = Get-Acl "C:\Temp"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($rule)
Set-Acl "C:\Temp" $acl

# Manejar los permisos de administrador si es necesario (asegurarse de que el script se ejecute con permisos elevados)
try {
    # Descargar la imagen
    Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath -ErrorAction Stop
    Write-Output "La imagen ha sido descargada exitosamente en: $imagePath"

    # Convertir la imagen a .bmp
    (Get-Item $imagePath).CopyTo($bmpImagePath, $true)
 
    # Función para cambiar el fondo de escritorio usando el registro de Windows
    function Set-Wallpaper {
        param (
            [string]$path
        )
       
        # Cambiar el fondo de pantalla en el registro
        Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name WallPaper -Value $path
       
        # Actualizar el cambio en Windows
        rundll32.exe user32.dll, UpdatePerUserSystemParameters
    }
 
    # Llamar a la función con la ruta de la imagen .bmp
    Set-Wallpaper -path $bmpImagePath
    Write-Output "El fondo de escritorio ha sido cambiado exitosamente."
 
} catch {
    # Manejar cualquier error de descarga
    Write-Output "Error al descargar la imagen: $_"
    exit 1
}
# Opcional: Retornar 0 para confirmar éxito
exit 0

