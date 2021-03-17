.PHONY: debug
debug:
	 curl -i -X POST -d 'text=' \
	 	-H "application/x-www-form-urlencoded" \
	 	-H "x-slack-request-timestamp: 1615897110" \
	 	"http://localhost:8080/ping"

.PHONY: test
test:
	perl ./t/test.t
