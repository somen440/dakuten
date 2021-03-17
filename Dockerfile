FROM perl:5.24.1

WORKDIR /usr/src/app

# install module
COPY cpanfile /usr/src/app/cpanfile
RUN cpanm --installdeps .

# copy app
COPY ./lib /usr/src/app

CMD ["./dakuten.pl"]
