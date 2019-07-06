test:
	for test in t/*.t6; do echo "$$test"; perl6 -I lib "$$test" || break; done
