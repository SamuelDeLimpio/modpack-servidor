import os

# Carpetas que contienen archivos de texto con errores
folders_to_fix = ['config', 'mods', 'resourcepacks']

for folder in folders_to_fix:
    for root, dirs, files in os.walk(folder):
        for file in files:
            if file.endswith(('.cfg', '.json', '.json5', '.properties', '.pw.toml', '.toml')):
                path = os.path.join(root, file)
                with open(path, 'rb') as f:
                    content = f.read()
                
                # Convertimos CRLF (\r\n) a LF (\n)
                new_content = content.replace(b'\r\n', b'\n')
                
                with open(path, 'wb') as f:
                    f.write(new_content)
                print(f"Corregido: {path}")

print("\n--- Todos los archivos de configuración convertidos a LF ---")