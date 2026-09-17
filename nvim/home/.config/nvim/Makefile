.PHONY: test

test:
	@for test in tests/*.lua; do \
		nvim --headless -u NONE "+set rtp+=." "+luafile $$test" +qa || exit; printf '\n'; \
	done
