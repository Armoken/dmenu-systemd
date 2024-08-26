from setuptools import setup, find_packages

setup(name='dmenu-systemd',
      version='1.0',
      # Modules to import from other scripts:
      packages=find_packages(),
      # Executables
      scripts=["dmenu-systemd"],
     )
