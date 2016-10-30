all : cnping searchnet cnping-mousey
windows : cnping.exe

CFLAGS:=$(CFLAGS) -g -Os 
CXXFLAGS:=$(CFLAGS)
LDFLAGS:=-g

# Comment out the following line to add an icon to the executable
RESFLAGS:=-DNO_ICON

cnping.exe : cnping.c DrawFunctions.c WinDriver.c os_generic.c ping.c resources.o
	$(MINGW32)mingw32-gcc -g -mwindows -m32 -DDEFLONG -o $@ $^  -lgdi32 -lws2_32 -s

resources.o: cnping.rc
	$(MINGW32)windres $(RESFLAGS) -v -i $^ -o $@

cnping : cnping.o DrawFunctions.o XDriver.o os_generic.o ping.o
	gcc $(CFLAGS) -o $@ $^ -lX11 -lm -lpthread -lXinerama -lXext $(LDFLAGS)

cnping-mousey : cnping-mousey.o DrawFunctions.o XDriver.o os_generic.o ping.o
	gcc $(CFLAGS) -o $@ $^ -lX11 -lm -lpthread -lXinerama -lXext $(LDFLAGS)

searchnet : os_generic.o ping.o searchnet.o
	gcc $(CFLAGS) -o $@ $^ -lpthread

linuxinstall : cnping
	sudo cp cnping /usr/local/bin/
	sudo chmod +s /usr/local/bin/cnping

clean :
	rm -rf *.o *~ cnping cnping.exe
