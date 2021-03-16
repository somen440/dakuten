FROM perl:5.24.1
RUN curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious
COPY ./lib /usr/src/app
WORKDIR /usr/src/app
CMD ["./dakuten.pl"]
