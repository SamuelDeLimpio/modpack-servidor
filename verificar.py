import os

# Extensiones a normalizar
extensions = ('.cfg', '.conf', '.csv', '.meta', '.json', '.pw.toml', '.toml', '.txt', '.mcmeta', '.zs', '.sh', '.ps1')

# Rutas actualizadas: busca en la raíz y dentro de 'minecraft'
folders = ['.', 'minecraft/config', 'minecraft/mods', 'minecraft/scripts', 'minecraft/resourcepacks']

for folder in folders:
    if not os.path.exists(folder):
        print(f"Saltando: {folder} (no existe)")
        continue
    
    print(f"Limpiando carpeta: {folder}")
    for root, dirs, files in os.walk(folder):
        # Evitar entrar en carpetas de Git o runtime
        if '.git' in root or 'runtime' in root:
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
                        print(f"  Normalizado: {path}")
                except Exception as e:
                    print(f"  Error en {path}: {e}")

print("\n--- ¡Limpieza completada para la nueva estructura! ---")