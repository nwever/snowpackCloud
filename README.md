# SNOWPACK_in_the_cloud
Cloud platform deploying [The Littlest JupyterHub](https://tljh.jupyter.org) for running and visualizing [SNOWPACK](https://www.slf.ch/en/services-and-products/snowpack.html), a numerical snow and firn model, via a Jupyter Notebook.

# How to set up
## Step 1: set up VM with tljh
1. Create a Virtual Machine (VM) with the cloud provider, use Ubuntu as OS, enable http and https access.
2. ssh into the machine
3. To install tljh, pick an <admin_name> and execute:
  ```
  curl -L https://tljh.jupyter.org/bootstrap.py | sudo python3 - --admin <admin_name>
  ```
4. In the VM Instance panel, the external IP address is visible. The tljh is accessible via the IP address listed here. If there are accessing problems, check that http is used. By default, https does not work!
5. Reserve the external IP address, by navigating to VPC network --> External IP addresses. This ensures that the same IP address can be used when the server is rebooted.

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
### MeteoIO
Now compile MeteoIO and install in ```~/usr```:

1. ```cd snowpack/Source/meteoio```
2. ```ccmake .```
3. Hit [c] and [c] again to configure
4. Go to ```CMAKE_INSTALL_PREFIX``` and set to ```/home/<admin-user>/usr```
5. Enable PROJ by going to that option and hit enter
6. Hit [c], [c] and [g] to configure and generate
7. ```make install```

### SNOWPACK
Now compile SNOWPACK and install in ```~/usr```:
1. ```cd snowpack/Source/snowpack```
2. Do step 3 and 4 listed above for MeteoIO
3. Set ```DEBUG_ARITHM``` to ```OFF``` and ```ENABLE_LAPACK``` to ```ON``` (go to the respective item and hit <enter>)
4. Do step 6 and 7 listed above for MeteoIO

### Finalize
Make sure that the full path specified in ```settings.rc``` points to the ```usr/``` directory, where MeteoIO and SNOWPACK are installed.


## Step 4: Update Dry Lake example run (optional)
1. To update the Dry Lake example, navigate to the directory ```update_drylake```
2. The script ```retrieve_data.sh``` can be used to download the SNOTEL data for site 457 (Dry Lake).
	Before executing the script, check the years for which you want to download data. Note that the query is different for the current water year versus historical data.
3. After executing ```bash retrieve_data.sh``` to download the SNOTEL data, execute ```bash make_smet.sh``` to create the smet file with input data.
4. Copy the generated ```*.smet```-files to the directories with simulations:
	- ```cp drylake.smet ../drylake/drylake.smet```
	- ```cp drylake.smet ../drylake_tea/drylake_tea.smet```
	- ```cp lakeeldora.smet ../drylake_tea/lakeeldora.smet```
5. Set the start date to October 1 in the current water year for the simulations by modifying ```ProfileDate``` in ```drylake/drylake.sno``` and ```drylake_tea/drylake_tea.sno```.
6. Add the timestamp of the tea experiment in the file ```drylake_tea.ini```, for example:
	```
	# ENTER THE TIMESTAMP OF THE TEA EXPERIMENT BELOW:
	PSUM_PH::arg1::when  = 2022-03-03T12:00
	PSUM::arg1::when     = 2022-03-03T12:00
	PSUM::arg2::when     = 2022-03-03T12:00
	```
	Make sure that the timestamp falls within the available observational data, downloaded at step 2.
	
## Step 5: Adding users
  In the directory ```snowpackCloud```, modify the list of users in the file ```users.lst``` with the users to be created. Then 
  execute ```bash addusers.sh``` which will add all the users to jupyter-hub and copy over the snowpackCloud directory.
	Then, the users can log in after creating their own password and are ready to use the notebooks.
	
  Notes:
- User names should be all lower case, no special characters and no spaces, to minimize the risk of issues!
- Make sure that you do this as a last step when everything else is sorted out! The snowpackCloud directory from the user executing ```addusers.sh``` will be deployed to all users, and changes after deployment requires manual updating for all the users added in this step!
- Deleting a user including the home directory can be done via the admin panel, followed by:
	```sudo userdel -r jupyter-<user>```


## During a Class
1. Ideally, 1 CPU and at least 2 GB RAM per student is available. Shut down the VM, change its settings, and restart. After a class, the resources
	can be reduced again. Use the Admin panel from the Jupyter admin user to see if users all still working (have a running server).
2. Make sure the disk space is 10 GB for the operating system plus at least around 2 GB per user (users use around 1GB on average) plus some additional buffer. To resize a disk, follow these steps:
	- In the cloud web interface, navigate to "disks"
	- Select the VM boot disk and click "Edit"
	- Provide the new disk size and click "Save". Note that disk space is only allowed to increase.
	- ssh into the VM
	- Find the device in use by the VM by executing: ```sudo lsblk```.
	- Look for a line that has as ```MOUNTPOINT``` ```/```. Most likely it is ```sda1```
	- Resize the partition using (change partition ```sda 1``` when necessary): ```sudo growpart /dev/sda 1```
	- Resize the file system using (change device ```sda1``` when necessary): ```sudo resize2fs /dev/sda1```
	- Check if new space was correctly allocated by using: ```df -h```
3. In case you want to distribute a file to all jupyter users, the command below prints the commands to be executed to achieve that for file ```f=<file>```(f=Lab_4.ipynb in this example):

```f=Lab_4.ipynb; for u in /home/jupyter-*; do uu=$(echo ${u} | sed 's/\/home\///'); echo "sudo cp -p ${f} ${u}/${f} && sudo chown ${uu}:${uu} ${u}/${f}"; done```

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/EricKeenan/snowpackCloud/master)

