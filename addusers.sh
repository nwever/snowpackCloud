# Add users listed in users.lst
while read u
do
	# Force username to be lower case
	user=$(echo "$u" | tr '[:upper:]' '[:lower:]')

	echo "Adding: ${user}"
	# Create user on system
	sudo useradd -s /usr/bin/bash -d /home/jupyter-${user} -m jupyter-${user}
	# Add user to tljh
	sudo tljh-config add-item users.allowed ${user}
	# Copy over the repository
	sudo cp -Rp . /home/jupyter-${user}/
	# Remove files that the user doesn't need
	sudo rm /home/jupyter-${user}/users.lst
	sudo rm /home/jupyter-${user}/addusers.sh
	sudo rm /home/jupyter-${user}/README.md
	sudo rm /home/jupyter-${user}/setup.sh
	# Change file ownership to the user
	sudo chown -R jupyter-${user}:jupyter-${user} /home/jupyter-${user}/
done < users.lst
# Reload tljh with new userbase
sudo tljh-config reload
