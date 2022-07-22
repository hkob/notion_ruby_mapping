TARGETS=$(patsubst %.sh,%.json,$(SOURCES))
SOURCES=$(wildcard *.sh)

.SUFFIXES: .sh .json

.sh.json:
	sh $? > $@
	sleep 1

exec: $(TARGETS)
