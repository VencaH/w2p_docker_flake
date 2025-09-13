
## 0.1.0
- Moved web2py source files to src folder
- Removed following files and folders from web2py code in src folder:
    - folder examples and files in it
    - welcome app and example app in folder application
    - folder scripts and files in it
    - folder Docker and files in it
    - app.yaml file 
    - appveyor.yml file
    - binaries folder and files in it
    - deposit folder
    - requirements,.gae.txt file
    - requirements.txt file - replaced with pyproject.toml
    - folder extras/build_web2py and files in it
    - file tox.ini
    - folder site-packages
- addded Dockerfile and flake.nix file defining default docker image default web2py nix package (with no CGI)
