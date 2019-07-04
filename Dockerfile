FROM python:latest
LABEL maintainer=jswetzen

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ffmpeg rsstail zip && \
    rm -rf /var/lib/apt/lists/*
RUN pip install cryptography
RUN git clone https://github.com/spaam/svtplay-dl.git && \
    cd svtplay-dl && \
    make && \
    make install && \
    cd .. && \
    rm -r svtplay-dl

WORKDIR /data

ENV RSS_URL https://www.svtplay.se/genre/film/rss.xml
ENV DL_OPTIONS "-S --all-subtitles"

CMD rsstail -i 60 -u $RSS_URL -l -n 0 | grep --line-buffered Link | while read x ; do $(echo "svtplay-dl ${DL_OPTIONS} ${x##*: }x"); done
