import os

# Archivos y carpetas a procesar
targets = ['pack.toml', 'index.toml', 'mods']

def convert_to_lf(path):
    if os.path.isfile(path):
        if path.endswith('.toml') or path.endswith('.cfg'):
            with open(path, 'rb') as f:
                content = f.read()
            # Reemplazamos \r\n (Windows) por \n (Linux/GitHub)
            new_content = content.replace(b'\r\n', b'\n')
            with open(path, 'wb') as f:
                f.writelines([new_content])
            print(f"Convertido a LF: {path}")
    elif os.path.isdir(path):
        for root, dirs, files in os.walk(path):
            for file in files:
                convert_to_lf(os.path.join(root, file))

for t in targets:
    convert_to_lf(t)