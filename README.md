# Server for mobile store

## installation

- server

```bash

# install required utilities
> sudo npm install -g nodemon yarn pm2

# install required packages
> npm install express cors mysql2 morgan multer crypto-js nodemailer

```

- client

```bash

# method 1
> sudo gem install cocoapods

# method 2

# install brew
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install cocoapods using brew
> brew install cocoapods

# setup the client using pods
# step 1: create xcode project and close it
# step 2: open terminal and go to the project directory

# step 3: create Podfile (used to hold all the dependencies)
> pod init

# step 4: add dependencies in Podfile
> pod 'Alamofire'

# step 5: install the dependencies
> pod install
# this will install all the dependencies and will create a new file with extension .xcworkspace (collection of multiple projects)

# step 6: henceforth use .xcworkspace file instead of .xcodeporj file to open the application

# for curated list of io libraries
> https://github.com/vsouza/awesome-ios

# for curated list of android libraries
> https://github.com/wasabeef/awesome-android-libraries

```

## requirements

- user
  - register: send an email to the user
  - login
 
 
  - update profile
    - profile image
    - addresses
- product
  - add/update/delete/list/search products
  - rate a product
- order
  - place an order
  - update an order
  - cancel an order
  - finalize an order
  - get an order details
  
