docker run -d -it --rm -p 8888:8888 -v $(pwd)/workspace:/workspace --name=tensorrt-torch tensorrt-torch-cuda10.2 /bin/bash
