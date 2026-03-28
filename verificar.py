import os

# Extensiones a normalizar
extensions = ('.cfg', '.conf', '.csv', '.meta', '.json', '.json5', '.properties', '.pw.toml', '.toml', '.txt', '.mcmeta', '.zs')

# Rutas actualizadas: Ahora buscan DENTRO de la carpeta 'minecraft'
folders = [
    'minecraft/config', 
    'minecraft/mods', 
    'minecraft/resourcepacks', 
    'minecraft/scripts', 
    'minecraft/defaultoptions'
]

print("--- Iniciando Limpieza de Archivos (LF) ---")

for folder in folders:
    if not os.path.exists(folder):
        print(f"Saltando (no existe): {folder}")
        continue
        
    for root, dirs, files in os.walk(folder):
        # Ignorar carpetas de Git
        if '.git' in root:
            continue
            
        for file in files:
            if file.endswith(extensions):
                path = os.path.join(root, file)
                try:
                    with open(path, 'rb') as f:
                        content = f.read()
                    
                    # Convertir CRLF (\r\n) a LF (\n)
                    new_content = content.replace(b'\r\n', b'\n')
                    
                    if new_content != content:
                        with open(path, 'wb') as f:
                            f.write(new_content)
                        print(f"Normalizado: {path}")
                except Exception as e:
                    print(f"Error en {path}: {e}")

print("\n--- ¡Limpieza completada en la nueva estructura! ---")