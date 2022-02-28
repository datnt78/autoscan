
import tldextract

if __name__ == '__main__':
    filename="domain.txt"
    with open(filename,'r') as file:
        for line in file:
            try:
                target=''.join(line).strip('\n')
                val = tldextract.extract(target)
                val="{0}.{1}".format(val.domain, val.suffix)
                print(val)
            except Exception as e:
                s = 1