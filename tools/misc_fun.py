'''
Test case
'''

import numpy as np
from parse_glibc_bench import *

def merge_all_results(parser_list):
    '''Merge all parser's results to one list
    Typecial usage: merge_all_results(process_dir(PATH))
    '''
    ret_list = []
    for i in parser_list:
        ret_list += i.results
    return ret_list


def parse_n_folds(fold_list):
    '''Parse n folds to one list
    The result is a matrix:
    Fold[0]:{....}
    Fold[1]:{....}
    ...
    Fold[n]:{....}
    return value :
    [( cv, name, mean, std)
    .... ]
    '''
    ret = []
    l_results = []
    for file_name in fold_list:
        l_results.append(merge_all_results(process_dir(file_name)))
    nof_fold = len(fold_list)
    length = len(l_results[0])
    for i in range(length):
        l = [l_results[k][i][1] for k in range(nof_fold)]
    #    print(l)
        mean = np.mean(l)
        std = np.std(l)
        ret.append((std/mean, l_results[0][i][0], mean, std))
    return ret


def watch_cv_range(r, threshold, fn_filter, bad_or_good):
    '''Watch the cv, the cv > threshold, recode it
    r: N folds result -> merge_all_results -> parse_n_folds
    threshold: Sample 0.12
    fn_filter: file name filter
    '''
    r.sort()
    sv = 0
    fns = dict()
    for item in r:
        filename = item[1].split(".out")[0]
        key_string = item[1].split(".out")[1]
        if filename not in fns:
            fns[filename]=[[],0,0]
        fns[filename][2] += 1
        if bad_or_good == True :  # bad data
            if item[0] > threshold:
                sv += 1
                fns[filename][0].append(key_string)
                fns[filename][1] += 1
        else: # good data
            if item[0] < threshold:
                sv += 1
                fns[filename][0].append(key_string)
                fns[filename][1] += 1
    print("Total item is %d, sv is %d"%(len(r), sv))
    for i in fns:
        print(i,fns[i])
    for i in fns:
        print(i,fns[i][1],fns[i][2] )
    return

def compare_2_folds(fold1, fold2):
    '''compare 2 folds:
    input: 2 folds path
    output: [
        ( ratio, key), (ration,key)
    ]
    '''
    ret_list=[]
    fold1_ret=merge_all_results(process_dir(fold1))
    fold2_ret=merge_all_results(process_dir(fold2))
    for i in range(len(fold1_ret)):
        assert fold1_ret[i][0] == fold2_ret[i][0]
        ret=((fold1_ret[i][1] / fold2_ret[i][1]), fold1_ret[i][0],  
              fold1_ret[i], fold2_ret[i]  )
        ret_list.append(ret)
    return ret_list

def _print_item(item):
    print(item)

def test_fun1(fold1, fold2, threshold):
    '''test func 1:
    1, compare 2 folds; fold1 / fold 2 => Small / Big =>  ret < 1
    2, if ratio < threshold, print the key
    '''
    r = compare_2_folds(fold1, fold2)
    r.sort()
    sum = 0
    for i in r:
        if i[0] < threshold:
            _print_item(i)
            sum += 1
    print("Total is %d, The count is %d"%(len(r),sum))
    return 

def test_fun4(fold1, fold2, threshold):
    '''test func 1:
    1, compare 2 folds; fold1 / fold 2 => Small / Big =>  ret < 1
    2, if ratio > threshold, print the key
    '''
    r = compare_2_folds(fold1, fold2)
    r.sort()
    sum = 0
    for i in r:
        if i[0] > threshold:
            _print_item(i)
            sum += 1
    print("Total is %d, The count is %d"%(len(r),sum))
    return 

def test_fun2(folds, threshold):
    ''' test_fun 2:  Find BAD data, cv > threshold
    run test N rounds, saved them in fold "out-default-%d"%(i)
    Then calculate the CV of these results
    '''
    fold_list = ["%s-%d" % (folds, i) for i in range(10)]
    print(fold_list)
    r = parse_n_folds(fold_list)
    watch_cv_range(r, threshold, "", True)
    return 

def test_fun3(folds, threshold):
    ''' test_fun 3: Find GOOD data, cv < threshold
    run test N rounds, saved them in fold "out-default-%d"%(i)
    Then calculate the CV of these results
    '''
    fold_list = ["%s-%d" % (folds, i) for i in range(10)]
    print(fold_list)
    r = parse_n_folds(fold_list)
    watch_cv_range(r, threshold, "", False)
    return 

def main(fold1, fold2, threshold, func_num, folds):
    if func_num == 1:
        test_fun1(fold1, fold2, threshold)
    elif func_num == 2:
        test_fun2(folds, threshold)
    elif func_num == 3:
        test_fun3(folds, threshold)
    elif func_num == 4:
        test_fun4(fold1, fold2, threshold)
    else:
        return 
    

if __name__ == '__main__':
    app_parser = argparse.ArgumentParser()

    app_parser.add_argument(
        '-func', type=int, help='function num', dest='func_num')

    app_parser.add_argument(
        '-f1', type=str, help='fold1', dest='fold1')
    app_parser.add_argument(
        '-f2', type=str, help='fold2', dest='fold2')
    app_parser.add_argument(
        '-fs', type=str, help='folds', dest='folds')

    app_parser.add_argument(
        '-v', type=float, help='threshold', dest='threshold')
    

    args = app_parser.parse_args()
    main(args.fold1, args.fold2, args.threshold, args.func_num, args.folds)