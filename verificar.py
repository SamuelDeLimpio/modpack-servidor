import os

# Extensiones de texto incluyendo ahora .zs de CraftTweaker
extensions = ('.cfg', '.conf', '.csv', '.meta', '.json', '.json5', '.properties', '.pw.toml', '.toml', '.txt', '.mcmeta', '.zs')
# Se añade la carpeta 'scripts' a la lista de escaneo
folders = ['config', 'mods', 'resourcepacks', 'notfound', 'scripts', 'defaultoptions']

for folder in folders:
    if not os.path.exists(folder):
        continue
    for root, dirs, files in os.walk(folder):
        for file in files:
            if file.endswith(extensions):
                path = os.path.join(root, file)
                with open(path, 'rb') as f:
                    content = f.read()
                
                # Convertir CRLF (\r\n) a LF (\n)
                new_content = content.replace(b'\r\n', b'\n')
                
                with open(path, 'wb') as f:
                    f.write(new_content)
                print(f"Normalizado: {path}")

print("\n--- ¡Limpieza completada! Archivos .zs incluidos ---")