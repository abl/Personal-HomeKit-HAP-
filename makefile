LINK = -lssl -lcrypto -ldl -pthread
CFLAG = -O0
CC = gcc
CPP = g++
ifeq ($(OS),Windows_NT)
    ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
    endif
    ifeq ($(PROCESSOR_ARCHITECTURE),x86)
    endif
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        LINK +=  -ldns_sd
    endif
    ifeq ($(UNAME_S),Darwin)
    endif
    UNAME_P := $(shell uname -p)
endif
OBJFILE = chacha20.o curve25519.o ed25519.o poly1305.o rfc6234-master/hkdf.o rfc6234-master/hmac.o rfc6234-master/sha.o main.o PHKAccessory.o PHKControllerRecord.o PHKNetworkIP.o PHKArduinoLightInterface.o srp/srp.o srp/cstr.o srp/t_math.o srp/srp6_server.o srp/t_conf.o srp/t_conv.o srp/t_pw.o srp/t_misc.o srp/t_truerand.o srp/t_read.o Accessory.o
all: PHK
PHK: $(OBJFILE)
	$(CPP) $(CFLAG) -o PHK $(OBJFILE) $(LINK)
chacha20.o: Chacha20/chacha20_simple.c Chacha20/chacha20_simple.h
	$(CC) $(CFLAG) -w -o chacha20.o -c Chacha20/chacha20_simple.c
curve25519.o: curve25519/curve25519-donna.c curve25519/curve25519-donna.h
	$(CC) $(CFLAG) -w -o curve25519.o -c curve25519/curve25519-donna.c
ed25519.o: ed25519-donna/ed25519.c ed25519-donna/ed25519.h
	$(CC) $(CFLAG) -w -o ed25519.o -c ed25519-donna/ed25519.c
poly1305.o: poly1305-opt-master/poly1305.c poly1305-opt-master/poly1305.h
	$(CC) $(CFLAG) -w -o poly1305.o -c poly1305-opt-master/poly1305.c
rfc6234-master/%.o: rfc6234-master/%.c
	$(CC) $(CFLAG) -w -c $< -o $@
srp/%.o: srp/%.c
	$(CC) $(CFLAG) -lcrypto -w -c $< -o $@
%.o: %.cpp
	$(CPP) $(CFLAG) -w -c $<
clean:
	rm -rf ./*.o Chacha20/*.o curve25519/*.o ed25519-donna/*.o poly1305-opt-master/*.o rfc6234-master/*.o srp/*.o PHK
