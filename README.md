# SNOWPACK_in_the_cloud
Cloud platform for running and visualizing [SNOWPACK](https://www.slf.ch/en/services-and-products/snowpack.html), a numerical snow and firn model, via a Jupyter Notebook.

# How to set up
## Step 1: set up VM with tljh
1. Create a Virtual Machine (VM) with the cloud provider, use Ubuntu as OS, enable http and https access.
2. ssh into the machine
3. To install tljh, pick an <admin_name> and execute:
  ```
  curl -L https://tljh.jupyter.org/bootstrap.py | sudo python3 - --admin <admin_name>
  ```
See: https://tljh.jupyter.org/en/latest/install/google.html for details and more information on how to install tljh.

## Step 2: obtaining required packages
In the home directory of the default user, clone the snowpackCloud repository:
```
git clone https://github.com/nwever/snowpackCloud.git
```
To install all required packages, execute:
```
cd snowpackCloud
```
Followed by:
```
bash setup.sh
```

## Step 3: obtaining MeteoIO and SNOWPACK
Go to home directory:
```
cd	# Go to home directory of admin
```
Then clone the SNOWPACK model repository:
```
git clone https://github.com/snowpack-model/snowpack.git
```
Create a usr directory:
```
mkdir ~/usr/
```
Now compile MeteoIO and install in ```~/usr```:

1. ```cd snowpack/Source/meteoio```
2. ```ccmake .```
3. Hit [c] and [c] again to configure
4. Go to ```CMAKE_INSTALL_PREFIX``` and set to ```/home/<admin-user>/usr```
5. Enable PROJ by going to that option and hit enter
6. Hit [c], [c] and [g] to configure and generate
7. ```make install```

Now compile SNOWPACK and install in ```~/usr```:
1. ```cd snowpack/Source/snowpack```
2. Do step 3 and 4 listed above for MeteoIO
3. Set ```DEBUG_ARITHM``` to ```OFF``` and ```ENABLE_LAPACK``` to ```ON``` (go to the respective item and hit <enter>)
4. Do step 6 and 7 listed above for MeteoIO


## Step 4: Adding users
  In the directory ```snowpackCloud```, modify the list of users in the file ```users.lst``` with the users to be created. Then 
  execute ```bash addusers.sh```, which will add all the users to jupyter-hub and copy over the snowpackCloud directory.
	Then, the users can log in after creating their own password and are ready to use the notebooks.
	
  Note:
	Deleting a user including the home directory can be done via the admin panel, followed by:
	```sudo userdel -r <user>```

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/EricKeenan/snowpackCloud/master)

