.PHONY: debug
debug:
	 curl -X POST -d 'text=temp' \
	 	-H "application/x-www-form-urlencoded" \
	 	-H "x-slack-request-timestamp: 1615897110" \
	 	"http://localhost:8080/ping"
