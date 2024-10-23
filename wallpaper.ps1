# Ruta de descarga y permisos para entornos gestionados con Acronis Cyber Protect Cloud
$imageUrl = "https://github.com/eduardo339/Wallpaper/blob/main/3.5Roles.jpg?raw=true"
# Definir una ruta segura para la cuenta del sistema
$imagePath = "C:\Temp\3.5Roles.jpg"
# Crear el directorio si no existe
if (!(Test-Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory
}
# Manejar los permisos de administrador si es necesario (asegurarse de que el script se ejecute con permisos elevados)
try {
    # Descargar la imagen
    Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath -ErrorAction Stop
    Write-Output "La imagen ha sido descargada exitosamente en: $imagePath"
 
    # Función para cambiar el fondo de escritorio
    function Set-Wallpaper {
        param (
            [string]$path
        )
 
        # Importar la función para cambiar el fondo
        $signature = @"
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
"@
 
        $type = Add-Type -MemberDefinition $signature -Name Win32SetWallpaper -Namespace Win32Functions -PassThru
 
        # Cambiar el fondo de escritorio
        $type::SystemParametersInfo(20, 0, $path, 3)
    }
 
    # Llamar a la función con la ruta de la imagen
    Set-Wallpaper -path $imagePath
    Write-Output "El fondo de escritorio ha sido cambiado exitosamente."
 
} catch {
    # Manejar cualquier error de descarga
    Write-Output "Error al descargar la imagen: $_"
    exit 1
}
# Opcional: Retornar 0 para confirmar éxito
exit 0