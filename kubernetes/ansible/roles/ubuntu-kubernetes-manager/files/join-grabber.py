import sys

path_to_join = sys.argv[1]

with open(path_to_join, 'r') as reader:
    content = " ".join(reader.readlines())
    ix_join_first = content.find("join")
    ix_join_second = content.find("kubeadm", ix_join_first)
    kube_join_string = content[ix_join_second:]\
        .replace('"', "")\
        .replace("\\t", "")\
        .replace("\n", "")\
        .replace("]", "")\
        .replace("\\\\,", "")\
        .replace("}", "").strip()
    print(kube_join_string)
