BM / log1.txt : 
	3.5G 
	./rcs_all.sh -f ~/glibc/glibc-build-gcc11 -n 10 -R 0xffff0 | taskset 1 tee /tmp/log1.txt 
	Run : Core 4-19
	10 cycles

BM / log2.txt : 
	3.5G 
	isolcpus=4-19 nohz_full=4-19 rcu_nocbs=4-19
	./rcs_all.sh -f ~/glibc/glibc-build-gcc11 -n 10 -R 0xffff0 | taskset 1 tee /tmp/log1.txt 
	Run : Core 4-19
	10 cycles

BM / log3.txt
	3.5G
	./rcs_all.sh -f ~/glibc/glibc-build-gcc85 -n 10 -R 0xffff0 | taskset 1 tee /tmp/log1.txt
	Run : Core 4-19
	10 cycles

BM / log4.txt
	3.5G
	./rcs_all.sh -f ~/glibc/glibc-build-gcc85 -n 10 -R 0xffff0 | taskset 1 tee /tmp/log1.txt
	Run : Core 4-19
	Numabind -m 0 -N 0 -C 4-19
	10 cycles


BM / log5.txt
	3.5G
	./rcs_all.sh -f ~/glibc/glibc-build-gcc85 -n 10 -R 0xffff0 | taskset 1 tee /tmp/log1.txt
	Run : Core 4-19
	Numabind -m 0 -N 0 -C 4-19
	20 cycles

tdvm / log1.txt
	3.5G
	./rcs_all.sh -f  /home/taosy/libc-build/glibc-2.35-build -n 10 -R 0xfff0 | taskset 0x1 tee /tmp/log2.txt
	Run : Core 4-19
	Numabind -m 0 -N 0 -C 4-19
	10 cycles

tdvm / log2.txt
	3.5G
	./rcs_all.sh -f  /home/taosy/libc-build/glibc-2.35-build -n 20 -R 0xfff0 | taskset 0x1 tee /tmp/log2.txt
	Run : Core 4-19
	Numabind -m 0 -N 0 -C 4-19
	20 cycles
