#docker run --rm --name my-py -p 8000:8000 -d my-pyapp

# Скопировать проект в дир. с VOLUME (.pyapp/* -> /home/andr/temp2), иначе не запустится
#docker run -d -p 8000:8000 -v /home/andr/temp2:/home/ninja/pyapp --name my anpod07/my-pyapp:latest
docker run --rm --name my-py -p 8000:8000 -v /home/andr/temp2:/home/ninja/pyapp -d my-pyapp
