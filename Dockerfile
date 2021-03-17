FROM perl:5.24.1

WORKDIR /usr/src/app

# install module
COPY cpanfile /usr/src/app/cpanfile
RUN cpanm --installdeps .

# copy app
COPY . /usr/src/app

CMD ["./lib/dakuten.pl"]
