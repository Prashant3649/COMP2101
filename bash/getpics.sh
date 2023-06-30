# Download the tarfile from "http://zonzorp.net/pics.tar.gz" if it exists and is accessible
wget -q -O ~/public_html/pics/pics.tar.gz http://zonzorp.net/pics.tar.gz

# If the download was successful, extract the tarfile and remove the local copy
if [ $? -eq 0 ]; then
  tar -xf ~/public_html/pics/pics.tar.gz -C ~/public_html/pics/
  if [ $? -eq 0 ]; then
    rm ~/public_html/pics/pics.tar.gz
  fi
fi

# Remove the existing "pics" directory and create a new one
rm -rf ~/public_html/pics
mkdir -p ~/public_html/pics || (echo "Failed to make a new pics directory" && exit 1)

# Download a zipfile of pictures from "http://zonzorp.net/pics.zip" to the "pics" directory
# If the download succeeds, unpack the zipfile and remove the local copy
wget -q -O ~/public_html/pics/pics.zip http://zonzorp.net/pics.zip && unzip -d ~/public_html/pics/ ~/public_html/pics/pics.zip
if [ $? -eq 0 ]; then
  rm ~/public_html/pics/pics.zip
fi

# Task 1: Retrieve and install files from "https://zonzorp.net"
# Download the tarfile from "https://zonzorp.net/files.tar.gz" if it exists and is accessible
wget -q -O ~/public_html/pics/files.tar.gz https://zonzorp.net/files.tar.gz

# If the download was successful, extract the tarfile and remove the local copy
if [ $? -eq 0 ]; then
  tar -xf ~/public_html/pics/files.tar.gz -C ~/public_html/pics/
  if [ $? -eq 0 ]; then
    rm ~/public_html/pics/files.tar.gz
  fi
fi

# Generate a report on the content of the "pics" directory
if [ -d ~/public_html/pics ]; then
  file_count=$(find ~/public_html/pics -type f | wc -l)
  disk_usage=$(du -sh ~/public_html/pics | awk '{print $1}')
  cat <<EOF
Found $file_count files in the public_html/pics directory.
The public_html/pics directory uses $disk_usage of disk space.
EOF
fi
