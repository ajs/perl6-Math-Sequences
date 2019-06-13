FROM rakudo-star
RUN df
RUN ls -l /
COPY ci/ci.bash /
RUN chmod a+rx /ci.bash
RUN mkdir /build
COPY lib /build/lib
COPY t /build/t
CMD [ "/bin/bash", "-c", "cd /build && /ci.bash" ]
