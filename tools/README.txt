rcs_all.sh
    # Run all or part of all cases

Sample cmd:
./rcs_all.sh -f ~/glibc/glibc-build-gcc11 -n 10 -R 4-19 -c 'bench-thread_create' | python3 trans.py
    # 
./run-emon.sh -f ~/glibc/glibc-build-gcc11 -n 10 -R 4-19 0xffff0 | python3 trans.py
