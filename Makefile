.PHONY: check
check:
	expand bics | awk 'length($$0) > 80 { exit(1); }'
	./bics -h | expand |  awk 'length($$0) > 80 { exit(1); }'
	shellcheck bics
