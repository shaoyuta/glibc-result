Page 5, Guest OS and kernel version for legacy VM and TD VM.
Page 6, as talked on Tuesday, we need 1 thread 1 core data for multiple ones (8 and 32).
How many data you measured, what is the test method, we need simple description. Measurement is execution time, it longer, performance worse.  
You may refer the template or other finished report, to check which pages are missing.
Page 7, legacy VM is 86% of BM for thread creation, still why?
Page 8,  add one last column to cover TDVM/BM.
Page 8, TDVM is 187% of legacy VM, still why?
Page 9, conclusion 1: either compute-intensive, or memory-intensive, we need emon data for show if they are really compute intensive or memory-intensive. Even perf call stack is necessary.
Page 9, conclusion 2: where can we find 40% from previous page? Why multiple-process has such behavior?


From: Zhang, Alex H <alex.h.zhang@intel.com> 
Sent: Thursday, July 21, 2022 9:52 AM
To: Tao, Shaoyu <shaoyu.tao@intel.com>; Qian, Xiaobing <xiaobing.qian@intel.com>
Subject: RE: WL 'glibc-bench' performance data review

Things I feel needed:
-	Brief intro on TDX							=> Done
-	Logic that you choose specific test cases, core binding and so on	=> TODO
-	README: How our validation team is going to repeat your work?		=> What is 
-	SW Stack picture							
-	Explain on the performance drop diagram you got from other team, such as legend , how it associates with yours
-	Page 8: you r still analyze Legacy VM and BM (however, page is about legacy VM and TDX)

By the way, have you invite the expert talked yesterday? Is he/she going to join? Let me know if you need Xiaobing or me help. 
