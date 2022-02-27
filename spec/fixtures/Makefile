TARGETS=$(patsubst %.sh,%.json,$(SOURCES))
SOURCES=$(wildcard *.sh)

.SUFFIXES: .sh .json

.sh.json:
	sh $? > $@

exec: $(TARGETS)
