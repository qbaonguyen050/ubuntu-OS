RUN apt-get update && apt-get install -y tigervnc-standalone-server

RUN echo '#!/bin/bash\n\
vncserver -xstartup /usr/bin/xterm -geometry 1920x1080 -localhost no -SecurityTypes None :1\n\
' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh