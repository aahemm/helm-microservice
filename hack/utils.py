def is_str_different(str1, str2):
    print(len(str1), len(str2))
    if len(str1) > len(str2):
        for i in range(len(str2)):
            if str1[i] != str2[i]:
                print(i, hex(ord(str1[i])), hex(ord(str2[i])))
                print(str1[i - 40 : i + 10])
                print(str2[i - 40 : i + 10])
                return True
        print(str1[len(str2) :])
        return True

    for i in range(len(str1)):
        if str1[i] != str2[i]:
            print(i)
            print(str1[i - 10 : i + 10])
            print(str2[i - 10 : i + 10])
            return True

    ## if str1 is a subset of str2
    if len(str1) < len(str2):
        print(str2[len(str1) :])
        return True

    return False

with open("/tmp/helm-result.yaml") as f1:
    with open("hack/test-values/expected-results/secret-file-deployment.yaml") as f2:
        assert not is_str_different(f1.read(), f2.read())
