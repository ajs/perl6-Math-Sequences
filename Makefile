test:
	for test in t/*.t; do echo "$$test"; perl6 -I lib "$$test" || break; done
