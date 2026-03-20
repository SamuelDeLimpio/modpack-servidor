import os

# Extensiones de texto que están dando problemas de hash
extensions = ('.cfg', '.conf', '.csv', '.meta', '.json', '.json5', '.properties', '.pw.toml', '.toml', '.txt')
folders = ['config', 'mods', 'resourcepacks']

for folder in folders:
    for root, dirs, files in os.walk(folder):
        for file in files:
            if file.endswith(extensions):
                path = os.path.join(root, file)
                with open(path, 'rb') as f:
                    content = f.read()
                
                # Convertir CRLF a LF
                new_content = content.replace(b'\r\n', b'\n')
                
                with open(path, 'wb') as f:
                    f.write(new_content)
                print(f"Normalizado: {path}")

print("\n--- Limpieza de .csv, .conf y .meta completada ---")